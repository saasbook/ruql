quiz '1/22/15 (W1 L2)' do
  select_multiple do :question_uuid => 1
    text %q{Around 2007, the claim "Rails doesn't scale"  was attributed to
Twitter engineers, and the fact that Twitter later moved
away from Rails was cited by some as evidence that the claim was true.
Which of the following statements (there may be more than one) describe Raffi
Krikorian's (Twitter Director of Engineering) views on this subject?}
    answer "Rails itself isn't the problem, but the original Ruby VM does have some performance problems that impede scaling for heavy server workloads."
    answer "Rails itself isn't the problem, but the development processes typically used around Rails don't scale well to large teams."
    distractor "If you're building a startup and expect high volume, Raffi Krikorian would advise you to stay away from Ruby and Rails from the start."
    answer "If Twitter had been architected as a service-oriented architecture from the start, they might have stayed on Ruby/Rails somewhat longer than they did."
  end

  select_multiple do :question_uuid => 2

    text %q{Which statements comparing Plan-and-Document (P&D) with
            Agile software engineering processes are true?}

    answer "The basic types of activities involved in software
            engineering are the same in P&D and Agile methodologies",
    :explanation => """
            True: requirements analysis, design, testing, development,
            deployment/delivery, and maintenance are all part of both
            P&D and Agile, but their interaction over the project
            lifetime differs between P&D and Agile.
            """

    distractor "Because Agile tends to focus on small teams, it cannot
                be used effectively to build large systems.",
    :explanation => """
            False: many Agile-developed small services can be connected
            together to form large services in a Service-Oriented Architecture.
            For example, Amazon.com is architected this way.
            """

    answer "The Waterfall methodology involves the customer much more heavily at
            the beginning and end of the lifecycle, whereas the XP (extreme
            programming) methodology involves the customer throughout
            the lifecycle.",
    :explanation => """
            True: a basic tenet of XP is getting frequent feedback from
            the customer and using it to inform the next iteration of
            work.
            """

    answer "The Spiral methodology combines elements of the waterfall model
            with intermediate prototypes."

  end

end