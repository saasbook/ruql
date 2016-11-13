class Html5Renderer
  require 'builder'
  require 'erb'
  
  attr_reader :output

  def initialize(quiz,options={})
    @show_solutions = options.delete('s') || options.delete('solutions')
    @template = options.delete('t') ||
      options.delete('template') ||
      File.join(File.dirname(__FILE__), '../../../templates/html5.html.erb')
    @output = ''
    @list_type = (options.delete('o') || options.delete('list-type') || 'o')[0] + "l"
    @list_start = quiz.first_question_number
    @quiz = quiz
    @h = Builder::XmlMarkup.new(:target => @output, :indent => 2)
  end

  def render_quiz
    render_with_template do
      render_questions
      @output
    end
    self
  end

  def render_with_template
    # local variables that should be in scope in the template 
    quiz = @quiz
    # the ERB template includes 'yield' where questions should go:
    output = ERB.new(IO.read(File.expand_path @template)).result(binding)
    @output = output
  end
    
  def render_questions
    render_random_seed
    @h.ol :class => 'questions', :start => @list_start do
      @quiz.questions.each_with_index do |q,i|
        case q
        when MultipleChoice, SelectMultiple, TrueFalse then render_multiple_choice(q,i)
        when FillIn then render_fill_in(q, i)
        else
          raise "Unknown question type: #{q}"
        end
      end
    end
  end


  def render_multiple_choice(q,index)
    render_question_text(q, index) do
      answers =
        if q.class == TrueFalse then q.answers.sort.reverse # True always first
        elsif q.randomize && !@quiz.suppress_random then q.answers.sort_by { rand }
        else q.answers
        end
      @h.__send__(@list_type, :class => 'answers') do
        answers.each do |answer|
          if @show_solutions
            render_answer_for_solutions(answer, q.raw?, q.class == TrueFalse)
          else
            if q.raw? then @h.li { |l| l << answer.answer_text } else @h.li answer.answer_text end
          end
        end
        if @show_solutions && ((exp = q.explanation.to_s) != '')
          @h.br
          if q.raw? then @h.span(:class => 'explanation') { |p| p << exp } else @h.span(exp, :class => 'explanation') end
        end
      end
    end
    self
  end

  def render_fill_in(q, idx)
    render_question_text(q, idx) do
      if @show_solutions
        answer = q.answers[0]
        if answer.has_explanation?
          if q.raw? then @h.p(:class => 'explanation') { |p| p << answer.explanation }
          else @h.p(answer.explanation, :class => 'explanation') end
        end
        answers = (answer.answer_text.kind_of?(Array) ? answer.answer_text : [answer.answer_text])
        @h.ol :class => 'answers' do
          answers.each do |answer|
            if answer.kind_of?(Regexp)
              answer = answer.inspect
              if !q.case_sensitive
                answer += 'i'
              end
            end
            @h.li do
              if q.raw? then @h.p { |p| p << answer } else @h.p answer end
            end
          end
        end
      end
    end
  end

  def render_answer_for_solutions(answer,raw,is_true_false = nil)
    args = {:class => (answer.correct? ? 'correct' : 'incorrect')}
    if is_true_false 
      answer.answer_text.prepend(
        answer.correct? ? "CORRECT: " : "INCORRECT: ")
    end
    @h.li(args) do
      if raw then @h.span { |p| p << answer.answer_text } else @h.span answer.answer_text  end
      if answer.has_explanation?
        @h.br
        if raw then @h.span(:class => 'explanation') { |p| p << answer.explanation } else @h.span(answer.explanation, :class => 'explanation') end
      end
    end
  end

  def render_question_text(question,index)
    html_args = {
      :id => "question-#{index}",
      :'data-uid' => question.question_uid,
      :class => ['question', question.class.to_s.downcase, (question.multiple ? 'multiple' : '')].join(' ')
    }
    if question.question_image           # add CSS class to both <li> and <img>
      html_args[:class] << 'question-with-image'
    end
    @h.li html_args  do
      # if there's an image, render it first
      if question.question_image
        @h.img :src => question.question_image, :class => 'question-image'
      end
      @h.div :class => 'text' do
        qtext = @quiz.point_string(question.points) << ' ' <<
          ('Select <b>all</b> that apply: ' if question.multiple).to_s <<
          if question.class == FillIn then question.question_text.gsub(/\-+/, '_____________________________')
          else question.question_text
          end
        if question.raw?
          @h.p { |p| p << qtext }
        else
          qtext.each_line do |p|
            @h.p do |par|
              par << p # preserves HTML markup
            end
          end
        end
      end
      yield # render answers
    end
    self
  end

  def quiz_header
    @h.div(:id => 'student-name') do
      @h.p 'Name:'
      @h.p 'Student ID:'
    end
    if @quiz.options[:instructions]
      @h.div :id => 'instructions' do
        @quiz.options[:instructions].each_line { |p| @h.p p }
      end
    end
    self
  end

  def render_random_seed
    @h.comment! "Seed: #{@quiz.seed}"
  end
end
