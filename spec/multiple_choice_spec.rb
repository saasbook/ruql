require 'spec_helper'
require 'question'
require 'multiple_choice'

describe 'Multiple choice question' do
  context 'when created' do
    context 'with question text and no block' do
      subject { MultipleChoice.new('question text') }
      its(:question_text) { should == 'question text' }
    end
    context 'with no text and block with text attr inside' do
      subject { MultipleChoice.new() do |q| ; q.text 'New' ; end }
      its(:question_text) { should ==  'New' }
    end
  end
  context 'creating answers' do
    before :each do ; @q = MultipleChoice.new('question') ; end
    describe 'that are correct' do
      it 'with an explanation' do
        @q.answer 'sample', :explanation => 'why'
        @q.correct_answer.explanation.should == 'why'
        @q.correct_answer.answer_text.should == 'sample'
      end
    end
  end
  context 'rendering full question' do
    subject {
      @q = MultipleChoice.new :multiple => true, :randomize => true
      @q.text 'question'
      @q.answer 'answer', :explanation => 'correct'
      @q.distractor 'wrong'
      @q.distractor 'wrong with explanation', :explanation => 'wrong'
      @q.to_xml
      @q.string
    }
    it { should have_xml_element('question/text') }
    it { should have_xml_element('//option-group').containing(2, 'option') }
    it { should have_xml_element('//option/text', :value => 'wrong') }
  end    
end
