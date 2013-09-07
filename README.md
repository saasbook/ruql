Ruby-based Quiz Generator and DSL
=================================

This is a simple app (soon to be packaged as a gem) that takes a set of
questions (a "quiz") written in RuQL ("Ruby quiz language" or "Ruby
question language" - a DSL embedded in Ruby), and produces one
of several possible output formats.

Creating Quiz Questions
=======================

1. Clone this repo and run 'bundle install' in its root directory to get
all the gems
2. Create a file of questions following the example in ruql_example.rb

A 'quiz' is a collection of questions surrounded by

    quiz do
      # (questions here)
    end

So you can create a quiz by putting the quiz in its own file and
copying-and-pasting the questions you want into it.  (Yes, that's ugly.
Soon, questions will have unique IDs and you'll be able to 
The total number of points possible is automatically determined by
summing the points per question.  

Using questions with the EdX platform
=====================================

To quickly add an inline question (multiple choice, text or numeric
input, or option dropdown) to a course unit in EdX Studio:

1. Create the question in RuQL with an attribute `:name => "some-name"`
and put it in some file `questions.rb` 
2. On the command line say `ruql questions.rb edxml -n some-name`
3. Copy the resulting XML to the Clipboard.  In Studio, select "Advanced
Editor" view for the question, which shows the raw XML of the question.
Replace that raw XML with the output from `ruql`.
4. Visually check that the question looks right in Studio, since some
markup that is legal in RuQL doesn't format correctly in Studio.


Creating a Printable Version of a Quiz
======================================

3. Run the generator as follows (it's unwieldy now but it'll get
better):

To generate an HTML version suitable for viewing in a browser:
(./quiz with no arguments shows brief help)

./quiz questionfile.rb html5 --template=./html_template/template.html.erb > questionfile.html

If you also specify --solutions on command line, you can generate an
HTML5 version that includes identification of the correct answer.
(NOTE: the HTML5 tags clearly identify the correct answer--this format
is meant for printing, not for online use, since a simple "view page
source" would show the correct answers!)

You can replace the existing html.erb template with your own; take a
look at it to see how it works.

Creating a Coursera-Compatible Version of a Quiz
================================================

To generate a version that can be ingested by Coursera's online
quiz-taking machinery:

./quiz questionfile.rb xml > questionfile.xml

Please add to this documentation using the Wiki or by adding inline RDoc
comments to the code!

