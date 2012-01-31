class Answer
  include Comparable
  attr_accessor :answer_text, :explanation
  attr_reader :correct
  attr_reader :builder
  attr_reader :question

  def <=>(other) ; self.answer_text <=> other.answer_text ; end
  def correct? ; !!correct ; end
  def has_explanation? ; !!explanation ; end
  def initialize(answer_text, correct, explanation=nil)
    @answer_text = answer_text
    @correct = !!correct # ensure boolean
    @explanation = explanation
  end
end
