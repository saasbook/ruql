class Group < Question
    attr_accessor :questions
    def initialize(*args)
        super
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
    end

    def select_multiple(*args, &block)
        if args.first.is_a?(Hash) # no question text
            q = SelectMultiple.new('', *args)
        else
            text = args.shift
            q = SelectMultiple.new(text, *args)
        end
            q.instance_eval(&block)
        @questions << q
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
