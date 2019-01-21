module Content exposing (content)


content =
    { homeIntroText = homeIntroText
    , homeNotification = homeNotification
    , aboutText = aboutText
    , puzzleHuntIntroText = puzzleHuntIntroText
    , neverCodedText = neverCodedText
    , helpWanted = helpWanted
    }


homeIntroText =
    """

We are a group of medical students interested in exploring how coding can be
used to improve healthcare. Technology is rapidly changing the world, and we
believe that medical professionals will benefit from a basic understanding
of an increasingly important field. We hope to encourage medical students to
engage in learning basic coding principles to enrich their understanding of
how modern technology can help improve healthcare education and delivery.

"""


homeNotification =
    """

We have a survey! We're interested in hearing your perspectives on coding in
medicine. We've just started, so we're very open to shaping ourselves to be
whatever is most useful for **you**.

[Fill out the survey here - we'd really appreciate your
responses!](https://goo.gl/forms/0aFli8Y58ej37VcE2)

[We also have a Facebook group!](https://www.facebook.com/groups/cigmah/)

"""


aboutText =
    { whyLearn =
        """

Healthcare is rapidly changing. Doctors are in a privileged position of being
able to evaluate the clinical value of technology, but may lack the skills
needed in recognising both the technical power and limitations of modern tools.
Having an understanding of how the tools we use work is an important step to
using them skilfully. As tools evolve and become more pervasive, it's inevitable
that we will need to adopt new skillsets to not be left behind.

"""
    , butConcentrate =
        """

We don't believe there's any harm in extra knowledge. There is a lot of content
in medical school, but we believe medical students will find coding a breath of
fresh air. Learning to code can offer new perspectives in learning *how* to
think, rather than *what* to think, and can leave an impact on how you approach
problem solving regardless of whether you remember the specific details. Instead
of memory-intensive learning, coding is often an exercise in logical thinking.
Checking documentation is easy and encouraged. Programs are (mostly) verifiable
constructs. There's no more putting your faith in information simply because
someone higher-ranked told you so - information is free, open and derivable.

"""
    , whatCanDo =
        """

Coding is used in many medically-related domains. Doctors are not software
engineers, but they do not have to be to have an appreciation of code.
Inter-disciplinary interaction occurs in fields such as:

- Epidemiology and data analysis in public health
- Healthcare pattern recognition tools driven by artificial intelligence
- Clinician or patient-facing web and mobile applications for streamlined healthcare
- Interactive and visual educational materials
- Medical imaging and biomedical engineering software
- Automation of administrative tasks

Whether or not you end up applying coding in these domains, we still believe
that coding develops skills in problem-solving, systems thinking and rigorous
verification - all very handy skills for any clinical doctor.

"""
    , whatCIGMAH =
        """

CIGMAH is a new group of medical students interested in coding. We aim to host a
flagship Puzzle Hunt this year as a medically-themed, interactive way to begin
learning how to code. In the future, we hope that we may grow enough to sustain
regular activities such as tutorials, guest lectures, social events and
networking opportunities.

"""
    , thisSite =
        """

This website is written in [Elm](https://elm-lang.org) and styled with
[Bulma](https://bulma.io). The code is open source, and you can find it
[here](https://github.com/cigmah/cigmah.github.io).

"""
    }


puzzleHuntIntroText =
    """

Want to learn but don't know where to start? We've been there too.

We're hoping to run a puzzle hunt from the beginning of March to the end of
September.

At the beginning of each month, a puzzle set will be released themed around a
medical specialty and a topic within programming. We aim to choose topics especially
relevant to medicine to get the most value out of these puzzles. Most puzzles will
be aimed at beginners and will usually require some (short) coding to solve.

You, or a team, have the month to solve the puzzle and will earn points
depending on how quickly within the month you solved it. Most beginner puzzles
should be solvable within 10 minutes if you are familiar with the problem
domain, but as everyone has busy schedules, we want to accommodate a flexible
timeframe.

At the end of the month, the puzzle submissions will be locked and a
step-by-step solution posted.

At the end of September, the points earned by each team will be tallied and a
winner will be announced. But, forget the winner, you'll have come away with
a set of new skills that you can build upon!

We're aiming for it to be a bit like a medically-themed, beginner-friendly
[Advent of Code](https://adventofcode.com).

"""


neverCodedText =
    """

Don't worry, we've got you.

We're aiming to provide a beginner's template with each puzzle to reduce the
friction of learning how to code.

The beginner's templates will be offered in [Python](https://www.python.org) and
[Julia](https://julialang.org) - two very flexible languages with strong ties
with the scientific and medical data ecosystems.

These templates will be provided as online [Jupyter](https://jupyter.org)
notebooks, which you can run inside your browser. It will walk you through
step-by-step through the puzzle and provide some 'fill in the blank' style
coding exercises that target the learning objective very specifically.

We are still working on the details, but our hope is to offer this experience
straight from the browser - no need to install anything, just follow the link to
the template and go.

    """


helpWanted =
    """

We're looking for volunteers! We are believers in
[FOSS](https://en.wikipedia.org/wiki/Free_and_open-source_software) and are
currently maintained by a group of passionate volunteers. If you'd like to
volunteer as tribute, we're looking for:

- Puzzle writers (considerable experience in either Python or Julia, or any great ideas)
- Puzzle testers (no experience needed)

And of course, we're also looking for members and participants! Stay tuned for
the 2019 Puzzle Hunt :)

"""
