require 'spec_helper'

describe Answer do
  describe 'XML representation' do
    before :each do
      @o = ''
      @x = Builder::XmlMarkup.new(:target => @o)
    end
  end
end
