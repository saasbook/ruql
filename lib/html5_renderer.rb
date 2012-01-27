class Html5Renderer
  require 'builder'
  
  attr_reader :output

  def initialize(quiz,options={})
    @css = options.delete(:c) || options.delete(:css)
    @output = ''
    @quiz = quiz
    @h = Builder::XmlMarkup.new(:target => @output, :indent => 2)
  end

  def render_quiz
    @h.html
    @h.head do
      @h.title @quiz.title
      @h.link(:rel => 'stylesheet', :type =>'text/css', :href=>@css) if @css
    end
    @h.body do
      quiz_header
      @quiz.questions.each_with_index do |q,i|
        case q
        when MultipleChoice then render_multiple_choice(q,i)
        else
          raise "Unknown question type: #{q}"
        end
      end
    end
    self
  end

  def render_multiple_choice(q,index)
    render_question_text(q, index) do
      answers = (q.randomize ? q.answers.sort_by { rand } : q.answers)
      @h.ol :class => 'answers' do
        answers.each do |answer|
          @h.li answer.answer_text
        end
      end
    end
    self
  end

  def render_question_text(question,index)
    @h.div :class => 'question', :id => "question-#{index}" do
      @h.div :class => 'text' do
        question.question_text.each_line do |p|
          @h.p p
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
