require 'ruby-debug'
require 'builder'

$LOAD_PATH.unshift File.expand_path(File.join(File.dirname(__FILE__)))

# renderers
require 'xml_renderer'

# question types
require 'question'
require 'answer'
require 'multiple_choice'
require 'true_false'

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
    @renderer = Object.const_get(renderer.to_s.capitalize + 'Renderer').send(:new,self)
  end

  def render
    @output = @renderer.render_quiz(self)
  end
  
  # this should really be done using mixins.
  def choice_answer(opts={}, &block)
    q = MultipleChoice.new('',opts)
    q.instance_eval(&block)
    @questions << q
  end

  def self.quiz(*args,&block)
    quiz = Quiz.new(*args)
    quiz.instance_eval(&block)
    quiz.render
    puts quiz.output
  end
end
