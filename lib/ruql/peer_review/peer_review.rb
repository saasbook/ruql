class PeerReview

  attr_accessor :title, :prompts, :criterions, :name

  def initialize(*args)
    @prompts = []
    @criterions = []
  end

  def title(s)     ; @title  = s   ; end
  def prompt(s)    ; @prompts << s ; end
  def criterion(*args, &block)
    c = Criterion.new(*args)
    c.instance_eval(&block)
    binding.pry
    @criterions << c
  end
end
