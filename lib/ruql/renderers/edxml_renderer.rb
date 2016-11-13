require 'builder'
require 'yaml'

class EdXmlRenderer

  attr_reader :output
  attr_accessor :file
  def initialize(quiz,options={})
    @only_question = options.delete('n') || options.delete('name')
    @output = ''
    @b = Builder::XmlMarkup.new(:target => @output, :indent => 2)
    @quiz = quiz
  end

  def render(thing)
    case thing
    when MultipleChoice,SelectMultiple,TrueFalse then render_multiple_choice(thing)
    when FillIn then render_fill_in(thing)
    when OpenAssessment then render_open_assessment(thing)
    when Dropdown then render_dropdown(thing)
    else
      raise "Unknown question type: #{thing}"
    end
  end

  def render_quiz
    # entire quiz can be in one question group, as long as we specify
    # that ALL question from the group must be used to make the quiz.
    question_list = if @only_question
                    then @quiz.questions.select { |q| q.name == @only_question }
                    else @quiz.questions
                    end
    question_list.each { |question| render(question) }
    @output
  end

  def render_multiple_choice(question)
    # the OLX for select-multiple and select-one are frustratingly different in arbitrary ways
    # single choice has <multiplechoiceresponse> element containing a <choicegroup> with <choice>s
    # select-mult has <choiceresponse> element containing a <checkboxgroup> with <choice>s

    question_type, answer_type =
      if question.kind_of?(SelectMultiple)
      then ['choiceresponse', 'checkboxgroup']
      else ['multiplechoiceresponse', 'choicegroup']
      end
    @b.problem do
      # if question text has explicit newlines, use them to separate <p>'s
      if question.raw?
        @b.p { |p| p << question.question_text }
      else
        question.question_text.lines.map(&:chomp).each do |line|
          if question.raw? then @b.p { |p| p << line } else @b.p(line) end
        end
      end

      @b.__send__(question_type) do
        @b.__send__(answer_type, :type => 'MultipleChoice') do
          question.answers.each do |answer|
            if question.raw?
              @b.choice(:correct => answer.correct?) { @b << answer.answer_text.chomp }
            else
              @b.choice answer.answer_text, :correct => answer.correct?
            end
          end
        end
      end
      if (ans = question.correct_answer.explanation)
        @b.solution do
          @b.div :class => 'detailed-solution' do
            @b.p 'Explanation'
            if question.raw?
              @b.p { |p| p << ans }
            else
              @b.p ans
            end
          end
        end
      end
    end
  end

  def render_dropdown(question)
    @b.problem do
      if question.raw?
        @b.p { |p| p << question.question_text }
      else
        question.question_text.lines.map(&:chomp).each do |line|
          if question.raw? then @b.p { |p| p << line } else @b.p(line) end
        end
      end
      question.choices.each do |choice|
        idx = choice.correct
        menu_opts = choice.list
        if menu_opts.length == 1 # this is actually a label
          @b.span menu_opts[0]
        else
          @b.optionresponse do
            debugger if menu_opts[idx].nil?
            @b.optioninput :options => options_list_for_attribute(menu_opts),
            :correct => escape_doublequotes(menu_opts[idx])
          end
        end
      end
    end
  end
  
  def render_open_assessment(question)
    @b.openassessment url_name: question.url_name,
                      submission_start: "#{question.submission_start.to_s}T"\
                                        "#{question.submission_start_time}:00+00:00",
                      submission_due: "#{question.submission_due.to_s}T"\
                                      "#{question.submission_due_time}:00+00:00",
                      allow_file_upload: question.allow_file_upload.to_s.capitalize,
                      allow_latex: question.allow_latex.to_s.capitalize do

      @b.title question.question_title

      # Oh good lord my eyes
      @b.assessments do
        if question.trainings.size > 0
          @b.assessment name: "student-training" do
            question.trainings.each do |training|
              @b.example do
                @b.answer do
                  @b.part training.training_answer
                end
                training.training_criterions.each do |criterion|
                  @b.select criterion: criterion.criterion,
                            option:    criterion.option
                end
              end
            end
          end
        end

        if question.peer_review
          @b.assessment name: "peer-assessment",
                        must_grade: question.must_grade,
                        must_be_graded_by: question.graded_by,
                        start: "#{question.peer_review_start.to_s}T" \
                               "#{question.peer_review_start_time}:00+00:00",
                        due: "#{question.peer_review_due.to_s}T"\
                             "#{question.peer_review_due_time}:00+00:00"

        end

        if question.self_assessment
          @b.assessment name: "self-assessment",
                        start: "#{question.self_assessment_start.to_s}T"\
                               "#{question.self_assessment_start_time}:00+00:00",
                        due: "#{question.self_assessment_due.to_s}T"\
                             "#{question.self_assessment_due_time}:00+00:00"
        end
      end

      @b.prompts do
        question.prompts.each do |description|
          @b.prompt do
            @b.description description
          end
        end
      end

      @b.rubric do
        question.criterions.each do |criterion|
          @b.criterion feedback: criterion.feedback do
            @b.name   criterion.criterion_name
            @b.label  criterion.criterion_label
            @b.prompt criterion.criterion_prompt

            criterion.options.each do |option|
              @b.option points: option.points do
                @b.name        option.opt_name
                @b.label       option.opt_label
                @b.explanation option.opt_explanation
              end
            end
          end
        end
        @b.feedbackprompt        question.question_feedback_prompt
        @b.feedback_default_text question.question_feedback_default_text
      end
    end
  end

  private

  def escape_doublequotes(str)
    str.gsub(/"/, '&quot;') 
  end

  def options_list_for_attribute(list)
    # takes a list of strings, places single quotes around each element
    # and HTML-escapes doublequotes within any element. Because OLX.
    attr = list.map { |e| "'" << escape_doublequotes(e) << "'" }.join(',')
    "(#{attr})"
  end
end
