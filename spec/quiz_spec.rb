require 'spec_helper'
require 'quiz'
require 'xml_renderer'
require 'ruby-debug'

describe Quiz do
  describe 'when created with XML renderer' do
    subject { Quiz.new('Foo', 'xml') }
    its(:title) { should == 'Foo' }
    its(:renderer) { should be_an_instance_of XmlRenderer }
    its(:questions) { should be_empty }
  end
  
  describe 'should include XML elements' do
    subject { Quiz.new('Foo', 'xml', :maximum_submissions => 2, :start => '2011-01-01 00:00', :time_limit => 60).render }
    {'title' => 'Foo',
      'maximum-submissions' => '2',
      'type' => 'quiz' }.each_pair do |element, value|
      it { should have_xml_element "quiz/metadata/#{element}", :value => value }
    end
    %w(retry-delay open-time soft-close-time hard-close-time duration retry-delay maximum-submissions feedback-immediate feedback-after-hard-deadline randomise-question-group-order randomise-question-order randomise-option-order version default-question-group-break).each do |element|
      it { should have_xml_element "quiz/metadata/#{element}" }
    end
  end
end
