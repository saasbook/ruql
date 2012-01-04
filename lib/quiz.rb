require 'builder'

class Quiz

  def default_options
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
  end

  def initialize(title, options)
    @output = ''
    @xml = Builder::XmlMarkup.new(:target => @output)
    @title = title
    @options = default_options.merge(options)
    self.do_prologue
  end

  def render ; @output ; end
  
  def self.quiz(title, options={}, &block)
    quiz = Quiz.new(title, options)
    quiz.instance_eval(&block) if block_given?
    quiz.render
  end

  def do_prologue
    @xml.instruct!
    @xml.declare! :DOCTYPE, :quiz, :SYSTEM, "quiz.dtd"
    @xml.quiz do
      @xml.metadata do
        @xml.type 'quiz'
        @xml.title @title
        @options.each_pair do |k,v|
          @xml.__send__(k.to_s.gsub(/_/,'-').to_sym, v)
        end
      end
    end
  end
end
