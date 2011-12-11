require 'spec_helper'
require 'support/matchers/xml_matcher'
require 'quiz'

describe Quiz do
  describe 'when initialized' do
    subject { Quiz.new('Foo', :maximum_submissions => 2, :start => '2011-01-01 00:00', :time_limit => 60).xml }
    it { should have_xml_element 'title', :value => 'Foo' }
  end
end
