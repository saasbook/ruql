module Ruql
  class Json
    attr_reader :output
    def initialize(quiz, options={})
      @quiz = quiz
      @output = ''
    end
    def render_quiz
      @output = JSON.pretty_generate(@quiz.as_json)
    end
  end
end
