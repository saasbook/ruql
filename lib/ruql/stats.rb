module Ruql
  class Stats
    attr_reader :output, :quiz
    # a pseudo-renderer that just prints stats about the quiz
    def initialize(quiz, options={})
      @quiz = quiz
      @output = []
    end
    def render_quiz
      @output << "%3d questions" % quiz.questions.length
      @output << "    %3d (%d points) in no group" % [quiz.ungrouped_questions.length, quiz.ungrouped_points]
      @output << "    %3d (%d points) in %d groups" % [quiz.grouped_questions.length, quiz.grouped_points, quiz.groups.length]
      @output << "%3d effective questions on quiz" % quiz.num_questions
      @output << "%3d max points possible" % quiz.points
      @output.join("\n")
    end
  end
end
