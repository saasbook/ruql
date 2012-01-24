require 'spec_helper'

describe XmlRenderer do
  def c(str) ;
    @b ||= Builder::XmlMarkup.new
    @b.cdata!(str)
  end
  describe 'when created' do
    subject { XmlRenderer.new(:fake_quiz) }
    its(:quiz) { should == :fake_quiz }
    its(:output) { should == '' }
  end
  describe 'calling renderers' do
    before(:each) do ; @x = XmlRenderer.new(:fake_quiz) ; end
    it 'should call MultipleChoice renderer for multiple choice question' do
      q = mock('multiple choice question', :class => 'MultipleChoice')
      @x.should_receive(:render_multiple_choice).with(q)
      @x.render(q)
    end
  end
  describe 'rendering' do
    describe 'correct answer without explanation' do
      subject { XmlRenderer.new(:fake_quiz).render(Question::Answer.new('correct', true)) }
      it { should have_xml_element('option').with_attribute('selected-score', '1') }
      it { should have_xml_element('option/text', :value => c('correct')) }
      it { should_not have_xml_element 'option/explanation' }
    end
    describe 'distractor with explanation' do
      subject { XmlRenderer.new.render(Question::Answer.new('wrong', false, 'why')) }
      it { should have_xml_element 'option/explanation', :value => 'why' }
    end
    describe 'multiple choice question with answers' do
      subject {
        @q = MultipleChoice.new :multiple => true, :randomize => true
        @q.text 'question'
        @q.answer 'answer', :explanation => 'correct'
        @q.distractor 'wrong'
        @q.distractor 'wrong with explanation', :explanation => 'wrong'
        XmlRenderer.new(:fake_quiz).render(@q)
      }
      it { should have_xml_element('question/data/text') }
      it { should have_xml_element('//option_group').containing(2, 'option') }
      it { should have_xml_element('//option/text', :value => c('wrong')) }
    end    
  end
end

  
