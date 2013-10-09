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
  describe 'should include required XML elements when XML renderer used' do
    subject { Quiz.new('Foo', :maximum_submissions => 2, :start => '2011-01-01 00:00', :time_limit => 60).render_with('XML') }
    {'title' => 'Foo',
      'maximum_submissions' => '2',
      'type' => 'quiz' }.each_pair do |element, value|
      it { should have_xml_element "quiz/metadata/#{element}", :value => value }
    end
    %w(retry_delay open_time soft_close_time hard_close_time duration retry_delay maximum_submissions maximum_score).each do |element|
      it { should have_xml_element "quiz/metadata/#{element}" }
    end
    %w(question option score).each do |element|
      it { should have_xml_element "quiz/metadata/parameters/show_explanations/#{element}" }
    end
  end

end
