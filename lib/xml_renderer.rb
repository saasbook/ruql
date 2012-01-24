class XmlRenderer
  require 'builder'

  attr_reader :output, :quiz
  def initialize(quiz=nil)
    @output = ''
    @b = Builder::XmlMarkup.new(:target => @output)
    @quiz = quiz
  end

  def render(thing)
    m = self.method("render_" + thing.class.to_s.gsub(/\B[A-Z]/, '_\&').downcase)
    m.call(thing)
  end
  
  def render_quiz(quiz)
    xml_quiz do
      quiz.questions.each do |question|
        self.render(question)
      end
    end
    @output
  end
  
  def render_multiple_choice(question)
    @b.question :type => 'GS_Choice_Answer_Question' do
      @b.metadata {
        @b.parameters {
          @b.rescale_score 1
          @b.choice_type (question.multiple ? 'checkbox' : 'radio')
        }
      }
      @b.data {
        @b.text { @b.cdata!(question.question_text) }
        @b.option_groups {
          @b.option_group(:select => 'all') {
            question.answers.each { |a| self.render_answer(a) }
          }
        }
      }
    end
  end

  def render_answer(answer)
    option_args = {}
    option_args['selected_score'] = answer.correct? ? 1 : 0
    option_args['unselected_score'] = 1 - option_args['selected_score']
    @b.option(option_args) do
      @b.text { @b.cdata!(answer.answer_text) }
      @b.explanation { @b.cdata!(answer.explanation) } if answer.has_explanation?
    end
  end

  private

  def options_to_xml(h)
    h.each_pair do |k,v|
      if v.is_a?(Hash)
        @b.__send__(k.to_sym) do
          options_to_xml v
        end
      else
        @b.__send__(k.to_sym, v)
      end
    end
  end
  

  def xml_quiz
    @b.instruct!
    @b.declare! :DOCTYPE, :quiz, :SYSTEM, "quiz.dtd"
    @b.quiz do
      @b.metadata do
        @b.type 'quiz'
        @b.title quiz.title
        options_to_xml quiz.options
      end
      @b.preamble
      @b.data do 
        @b.question_groups do
          @b.__send__('question-group', :select => '1') do
            @b.questions do
              yield
            end
          end
      end
    end
  end
  end
end
