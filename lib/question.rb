class Question
  require 'builder'
  attr_accessor :question_text, :answers, :randomize
  attr_reader :builder, :string
  
  def initialize(*args)
    @answers = []
    @string = ''
    @builder = Builder::XmlMarkup.new(:target => @string)
  end

  def text(s) ; @question_text = s ; end
  
  def answer(text, opts={})
    @answers << Question::Answer.new(self.builder, text, true, opts[:explanation])
  end

  def distractor(text, opts={})
    @answers << Question::Answer.new(self.builder, text, false, opts[:explanation])
  end

  def correct_answer ;  @answers.detect(&:correct?)  ;  end

  def correct_answers ;  @answers.collect(&:correct?) ; end

  def render_answers(builder)
    self.answers.each { |answer| answer.to_xml }
  end

  class Answer
    attr_accessor :answer_text, :explanation
    attr_reader :correct
    attr_reader :builder

    def correct? ; !!correct ; end
    def has_explanation? ; !!explanation ; end
    def initialize(builder, answer_text, correct, explanation=nil)
      @builder = builder
      @answer_text = answer_text
      @correct = !!correct # ensure boolean
      @explanation = explanation
    end
    def to_xml
      option_args = {}
      option_args['selected-score'] = '1' if correct?
      builder.option(option_args) do
        builder.text answer_text
        builder.explanation(explanation) if has_explanation?
      end
    end
  end
end
