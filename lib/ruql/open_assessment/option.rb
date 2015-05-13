class Option
  attr_accessor :points, :opt_name, :opt_name, :opt_explanation

  def initialize(options={})
    @points = options[:points] || 0
  end

  def name(name)               ; @opt_name = name               ; end
  def label(label)             ; @opt_label = label             ; end
  def explanation(explanation) ; @opt_explanation = explanation ; end

  def missing_parameters?
    @opt_name.nil? || @opt_name.nil? || @opt_explanation.nil?
  end
end
