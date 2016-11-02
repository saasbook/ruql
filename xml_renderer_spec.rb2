require 'spec_helper'

describe XMLRenderer do
  def c(str) 
    @b ||= Builder::XmlMarkup.new
    @b.cdata!(str)
  end
  describe 'when created' do
    subject { XMLRenderer.new(:fake_quiz) }
    its(:output) { should == '' }
  end
  describe 'calling renderers' do
    before(:each) do ; @x = XMLRenderer.new(:fake_quiz) ; end
    it 'should call MultipleChoice renderer for SelectMultiple question' do
      q = SelectMultiple.new('question', :answers =>
        [Answer.new('y1', true), Answer.new('n1', false), Answer.new('y2',true)])
      @x.should_receive(:render_multiple_choice).with(q)
      @x.render(q)
    end
  end
  describe 'answer for radiobutton question' do
    subject do
      q = MultipleChoice.new('question', :multiple => false, :answers =>
        [Answer.new('y', true), Answer.new('n1', false), Answer.new('n2',false)])
      XMLRenderer.new(:fake_quiz).render_multiple_choice(q)
    end
    ['n1','n2'].each do |wrong|
      it { should have_xml_element(
          "//option[@selected_score='0',@unselected_score='0']/text", :value =>c(wrong))}
    end
    it { should have_xml_element(
        "//option[@selected_score='1',@unselected_score='0']/text", :value =>c('y'))}
  end
  describe 'answer for select-all-that-apply questions' do
    subject do
      q = MultipleChoice.new('question', :multiple => true, :answers =>
        [Answer.new('y1', true), Answer.new('n1', false), Answer.new('y2',true)])
      XMLRenderer.new(:fake_quiz).render_multiple_choice(q)
    end
    it { should have_xml_element(
        "//option[@selected_score='0',@unselected_score='1']/text", :value =>c('n1'))}
    %w(y1 y2).each do |y|
      it { should have_xml_element(
          "//option[@selected_score='1',@unselected_score='0']/text", :value =>c(y))}
    end
  end
  describe 'rendering' do
    describe 'correct answer without explanation' do
      subject { XMLRenderer.new(:fake_quiz).render_multiple_choice_answer(Answer.new('correct', true), nil) }
      it { should have_xml_element('option').with_attribute('selected-score', '1') }
      it { should have_xml_element('option/text', :value => c('correct')) }
      it { should_not have_xml_element 'option/explanation' }
    end
    describe 'distractor with explanation' do
      subject { XMLRenderer.new(:fake).render_multiple_choice_answer(Answer.new('wrong', false, 'why'), nil) }
      it { should have_xml_element 'option/explanation', :value => c('why') }
    end
    describe 'multiple choice question with answers' do
      subject {
        @q = MultipleChoice.new :multiple => true, :randomize => true
        @q.text 'question'
        @q.answer 'answer', :explanation => 'correct'
        @q.distractor 'wrong'
        @q.distractor 'wrong with explanation', :explanation => 'wrong'
        XMLRenderer.new(:fake_quiz).render(@q)
      }
      it { should have_xml_element('question/data/text') }
      it { should have_xml_element('//option_group').containing(2, 'option') }
      it { should have_xml_element('//option/text', :value => c('wrong')) }
    end    
  end
end

  
