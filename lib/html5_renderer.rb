class Html5Renderer
  require 'builder'
  require 'erb'
  
  attr_reader :output

  def initialize(quiz,options={})
    @css = options.delete('c') || options.delete('css')
    @show_solutions = options.delete('s') || options.delete('solutions')
    @template = options.delete('t') || options.delete('template')
    @output = ''
    @quiz = quiz
    @h = Builder::XmlMarkup.new(:target => @output, :indent => 2)
  end

  def render_quiz
    if @template
      render_with_template do
        render_questions
        @output
      end
    else
      @h.html do
        @h.head do
          @h.title @quiz.title
          @h.link(:rel => 'stylesheet', :type =>'text/css', :href=>@css) if @css
        end
        @h.body do
          render_questions
        end
      end
    end
    self
  end

  def render_with_template
    # 3 local variables that can should be in scope in the template:
    title = @quiz.title
    total_points = @quiz.points
    num_questions = @quiz.num_questions
    output = ERB.new(IO.read(File.expand_path @template)).result(binding)
    @output = output
  end
    
  def render_questions
    @h.ol :class => 'questions' do
      @quiz.questions.each_with_index do |q,i|
        case q
        when MultipleChoice, TrueFalse then render_multiple_choice(q,i)
        else
          raise "Unknown question type: #{q}"
        end
      end
    end
  end


  def render_multiple_choice(q,index)
    render_question_text(q, index) do
      answers = (q.randomize ? q.answers.sort_by { rand } : q.answers)
      @h.ol :class => 'answers' do
        answers.each do |answer|
          if @show_solutions
            render_answer_for_solutions(answer, q.raw?)
          else
            if q.raw? then @h.li { |l| l << answer.answer_text } else @h.li answer.answer_text end
          end
        end
      end
    end
    self
  end

  def render_answer_for_solutions(answer,raw)
    args = {:class => (answer.correct? ? 'correct' : 'incorrect')}
    @h.li(args) do
      if raw then @h.p { |p| p << answer.answer_text } else @h.p answer.answer_text  end
      if answer.has_explanation?
        if raw then @h.p(:class => 'explanation') { |p| p << answer.explanation }
        else @h.p(answer.explanation, :class => 'explanation') end
      end
    end
  end

  def render_question_text(question,index)
    html_args = {
      :id => "question-#{index}",
      :class => ['question', question.class.to_s.downcase, (question.multiple ? 'multiple' : '')]
        .join(' ')
    }
    @h.li html_args  do
      @h.div :class => 'text' do
        if question.raw?
          @h.p { |p| p << question.question_text }
        else
          question.question_text.each_line do |p|
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

end
