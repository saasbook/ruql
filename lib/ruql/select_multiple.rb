class SelectMultiple < Question

  attr_accessor :multiple
  
  def initialize(text='', opts={})
    super
    self.question_text = text
    self.multiple = true
  end

end
