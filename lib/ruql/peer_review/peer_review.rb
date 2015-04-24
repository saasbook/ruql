class PeerReview

  attr_accessor :title, :prompts, :criterions, :name

  def initialize(*args)
    @prompts = []
    @criterions = []
  end

  def title(title)      ; @title  = title    ; end
  def prompt(prompt)    ; @prompts << prompt ; end

  def criterion(*args, &block)
    criterion = Criterion.new(*args)
    criterion.instance_eval(&block)
    binding.pry
    @criterions << criterion
  end
end
