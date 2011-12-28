class MultipleChoice < Question

  attr_accessor :multiple
  
  def initialize(text='', opts={})
    super
    self.question_text = text
    self.multiple =  !!opts[:multiple]
    self.randomize = !!opts[:randomize]  
    yield self if block_given?
  end

  def to_xml
    select_options = {}
    select_options['randomise-option-order'] = !!(self.randomize).to_s
    select_options['multiple'] = '1' if self.multiple
    builder.question :type => 'choice-answer' do
      builder.text self.question_text
      builder.select(select_options) do 
        builder.__send__('option-group') {  self.render_answers(builder) }
      end
      builder.grader :name => 'Choice_Answer_Grader'
    end
  end
end
