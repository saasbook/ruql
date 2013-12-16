class EdXmlRenderer
  require 'builder'

  attr_reader :output
  def initialize(quiz,options={})
    @only_question = options.delete('n') || options.delete('name')
    @output = ''
    @b = Builder::XmlMarkup.new(:target => @output, :indent => 2)
    @quiz = quiz
  end

  def render(thing)
    case thing
    when MultipleChoice,SelectMultiple,TrueFalse then render_multiple_choice(thing)
    when FillIn then render_fill_in(thing)
    else
      raise "Unknown question type: #{thing}"
    end
  end
  
  def render_quiz
    # entire quiz can be in one question group, as long as we specify
    # that ALL question from the group must be used to make the quiz.
    question_list = if @only_question
                    then @quiz.questions.select { |q| q.name == @only_question }
                    else @quiz.questions
                    end
    question_list.each { |question| render(question) }
    @output
  end

  def render_fill_in(question)
    raise "Not yet implemented for edXML"
  end

  def render_multiple_choice(question)
    @b.problem do
      # if question text has explicit newlines, use them to separate <p>'s
      if question.raw?
        @b.p { |p| p << question.question_text }
      else
        question.question_text.lines.map(&:chomp).each do |line|
          if question.raw? then @b.p { |p| p << line } else @b.p(line) end
        end
      end
      @b.multiplechoiceresponse do
        @b.choicegroup :type => 'MultipleChoice' do
          question.answers.each do |answer|
            if question.raw?
              @b.choice(:correct => answer.correct?) do |choice|
                choice << answer.answer_text
                choice << "\n"
              end
            else
              @b.choice answer.answer_text, :correct => answer.correct?
            end
          end
        end
      end
      @b.solution do
        @b.div :class => 'detailed_solution' do
          @b.p 'Explanation'
          if question.raw?
            @b.p { |p| p << question.correct_answer.explanation }
          else
            @b.p question.correct_answer.explanation
          end
        end
      end
    end
  end

end

