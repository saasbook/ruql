class SelectMultiple < MultipleChoice

  def initialize(text='', opts={})
    super
    self.multiple = true
  end

end
