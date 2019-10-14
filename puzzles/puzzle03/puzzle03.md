

# Combo Catcher

> This puzzle was released on 2019-02-23, and was the Beginner puzzle for the theme *Text Books (Sample)*.

> *This is a sample puzzle in the Beginner set. This puzzle isn't worth any
> points or prizes itself, but it contributes to the meta puzzle and helps
> introduce the puzzle hunt format. It's also worth a look to practise basic
> text processing. The solution text for this sample puzzle (as well as the other sample puzzles) is available from the following link: [![Azure Notebooks](https://notebooks.azure.com/launch.svg)](https://notebooks.azure.com/cigmah-cgmnt/projects/cgmnt) This solution text is normally only revealed after a puzzle is completed.*

<br>

It's 12:20am. Facing North, you walk through the corridor on the 6th wall.

![Image](https://i.imgur.com/diXqpfu.gif)

Again, you step up to the center of the room and look at the book on the table.
The cover says *Unusual Effects of the Anti-Mycobacterial*. You open it up and
read the first page.

> We have discovered surprising and potentially useful effects of the
> aforementioned anti-mycobacterial. Our previously bedridden patients have
> experienced increased vitality and improved mood. Unfortunately, upon
> introduction of the medication to our wards, we have noticed an unprecedented
> increase of an unknown process manifesting as retinal haemorrhage, headache
> and neurological weakness. We therefore urge the committee to pend usage of
> this drug until further investigation.

It sounds like part of a transmission. Unfortunately, it's very vague. You read
on.

> We have strong reason to believe that this is due to an interaction with an
> existing medication. We do not know the identify of this medication, so to
> help with our further exploration of this issue, we have attached records of
> our last month of admissions and the presence of the interaction outcome. If
> you could assist us with determining the identity of the existing medication
> which causes this interaction, we would be very grateful.

The next pages all appear to be deidentified clinical records of some sort. The
first page reads:

```
PATIENT ID: 000000
DATE: 14/01/0001

CLINICAL BRIEF:
A 30 year old man employed as a shoe builder, previously diagnosed with osteoarthritis.
Presented with diarrhoea.

MEDICATIONS:
- Atropine sulfate monohydrate
- Iron
- Rituximab
- Valaciclovir
- Mupirocin
- Magnesium aspartate dihydrate
- Pyrazinamide
- Diclofenac
- Ethambutol
- Sapropterin
- Honey bee venom
- Iproniazid
- Trimethoprim
- Cabazitaxel

OUTCOME OF INTEREST:
Not present.

```

(You are bemused by the year `0001` and how these medications existed back then,
but much more disturbed by the completely nonsensical combination of medications
this patient is on. "But," you reason to yourself, "perhaps things were
different back then...").

The remaining pages are all in the same format.

You have a think. It seems like this transmission is referring to an interaction
between two medications (both unnamed) causing an outcome of interest. And it
looks like this transmission wanted the receiver to determine what these two
interacting medications were from the attached records.

## Input

[cgmnt_input03.txt](https://drive.google.com/open?id=1K1PJ3XbyfL9p0gMvfXxr0bhJCBeS_Kj2) (446Kb)

## Statement

State the name of the anti-mycobacterial first, then the interacting drug. (e.g. `RIFAMPIN CULPRITASE`).


## References

Written by the CIGMAH Puzzle Hunt 2019 team. \

Here was a reference we found useful for making this puzzle:

Phansalkar, S., Desai, A., Bell, D., Yoshida, E., Doole, J., Czochanski, M., Middleton, B. and Bates, D. (2012). High-priority drug–drug interactions for use in electronic health records. Journal of the American Medical Informatics Association, 19(5), pp.735-743.

## Answer

The correct solution was `Iproniazid Amfepramone`.

## Explanation

### Map Hint

You feel gratified for having found the right answer and marvel at how far modern medicine has come since the year `0001`. To think, combining a stimulant with a MAO inhibitor! Not to mention all the other wacky combinations this hospital used...

You open `map_hint.txt`. It has only one line:

```txt
The Map of the Medical Library of Babel is an HTML file.
```

Hm. You wonder, how could there be a HTML file in that random collection of letters?

### Writer's Notes

#### Objectives

Our objectives for this puzzle were to incorporate:

1. Basic text processing
2. Basic set theory
3. Basic data structures

When planning the puzzle, we intended the solving steps to be to:

1. Extract medications and the outcome for each patient
2. Perform set operations to determine the common combination
3. Correctly interpret the medications (i.e. put the anti-mycobacterial first)

Because the objectives were based around basic text processing, we didn't strive for realism for the generated medication lists (or clinical briefs for that matter). We reasoned that the principles would be the same as long as the format of the input was similar, even if the actual content was nonsense.


#### Context

Drug interactions are a vital consideration when prescribing, modifying prescriptions and evaluating symptoms. Many systems for automatically detecting drug interactions are available in various EMR software - although some clinicians might contest the usefulness of these alerts, it is one prominent example where software can assist in "catching" or flagging potential errors.

We brainstormed potential ways of having participants emulate such a system. We eventually settled on a small problem involving some basic set operations to discover an interaction between two unknown drugs. While this puzzle is, of course, heavily simplified, we hoped that the simplification would make the puzzle accessible for beginners.


#### Example Solution

> Our example solutions are just one way of solving the puzzle. They're not necessarily the best way, or even a good way!

Loading the data:


```python
import requests

input_url = "https://drive.google.com/uc?id=1K1PJ3XbyfL9p0gMvfXxr0bhJCBeS_Kj2"
text = requests.get(input_url).text
```

Processing the data:


```python
import re

positive_regex = re.compile(r'MEDICATIONS:\n((?:-\s.*?\n?)*)\n\nOUTCOME OF INTEREST:\nPresent')
medications = [set(record.lstrip('- ').split('\n- ')) for record in positive_regex.findall(text)]
set.intersection(*medications)
```




    {'Amfepramone', 'Iproniazid'}



> Note - for the actual solution, this needs to be submitted as "Iproniazid Amfepramone" as the solution specifies that the anti-mycobacterial should be written first!

The three lines of this solution do the following:

1. Extract the medications block from every patient record which had a positive outcome.
2. Make a Python `set` of medications for each medication block that was extracted.
3. Find the intersection of all the sets (which should give only the medications that *all* patients who had the outcome were taking)

This gave only two medications, so we could stop there - if there were more, we would have had to check which combination also occurred in patients who didn't have the outcome.

#### Data Generation

We chose two drug classes based on [an article on high-priority drug interactions for EMR systems](https://dx.doi.org/10.1136%2Famiajnl-2011-000612) by Phansalkar et al. 2012, settling on the interaction between stimulants and MAO inhibitors. We also [read up on the history](https://www.ncbi.nlm.nih.gov/pubmed/23231399) of MAO inhibitors to help give the scenario some meaningful context and used its origins as an anti-mycobacterial to provide one of the clues.

To help prevent against shrewd medical students correctly guessing the drugs from the scenario text (though perhaps they should have been rewarded!), we chose **amfepramone** as the answer, a drug that was less likely to be known by medical students than those such as methylphenidate or atomoxetine. We chose **iproniazid** given its importance in the history of MAO inhibitors, and mixed in other antimycobacterials (such as rifampin and isoniazid) to prevent easy guessing from inspecting the records. We also made the medication lists quite long (minimum 12 medications), again to prevent inspection being an easy way out (even if this was unrealistic).



To generate the data, we began by specifying a template for the format of the patient records. It was unnecessary for our purposes to use any sophisticated language processing for this puzzle, so we made it a straight substitution template.


```python
template = """
PATIENT ID: {patient_id}
DATE: {date}

CLINICAL BRIEF:
A {age} year old {person} employed as a {object} {job}, previously {health}.
Presented with {presentation}.

MEDICATIONS:
{medications}

OUTCOME OF INTEREST:
{outcome}
"""
```

We then specified some generation functions for each variable. You will notice they are quite limited - we didn't feel the need to spend much time on this part given that the information was not necessary for the puzzle objectives.


```python
import random

answer = "Amfepramone"
introduced = "Iproniazid"

def get_patient_id(index):
    return "{0:06d}".format(index)

def get_date():
    day = (random.randint(1, 31))
    return "{0:02d}/01/0001".format(day)

def get_age():
    return random.randint(20, 80)

def get_person():
    choices = ["man",
             "woman",
             "gentleman",
             "lady",
             "sir",
             "madam"]
    return random.choice(choices)

def get_object():
    choices = ["violone",
             "pyramid",
             "throne",
             "sarcophagus",
             "chimney",
             "carriage",
             "pickaxe",
             "shoe"]
    return random.choice(choices)

def get_job():
    choices = ["builder",
             "shiner",
             "mender",
             "seller",
             "sweeper",
             "painter",
             "holder",
             "mover"]
    return random.choice(choices)

def get_health():
    diagnoses = ["rickets",
               "an unknown infection",
               "hypertension",
               "hyperlipidaemia",
               "gastroenteritis",
               "osteoarthritis",
               "an unknown chronic cough" ]

    diagnosis_strings = ["diagnosed with {}".format(diagnosis)
                       for diagnosis in diagnoses]

    choices = ["healthy"] + diagnosis_strings

    return random.choice(choices)

def get_presentation():
    choices = ["cough",
             "wheeze",
             "fever", "dyspnoea",
             "chest pain",
             "a fracture",
             "haemoptysis",
             "diarrhoea",
             "joint pain",
             "a rash"]
    return random.choice(choices)

def get_outcome(has_outcome):
    if has_outcome:
        return "Present."
    else:
        return "Not present."
```

To get a comprehensive list of medications, we scraped data (once only) from the [PBS Medicine Listing](https://www.pbs.gov.au/browse/medicine-listing).


```python
import requests
import urllib.parse as parse
import string

url_base = "https://www.pbs.gov.au/browse/medicine-listing?"
queries  = [{"initial": char} for char in string.ascii_lowercase]
urls     = [url_base + parse.urlencode(query) for query in queries]
data     = [requests.get(url).text for url in urls]
```

Upon inspection of the HTML of the PBS Medicine Listing page, the drug names are included in table cells (``) within the `title` attribute.


```python
import re

def get_meds(string):
    matches = re.findall(r'<td class="cell_drug">.*?title="([\w\s]+)"', string)
    return matches
```

We wanted to release this sample puzzle early, so we only did a very cursory (and ugly) removal of other stimulants and MAO inhibitors on the resulting set - to remove them more thoroughly would have been nice.


```python
exclusion_text = """

   Dexmethylphenidate

   Dextroamphetamine

   Methylphenidate

   Lisdexamefetamine

   Methamphetamine

   Phendimetrazine

   Pseudoephedrine

   Amphetamine

   Benzphetamine

   Diethylpropion

   Phentermine

   Atomoxetine

   Tranylcypromine

   Phenelzine

   Isocarboxazid

   Procarbazine

   Selegiline

   Iproniazid

   Amfepramone


"""

exclusions = re.findall(r'\w+', exclusion_text)
```


```python
meds = [med.capitalize()
        for page in data
        for med in get_meds(page)
        if not any([exclusion.lower() in med.lower() for exclusion in exclusions])
       ]
```


```python
len(meds)
```




    1050



It struck us that having a large list of medications meant that it would be easy to manually inspect two records with the "Present" outcome and find the intersection without needing to use any programming. We therefore decided to limit the set to 16 medications, and ensured there was more than one anti-mycobacterial drug.


```python
meds = random.sample(meds, k=14) + ["Ethambutol", "Pyrazinamide"]
```

We can then write a function to get medicaitons.


```python
def get_medications(has_outcome):
    number = random.randint(12, 16)
    sample = random.sample(meds, k=number)
    if has_outcome:
        medications = [answer, introduced] + sample
        random.shuffle(medications)
    else:
        # Sometimes choose only ONE of the answer/introduced medication
        maybe_other = random.choices([answer, introduced, None],
                                     [0.40, 0.40, 0.20],
                                     k=1)
        medications = sample
        if maybe_other[0] is not None:
            medications += maybe_other
            random.shuffle(medications)
    med_string = "\n".join(["- {}".format(med) for med in medications])
    return med_string
```

We now have all the `get` functions we need. Let's make a patient record generator.


```python
def get_patient(index, has_outcome):
    record = template.format(patient_id=get_patient_id(index),
                           date=get_date(),
                           age=get_age(),
                           person=get_person(),
                           object=get_object(),
                           job=get_job(),
                           health=get_health(),
                           presentation=get_presentation(),
                           medications=get_medications(has_outcome),
                           outcome=get_outcome(has_outcome)
                          )
    return record
```

Now, let's generate patient records. We'll make the number large (1000), and the percentage of patients with the outcome relatively small (about 100 or so).


```python
def allocate_outcomes(number):
    return random.choices([True, False], [0.1, 0.9], k=number)
```


```python
records = [get_patient(i, outcome)
           for (i, outcome) in zip(range(1000), allocate_outcomes(1000))]
```

We can now write to a file and save it as the input.


```python
text = "\n---\n".join(records)
filename = 'cgmnt_input03.txt'

with open(filename, 'w') as f:
    f.write(text)
```

At this point, we verified that indeed the only two shared medications were Amfepramone and Iproniazid.


```python
positive_regex = re.compile(r'MEDICATIONS:\n((?:-\s.*?\n?)*)\n\nOUTCOME OF INTEREST:\nPresent')
medications = [set(record.lstrip('- ').split('\n- ')) for record in positive_regex.findall(text)]
set.intersection(*medications)
```




    {'Amfepramone', 'Iproniazid'}


