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
end
