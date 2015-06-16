class Option
  attr_accessor :points, :opt_name, :opt_label, :opt_explanation

  ##
  # Initializes an option
  def initialize(options={})
    @points = options[:points] || 0
  end

  ##
  # Adds name to option
  def name(name)               ; @opt_name = name               ; end

  ##
  # Adds label to option
  def label(label)             ; @opt_label = label             ; end

  ##
  # Adds explanation to option
  def explanation(explanation) ; @opt_explanation = explanation ; end

  ##
  # Sets preset option paramters
  def add_params(score_array)
    _, @opt_label, @opt_explanation = score_array
    @opt_name = @opt_label
  end

  ##
  # Validation to make sure that all the required fields are in
  def missing_parameters?
    @opt_name.nil? || @opt_label.nil? || @opt_explanation.nil?
  end
end
