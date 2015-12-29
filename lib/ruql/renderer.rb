class Renderer

  attr_reader :quiz
  def initialize(quiz)
    @quiz = quiz
  end
  
  @@render_handlers = {}
  def self.render(thing, &block)
    @@render_handlers[thing.to_sym] = block
  end
  def self.renderer_for(thing)
    @@render_handlers[thing.to_sym]
  end
  
  def render_quiz!
    self.instance_eval@@render_handlers[:quiz].call(self.quiz)
  end

  # Override these methods in each renderer:

  %w(fill_in multiple_choice select_multiple dropdown open_assessment true_false).each do |q|
    define_method "render_#{q}" do |question|
      STDERR.puts "Question type '#{q}' not yet implemented for this renderer"
    end
  end
  
end
