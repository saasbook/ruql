quiz "I. Introduction", :time_limit => 60 do
  choice_answer :randomize => true do # means: randomize order of choices
    text 'question 1'
    distractor 'wrong answer a'
    distractor 'wrong answer b', :explanation => 'b is wrong'
    answer 'right answer', :explanation => 'yes!'
  end
  truefalse 'Jupiter is farther away than the sun.', true, 'Think about which one looks smaller!'
end
