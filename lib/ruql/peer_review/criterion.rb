class Criterion

  attr_accessor :options, :feedback, :name, :label, :prompt

  def initialize(*args)
    @options = []
    @feedback = args[:feedback]
  end

  def name(s)   ; @name = s  ; end
  def label(s)  ; @label = s ; end
  def prompt(s) ; @prompt = s ; end
end
