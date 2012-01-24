require 'spec_helper'
require 'xml_renderer'
require 'renderer'

describe XmlRenderer do
  describe 'when created' do
    subject { XmlRenderer.new(:fake_quiz) }
    its(:quiz) { should == :fake_quiz }
    its(:output) { should == '' }
  end
end

    
