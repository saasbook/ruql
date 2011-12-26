require 'spec_helper'
require 'question'
require 'multiple_choice'

describe 'Multiple choice question' do
  context 'when created' do
    context 'with question text and no block' do
      subject { MultipleChoice.new('question text') }
      its(:text) { should == 'question text' }
    end
    context 'with no text and block with text attr inside' do
      subject { MultipleChoice.new() do |q| ; q.text = 'New' ; end }
      its(:text) { should ==  'New' }
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
  describe 'order of answers' do
    before :each do
      @q = MultipleChoice.new()
      @q.distractor 'wrong 0'
      @q.answer 'correct 1'
      @q.distractor 'wrong 2'
    end
    context 'if randomized' do
      it 'should be random' do
        # at least 1 trial out of 10 should move answer position
        randomized = false
        10.times do
          @q.randomize!
          randomized = true if @q.answers.first != 'wrong 0'
        end
        randomized.should be_true
      end
      it 'should have same number of elements' do
        @q.randomize!
        @q.should have(3).answers
      end
    end
  end  
end
