class Option
  attr_accessor :points, :name, :label, :explanation

  def initialize(*args)
    @points = args[:points] || 0
  end

  def name(s)      ;   @name = s  ; end
  def label(s)     ;   @label = s ; end
  def explanation(s) ; @explanation = s ; end
end
