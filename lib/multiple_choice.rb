class MultipleChoice < Question

  def initialize(text='')
    self.text = text
    yield self if block_given?
  end

end
