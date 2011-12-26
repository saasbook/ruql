require 'spec_helper'
require 'question'

describe Question do
  describe 'emitting XML' do
    subject {
      q = Question.new
      q.answers = mock 'answers'
      q
    }
  end
end

    
