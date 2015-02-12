require 'erb'
require 'ruql/tex_output'

class AutoQCMRenderer
  include TexOutput
  attr_reader :output
  
  def initialize(quiz, options={})
    @output = ''
    @quiz = quiz
    @template = options.delete('t') ||
      options.delete('template') ||
      File.join(Gem.loaded_specs['ruql'].full_gem_path, 'templates/autoqcm.tex.erb')
    @penalty = (options.delete('p') || options.delete('penalty') || '0').to_f
    @show_solutions = options.delete('s') || options.delete('solutions')
    
  end

  def render_quiz
    quiz = @quiz                # make quiz object available in template's scope
    with_erb_template(IO.read(File.expand_path @template)) do
      output = ''
      render_random_seed
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
    when SelectMultiple,TrueFalse then render(q, index, 'mult') # These are subclasses of MultipleChoice, should go first
    when MultipleChoice then render(q, index)
    else
      @quiz.logger.error "Question #{index} (#{q.question_text[0,15]}...): AutoQCM can only handle multiple_choice, truefalse, or select_multiple questions"
      ''
    end
  end

  def render_random_seed
    seed = @quiz.seed
    @output << "\n%% Random seed: #{seed}\n"
    @output << "\\AMCrandomseed{#{seed}}\n\n"
  end
  
  def render(question, index, type='')    
    output = ''
    output << "\\begin{question#{type}}{q#{index}}\n"
    output << "  \\scoring{b=#{question.points},m=#{@penalty*question.points}}\n"
    if type == 'mult'
      question.question_text = "Select ALL that apply. " + question.question_text
    elsif type == ''
      question.question_text = "Choose ONE answer. " + question.question_text
    end
    output << "  " << to_tex(question.question_text) << "\n"

    # answers - ignore randomization

    output << "  \\begin{choices}\n"
    question.answers.each do |answer|
      answer_text = to_tex(answer.answer_text)
      answer_type = if answer.correct? then 'correct' else 'wrong' end
      output << "    \\#{answer_type}choice{#{answer_text}}\n"
      if @show_solutions and answer.explanation
        explanation = to_tex(answer.explanation)
        if answer_type == 'wrong'
          output << "{\\color{red}\\tab #{explanation}}"
        else
          output << "{\\color[rgb]{0,.5,0}\\tab #{explanation}}"
        end
      end
    end
    output << "  \\end{choices}\n"
    output << "\\end{question#{type}}\n\n"
    output
  end

end
