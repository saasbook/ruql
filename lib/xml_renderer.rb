class XmlRenderer
  require 'builder'

  attr_reader :output
  def initialize(quiz,options={})
    @output = ''
    @b = Builder::XmlMarkup.new(:target => @output, :indent => 2)
    @quiz = quiz
  end

  def render(thing)
    m = self.method("render_" + thing.class.to_s.gsub(/\B[A-Z]/, '_\&').downcase)
    m.call(thing)
  end
  
  def render_quiz
    # entire quiz can be in one question group, as long as we specify
    # that ALL question from the group must be used to make the quiz.
    xml_quiz do
      # after preamble...
      @b.question_groups do
        @b.question_group(:select => @quiz.questions.length) do
          @quiz.questions.each do |question|
            self.render(question)
          end
        end
      end
    end
    @output
  end
  
  def render_multiple_choice(question)
    @b.question :type => 'GS_Choice_Answer_Question', :id => question.object_id.to_s(16) do
      @b.metadata {
        @b.parameters {
          @b.rescale_score 1
          @b.choice_type (question.multiple ? 'checkbox' : 'radio')
        }
      }
      # since we want all the options to appear, we create N option
      # groups each containig 1 option, and specify that option to
      # always be selected for inclusion in the quiz.  If the original
      # question specified 'random', use the 'randomize' attribute on
      # option_groups to scramble the order in which displayed;
      # otherwise, display in same order as answers appear in source.
      @b.data {
        @b.text { @b.cdata!(question.question_text) }
        @b.option_groups(:randomize => !!question.randomize) {
          question.answers.each do |a|
            @b.option_group(:select => 'all') {
              self.render_multiple_choice_answer a
            }
          end
        }
      }
    end
  end

  def render_multiple_choice_answer(answer)
    option_args = {}
    option_args['selected_score'] = answer.correct? ? 1 : 0
    option_args['unselected_score'] = 1 - option_args['selected_score']
    option_args['id'] = answer.object_id.to_s(16)
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
    @b.quiz do
      @b.metadata do
        @b.type 'quiz'
        @b.title @quiz.title
        options_to_xml @quiz.options
      end
      @b.preamble
      @b.data do 
        yield
      end
    end
  end

end

