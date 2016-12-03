quiz 'Example group' do

  truefalse 'The week has 7 days.', true

  grouped_question do
    choice_answer do
      image "http://advocatesforanimalrights.org/wp-content/uploads/2012/07/god_bless_america.jpg"
      text "Which are American political parties?"
      explanation "Congratulations"
      distractor "Tories", :explanation => "They're British"
      distractor "Social Democrats"
      answer "Democrats"
    end
  end

  choice_answer :randomize => true do
    text  "What is the largest US state?"
    explanation "Not big enough." # for distractors without their own explanation
    distractor 'Hawaii'
    distractor 'Texas', :explanation => "That's pretty big, but think colder."
    answer 'Alaska'
  end

end
