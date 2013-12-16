class XMLRenderer
  require 'builder'

  attr_reader :output
  def initialize(quiz,options={})
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

  def render_fill_in(question)
    @b.question :type => 'GS_Short_Answer_Question_Simple', :id => question.object_id.to_s(16) do
      @b.metadata {
        @b.parameters {
          @b.rescale_score question.points
          @b.type 'regexp'
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
          @b.option_group(:select => 'all') {
            question.answers.each do |answer|
              option_args = {}
              option_args['selected_score'] = answer.correct? ? 1 : 0
              option_args['unselected_score'] =
                question.multiple ? 1 - option_args['selected_score'] : 0
              option_args['id'] = answer.object_id.to_s(16)
              @b.option(option_args) do
                answer_text = answer.answer_text
                if answer_text.kind_of?(Regexp)
                  answer_text = answer_text.inspect
                  if !question.case_sensitive
                    answer_text += 'i'
                  end
                end
                @b.text { @b.cdata!(answer_text) }
                @b.explanation { @b.cdata!(answer.explanation) } if answer.has_explanation?
              end
            end
          }
        }
      }
    end
  end

  def render_multiple_choice(question)
    @b.question :type => 'GS_Choice_Answer_Question', :id => question.object_id.to_s(16) do
      @b.metadata {
        @b.parameters {
          @b.rescale_score question.points
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
              self.render_multiple_choice_answer a, question.multiple
            }
          end
        }
      }
    end
  end
  alias :render_true_false :render_multiple_choice

  def render_multiple_choice_answer(answer, multiple_allowed)
    option_args = {}
    option_args['selected_score'] = answer.correct? ? 1 : 0
    option_args['unselected_score'] =
      multiple_allowed ? 1 - option_args['selected_score'] : 0
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

