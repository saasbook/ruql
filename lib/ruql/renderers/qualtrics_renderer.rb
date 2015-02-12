class QualtricsRenderer

  attr_reader :output
  
  def initialize(quiz, options={})
    @output = ''
    @quiz = quiz
    @template = options.delete('t') || options.delete('template')
  end

  def render_quiz
    quiz = @quiz                # make quiz object available in template's scope
    with_erb_template(IO.read(File.expand_path @template)) do
      output = ''
      @quiz.questions.each_with_index do |q,i|
        next_question = render_question q,i
        output << next_question
      end
      output
    end
  end

  def with_erb_template(template)
    # template will 'yield' back to render_quiz to render the questions
    @output = ERB.new(template).result(binding)
  end

  def render_question(q,index)
    case q
    when SelectMultiple,TrueFalse then render(q, index, 'Multiple') # These are subclasses of MultipleChoice, should go first
    when MultipleChoice then render(q, index, 'Single')
    else
      @quiz.logger.error "Question #{index} (#{q.question_text[0,15]}...): Only written to handle multiple_choice, truefalse, or select_multiple questions at this time."
      ''
    end
  end
  
  def render(question, index, type='')    
    output = ''
    output << "[[Question:MC:#{type}Answer]]\n"
    output << "[[ID:#{index}]]\n"
    if type == 'Multiple'
      question.question_text = "Select ALL that apply. " + question.question_text
    elsif type == 'Single'
      question.question_text = "Choose ONE answer. " + question.question_text
    end
    output << question.question_text << "\n"

    # answers - ignore randomization

    output << "[[AdvancedChoices]]\n"
    question.answers.each do |answer|
      output << "[[Choice]]\n"
      output << "#{answer.answer_text}\n"
    end
    if type == 'Multiple'
      output << "[[Choice]]\n"
      output << "<i>None of these answers are correct.</i>\n"
    end
    output
  end

end
