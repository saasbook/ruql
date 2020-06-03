class Quiz
  @@quizzes = []
  @@yaml_file = nil
  @quiz_yaml = {}
  @@options = {}
  def self.quizzes ; @@quizzes ;  end

  attr_reader :renderer
  attr_reader :questions
  attr_reader :options
  attr_reader :output
  attr_reader :seed
  attr_reader :logger
  attr_accessor :title

  def initialize(title, options={})
    @output = ''
    @questions = options[:questions] || []
    @title = title
    @options = @@options.merge(options)
    @seed = srand
    @logger = Logger.new(STDERR)
    @logger.level = (@options['-V'] || @options['--verbose']) ? Logger::INFO : Logger::WARN
    #@quiz_yaml = yaml
  end

  def render_with(renderer,options={})
    srand @seed
    @renderer = renderer.send(:new,self,options)
    @renderer.render_quiz
    @output = @renderer.output
  end

  def self.set_options(options)
    @@options = options
  end

  def ungrouped_questions
    questions.filter { |q| q.question_group.to_s == '' }
  end

  def grouped_questions
    questions.filter { |q| q.question_group.to_s != '' }.sort_by(&:question_group)
  end

  def groups ; questions.map(&:question_group).uniq.reject { |g| g.to_s == '' } ; end

  def ungrouped_points
    ungrouped_questions.map(&:points).sum
  end

  def grouped_points
    gq = grouped_questions
    groups.sum do |g|
      gq.detect { |q| q.question_group == g }.points
    end
  end

  def points
    ungrouped_points + grouped_points
  end
  
  def num_questions
    groups.length + ungrouped_questions.length
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

  def self.quiz(title, args={}, &block)
    quiz = Quiz.new(title, args)
    quiz.instance_eval(&block)
    @@quizzes << quiz
  end
end
