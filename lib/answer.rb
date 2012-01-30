class Answer
  attr_accessor :answer_text, :explanation
  attr_reader :correct
  attr_reader :builder
  attr_reader :question

  def correct? ; !!correct ; end
  def has_explanation? ; !!explanation ; end
  def initialize(answer_text, correct, explanation=nil)
    @answer_text = answer_text
    @correct = !!correct # ensure boolean
    @explanation = explanation
  end
end
