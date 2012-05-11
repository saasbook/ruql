# A quiz has a mandatory name and optional time limit in minutes.
# There's also various other obscure options not documented here.

quiz 'Example quiz', :time_limit => 45 do

  # Examples of quiz questions.
  # All questions have an optional :points => n that determines the
  # number of points the question is worth.  The value is
  # non-normalized, i.e. it's relative only to other questions.  Default
  # is 1 if omitted.

  # This is straight Ruby code, so you can put in expressions, etc.

  # short answer/fill in blanks questions:
  #  - provide a string or regexp to check answer
  #  - a "blank" is three or more hyphens in a row
  #  - all regexps are case-INSENSITIVE unless :case_sensitive => true is passed

  fill_in :points => 2 do
    text 'The capital of California is ---'
    answer 'sacramento'
  end

  # multiple blanks, order matters: answer must be an array 
  fill_in do
    text 'The --- brown fox jumped over the lazy ---'
    answer [/fox/, /dog/]
  end
  
  # multiple blanks, order doesn't matter but no answer can be reused
  fill_in :order => false do
    text 'Two of the Three Stooges are --- and ---'
    answer %w(moe larry curly)
  end

  # true/false questions - explanation is optional

  truefalse true, 'The week has 7 days.'
  truefalse false, 'The earth is flat.', :explanation => 'No, just looks that way'

  # multiple choice questions (one correct answer):
  #  - can provide a generic 'explanation' clause and/or override it
  # with specific explanations to accompany right or wrong answers.
  # - if :randomize => true is given, order of choices will be randomized
  #   (default is to preserve order) 

  choice_answer :points => 3, :randomize => true do
    text  "What is the largest US state?"
    explanation "Not big enough." # for distractors without their own explanation
    answer 'Alaska'
    distractor 'Hawaii'
    distractor 'Texas', :explanation => "That's pretty big, but think colder."
  end

  # multiple choice question with HTML markup in question text or answer
  # choices (eg for code)

  choice_answer :raw => true do
    text %Q{What does the following code do:
<pre>
  puts "Hello world!"
</pre>
}
    distractor 'Throws an exception', :explanation => "Don't be an idiot."
    answer 'Prints a friendly message'
  end
    
  # "select all that are true" question
  # Just like choice_answer, but multiple 'answer' clauses allowed

  select_multiple do
    text "Which are American political parties?"
    answer "Democrats"
    answer "Republicans"
    answer "Greens", :explanation => "Yes, they're a party!"
    distractor "Tories", :explanation => "They're British"
    distractor "Social Democrats"
  end
end
