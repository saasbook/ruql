class JSONRenderer
  require 'json'

  attr_reader :output

  def initialize(quiz,options={})
    @output = ''
    @json_array = []
    @quiz = quiz
  end

  def render_quiz
    @quiz.questions.each do |question|
      case question
      when MultipleChoice, SelectMultiple, TrueFalse then render_multiple_choice(question)
      when FillIn then render_fill_in(question) # not currently supported
      else
        raise "Unknown question type: #{question}"
      end
    end
    @output = JSON.pretty_generate(@json_array)
  end

  def render_multiple_choice(question)
    question_hash = {
      "text" => question.question_text,
      "answers" => answers_to_json_array(question.answers)
    }
    @json_array.push(question_hash)
  end

  def answers_to_json_array(answers)
    answers_array = []
    answers.each do |answer|
      answer_json = {
        "text" => answer.answer_text,
        "explanation" => answer.explanation,
        "correct" => answer.correct
      }
      answers_array.push(answer_json)
    end
    answers_array
  end

  def render_fill_in(q)
    # fill-in-the-blank questions not currently supported
  end

end
