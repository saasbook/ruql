class TrueFalse < Question

  def initialize(text, correct_answer, explanation=nil)
    super
    correct_answer = !!correct_answer # ensure 'true' or 'false' only
    self.question_text = "True or False: #{text}"
    self.answer correct_answer.to_s.capitalize
    self.distractor (!correct_answer).to_s.capitalize, :explanation => explanation
  end

  def incorrect_answer ; self.answers.reject(&:correct).first ; end
  def explanation ; incorrect_answer.explanation ; end
    
end
