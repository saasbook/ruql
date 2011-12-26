class Question
  attr_accessor :text
  attr_accessor :answers

  def initialize(*args)
    @answers = []
  end

  def answer(text, opts={})
    @answers << Question::Answer.new(text, true, opts[:explanation])
  end

  def distractor(text, opts={})
    @answers << Question::Answer.new(text, false, opts[:explanation])
  end

  def correct_answer ;  @answers.detect(&:correct?)  ;  end

  def correct_answers ;  @answers.collect(&:correct?) ; end

  class Answer
    attr_accessor :answer_text, :explanation
    attr_reader :correct
    def correct? ; !!correct ; end
    def has_explanation? ; !!explanation ; end
    def initialize(answer_text, correct, explanation=nil)
      @answer_text = answer_text
      @correct = !!correct # ensure boolean
      @explanation = explanation
    end
    def to_xml(builder)
      option_args = {}
      option_args['selected-score'] = '1' if correct?
      builder.option(option_args) do
        builder.text answer_text
        builder.explanation(explanation) if has_explanation?
      end
    end
  end
end
