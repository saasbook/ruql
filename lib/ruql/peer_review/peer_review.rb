class PeerReview

  attr_accessor :question_title, :prompts, :criterions, :name,
                :url_name, :allow_file_upload, :allow_latex,
                :submission_start, :submission_end

  def initialize(options={})
    @prompts = []
    @criterions = []

    # Not sure what to do with url_name...hopefully I'll find out soon
    @url_name = rand(1000000000)

    @allow_file_upload = options[:allow_file_upload] || false
    @allow_latex = options[:allow_latex] || false

    start_date = options[:submission_start] || Time.now.to_s
    end_date = options[:submission_end] || Time.now.to_s

    @submission_start = Date.parse(start_date)
    @submission_end = Date.parse(end_date)
  end

  def title(title)      ; @question_title  = title ; end
  def prompt(prompt)    ; @prompts << prompt       ; end

  def criterion(*args, &block)
    criterion = Criterion.new(*args)
    criterion.instance_eval(&block)
    @criterions << criterion
  end
end
