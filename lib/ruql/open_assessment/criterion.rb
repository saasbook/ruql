class Criterion

  attr_accessor :options, :feedback, :criterion_name,
                :criterion_label, :criterion_prompt

  ##
  # Initializes a criterion
  def initialize(options={})
    @options = []
    @feedback = options[:feedback] || "required"
  end

  ##
  # Sets the criterion name
  def name(name)     ; @criterion_name = name     ; end

  ##
  # Sets the criterion label
  def label(label)   ; @criterion_label = label   ; end

  ##
  # Sets the criterion prompt
  def prompt(prompt) ; @criterion_prompt = prompt ; end

  ##
  # Adds an option to the block and evaluates the proc bloc
  def option(*args, &block)
    option = Option.new(*args)
    option.instance_eval(&block)
    raise "Missing option parameters" if option.missing_parameters?
    options << option
  end

  ##
  # Adds an already initialized option
  def add_option(option)
    options << option
  end

  ##
  # Validation to make sure that all the required fields are in
  def missing_parameters?
    @criterion_name.nil? || @criterion_label.nil? || @criterion_prompt.nil?
  end
end
