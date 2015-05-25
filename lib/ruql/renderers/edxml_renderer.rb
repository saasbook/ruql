require 'builder'
require 'yaml'

class EdXmlRenderer

  attr_reader :output
  attr_accessor :file, :yaml_file
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

  def render_fill_in(question)
    raise "Not yet implemented for edXML"
  end

  def render_multiple_choice(question)
    @b.problem do
      # if question text has explicit newlines, use them to separate <p>'s
      if question.raw?
        @b.p { |p| p << question.question_text }
      else
        question.question_text.lines.map(&:chomp).each do |line|
          if question.raw? then @b.p { |p| p << line } else @b.p(line) end
        end
      end
      @b.multiplechoiceresponse do
        @b.choicegroup :type => 'MultipleChoice' do
          question.answers.each do |answer|
            if question.raw?
              @b.choice(:correct => answer.correct?) do |choice|
                choice << answer.answer_text
                choice << "\n"
              end
            else
              @b.choice answer.answer_text, :correct => answer.correct?
            end
          end
        end
      end
      @b.solution do
        @b.div :class => 'detailed_solution' do
          @b.p 'Explanation'
          if question.raw?
            @b.p { |p| p << question.correct_answer.explanation }
          else
            @b.p question.correct_answer.explanation
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
end

