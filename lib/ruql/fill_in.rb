class FillIn < Question

    attr_accessor :order
    attr_accessor :case_sensitive

  def initialize(text='', opts={})
    super
    self.question_text = text
    self.order =  !!opts[:order]
    self.case_sensitive = !!opts[:case_sensitive]
  end

  def multiple ; false ; end

end
