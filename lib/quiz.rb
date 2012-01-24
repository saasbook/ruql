require 'builder'

class Quiz

  @@default_options = 
    {
    :open_time => Time.now,
    :soft_close_time => Time.now + 24*60*60,
    :hard_close_time => Time.now + 24*60*60,
    :maximum_submissions => 1,
    :duration => 3600,
    :retry_delay => 600,
    :parameters =>  {
      :show_explanations => {
        :question => 'before_soft_close_time',
        :option => 'before_soft_close_time',
        :score => 'before_soft_close_time',
      }
    },
    :maximum_score => 1,
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
    @output = @renderer.render_quiz(self)
  end
  
  def self.quiz(title, options={}, &block)
    quiz = Quiz.new(title, options)
    quiz.instance_eval(&block) if block_given?
    quiz.render
  end
end
