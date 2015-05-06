require 'securerandom'
class PeerReview

  attr_accessor :question_title, :prompts, :criterions, :name,
                :url_name, :allow_file_upload, :allow_latex,
                :submission_start, :submission_due,
                :question_feedback_prompt, :question_feedback_default_text

  attr_accessor :yaml

  def initialize(options={}, yaml={})
    @prompts = []
    @criterions = []

    @url_name = SecureRandom.hex
    @yaml = yaml

    @allow_file_upload = options[:allow_file_upload] || false
    @allow_latex = options[:allow_latex] || false

    start_date = @yaml[:submission_start] || Time.now.to_s
    end_date = @yaml[:submission_end] || Time.now.to_s

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
    @criterions << criterion
  end

  def single_question(*args, &block)
    instance_eval(&block)
  end
end
