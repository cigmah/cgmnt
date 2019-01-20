module Content exposing (content)


content =
    { homeIntroText = homeIntroText
    , aboutText = aboutText
    }


homeIntroText =
    """ We are a group of medical students interested in exploring
    how coding can be used to improve healthcare. Technology is rapidly changing
    the world, and we believe that medical professionals will benefit from a
    basic understanding of an increasingly important field. We hope to encourage
    medical students to engage in learning basic coding principles to enrich
    their understanding of how modern technology can help improve healthcare
    education and delivery. """


aboutText =
    { whyLearn = """ Healthcare is rapidly changing. The idea that
'robots will replace doctors' is often scoffed at within the medical
community, but the prospect is drawing incrementally closer to fruition.
The stage we are at depends on who you ask, but it's no longer a crazy
idea. Doctors are in a privileged position of being able to evaluate
the clinical value of technology, but can often fall short at recognising
both the technical power and limitations of modern tools. We hope doctors
in the future will not be left behind in a society of technical progress
and will be able to contribute meaningfully in a ballooning domain."""
    , butConcentrate = """ There is a lot of content in medical school,
but we believe medical students will find coding a breath of fresh air.
Instead of memory-intensive learning, coding is often an exercise in
logical thinking. Checking documentation is easy and encouraged. Programs
are (mostly) verifiable constructs. There's no more putting your faith in
information simply because someone higher-ranked told you so - information
is free, open and often much closer to theory than the empiricisms of
evidence-based medicine. """
    , whatCanDo = """Coding is used in many medically-related domains.
Doctors are not software engineers, but they do not have to be to have
an appreciation of code. Inter-disciplinary interaction occurs in fields such as:

- Epidemiology and data analysis in public health
- Healthcare pattern recognition tools driven by artificial intelligence
- Clinician or patient-facing web and mobile applications for streamlined healthcare
- Interactive and visual educational materials
- Medical imaging and bioprosthetic software
- Automation of administrative tasks"""
    , whatCIGMAH = """ CIGMAH is a new group of medical students interested in coding.
We aim to host a flagship Puzzle Hunt this year as a medically-themed, interactive
way to begin learning how to code. In the future, we hope that we may grow enough
to sustain regular activities such as tutorials, guest lectures, social events and
networking opportunities."""
    }
