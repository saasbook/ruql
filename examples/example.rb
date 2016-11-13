quiz 'Example quiz' do
  
  fill_in :points => 2 do
    image "http://3.bp.blogspot.com/--v59FgET6XA/VahnCZ35oWI/AAAAAAAAQFQ/vSnXdSXrX38/s1600/California-Outline-and-Flag-Solid.png"
    text 'The capital of California is ---'
    answer 'sacramento'
  end
  
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
  
  truefalse 'The week has 7 days.', true
  truefalse 'The earth is flat.', false, :explanation => 'No, just looks that way'
  
end