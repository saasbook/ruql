class Option
  attr_accessor :points, :opt_name, :opt_label, :opt_explanation

  def initialize(options={})
    @points = options[:points] || 0
  end

  def name(name)               ; @opt_name = name               ; end
  def label(label)             ; @opt_label = label             ; end
  def explanation(explanation) ; @opt_explanation = explanation ; end

  def add_params(score_array)
    _, @opt_label, @opt_explanation = score_array
    @opt_name = @opt_label
  end

  def missing_parameters?
    @opt_name.nil? || @opt_label.nil? || @opt_explanation.nil?
  end
end
