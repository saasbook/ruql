class Question
  attr_accessor :question_text, 
                :answers,
                :question_image,
                :randomize, 
                :points, 
                :name, 
                :question_tags, 
                :question_uid, 
                :question_comment, 
                :raw
  
  def initialize(*args)
    options = if args[-1].kind_of?(Hash) then args[-1] else {} end
    @answers = options[:answers] || []
    @points = [options[:points].to_i, 1].max
    @raw = options[:raw]
    @name = options[:name]
    @question_image = options[:image]
    @question_tags = []
    @question_uid = (options.delete(:uid) || SecureRandom.uuid).to_s
    @explanation = nil
    @question_comment = ''
  end
  def raw? ; !!@raw ; end
  
  def has_explanation? ; @explanation.to_s != '' ; end

  def explanation(text=nil)
    if text
      @explanation = text
    else
      @explanation
    end
  end

  def uid(u) ; @question_uid = u ; end
  
  def text(s) ; @question_text = s ; end

  def image(url)
    @question_image = url
  end
  
  def answer(text, opts={})
    @answers << Answer.new(text, correct=true, opts[:explanation], self)
  end

  def distractor(text, opts={})
    @answers << Answer.new(text, correct=false, opts[:explanation], self)
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

  def answer_helper(obj)
    if obj.is_a? Array and obj.size and obj[0].is_a? Answer
      return obj.map {|answer| answer.to_JSON}
    end
    obj
  end

  #creates a JSON hash of the object with its object name. we should convert this to a mixin for answer and question. aaron
  def to_JSON
      h = Hash[instance_variables.collect { |var| [var.to_s.delete('@'), answer_helper(instance_variable_get(var))] }]
      h['question_type'] = self.class.to_s
      return h
  end

  #factory method to return correct type of question
  def self.from_JSON(hash_str)
    hash = JSON.parse(hash_str)
    #create the appropriate class of the object from the hash's class name
    question = Object.const_get(hash.fetch('question_type')).new()
    hash.reject{|key| key == 'answers' or key == 'question_type'}.each do |key, value|
      question.send((key + '=').to_sym, value)
    end
    question.answers = hash['answers'].map{|answer_hash| Answer.from_JSON(answer_hash)}
    question
  end

end
