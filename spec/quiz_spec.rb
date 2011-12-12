require 'spec_helper'
require 'quiz'
require 'ruby-debug'

describe Quiz do
  describe 'new quiz' do
    subject { Quiz.new('Foo', :maximum_submissions => 2, :start => '2011-01-01 00:00', :time_limit => 60).render }
    it { should have_xml_element 'quiz/metadata/title', :value => 'Foo' }
    it { should have_xml_element 'quiz/metadata/maximum-submissions', :value => 2 }
  end
end
