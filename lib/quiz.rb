require 'builder'

class Quiz

  @@default_options = 
    {
      :open_time => Time.now,
      :soft_close_time => Time.now + 24*60*60,
      :hard_close_time => Time.now + 24*60*60,
      :maximum_submissions => 1,
      :duration => 0,
      :retry_delay => 600,
      :version => 'First version',
      :default_question_group_break => 'continue-previous-section',
      :randomise_question_group_order => false,
      :randomise_question_order => false,
      :randomise_option_order => false,
      :feedback_immediate => 'all_explanations',
      :feedback_after_hard_deadline => 'all_explanations',
    }

  attr_reader :renderer, :questions, :options, :output
  attr_accessor :title

  def initialize(title, renderer, options={})
    @output = ''
    @questions = []
    @title = title
    @options = @@default_options.merge(options)
    @renderer = Object.const_get(renderer.capitalize + 'Renderer').send(:new,self)
  end

  def render
    @output = @renderer.render_quiz
  end
  
  def self.quiz(title, options={}, &block)
    quiz = Quiz.new(title, options)
    quiz.instance_eval(&block) if block_given?
    quiz.render
  end
end
