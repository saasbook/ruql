require 'spec_helper'

describe OpenAssessment do
  it "input should match the following EdXml output" do
    renderer = "EdXml"
    Quiz.set_yaml_file "./spec/fixtures/example_open_assessment.yaml"
    Quiz.instance_eval "#{IO.read('./spec/fixtures/example_open_assessment.rb')}"
    output = ""
    Quiz.quizzes.each { |quiz| output << quiz.render_with(renderer, {}) }
    expect(output).to eq(
%q{<openassessment url_name="100000" submission_start="2011-01-01T00:00:00+00:00" submission_due="2015-05-24T00:00:00+00:00" allow_file_upload="False" allow_latex="False">
  <title>This is a title.</title>
  <assessments>
    <assessment name="student-training">
      <example>
        <answer>
          <part>This is an example answer</part>
        </answer>
        <select criterion="Ideas" option="Poor"/>
      </example>
    </assessment>
    <assessment name="peer-assessment" must_grade="5" must_be_graded_by="3" start="2011-02-01T00:00:00+00:00" due="2013-02-01T00:00:00+00:00"/>
    <assessment name="self-assessment" start="2011-01-01T00:00:00+00:00" due="2015-05-24T00:00:00+00:00"/>
  </assessments>
  <prompts>
    <prompt>
      <description>This is a test prompt.</description>
    </prompt>
    <prompt>
      <description>This is another test prompt.</description>
    </prompt>
  </prompts>
  <rubric>
    <criterion feedback="optional">
      <name>Ideas</name>
      <label>Crierion Name</label>
      <prompt>Example 1</prompt>
      <option points="4">
        <name>Poor</name>
        <label>Poor</label>
        <explanation>Some explanation</explanation>
      </option>
    </criterion>
    <feedbackprompt>Leave feedback</feedbackprompt>
    <feedback_default_text>Let them know how they did</feedback_default_text>
  </rubric>
</openassessment>
<openassessment url_name="100000" submission_start="2011-02-01T00:00:00+00:00" submission_due="2015-05-24T00:00:00+00:00" allow_file_upload="False" allow_latex="False">
  <title>This is a title.</title>
  <assessments>
    <assessment name="self-assessment" start="2011-02-01T00:00:00+00:00" due="2013-02-01T00:00:00+00:00"/>
  </assessments>
  <prompts>
    <prompt>
      <description>This is a test prompt</description>
    </prompt>
  </prompts>
  <rubric>
    <criterion feedback="required">
      <name>How'd you do?</name>
      <label>Scoring Rubric</label>
      <prompt>This is the answer</prompt>
      <option points="5">
        <name>Excellent</name>
        <label>Excellent</label>
        <explanation>You got all of the question correct</explanation>
      </option>
      <option points="4">
        <name>Great</name>
        <label>Great</label>
        <explanation>You got most of the question correct</explanation>
      </option>
      <option points="3">
        <name>Good</name>
        <label>Good</label>
        <explanation>You got half of the question correct</explanation>
      </option>
      <option points="2">
        <name>Fair</name>
        <label>Fair</label>
        <explanation>You got parts of the question correct</explanation>
      </option>
      <option points="1">
        <name>OK</name>
        <label>OK</label>
        <explanation>You got bits of the question correct</explanation>
      </option>
      <option points="0">
        <name>Poor</name>
        <label>Poor</label>
        <explanation>You got none of the question correct</explanation>
      </option>
    </criterion>
    <feedbackprompt>Leave feedback</feedbackprompt>
    <feedback_default_text>Let them know how they did</feedback_default_text>
  </rubric>
</openassessment>
})
  end
end
