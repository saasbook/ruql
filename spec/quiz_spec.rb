require 'spec_helper'

describe Quiz do
  specify 'when created' do
    @q = Quiz.new('Foo') 
    expect(@q.title).to eq('Foo')
    expect(@q.questions). to be_empty
  end
  it 'should compute points based on its questions' do
    @q = Quiz.new('quiz',:questions => Array.new(3) { double('question', :points => 7, :question_group => nil) })
    expect(@q.points).to eq(21)
  end
end
