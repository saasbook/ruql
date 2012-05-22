require 'spec_helper'

describe 'question with true answer' do
  before :each do ; @q = TrueFalse.new('true', true, :explanation => 'why') ; end
  it 'should have True as correct answer' do
    @q.correct_answer.answer_text.should == 'True'
  end
  it 'should have explanation for False answer' do
    @q.incorrect_answer.explanation.should == 'why'
  end
  it 'should not have explanation for correct answer' do
    @q.correct_answer.explanation.should be_nil
  end
end
