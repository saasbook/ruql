require 'spec_helper'
require 'quiz'
require 'ruby-debug'

describe Quiz do
  describe 'should include XML elements' do
    subject { Quiz.new('Foo', :maximum_submissions => 2, :start => '2011-01-01 00:00', :time_limit => 60).render }
    {'title' => 'Foo',
      'maximum-submissions' => '2',
      'type' => 'quiz' }.each_pair do |element, value|
      it { should have_xml_element "quiz/metadata/#{element}", :value => value }
    end
    %w(retry-delay open-time soft-close-time hard-close-time duration retry-delay maximum-submissions feedback-immediate feedback-after-hard-deadline randomise-question-group-order randomise-question-order randomise-option-order version default-question-group-break).each do |element|
      it { should have_xml_element "quiz/metadata/#{element}" }
    end
  end
  describe 'parsing questions' do
    it 'should not raise error' do
      lambda { Quiz.quiz('foo') {  } }.should_not raise_error
    end
  end
        
end
