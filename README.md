[![CodeClimate](https://codeclimate.com/github/saasbook/ruql/badges/gpa.svg)](https://codeclimate.com/github/saasbook/ruql)
[![Coverage](https://codeclimate.com/github/saasbook/ruql/badges/coverage.svg)](https://codeclimate.com/github/saasbook/ruql/coverage)
[![Gem Version](https://badge.fury.io/rb/ruql.svg)](https://badge.fury.io/rb/ruql)

Ruby-based DSL for Authoring Quiz Questions
===========================================

This is a simple gem that takes a set of questions (a "quiz") written in
RuQL ("Ruby quiz language" or "Ruby question language" - a DSL embedded
in Ruby), and produces one of several possible output formats.

Some types of questions or question elements that can be expressed in
RuQL cannot be expressed by some LMSs, and some LMS-specific question
features cannot be expressed in RuQL.


Installation
============

`gem install ruql` to install this from RubyGems.  It works with Ruby
>=1.9.2

You'll also need to install one or more formatters to produce quiz output.

Installation: Current Formatters
================================

* [ruql-html](https://github.com/saasbook/ruql-html): produces HTML 5 output using a default or user-supplied HTML
template
* [ruql-canvas](https://github.com/saasbook/ruql-canvas): creates a quiz in Canvas LMS using its REST API


Running RuQL
============

Create your `quiz.rb` file as described below, then run:

`ruql formatter-name quiz.rb`

Where `formatter-name` is from the list above, eg `html` for the
`ruql-html` formatter.

`ruql formatter-name -h` lists the options supported by that
formatter, and `ruql -h` shows RuQL's global options.


Creating Quiz Questions in RuQL
===============================

RuQL supports a few different types of short-answer questions and can
output them in a variety of formats compatible with different Learning
Management Systems or in printable form.

RuQL is a DSL embedded in Ruby, so you can include expressions in
questions, for example, to generate simple variants of a question along
with its solution.

In addition to the basic parts of a question (prompt text, answers,
etc.), each question can also have an optional list of one or more
_tags_, and an optional _comment_.  These attributes
are available to formatters, but most formatters ignore them.
They can be used to provide information about the
question's topic(s) or other info useful to a question-management app
such as [Course Question Bank](https://github.com/saasbook/coursequestionbank).

A question can also optionally have a _group_.  Questions with the
same group name (within the scope of a single quiz) are grouped in
a "pool" from which a single question is selected at quiz generation time.
For "static" formatters such as HTML, RuQL will pick a random
question.  For some LMSs, like Canvas, the questions are put into a
"quiz group" and any given student gets a randomly chosen one at runtime.

Preparing a quiz
----------------

A quiz is an `.rb` file with a collection of questions:

    quiz 'Example quiz name here' do
      # (questions here)
    end

You create a quiz by putting the quiz in its own file and
copying-and-pasting the questions you want into it.  (Yes, that's ugly.
Soon, questions will have unique IDs and you'll be able to create a quiz
by reference.)

Multiple-choice questions with a single correct answer
------------------------------------------------------

You can provide a generic `explanation` clause, and/or override it with
specific explanations to accompany right or wrong answers.
Choices are rendered in the order in which
they appear in the RuQL markup, but capable LMSs or formatters can be
told to randomize them.  This example also shows the use of tags to
include metadata about a question's topic, and the use of groups to
place two questions into a group from which one will be chosen at
random for the quiz.

```ruby
choice_answer  do
  tags 'US states', 'geography'
  group 'states-1'
  text  "What is the largest US state?"
  explanation "Not big enough." # for distractors without their own explanation
  answer 'Alaska'
  distractor 'Hawaii'
  distractor 'Texas', :explanation => "That's pretty big, but think colder."
end
choice_answer  do
  tags 'US cities', 'geography'
  group 'states-1'
  text  "What is the largest US city?"
  answer 'New York'
  distractor 'Los Angeles'
  distractor 'Chicago'
end
```

Specifying `:raw => true` allows HTML markup in the question to be
passed through unescaped, such as for `<pre>` or `<code>` blocks.


```ruby
  choice_answer :raw => true do
    text %Q{What does the following code do:
<pre>
  puts "Hello world!"
</pre>
}
    distractor 'Throws an exception', :explanation => "Don't be an idiot."
    answer 'Prints a friendly message'
  end
```

Multiple-choice "select all that apply" questions
-------------------------------------------------

These use the same syntax as single-choice questions, but multiple
`answer` clauses are allowed:

```ruby
select_multiple do
  text "Which are American political parties?"
  answer "Democrats"
  answer "Republicans"
  answer "Greens", :explanation => "Yes, they're a party!"
  distractor "Tories", :explanation => "They're British"
  distractor "Social Democrats"
end
```

True or false questions
-----------------------

Internally, true/false questions are treated as a special case of
multiple-choice questions with a single correct answer, but there's a
shortcut syntax for them.

```ruby
truefalse 'The week has 7 days.', true
truefalse 'The earth is flat.', false, :explanation => 'No, just looks that way'
```

Short-answer fill-in-the-blanks questions
-----------------------------------------

Put three or more hyphens in a row where you want the "blanks" to be,
and provide a string or regexp to check the answer; all regexps are 
case-INSENSITIVE unless :case_sensitive => true is passed.  

```ruby
fill_in :points => 2 do
  text 'The capital of California is ---.'
  answer 'sacramento'
end
```

Optional distractors can capture common incorrect answers.  As with all
question types, an optional `:explanation` can accompany a correct
answer or a distractor; its usage varies with the LMS, but a typical use
is to display a hint if the wrong answer is given, or to display
explanatory text accompanying the correct answer.

```ruby
fill_in do
  text 'The visionary founder of Apple is ---'
  answer /^ste(ve|phen)\s+jobs$/
  distractor /^steve\s+wozniak/, :explanation => 'Almost, but not quite.'
end
```

You can have multiple blanks per question and pass an array of regexps
or strings to check them.  Passing `:order => false` means that the
order in which blanks are filled doesn't matter.  The number of elements
in the array must exactly match the number of blanks.

```ruby
fill_in do
  text 'The --- brown fox jumped over the lazy ---'
  answer [/fox/, /dog/], :explanation => 'This sentence contains all of the letters of the English Alphabet'
end

fill_in do
  text 'The three stooges are ---, ---, and ---.'
  answer %w(larry moe curly), :order => false
end
```



Questions with one or more dropdown-menu choices
------------------------------------------------

A question can consist of one or more dropdown menus and interstitial text (which is rendered verbatim without newlines,
so use `:raw => true` to embed `<br>` tags if you want breaks).  A choice selector needs
two arguments: the 0-based index of the correct choice, and an array of strings of all the choices.
The `label` method provides interstitial text that separates the dropdowns.

```ruby
dropdown do
  text "Arguably the world's first theme park was"
  choice 0, ['Disneyland', 'Mickey World', 'Teenage Mutant Ninja Turtles Park']
  label "located in"
  choice 2, ['Beijing, China', 'Paris, France', 'California, USA']
end
```


Additional arguments and options
--------------------------------

The following arguments and options have different behavior (or no
effect on behavior) depending on what format questions are emitted in:

1. All question types accept a `:name => 'something'` argument, which some
output generators use to create a displayable name for the question or
to identify it within a group of questions.

2. The optional `tag` clause is followed by a string or array of strings,
and associates the given tag(s) with the question, in anticipation of
future tools that can use this information.

3. The optional `comment` clause is followed by a string and allows a
free-text comment to be added to a question.


Adding your own renderer
========================

**This documentation is incomplete**

If you're creating the `foobar` formatter, the gem should
be named `ruql-foobar` and have the following directory
structure (heavily recommend using Bundler):

```
ruql-foobar:
.
├── CODE_OF_CONDUCT.md
├── Gemfile
├── README.md
├── Rakefile
├── bin
│   ├── console
│   └── setup
├── lib
│   └── ruql
│       ├── foobar
│       │   ├── foobar.rb
│       │   └── version.rb
│       └── foobar.rb
├── result.json
├── ruql-foobar.gemspec
├── spec
│   ├── ruql
│   │   └── foobar_spec.rb
│   └── spec_helper.rb
└── templates
    └── quiz.json


```

The main entry point should be in
`ruql-foobar/lib/ruql/foobar/foobar.rb` and include the following at a
minimum:

```ruby
module Ruql
  module Foobar
    def initialize(quiz, options={})
      # initialize yourself, given a Quiz object and command-line
      # options in Getoptlong format
    end
    def self.allowed_options
      opts = [['--foobar-option1', Getoptlong::REQUIRED_ARGUMENT],
              ['--foobar-option2', Getoptlong::BOOLEAN_ARGUMENT]]
      help_text = "Some text describing what the options do"
      return [help_text, opts]
    end
    def render_quiz
      # render your quiz however you like. See the descriptions of 
      # the Quiz class and various subclasses of Question and Answer.
    end
  end
end
```

