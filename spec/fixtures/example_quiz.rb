Quiz.quiz "I. Introduction", :time_limit => 60 do
  multiple_choice :points => 1 do
    text %q{A computer program is said to learn from experience E with
          respect to some task T and some performance measure P if its
          performance on T, as measured by P, improves with experience E.
          Suppose we feed a learning algorithm a lot of historical weather
          data, and have it learn to predict weather. What would be a
          reasonable choice for P?}

    distractor 'The weather prediction task'
    explanation 'The task described is weather prediction, so this is Task T.'

    distractor 'The process of the algorithm examining a large amount of historical weather data.'
    explanation 'It is by examining the historical weather data that the learning algorithm improves its performance, so this is the experience E.'

    answer %q{The probability of it correctly predicting a future date's weather.}
    explanation %q{This would be a reasonable measure P of measuring our weather predictions' accuracy.}

    distractor 'None of the above.'
  end

end
    

