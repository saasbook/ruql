require 'spec_helper'

describe AutoQCMRenderer do
  describe 'new' do
    subject { AutoQCMRenderer.new(:fake_quiz, {'t' => 'fake_template'}) }
    its(:output) { should be_empty }
  end
  shared_examples_for 'all questions' do
    it 'should ignore explanation'
  end
  describe 'rendering single-answer multiple choice' do
    context 'cooked' do
      before :each do
        @q = MultipleChoice.new(
          :text => 'Question text with_illegal $chars #',
          :answers => [
            Answer.new('correct', true, 'explanation 1'),
            Answer.new('wrong 1', false, 'explanation 2'),
            Answer.new('wrong 2', false, 'explanation 3')
          ]
          )
      end
    end
  end
end
