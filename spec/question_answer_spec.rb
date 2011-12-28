require 'spec_helper'
require 'question'
require 'builder'

describe Question::Answer do
  describe 'XML representation' do
    before :each do
      @o = ''
      @x = Builder::XmlMarkup.new(:target => @o)
    end
    describe 'of correct answer without explanation' do
      subject { Question::Answer.new(@x,'answer', true).to_xml ; @o }
      it { should have_xml_element('option').with_attribute('selected-score', '1') }
      it { should have_xml_element('option/text', :value => 'answer') }
      it { should_not have_xml_element 'option/explanation' }
    end
    describe 'of distractor with explanation' do
      subject { Question::Answer.new(@x, 'wrong', false, 'why').to_xml ; @o }
      it { should have_xml_element 'option/explanation', :value => 'why' }
    end
  end
        
end
