require 'builder'

class Quiz
  
  def default_options
    {
      :open_time => Time.now,
      :soft_close_time => Time.now + 24*60*60,
      :hard_close_time => Time.now + 24*60*60,
      :maximum_submissions => 1,
      :duration => 0,
    }
  end

  def initialize(title, options)
    @output = ''
    @xml = Builder::XmlMarkup.new(:target => @output)
    @xml.instruct!
    @xml.declare! :DOCTYPE, :quiz, :SYSTEM, "quiz.dtd"
    @title = title
    @options = default_options.merge(options)
    @xml.quiz do
      emit_metadata
    end
  end

  def render ; @output ; end
  
  def self.quiz(title, options={})
    quiz = Quiz.new(title, options)
    debugger
  end

  private

  def emit_metadata
    @xml.metadata do
      @xml.type 'quiz'
      @xml.title @title
      @options.each_pair do |k,v|
        @xml.__send__(k.to_s.gsub(/_/,'-').to_sym, v)
      end
    end
  end

end
