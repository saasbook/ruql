class Quiz
  @@quizzes = []
  @quiz_yaml = {}
  def self.quizzes ; @@quizzes ;  end
  @@default_options =
    {
    :open_time => Time.now,
    :soft_close_time => Time.now + 24*60*60,
    :hard_close_time => Time.now + 24*60*60,
    :maximum_submissions => 1,
    :duration => 3600,
    :retry_delay => 600,
    :parameters =>  {
      :show_explanations => {
        :question => 'before_soft_close_time',
        :option => 'before_soft_close_time',
        :score => 'before_soft_close_time',
      }
    },
    :maximum_score => 1,
  }

  attr_reader :renderer
  attr_reader :questions
  attr_reader :first_question_number
  attr_reader :options
  attr_reader :output
  attr_reader :suppress_random
  attr_reader :seed
  attr_reader :logger
  attr_reader :points_threshold
  attr_reader :points_string
  attr_accessor :title, :quizzes


  def initialize(title, options={})
    @output = ''
    @questions = options.delete(:questions) || []
    @title = title
    @options = @@default_options.merge(options)
    @seed = srand
    @logger = Logger.new(STDERR)
    @logger.level = Logger.const_get (options.delete('l') ||
                                      options.delete('log') || 'warn').upcase
    if (yaml = options.delete(:yaml))
      @quiz_yaml = YAML::load(IO.read yaml)
    end
  end

  def get_first_question_number(spec)
    return 1 if spec.nil?
    return $1.to_i if spec =~ /^(\d+)$/
    # file?
    begin
      File.readlines(spec).each do |f|
        return 1 + $1.to_i if f =~ /^last\s+(\d+)/
      end
      return 1
    rescue StandardError => e
      warn "Warning: starting question numbering at 1, cannot read #{spec}: #{e.message}"
      return 1
    end
  end

  def self.get_renderer(renderer)
    Object.const_get(renderer.to_s + 'Renderer') rescue nil
  end

  def render_with(renderer,options={})
    srand @seed
    @first_question_number = get_first_question_number(options.delete('a'))
    @points_threshold = (options.delete('p') || 0).to_i
    @points_string = options.delete('P') || "[%d point%s]"
    @suppress_random = !!options['R']
    @renderer = Quiz.get_renderer(renderer).send(:new,self,options)
    @renderer.render_quiz
    if (report = options.delete('r'))
      File.open(report, "w") do |f|
        f.puts "questions #{num_questions}"
        f.puts "first #{first_question_number}"
        f.puts "last #{first_question_number + num_questions - 1}"
        f.puts "points #{self.points}"
      end
    end
    @output = @renderer.output
  end

  def points ; questions.map(&:points).inject { |sum,points| sum + points } ; end

  def num_questions ; questions.length ; end

  def point_string(points)
    points >= points_threshold ?
    sprintf(points_string.to_s, points, (points > 1 ? 's' : '')) :
      ''
  end

  def random_seed(num)
    @seed = num.to_i
  end

  # this should really be done using mixins.
  def choice_answer(*args, &block)
    if args.first.is_a?(Hash) # no question text
      q = MultipleChoice.new('',*args)
    else
      text = args.shift
      q = MultipleChoice.new(text, *args)
    end
    q.instance_eval(&block)
    @questions << q
  end

  def select_multiple(*args, &block)
    if args.first.is_a?(Hash) # no question text
      q = SelectMultiple.new('', *args)
    else
      text = args.shift
      q = SelectMultiple.new(text, *args)
    end
    q.instance_eval(&block)
    @questions << q
  end

  def truefalse(*args)
    q = TrueFalse.new(*args)
    @questions << q
  end

  def dropdown(*args, &block)
    q = Dropdown.new(*args)
    q.instance_eval(&block)
    @questions << q
  end
  
  def open_assessment(*args, &block)
    q = get_open_assessment(*args, &block)
    @questions << q
  end

  def simple_open_assessment(*args, &block)
    q = get_open_assessment(*args, &block)
    q.add_simple_question
    @questions << q
  end

  def get_open_assessment(*args, &block)
    y = @quiz_yaml.shift
    raise "Cannot continue - You must have a yaml block for each peer evaluation question" if y.nil?
    yaml = y[1][0]
    q = OpenAssessment.new(*args, yaml)
    q.instance_eval(&block)
    q
  end

  def fill_in(*args, &block)
    if args.first.is_a?(Hash) # no question text
      q = FillIn.new('', *args)
    else
      text = args.shift
      q = FillIn.new(text, *args)
    end
    q.instance_eval(&block)
    @questions << q
  end

  def self.quiz(*args, &block)
    quiz = Quiz.new(*args)
    quiz.instance_eval(&block)
    @@quizzes << quiz
  end
end
