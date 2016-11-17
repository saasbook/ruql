quiz 'Example group' do

  grouped_question do
    image "Trump"
    text "Stories"

    choice_answer :randomize => true do
      text  "What is the largest US state?"
      explanation "Not big enough." # for distractors without their own explanation
      distractor 'Hawaii'
      distractor 'Texas', :explanation => "That's pretty big, but think colder."
      answer 'Alaska'
    end

    select_multiple do
      image "http://michaelmoore.s3.amazonaws.com/wp/uploads/2016/07/23143828/trumpwillwin-notext.jpg"
      text "Which are American political parties?"
      distractor "Tories", :explanation => "They're British"
      distractor "Social Democrats"
      answer "Democrats"
      answer "Republicans"
      answer "Greens", :explanation => "Yes, they're a party!"
    end

  end
end