require 'spec_helper'

describe Quiz do
  describe 'when created' do
    subject { Quiz.new('Foo') }
    its(:title) { should == 'Foo' }
    its(:questions) { should be_empty }
  end
  it 'should compute points based on its questions' do
    Quiz.new('quiz',:questions => Array.new(3) { mock 'question', :points => 7 }).points.should == 21
  end
end
