class Quiz
  require 'builder'
  attr_reader :xml

  class MultipleChoiceQuestion
    attr_accessor :text, :answer, :score
  end

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
    @xml = Builder::XmlMarkup.new
    @xml.instruct!
    @xml.declare! '!DOCTYPE', 'quiz', 'SYSTEM', '"quiz.dtd"'
    @title = title
    options = default_options.merge(options)
    @xml.metadata do
      @xml.type 'quiz'
      @xml.title title
    end
  end

  def render
    @xml.to_s
  end

  def self.quiz(title, options={})
    quiz = Quiz.new(title, options)
    debugger
  end

end
