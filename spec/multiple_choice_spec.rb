require 'spec_helper'

describe 'Multiple choice question' do
  context 'when created' do
    specify 'with question text and no block' do
      subject = MultipleChoice.new('question text')
      expect(subject.question_text).to eq('question text')
    end
    specify 'with no text and block with text attr inside' do
      q = MultipleChoice.new()
      q.text 'New'
      expect(q.question_text).to eq('New')
    end
  end
  context 'creating answers' do
    before :each do ; @q = MultipleChoice.new('question') ; end
    describe 'that are correct' do
      specify 'with an explanation' do
        @q.answer 'sample', :explanation => 'why'
        expect(@q.correct_answer.explanation).to eq('why')
        expect(@q.correct_answer.answer_text).to eq('sample')
      end
    end
  end
end
