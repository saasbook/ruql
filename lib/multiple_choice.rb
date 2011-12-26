class MultipleChoice < Question

  def initialize(text='', opts={})
    super
    self.text = text
    yield self if block_given?
  end

  def randomize!
    new = []
    while !(@answers.empty?)
      new << @answers.delete(@answers.sample)
    end
    @answers = new
  end
end
