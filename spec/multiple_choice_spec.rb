require 'spec_helper'

describe 'Multiple choice question' do
  context 'when created' do
    context 'with question text and no block' do
      subject { MultipleChoice.new('question text') }
      its(:question_text) { should == 'question text' }
    end
    context 'with no text and block with text attr inside' do
      subject { q = MultipleChoice.new() ; q.text 'New' ; q }
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
end
