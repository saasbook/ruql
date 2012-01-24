class XmlRenderer
  require 'builder'

  attr_reader :output, :quiz
  def initialize(quiz)
    @output = ''
    @builder = Builder::XmlMarkup.new(:target => @output)
    @quiz = quiz
  end

  def render_quiz
    @builder.instruct!
    @builder.declare! :DOCTYPE, :quiz, :SYSTEM, "quiz.dtd"
    @builder.quiz do
      @builder.metadata do
        @builder.type 'quiz'
        @builder.title @quiz.title
        @quiz.options.each_pair do |k,v|
          @builder.__send__(k.to_s.gsub(/_/,'-').to_sym, v)
        end
      end
    end
    @output
  end
  
end
