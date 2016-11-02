# cs169 spring '15 microquizzes

quiz '1/22/15 (W1 L2)', :yaml => 'spec/fixtures/example_open_assessment.yaml' do
  ###########
  # Open Assessment question.
  # Includes both peer/self graded questions.
  # ------
  # Requirements:
  # 1. Must have: either peer_review or self_assessment set to true
  # 2. A corresponding yaml file, one section for each question.
  #    (see example file)
  ###########
  open_assessment peer_review: true, self_assessment: false, url_name: "100000" do
  # Self default to true/peer set to false unless stated otherwise
  # DTD - document type definition - check if EDX has one for this type of question

    ###########
    # Basic Information
    # This section is required.
    # You can add more prompts if students can choose
    # from multiple prompts.
    # ------
    # Requirements:
    # 1. Must have: title, at least one prompt
    ###########

    title "This is a title."
    prompt "This is a test prompt."
    prompt "This is another test prompt."

    ###########
    # Criterion/subject for grading
    # Feedback is required by default.
    # This section is required.
    # ------
    # Requirements:
    # 1. Must have: at least one criterion.
    # 2. Each criterion must have at least one option.
    #
    # Optional:
    # 1. Feedback - "optional" if the feedback is optional. Default setting is "required"
    ###########

    criterion feedback: "optional" do
      name "Ideas"
      label "Crierion Name"
      prompt "Example 1"

      ###########
      # Option for each Criterion.
      # Points are set to 0 by default.
      # ------
      # Requirements:
      # 1. Must have: name, label, and explanation.
      ###########

      option points: 4 do
        name "Poor"
        label "Poor"
        explanation "Some explanation"
      end

      # MORE OPTIONS GO HERE
    end

    # MORE CRITERION GO HERE

    ###########
    # Student training section.
    # This section is optional.
    ###########

    ###########
    # Student training
    # An example answer that helps students
    # see what kind of responses get what scores.
    # ------
    # Requirements:
    # 1. Must have: answer and at least one training criterion.
    # 2. Each training criterion and option must correspond to an existing
    #    criterion and option in the previous section.
    ###########

    student_training do
      answer "This is an example answer"
      training_criterion criterion: "Ideas", option: "Poor"
    end

    feedback_prompt "Leave feedback"
    feedback_default_text "Let them know how they did"
  end

  simple_open_assessment self_assessment: true, url_name: "100000" do
    title "This is a title."
    prompt "This is a test prompt"
    answer "This is the answer"

    # Optional array of scoring guidelines
    # Each element should compose of [score, score title, description]
    scoring_guideline [[5, "Excellent", "You got all of the question correct"],
                       [4, "Great", "You got most of the question correct"],
                       [3, "Good", "You got half of the question correct"],
                       [2, "Fair", "You got parts of the question correct"],
                       [1, "OK", "You got bits of the question correct"],
                       [0, "Poor", "You got none of the question correct"]]
  end
end
