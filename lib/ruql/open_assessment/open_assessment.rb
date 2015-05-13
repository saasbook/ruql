require 'securerandom'
class OpenAssessment

  attr_accessor :question_title, :prompts, :criterions, :name,
                :url_name, :self_assessment, :peer_review,
                :must_grade, :graded_by
  attr_accessor :allow_file_upload, :allow_latex,
                :submission_start, :submission_due
  attr_accessor :question_feedback_prompt, :question_feedback_default_text
  attr_accessor :yaml
  attr_accessor :trainings

  @@single_question_scores =
    [[5, "Excellent", "You got all of the question correct"],
     [4, "Great", "You got most of the question correct"],
     [3, "Good", "You got half of the question correct"],
     [2, "Fair", "You got parts of the question correct"],
     [1, "OK", "You got bits of the question correct"],
     [0, "Poor", "You got none of the question correct"]]

  def initialize(options={}, yaml={})
    @peer_review = options[:peer_review]
    @self_assessment = options[:self_assessment]

    # Validation
    if @peer_review.nil? && @self_assessment.nil?
      raise "Must specify open assesment type as either peer_review or self_assessment."
    end

    @prompts = []
    @criterions = []
    @trainings = []

    @url_name = SecureRandom.hex
    @yaml = yaml

    @must_grade = @yaml[:must_grade] || 5
    @graded_by = @yaml[:graded_by] || 3

    @allow_file_upload = options[:allow_file_upload] || false
    @allow_latex = options[:allow_latex] || false

    start_date = @yaml[:submission_start] || Time.now.to_s
    end_date = @yaml[:submission_end] || (Time.now + 14).to_s

    @submission_start = Date.parse(start_date)
    @submission_due = Date.parse(end_date)
  end

  def title(title)      ; @question_title  = title              ; end
  def prompt(prompt)    ; @prompts << prompt                    ; end
  def feedback_prompt(fb_prompt) ; @question_feedback_prompt = fb_prompt ; end
  def feedback_default_text(fb_text) ; @question_feedback_default_text = fb_text ; end

  def criterion(*args, &block)
    criterion = Criterion.new(*args)
    criterion.instance_eval(&block)

    raise "Missing criterion parameters" if criterion.missing_parameters?

    @criterions << criterion
  end

  def single_question(*args, &block)
    criterion = Criterion.new()
    criterion.name("How'd you do?")
    criterion.label("Scoring Rubric")
    criterions << criterion

    @@single_question_scores.each do |score_array|
      points, label, explanation = score_array
      option = Option.new({ points: points })
      option.name(label)
      option.label(label)
      option.explanation(explanation)
      criterion.add_option(option)
    end

    instance_eval(&block)
  end

  def answer(s)
    criterions.first.prompt("Answer: #{s}")
  end

  def student_training(*args, &block)
    training = Training.new(*args)
    training.instance_eval(&block)
    @trainings << training
  end
end
