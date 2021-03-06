class Html5Renderer
  require 'builder'
  require 'erb'
  
  attr_reader :output

  def initialize(quiz,options={})
    @css = options.delete('c') || options.delete('css')
    @show_solutions = options.delete('s') || options.delete('solutions')
    @show_tags = options.delete('T') || options.delete('show-tags')
    @template = options.delete('t') ||
      options.delete('template') ||
      File.join((Gem.loaded_specs['ruql'].full_gem_path rescue '.'), 'templates/html5.html.erb')
    @output = ''
    @quiz = quiz
    @h = Builder::XmlMarkup.new(:target => @output, :indent => 2)
  end

  def allowed_options
    opts = [
      ['-c', '--css', Getopt::REQUIRED],
      ['-t', '--template', Getopt::REQUIRED],
      ['-s', '--solutions', Getopt::BOOLEAN],
      ['-T', '--show-tags', Getopt::BOOLEAN]
    ]
    help = <<eos
The HTML5 and HTML Forms renderers supports these options:
  -c <href>, --css=<href>
      embed <href> for stylesheet into generated HTML5
  -j <src>, --js=<src>
      embed <src> for JavaScrips
  -t <file.html.erb>, --template=<file.html.erb>
      Use file.html.erb as HTML template rather than generating our own file.
      file.html.erb should have <%= yield %> where questions should go.
      An example is in the templates/ directory of RuQL.
      The following local variables will be replaced with their values in
      the template:
        <%= quiz.title %> - the quiz title
        <%= quiz.num_questions %> - total number of questions
        <%= quiz.points %> - total number of points for whole quiz
  -T, --show-tags
      Show the tag(s) associated with a question within an element <div class="tags">.
  -s, --solutions
      generate solutions (showing correct answers and explanations)
  NOTE: If there is more than one quiz (collection of questions) in the file,
      a complete <html>...</html> block is produced in the output for EACH quiz.
eos
    return(


  def render_quiz
    if @template
      render_with_template do
        render_questions
        @output
      end
    else
      @h.html do
        @h.head do
          @h.title @quiz.title
          @h.link(:rel => 'stylesheet', :type =>'text/css', :href=>@css) if @css
        end
        @h.body do
          render_questions
        end
      end
    end
    self
  end

  def render_with_template
    # local variables that should be in scope in the template 
    quiz = @quiz
    # the ERB template includes 'yield' where questions should go:
    output = ERB.new(IO.read(File.expand_path @template)).result(binding)
    @output = output
  end
    
  def render_questions
    render_random_seed
    @h.ol :class => 'questions' do
      @quiz.questions.each_with_index do |q,i|
        case q
        when MultipleChoice, SelectMultiple, TrueFalse then render_multiple_choice(q,i)
        when FillIn then render_fill_in(q, i)
        else
          raise "Unknown question type: #{q}"
        end
      end
    end
  end


  def render_multiple_choice(q,index)
    render_question_text(q, index) do
      answers =
        if q.class == TrueFalse then q.answers.sort.reverse # True always first
        elsif q.randomize then q.answers.sort_by { rand }
        else q.answers
        end
      @h.ol :class => 'answers' do
        answers.each do |answer|
          if @show_solutions
            render_answer_for_solutions(answer, q.raw?, q.class == TrueFalse)
          else
            if q.raw? then @h.li { |l| l << answer.answer_text } else @h.li answer.answer_text end
          end
        end
      end
    end
    self
  end

  def render_fill_in(q, idx)
    render_question_text(q, idx) do
      if @show_solutions
        answer = q.answers[0]
        if answer.has_explanation?
          if q.raw? then @h.p(:class => 'explanation') { |p| p << answer.explanation }
          else @h.p(answer.explanation, :class => 'explanation') end
        end
        answers = (answer.answer_text.kind_of?(Array) ? answer.answer_text : [answer.answer_text])
        @h.ol :class => 'answers' do
          answers.each do |answer|
            if answer.kind_of?(Regexp)
              answer = answer.inspect
              if !q.case_sensitive
                answer += 'i'
              end
            end
            @h.li do
              if q.raw? then @h.p { |p| p << answer } else @h.p answer end
            end
          end
        end
      end
    end
  end

  def render_answer_for_solutions(answer,raw,is_true_false = nil)
    args = {:class => (answer.correct? ? 'correct' : 'incorrect')}
    if is_true_false 
      answer.answer_text.prepend(
        answer.correct? ? "CORRECT: " : "INCORRECT: ")
    end
    @h.li(args) do
      if raw then @h.p { |p| p << answer.answer_text } else @h.p answer.answer_text  end
      if answer.has_explanation?
        if raw then @h.p(:class => 'explanation') { |p| p << answer.explanation }
        else @h.p(answer.explanation, :class => 'explanation') end
      end
    end
  end

  def render_question_text(question,index)
    html_args = {
      :id => "question-#{index}",
      :class => ['question', question.class.to_s.downcase, (question.multiple ? 'multiple' : '')]
        .join(' ')
    }
    @h.li html_args  do
      @h.div :class => 'text' do
        qtext = "[#{question.points} point#{'s' if question.points>1}] " <<
          ('Select ALL that apply: ' if question.multiple).to_s <<
          if question.class == FillIn then question.question_text.gsub(/\-+/, '_____________________________')
          else question.question_text
          end
        if @show_tags
          @h.div(:class => 'text') do
            question.tags.join(',')
          end
        end
        if question.raw?
          @h.p { |p| p << qtext }
        else
          qtext.each_line do |p|
            @h.p do |par|
              par << p # preserves HTML markup
            end
          end
        end
      end
      yield # render answers
    end
    self
  end

  def quiz_header
    @h.div(:id => 'student-name') do
      @h.p 'Name:'
      @h.p 'Student ID:'
    end
    if @quiz.options[:instructions]
      @h.div :id => 'instructions' do
        @quiz.options[:instructions].each_line { |p| @h.p p }
      end
    end
    self
  end

  def render_random_seed
    @h.comment! "Seed: #{@quiz.seed}"
  end
end
