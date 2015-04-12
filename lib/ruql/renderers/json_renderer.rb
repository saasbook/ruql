class JSONRenderer
  require 'json'

  attr_reader :output

  def initialize(quiz,options={})
    @output = ''
    @json_array = []
    @quiz = quiz
  end

  def render_quiz
    @output = @quiz.questions.map {|question| JSON.pretty_generate(question.to_JSON)}
  end
end
