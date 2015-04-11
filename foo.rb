quiz 'A few example questions' do
  
  choice_answer :randomize => true do
    text "Which of the following best identifies the four basic operations supported by RDBMS?"
    distractor "HTTP", :explanation => 'HTTP stands for HyperText Transfer Protocol, which is used to transfer SaaS content to browsers.'
    distractor "Get, Put, Post, Delete", :explanation => 'These are four of the methods or "verbs" used by HTTP.'
    answer "CRUD", :explanation => 'Create, Read, Update, Delete are the four basic database operations commonly performed by SaaS apps.'
    distractor "REST", :explanation => 'REpresentational State Transfer is a design approach for making SaaS requests self-contained by having each request refer to a resource and an operation on that resource.'
  end

  truefalse 'If an app has a RESTful API, it must be performing CRUD operations.',
  false,
  :explanation => 'The REST principle can be applied to any kind of operation'

  choice_answer :randomize => true do
    text "The implied port number of the URI <tt>http://google.com</tt> is"
    answer "80"
    distractor "400"
    distractor "3000"
    distractor "8000"
  end

  select_multiple :randomize => true do
    text  "Which tiers in the three-tier architecture are involved in handling views?"
    answer "Presentation"
    answer "Logic"
    distractor "Persistence"
    distractor "Database"
  end

  choice_answer :randomize => true do
    text "The ----- tier of three-tier SaaS apps is the most complicated to scale."
    answer "Presentation"
    distractor "Logic"
    distractor "Persistence"
    distractor "Database"
  end

  choice_answer :randomize => true do
    text "An HTTP request must consist of both a(n) ----- and a(n) -----"
    distractor "CRUD action, database"
    distractor "header, cookie", :explanation => 'A header is part of the request, but a cookie is not necessarily included unless the server previously specified one.'
    distractor "URL, wildcard", :explanation => 'A URL is necessary, but not a wildcard.'
    answer "URI, HTTP request method", :explanation => "The URI alone isn't enough--the same URI used with two different methods can cause two different actions."
  end
end
