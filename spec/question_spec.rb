require 'spec_helper'

describe Question do
  describe 'tags' do
    it 'should be empty array by default' do
      Question.new.question_tags.should be_empty
    end
    describe 'setting' do
      before(:each) { @q = Question.new }
      it 'single string tag' do
        @q.tags 'string'
        @q.question_tags.should include 'string'
      end
      it 'single nonstring gets converted to string' do
        @q.tags 25
        @q.question_tags.should include '25'
      end
      it 'array of strings or nonstrings' do
        @q.tags 'tag', 30
        @q.question_tags.should include('tag')
        @q.question_tags.should include('30')
      end
    end
  end
  describe 'comment' do
    it 'should be empty by default' do
      Question.new.question_comment.should == ''
    end
    it 'should be settable to a string' do
      @q = Question.new
      @q.comment 'comment'
      @q.question_comment.should == 'comment'
    end
  end
  describe 'points' do
    it 'should be 1 by default' do
      Question.new.points.should == 1
    end
    it 'should be overridable' do
      Question.new(:points => 3).points.should == 3
    end
  end
  describe 'raw question' do
    subject { Question.new(:raw => true) }
    it { should be_raw }
  end
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

    
