

# While You're Waiting

> This puzzle was released on 2019-03-09, and was the Beginner puzzle for the theme *Automatic, Automata*. 

It's 1:20am. Facing North, you walk through the corridor on the 4th wall.

![Image](https://i.imgur.com/Q5Sxr2x.gif)

You open the book on the table. It's called *Rhinal RPG*, a combination of words you'd never thought you'd hear in your lifetime...and never really wanted to hear.

You start reading. 


```text
┌────────────────────────────────────────────┐
│ Hi, I'm Dr Lionel. I'm the head Rhino at   │ 
│ Rhinal Clinics! Bahaha!                  ▾ │
└────────────────────────────────────────────┘
┌────────────────────────────────────────────┐
│ You know our clinics? Our clinic is        │
│ different from regular clinics. It's like  │
│ my clinic is in the top percentage of all  │ 
│ rhinitis clinics! Bahaha!                ▾ │
└────────────────────────────────────────────┘
┌────────────────────────────────────────────┐
│ You look like a sharp one. How about doing │
│ a little job for me? We have a lot of      │
│ patients. Of course we do! Why wouldn't    │
│ we? We're a popular clinic!              ▾ │
└────────────────────────────────────────────┘
┌────────────────────────────────────────────┐
│ But patients don't like waiting. No one    │
│ likes waiting! I don't like waiting! But   │
│ you know what I do like? Not waiting!      │
│ Bahaha!                                  ▾ │
└────────────────────────────────────────────┘
┌────────────────────────────────────────────┐
│ Instead of waiting, patients fill out a    │
│ form about their allergic rhinitis. I like │
│ forms! They're lovely and easy to share! ▾ │
└────────────────────────────────────────────┘
┌────────────────────────────────────────────┐
│ But I want the forms to help me. I want    │
│ everyone to help me. I want you to help    │
│ me! I want the forms to classify someone's │
│ rhinitis for me. Then I don't have to do   │ 
│ it!                                      ▾ │
└────────────────────────────────────────────┘
┌────────────────────────────────────────────┐
│ Enough talking! You've talked too much. I  │
│ could be seeing patients right now! Here's │
│ the classification. Now go forth and       │
│ classify! That's my motto! Bahaha!       ▾ │
└────────────────────────────────────────────┘

```


(Who *wrote* this? A robot? You think you're going to vomit if you hear someone say "bahaha" just one more time...)

There's some more text and a table following [1]:

```text

Allergic rhinitis symptoms are classified by DURATION AND SEVERITY.


DURATION: 

+------------------------------------+------------------------------------+
|            Intermittent            |            Persistent              |
+------------------------------------+------------------------------------+
| EITHER of                          | BOTH of                            |
| 1. Symptoms < 4 days per week, OR  | 1. Symptoms >= 4 days per week     |
| 2. Symptoms < 4 consecutive weeks. | 2. Symptoms >= 4 consecutive weeks |
+------------------------------------+------------------------------------+

SEVERITY:

+---------------------------------+---------------------------------------------------------+
|              Mild               |                   Moderate to Severe                    |
+---------------------------------+---------------------------------------------------------+
| NONE of the stuff on the right. | ANY (one or more) of:                                   |
|                                 | 1. Troublesome symptoms                                 |
|                                 | 2. Sleep disturbance                                    |
|                                 | 3. Impairment of daily activities, leisure and/or sport |
|                                 | 4. Impairment of school or work performance             |
+---------------------------------+---------------------------------------------------------+

Thus, allergic rhinitis can be classified into four groups:

1. Mild intermittent
2. Mild persistent
3. Moderate-to-severe intermittent
4. Moderate-to-severe persistent

```

You think you understand the problem - Dr Rhinal's given you a list of form data submitted by patients and wants you to figure out what classification of allergic rhinitis each patient would fall into. You could see the utility for this - after all, the classification is very specific and Dr Rhinal could spend less time classifying, and more time managing.

# Input

[cgmnt_input06.csv](https://drive.google.com/open?id=1WfX4jj8XYS0rqM_9hr_idXHqFU49kcSd) (165KB)

Templates on [Binder](https://mybinder.org/v2/gh/cigmah/cgmnt-beginners/master), [Azure Notebooks](https://notebooks.azure.com/cigmah-cgmnt/projects/cgmnt) and [GitHub](https://github.com/cigmah/cgmnt-beginners/).

# Statement

State the number of patients in Dr Rhinal's list with **moderate-to-severe persistent** allergic rhinitis.


# References

Written by the CIGMAH Puzzle Hunt Team.

[1] This reference table for classification of allergic rhinitis is from the [Australian Asthma Handbook](https://www.asthmahandbook.org.au/table/show/54).

# Answer

The correct solution was `1758`.

# Explanation

# Map Hint

Great work! It's been a long time since you last played an RPG, but you have to wonder what *Rhinal RPG* would have been like...

You open `map_hint.txt`. It contains only two words:

```text
shifting caesar
```

Hm..."caesar"? That reminds you, you haven't eaten for a while. Better find a way out of this library soon...

# Writer's Notes

## Objectives

1. Practise basic CSV reading and processing using Pandas.
2. Practise implementing a simple classification system.

## Context

There are some tasks in medicine which are readily amenable to automation - some classifications and interpretive algorithms are simple and specific enough that automation could be used to free up some time to do other things. What's more, being able to describe these classifications and algorithms to a computer means that these can be replicated exactly and without much cost, which can improve both the reliability and accessibility of such tools.

Many algorithms in medicine, however, are primarily for "guidance" and it is often expected that senior clinicians will use these to supplement expert knowledge. This is especially true for treatment algorithms; many factors about a patient's individual situation can influence treatment decision-making and such treatments should always be in consultation with the patient themselves. 

We chose a very simple, and very specific, classification for allergic rhinitis to help beginners have a go at using code in some way that integrates with medical learning and hopefully shows a very approachable case of where coding can help provide tools to assist medical care. We were very much aware that this puzzle could be completed in Excel (which most people will be familiar with to some extent). We hoped that an Excel-solvable problem could help make the coded solution more easily digestible by pointing out similarities and differences between Excel's capabilities and a Python implementation using Pandas. 

## Example Solution

> Note: Our example solutions are just one way of approaching our puzzles. They're not necessarily the best way, or even a good way!

Loading data:


```python
import pandas as pd

df = pd.read_csv("https://drive.google.com/uc?id=1WfX4jj8XYS0rqM_9hr_idXHqFU49kcSd")
```

Making a function to return `True` for a row if it is classified as moderate-to-severe persistent allergic rhinitis:


```python
def is_mod_persistent(row):
    if (row.symptoms_days_per_week     >= 4 and 
        row.symptoms_consecutive_weeks >= 4 and 
        any([row.troublesome_symptoms,
             row.disturbed_sleep, 
             row.personal_activities_impaired, 
             row.work_impaired])
       ):
            return True
    return False
```

Then applying it to the Data Frame and summing over rows where this returns `True`:


```python
sum(df.apply(is_mod_persistent, axis=1))
```




    1758



## Data Generation

In order to classify allergic rhinitis according to the guidelines we've referenced, we need the following information:

1. How many days per week symptoms occur
2. How many consecutive weeks symptoms have occurred for
3. Whether symptoms are troublesome
4. Whether sleep is disturbed
5. Whether daily activities, leisure and/or sport are impaired (we'll call these "personal activities" for shorthand)
6. Whether school or work is impaired (we'll call these "work activities" for shorthand)

So we'll generate a CSV file with 6 (plus an ID) columns and we'll arbitrarily choose 5000 rows so our answer is large enough to not be guessible.

We referenced a study with some rough proportions of each type in Korea [1]. We'll use these for now - we thought it would be a good idea to prevent the proportions being 25% for each classification as it might make guessing too easy!

We'll generate the data by specifically asking for a certain classification, and then generating the data for it.


```python
import random
```


```python
""" There are only six items we need - that's quite manageable. We'll make each patient simply a 
    list of seven values - an ID, then the six values we specified above.
    
    1. ID
    2. Days per week
    3. Consecutive weeks
    4. Troublesome symptoms
    5. Disturbed sleep
    6. Personal impaired
    7. Work impaired
"""

class Patient(object):
    """
    
    Args:
        intermittent (boolean) : Intermittent if True, else Persistent
        mild (boolean) : Mild if True, else Moderate-Severe
        patient_id (string): Patient ID
        
    Attributes:
        data: Generate data
    
    """
    
    def __init__(self, patient_id, intermittent, mild):
        
        self.patient_id = patient_id
        self.intermittent = intermittent
        self.mild = mild
        self.data = self.generate_data()
    
    def generate_data(self):
        if self.intermittent:
            choices = [random.randint(1,7), random.randint(1,3)]
            random.shuffle(choices)
            days_per_week, weeks = choices
        else:
            days_per_week = random.randint(4,7)
            weeks = random.randint(4,7)
        
        if self.mild:
            trouble, sleep, personal, work = [False] * 4
        else:
            options = [True] + random.choices([True, False], k=3)
            random.shuffle(options)
            trouble, sleep, personal, work = options
        
        return [self.patient_id, days_per_week, weeks, trouble, sleep, personal, work]
```


```python
num_patients = 5000

# From reference (2)
# mild intermittent, mild persistent, mod intermittent, mod persistent
choices = [(True, True), (False, True), (True, False), (False, False)]
props = [0.274, 0.208, 0.171, 0.347]

classes = random.choices(choices, props, k=num_patients)
ids = random.sample(range(1000000), k=num_patients)

inputs = [("{0:06d}".format(i), *c) for i, c in zip(ids, classes)]

data = [Patient(*input_data).data for input_data in inputs]

# shuffle, though it should already be random...
random.shuffle(data)
```


```python
columns = ["patient_id", 
           "symptoms_days_per_week", 
           "symptoms_consecutive_weeks",
           "troublesome_symptoms",
           "disturbed_sleep",
           "personal_activities_impaired",
           "work_impaired"]

df = pd.DataFrame(data, columns=columns).set_index("patient_id")
```

And we can save our data now.


```python
df.to_csv("cgmnt_input06.csv")
```

We'll make the puzzle to find how many patients have moderate to severe, persistent allergic rhinitis.


```python
def is_mod_persistent(row):
    if (row.symptoms_days_per_week     >= 4 and 
        row.symptoms_consecutive_weeks >= 4 and 
        any([row.troublesome_symptoms,
             row.disturbed_sleep, 
             row.personal_activities_impaired, 
             row.work_impaired])
       ):
            return True
    return False
```


```python
sum(df.apply(is_mod_persistent, axis=1))
```




    1758



We can check if this is similar to our expected proportion:


```python
1758 / 5000
```




    0.3516



Great, that's close enough (considering we used weighted probabilities).

And just to check this is the same as what we actually tried to generate:


```python
len([c for c in classes if c == (False, False)])
```




    1758



Great!

### References

[1] https://www.ncbi.nlm.nih.gov/pmc/articles/PMC2671762/

