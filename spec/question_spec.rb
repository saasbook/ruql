require 'spec_helper'

describe Question do
  describe 'default explanation' do
    before(:each) do
      @q = Question.new
      @q.text 'question'
      @q.answer 'answer'
      @q.distractor 'distractor'
    end
    it 'if absent should mean no answers have explanation' do
      @q.answers.each do |ans|
        ans.explanation.should be_nil
      end
    end
    it 'should apply when individual answers have no explanation' do
      @q.explanation 'expl'
      @q.answers.each do |ans|
        ans.explanation.should == 'expl'
      end
    end
    it 'should not override per-answer explanation' do
      @q.answer 'new answer', :explanation => 'new explanation'
      @q.explanation 'expl'
      @q.answers.each do |ans|
        ans.explanation.should == (ans.answer_text =~ /new/ ? 'new explanation' : 'expl')
      end
    end
  end
end

    
