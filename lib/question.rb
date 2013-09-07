class Question
  require 'builder'
  attr_accessor :question_text, :answers, :randomize, :points, :name
  
  def initialize(*args)
    options = if args[-1].kind_of?(Hash) then args[-1] else {} end
    @answers = options[:answers] || []
    @points = [options[:points].to_i, 1].max
    @raw = options[:raw]
    @name = options[:name]
  end

  def raw? ; !!@raw ; end
  
  def text(s) ; @question_text = s ; end
  
  def explanation(text)
    @answers.each { |answer| answer.explanation ||= text }
  end

  def answer(text, opts={})
    @answers << Answer.new(text, correct=true, opts[:explanation])
  end

  def distractor(text, opts={})
    @answers << Answer.new(text, correct=false, opts[:explanation])
  end

  def correct_answer ;  @answers.detect(&:correct?)  ;  end

  def correct_answers ;  @answers.collect(&:correct?) ; end

end
