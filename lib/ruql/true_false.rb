class TrueFalse < Question

  def initialize(text, correct_answer, opts=nil)
    super
    opts ||= {}
    opts[:explanation] ||= ''
    correct_answer = !!correct_answer # ensure 'true' or 'false' only
    self.question_text = "True or False: #{text}"
    self.answer correct_answer.to_s.capitalize
    self.distractor (!correct_answer).to_s.capitalize, :explanation => opts[:explanation]
  end

  def multiple ; false ; end
  def incorrect_answer ; self.answers.reject(&:correct).first ; end
  def explanation ; incorrect_answer.explanation ; end
    
end
