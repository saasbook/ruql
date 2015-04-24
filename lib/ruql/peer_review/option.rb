class Option
  attr_accessor :points, :opt_name, :opt_label, :opt_explanation

  def initialize(options={})
    @points = options[:points] || 0
  end

  def name(name)               ; @opt_name = name               ; end
  def label(label)             ; @opt_label = label             ; end
  def explanation(explanation) ; @opt_explanation = explanation ; end
end
