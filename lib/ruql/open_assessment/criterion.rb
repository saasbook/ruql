class Criterion

  attr_accessor :options, :feedback, :criterion_name,
                :criterion_label, :criterion_prompt

  def initialize(options={})
    @options = []
    @feedback = options[:feedback]
  end

  def name(name)     ; @criterion_name = name     ; end
  def label(label)   ; @criterion_label = label   ; end
  def prompt(prompt) ; @criterion_prompt = prompt ; end

  def option(*args, &block)
    option = Option.new(*args)
    option.instance_eval(&block)

    raise "Missing option parameters" if option.missing_parameters?

    options << option
  end

  def add_option(option)
    options << option
  end

  def missing_parameters?
    return @name.nil? || @label.nil? || @prompt.nil?
  end
end
