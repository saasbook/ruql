def PeerReview

  attr_accessor :title, :prompts, :criterions

  def initialize(*args)
    @prompts = []
    @criterions = []
  end

  def title(s)     ; @title  = s   ; end
  def prompt(s)    ; @prompts << s ; end
  def criterion(s) ; @criterions << c ; end
end
