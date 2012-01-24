require 'spec_helper'

describe Question::Answer do
  describe 'XML representation' do
    before :each do
      @o = ''
      @x = Builder::XmlMarkup.new(:target => @o)
    end
  end
        
end
