class Option
  attr_accessor :points, :name, :label, :explanation

  def initialize(*args)
    @points = args[:points] || 0
  end

  def name(name)               ; @name = name               ; end
  def label(label)             ; @label = label             ; end
  def explanation(explanation) ; @explanation = explanation ; end
end
