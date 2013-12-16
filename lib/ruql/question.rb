class Question
  attr_accessor :question_text, :answers, :randomize, :points, :name, :question_tags, :question_comment
  
  def initialize(*args)
    options = if args[-1].kind_of?(Hash) then args[-1] else {} end
    @answers = options[:answers] || []
    @points = [options[:points].to_i, 1].max
    @raw = options[:raw]
    @name = options[:name]
    @question_tags = []
    @question_comment = ''
  end

  def raw? ; !!@raw ; end
  
  def text(s) ; @question_text = s ; end
  
  def explanation(text)
    @answers.each { |answer| answer.explanation ||= text }
  end

  def answer(text, opts={})
    @answers << Answer.new(text, correct=true, opts[:explanation])
  end

  def distractor(text, opts={})
    @answers << Answer.new(text, correct=false, opts[:explanation])
  end

  # these are ignored but legal for now:
  def tags(*args) # string or array of strings 
    if args.length > 1
      @question_tags += args.map(&:to_s)
    else
      @question_tags << args.first.to_s
    end
  end

  def comment(str = '')
    @question_comment = str.to_s
  end

  def correct_answer ;  @answers.detect(&:correct?)  ;  end

  def correct_answers ;  @answers.collect(&:correct?) ; end

end
