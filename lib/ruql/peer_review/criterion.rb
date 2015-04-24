class Criterion

  attr_accessor :options, :feedback, :name, :label, :prompt

  def initialize(*args)
    @options = []
    @feedback = args[:feedback]
  end

  def name(name)     ; @name = name     ; end
  def label(label)   ; @label = label   ; end
  def prompt(prompt) ; @prompt = prompt ; end

  def options(*args, &block)
    option = Option.new(*args)
    option.instance_eval(&block)
    binding.pry
    options << option
  end
end
