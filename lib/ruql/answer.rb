class Answer
  include Comparable
  attr_accessor :answer_text, :explanation, :correct
  attr_reader :correct
  attr_reader :builder
  attr_reader :question

  def <=>(other) ; self.answer_text <=> other.answer_text ; end
  def correct? ; !!correct ; end
  def has_explanation? ; !!explanation ; end
  def initialize(answer_text = '', correct = false, explanation=nil)
    @answer_text = answer_text
    @correct = !!correct # ensure boolean
    @explanation = explanation
  end
  
  def to_JSON
    Hash[instance_variables.collect { |var| [var.to_s.delete('@'), instance_variable_get(var)] }]
  end

  def self.from_JSON(hash)
    answer = Answer.new
    hash.each do |key, value|
      answer.send((key + '=').to_sym, value)
    end
    answer
  end
end
