class MultipleChoice < Question

  attr_accessor :multiple
  
  def initialize(text='', opts={})
    super
    self.question_text = text
    self.multiple =  !!opts[:multiple]
    self.randomize = !!opts[:randomize]  
  end

end
