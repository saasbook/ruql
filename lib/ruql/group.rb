class Group < Question
    attr_accessor :questions
    def initialize(*args)
        super
        @log = Logger.new(STDERR)
        @log.debug "in Group class"
        @questions = []
    end
    
    def choice_answer(*args, &block)
        if args.first.is_a?(Hash) # no question text
          q = MultipleChoice.new('',*args)
        else
          text = args.shift
          q = MultipleChoice.new(text, *args)
        end
        q.instance_eval(&block)
        @questions << q
        @log.debug "Added choice answer"
    end
  
    def select_multiple(*args, &block)
        if args.first.is_a?(Hash) # no question text
            q = SelectMultiple.new('', *args)
        else
            text = args.shift
            q = SelectMultiple.new(text, *args)
        end
            q.instance_eval(&block)
        @log.debug "in select multiple"
        @log.debug @questions.class
        @log.debug q.class
        @log.debug q
        @questions << q
        @log.debug "Added select multiple"
    end

    def truefalse(*args)
        q = TrueFalse.new(*args)
        @questions << q
    end

    def dropdown(*args, &block)
        q = Dropdown.new(*args)
        q.instance_eval(&block)
        @questions << q
    end
end