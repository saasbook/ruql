require 'securerandom'
class OpenAssessment

  attr_accessor :question_title, :prompts, :criterions, :name,
                :url_name, :self_assessment, :peer_review,
                :must_grade, :graded_by
  attr_accessor :allow_file_upload, :allow_latex
  attr_accessor :submission_start, :submission_due,
                :submission_start_time, :submission_due_time,
                :self_assessment_start, :self_assessment_due,
                :self_assessment_start_time, :self_assessment_due_time,
                :peer_review_start, :peer_review_due,
                :peer_review_start_time, :peer_review_due_time
  attr_accessor :question_feedback_prompt, :question_feedback_default_text
  attr_accessor :yaml
  attr_accessor :trainings
  attr_accessor :answer, :question_scoring_guideline

  @@single_question_scores =
    [[5, "Excellent", "You got all of the question correct"],
     [4, "Great", "You got most of the question correct"],
     [3, "Good", "You got half of the question correct"],
     [2, "Fair", "You got parts of the question correct"],
     [1, "OK", "You got bits of the question correct"],
     [0, "Poor", "You got none of the question correct"]]

  @@DATE_REGEX = /\d{4}-\d{2}-\d{2}T\d{2}:\d{2}/

  ##
  # Initializes the open assessment question
  def initialize(options={}, yaml={})
    @peer_review = options[:peer_review] || false
    @self_assessment = options[:self_assessment]
    @self_assessment = true if @self_assessment.nil?

    @prompts = []
    @criterions = []
    @trainings = []

    @url_name = options[:url_name] || SecureRandom.hex
    @yaml = yaml

    @must_grade = @yaml["must_grade"] || 5
    @graded_by = @yaml["graded_by"] || 3

    @allow_file_upload = options[:allow_file_upload] || false
    @allow_latex = options[:allow_latex] || false

    # Parsing start/due dates
    start_date = @yaml["submission_start"] || Time.now.to_s
    end_date = @yaml["submission_due"] || (Time.now + 14).to_s

    peer_review_start = @yaml["peer_review_start"] || start_date
    peer_review_due = @yaml["peer_review_due"] || end_date

    self_assessment_start = @yaml["self_assessment_start"] || start_date
    self_assessment_due = @yaml["self_assessment_due"] || end_date

    @submission_start = Date.parse(start_date)
    @submission_due = Date.parse(end_date)
    @submission_start_time = @yaml["submission_start_time"] || "00:00"
    @submission_due_time = @yaml["submission_due_time"] || "00:00"

    @peer_review_start = Date.parse(peer_review_start)
    @peer_review_due = Date.parse(peer_review_due)
    @peer_review_start_time = @yaml["peer_review_start_time"] || "00:00"
    @peer_review_due_time = @yaml["peer_review_due_time"] || "00:00"

    @self_assessment_start = Date.parse(self_assessment_start)
    @self_assessment_due = Date.parse(self_assessment_due)
    @self_assessment_start_time = @yaml["self_assessment_start_time"] || "00:00"
    @self_assessment_due_time = @yaml["self_assessment_due_time"] || "00:00"

    # Default feedback settings
    @question_feedback_prompt = "Leave feedback"
    @question_feedback_default_text = "Let them know how they did"
  end

  ##
  # Sets the title of the question
  def title(title)      ; @question_title  = title  ; end

  ##
  # Adds a prompt to the question - you must have at least one
  def prompt(prompt)    ; @prompts << prompt        ; end

  ##
  # Sets the answers for a simple_open_assessment question
  def answer(answer)    ; @question_answer = answer ; end

  ##
  # Sets the scoring guidelines for a simple_open_assesment question
  def scoring_guideline(score_array) ; @question_scoring_guideline = score_array ; end

  ##
  # Sets the feedback prompt if you want students to leave feedback
  def feedback_prompt(fb_prompt) ; @question_feedback_prompt = fb_prompt ; end

  ##
  # Sets the default text for the feedback textarea
  def feedback_default_text(fb_text) ; @question_feedback_default_text = fb_text ; end

  ##
  # Adds a criterion and evaluates its proc block.
  def criterion(*args, &block)
    criterion = Criterion.new(*args)
    criterion.instance_eval(&block)

    raise "Missing criterion parameters" if criterion.missing_parameters?

    @criterions << criterion
  end

  ##
  # Adds fields for a simple_open_assessment question
  def add_simple_question
    criterion = Criterion.new
    criterion.name("How'd you do?") # "
    criterion.label("Scoring Rubric")

    raise "Must have answer for question" if @question_answer.nil?
    criterion.prompt(@question_answer)

    criterions << criterion
    scoring_guidelines = @question_scoring_guideline || @@single_question_scores
    scoring_guidelines.each do |score_array|
      option = Option.new({ points: score_array[0] })
      option.add_params(score_array)
      criterion.add_option(option)
    end
  end

  ##
  # Adds a student training question - only used with peer review enabled questions
  def student_training(*args, &block)
    return unless @peer_review
    training = Training.new(*args)
    training.instance_eval(&block)
    @trainings << training
  end
end
