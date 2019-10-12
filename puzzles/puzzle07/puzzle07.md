

# Infectious Network

> This puzzle was released on 2019-03-09, and was the Challenge puzzle for the theme *Automatic, Automata*. 

It's 1:40am. Facing North, you walk through the corridor on the 5th wall.

![Image](https://i.imgur.com/UAkON0z.gif)

You open the book on the table. Its cover says **Expedition Logs - Star Runner II**.

You start reading.

> ### 10th March 2050

> **Yuen**'s got The Cold today. This darn, mysterious Cold which seems to be making its rounds through the crew. While it doesn't seem deadly, it's been putting a stopper in our team morale. It seems to **last for only one day**, which we're thankful for, but we're worried it might have more sinister side effects - some of our group are expecting children and we have to be vigilant in case it's another infectious teratogen. We also cannot afford to endanger Silver Sun with an unknown infection. We must move fast. 

> We remain isolated. **None of our expedition of 100 people has gotten in contact with anyone outside our group since the new year.** Until we know what this disease is, we should keep it that way.

> It seems most likely that **one person** had The Cold when we began our expedition **on January 1st** and was able to infect another person on that day. We suspect transmission is through air droplet exposure, with the natural history of The Cold appearing to be:

> 1. Day X: A person contracts The Cold from an infected host (but is not infectious on the day they contract it).
> 2. Day X + 1: The person is **infectious** and symptomatic during the duration of this day and can transmit it to another person.
> 3. Day X + 2 and onward: The person is no longer infectious or symptomatic, and is now **immune** to The Cold (and **can no longer be reinfected**).

> The Cold **does not always transmit when a person meets an infected host** - however, as the cold is only infectious for one day, the fact that it remains among us means **we can deduce that at least one person has contracted the cold every day from a host infected the previous day**. 

> This is vital information. It means **we can trace a path from host to host from an infect*ious* host on January 1st, to Yuen who is infect*ious* today on March 10th** (i.e. **Yuen contracted The Cold yesterday by meeting an infected host on March 9th**, who themselves contracted The Cold by meeting an infected host on March 8th, and so on).

> We are fortunate that the ship has kept a log of **all meetings between two people** on each day of our expedition so far (from January 1st 2050 to March 9th 2050 inclusive). We can use this list of meetings to trace the infection back and hopefully arrive at single possible path that satisfies the constraints of the natural history of the cold. This is not as simple as it seems, as our crew is very tightly integrated: **crew members may meet mutiple people per day**. Backtracking is not as simple as it may seem as we must explore all possibilities: for example, if Clinton is infect*ious* today and met Alexander and Benson the previous day, we cannot know whether it was Alexander or Benson who was the infected host - we need to search through both possibilities. As you can imagine, the number of possibilities may grow rapidly as possibilities continue to branch off - when searching through the assumption that it was Alexander who was the host that day, if Alexander met Derekson and Emerald the day before, we also cannot know whether it was Derekson or Emerald who was the infected host and again we have to explore both possibilities separately, as well as those for Benson. We can only **exclude** possibilities once we are certain they violate the constraints of the natural history of the cold or the meeting trail does not extend back to January 1st.

> If we can trace the infection back to the **person who was infect*ious* on January 1st**, perhaps we can find out where it came from and stop it spreading further - both inside and outside our expedition. Many of our crew have been crew members on other ships; once we have established the source of our infection here, we can perhaps trace even further back and get to the bottom of The Cold. We have experienced too many cases where something innocuous has emerged as something deadly. We cannot afford to be complacent again.

That sounds ominous. It must have been scary to be in an isolated environment with an unknown infection passing through. They even capitalised "The Cold" - that means business...

It looks like you've got a list of meetings - each meeting consists of a date, a first person in that meeting and a second person in that meeting. A cursory look shows you that the order of the first person and second person within a meeting is just alphabetical order. You suppose you'll have to use the information above to find the person who was infectious on January 1st.

# Input

[cgmnt_input07.csv](https://drive.google.com/open?id=1QpkZKuHlZWZrqQieGjGLpU2bzB1oQNxf) (89KB)

# Statement

State the name of the person who brought the infection to the expedition. (i.e. who was infect*ious* on January 1st 2050). (e.g. `YUEN`)


# References

Written by the CIGMAH Puzzle Hunt Team with passing reference to *Silversun* broadcast by the ABC.

# Answer

The correct solution was `SCHOLZE`.

# Explanation

# Map Hint

You wonder what ever happened to the crew of Star Runner II. You wonder...but it seems like you'll never know.

You open `map_hint.txt`. It contains only one word:

```text
vigenere
```

Hm. It looks like it's going to be a long morning...

# Writer's Notes

## Objectives

1. Use constraint programming, recursive search strategies or otherwise to traverse a graph
2. Practise applying programming principles to a simple infection model to gather useful information.

## Context

Examining the spread of infection from host to host can be fairly arduous to do manually, but becomes much easier when we can automate the modelling process. Infection models are a highly studied topic within the medical field, and with great relevance to population health. Sometimes, we can even establish information such as where an infection came from - tracing infections back using a valid model of their behaviour, while perhaps unrealistic, is an interesting problem to solve.

We hoped to present a simple case which we intended to be solved with constraint programming (though there are of course, other methods!). Using abstracted declarative programming methods may be one option for medical personnel who do not have time to invest in learning the finer implementations of algorithms, but still want to be able to use programming to automate some tasks. In such cases, learning how to define *what* is desired rather than *how* to achieve it may be a viable, useful and enjoyable endeavour. As programming languages evolve and paradigms shift, perhaps logic programming (already known for use in medical expert systems) could become more prevalent within the general medical community.

## Example Solution

> Note: our example solutions are just one way of approaching the puzzle. They are not necessarily the best way, or even a good way!

We solved the puzzle using Constraint Programming which was easy to write though not the fastest to run (for this particular puzzle, it probably didn't matter so much - our solution still completes in under one second). We imagine some of our participants would solve this by implementing their own recursive depth-first search, which could perhaps be optimised more finely than ours.

```python
import pandas as pd
import numpy as np
from constraint import *
from datetime import datetime, timedelta

data = pd.read_csv("https://drive.google.com/uc?id=1QpkZKuHlZWZrqQieGjGLpU2bzB1oQNxf", header=None, names=["date", "first", "second"])
```


```python
# We are given these values
last_infected = "YUEN"
last_date = "2050-03-09" # of the meetings we have
start_date = "2050-01-01" # of the meetings we have
```


```python
# Preprocessing 
# -------------

# Convert possible names to id numbers
unique_names = list(set(pd.concat([data["first"], data["second"]])))
id_to_name = {i:n for i, n in enumerate(unique_names)}
name_to_id = {n:i for i, n in enumerate(unique_names)}
domain = list(range(len(unique_names)))

data["first"] = data["first"].apply(lambda x: name_to_id[x])
data["second"] = data["second"].apply(lambda x: name_to_id[x])

def next_date(date):
    fmt = "%Y-%m-%d"
    return (datetime.strptime(date, fmt) + timedelta(days=1)).strftime(fmt)

dates = list(set(data["date"]))
next_dates = {date: next_date(date) for date in dates}

dataset = set(data.apply(tuple, axis=1))

# Constraint solution
# --------------------

problem = Problem()

# Include all the meetings dates, plus the day after the last date
# This is so we have consistency (i.e. dates are defined as when someone is infect*ious*)
problem.addVariables(dates + [next_dates[last_date]], domain)

# Beginning constraints
# Yuen was infect*ious* on the day after the last day of the meeting set
problem.addConstraint(lambda x: x == name_to_id[last_infected], [next_dates[last_date]])

# People cannot get the infection twice (i.e. each date must have a unique infect*ious* person)
problem.addConstraint(AllDifferentConstraint())

# There must be a meeting between the infect*ious* person of a day and the infect*ious* person of the previous day
def add_constraint(day):
    problem.addConstraint(lambda a, b: ((day, a, b) in dataset) or ((day, b, a) in dataset), [day, next_dates[day]])

for date in dates:
    add_constraint(date)

solution = problem.getSolution()
    
print(id_to_name[solution[start_date]])
```

    SCHOLZE


## Extra Notes

We can also verify that this is the only solution.


```python
print(len(problem.getSolutions()))
```

    1


And trace the path of infection from host to host:


```python
datetimed = {datetime.strptime(d, "%Y-%m-%d"):solution[d] for d in solution.keys()}
sorted_solution_datetimes = sorted(list(datetimed))
[print("Infectious on {}: {}".format(datetime.strftime(d, "%Y-%m-%d"),
                                     id_to_name[datetimed[d]]))
 for d in sorted_solution_datetimes]
print()
```

    Infectious on 2050-01-01: SCHOLZE
    Infectious on 2050-01-02: LEPINE
    Infectious on 2050-01-03: MARURI
    Infectious on 2050-01-04: HALABURDA
    Infectious on 2050-01-05: CHISCHILLY
    Infectious on 2050-01-06: DINKELMAN
    Infectious on 2050-01-07: VALLARINO
    Infectious on 2050-01-08: SOWRY
    Infectious on 2050-01-09: MORGRIDGE
    Infectious on 2050-01-10: KARDOS
    Infectious on 2050-01-11: SOBOTKA
    Infectious on 2050-01-12: KOESTERER
    Infectious on 2050-01-13: VRABLIC
    Infectious on 2050-01-14: TRANTINA
    Infectious on 2050-01-15: BARKELL
    Infectious on 2050-01-16: ALKHATEEB
    Infectious on 2050-01-17: KROPIK
    Infectious on 2050-01-18: DEADMOND
    Infectious on 2050-01-19: WENNDT
    Infectious on 2050-01-20: ELHART
    Infectious on 2050-01-21: FUQUAY
    Infectious on 2050-01-22: STRICKLETT
    Infectious on 2050-01-23: NAM
    Infectious on 2050-01-24: BOEGLI
    Infectious on 2050-01-25: VANLOO
    Infectious on 2050-01-26: THUN
    Infectious on 2050-01-27: HIMEBAUGH
    Infectious on 2050-01-28: MAJKA
    Infectious on 2050-01-29: LEICK
    Infectious on 2050-01-30: GAHR
    Infectious on 2050-01-31: MOSKOW
    Infectious on 2050-02-01: BOEHMLER
    Infectious on 2050-02-02: KERRISON
    Infectious on 2050-02-03: PARROW
    Infectious on 2050-02-04: ROKUS
    Infectious on 2050-02-05: DEKAT
    Infectious on 2050-02-06: LINEGAR
    Infectious on 2050-02-07: ZDUNICH
    Infectious on 2050-02-08: LYCKE
    Infectious on 2050-02-09: FORCHIONE
    Infectious on 2050-02-10: WIDMER
    Infectious on 2050-02-11: CHARRON
    Infectious on 2050-02-12: KOPASZ
    Infectious on 2050-02-13: RUDQUIST
    Infectious on 2050-02-14: RIPPETH
    Infectious on 2050-02-15: JENNETT
    Infectious on 2050-02-16: STERLACCI
    Infectious on 2050-02-17: NIMBLETT
    Infectious on 2050-02-18: VILLALOBO
    Infectious on 2050-02-19: SPANO
    Infectious on 2050-02-20: CIARLEGLIO
    Infectious on 2050-02-21: FLIFLET
    Infectious on 2050-02-22: CIARDIELLO
    Infectious on 2050-02-23: TUDOR
    Infectious on 2050-02-24: JULY
    Infectious on 2050-02-25: KOTTE
    Infectious on 2050-02-26: COFFEN
    Infectious on 2050-02-27: CRIPPIN
    Infectious on 2050-02-28: STRAUBINGER
    Infectious on 2050-03-01: GRIJALVA
    Infectious on 2050-03-02: KUHNLE
    Infectious on 2050-03-03: CIOCHON
    Infectious on 2050-03-04: GERSHKOVICH
    Infectious on 2050-03-05: COKE
    Infectious on 2050-03-06: MOWDAY
    Infectious on 2050-03-07: HIRSCHLER
    Infectious on 2050-03-08: EMBRY
    Infectious on 2050-03-09: ZAFAR
    Infectious on 2050-03-10: YUEN
    


## Data Generation

The infectious network input will consist of a list of meetings between people. 

To construct the infectious network, we need to construct an `(n, 3)` matrix (`n` rows, `3` columns) with:

1. The datetime of the meeting
2. The name of the first person in the meeting
3. The name of the second person in the meeting.

The names of the first and second person will simply be in alphabetical order.

To create these tuples, we need to decide:

1. What the datetime range will be
2. What the name pool will be

At each generation step, we will enforce that a randomly selected case contribute to the "solution path" - i.e. we start by selecting a random case, generating a meeting, then follow the person they met to generate the next meeting and so on. At the end, we will solve to find solution paths and remove nodes to disrupt every solution path but one to ensure our solution is unique.

### Name Source

We will use names from the `surnames` dataset provided as a public material by the Princeton Intro to Programming course, itself derived from a [public dataset by the US Census Bureau](https://www.census.gov/topics/population/genealogy/data/2000_surnames.html).


```python
import pandas as pd

surnames = pd.read_csv("https://introcs.cs.princeton.edu/java/data/surnames.csv")
```

We'll use 100 names for our data generation.


```python
import random

num_names = 100
names = random.sample(list(surnames.name), k=num_names)
name_set = set(names)
```

### Datetime Range

We'll choose an arbitrary start date of Jan 1st 2050 and proceed until 67 days after that.


```python
import time
import datetime

start_date = datetime.date(2050, 1, 1)
unix_start = time.mktime(start_date.timetuple())
```


```python
num_days = 67
unix_end = unix_start + (num_days * 24 * 60 * 60)
```


```python
datetime.datetime.utcfromtimestamp(unix_end).date()
```




    datetime.date(2050, 3, 9)



So we end up on March 9th on the 67th day after Jan 1st 2050. Perfect timing for the puzzle!

### Meetings

We'll define a function to make meetings of two types - random meeting, and solution meeting (which will guarantee us that at least one solution exists). The solution meeting will take the name of a previously infected person and an exclusion list and return a new meeting that includes the infected person and does not include someone in the exclusion list.


```python
def make_meeting(day_num, infected=False, exclusions=False):
    """ Make a 3-element tuple representing a meeting.
    
    Uses global variables:
    
        unix_start : start datetime in unix time
        names : list of possible names
        name_set : set of possible names
    
    Args:
        day_num (int) : the day number of the meeting.
        infected (string) : the infected person to include.
        exclusions (list of strings) : required if infected meeting.
                    The meeting will not include these people
                    (previously infected, and hence cannot be reinfected).
    
    Returns:
    
        3-element tuple correspond to:

            1. Datetime of meeting
            2. First person in meeting
            3. Second person in meeting
            
        Also returns newly infected name (or None)

        First and second person are ordered alphabetically.
    
    """
    
    if infected and exclusions:
        allowed = list(set(names) - set(exclusions))
        new_infection = random.choice(allowed)
        selected = sorted([infected, new_infection])
    else:
        selected = sorted(random.sample(names, k=2))
        new_infection = None
        
    unix_date = unix_start + (day_num * 24 * 60 * 60)
    date = datetime.datetime.utcfromtimestamp(unix_date).date()
    
    return (date, selected[0], selected[1]), new_infection
```

We'll make between 45 and 55 meetings per day.


```python
contagious_days = 1
num_meetings_per_day = 50

next_infection_day = 0
last_infected = ""

infection_list = []
infection_meetings = []
meetings = []

for day in range(num_days + 1):
    num_meetings = random.randint(num_meetings_per_day - 5, num_meetings_per_day + 5)
    meetings += [make_meeting(day)[0] for i in range(num_meetings)]
    
    if day == next_infection_day:
        if last_infected:
            infected_meeting, infected = make_meeting(day, infected=last_infected, exclusions=infection_list)
            
        else: # first infection
            infected_meeting = make_meeting(day)[0]
            
            i_options = [1, 2]
            random.shuffle(i_options)
            
            infected = infected_meeting[i_options[0]]
            infection_list.append(infected_meeting[i_options[1]])

        last_infected = infected
        next_infection_day = day + (random.randint(1,contagious_days))
        
        infection_list.append(infected)
        infection_meetings.append(infected_meeting)
        meetings.append(infected_meeting)
```

And here's the generated list of meetings in the infection path:


```python
infection_meetings
```




    [(datetime.date(2050, 1, 1), 'LEPINE', 'SCHOLZE'),
     (datetime.date(2050, 1, 2), 'LEPINE', 'MARURI'),
     (datetime.date(2050, 1, 3), 'HALABURDA', 'MARURI'),
     (datetime.date(2050, 1, 4), 'CHISCHILLY', 'HALABURDA'),
     (datetime.date(2050, 1, 5), 'CHISCHILLY', 'DINKELMAN'),
     (datetime.date(2050, 1, 6), 'DINKELMAN', 'VALLARINO'),
     (datetime.date(2050, 1, 7), 'SOWRY', 'VALLARINO'),
     (datetime.date(2050, 1, 8), 'MORGRIDGE', 'SOWRY'),
     (datetime.date(2050, 1, 9), 'KARDOS', 'MORGRIDGE'),
     (datetime.date(2050, 1, 10), 'KARDOS', 'SOBOTKA'),
     (datetime.date(2050, 1, 11), 'KOESTERER', 'SOBOTKA'),
     (datetime.date(2050, 1, 12), 'KOESTERER', 'VRABLIC'),
     (datetime.date(2050, 1, 13), 'TRANTINA', 'VRABLIC'),
     (datetime.date(2050, 1, 14), 'BARKELL', 'TRANTINA'),
     (datetime.date(2050, 1, 15), 'ALKHATEEB', 'BARKELL'),
     (datetime.date(2050, 1, 16), 'ALKHATEEB', 'KROPIK'),
     (datetime.date(2050, 1, 17), 'DEADMOND', 'KROPIK'),
     (datetime.date(2050, 1, 18), 'DEADMOND', 'WENNDT'),
     (datetime.date(2050, 1, 19), 'ELHART', 'WENNDT'),
     (datetime.date(2050, 1, 20), 'ELHART', 'FUQUAY'),
     (datetime.date(2050, 1, 21), 'FUQUAY', 'STRICKLETT'),
     (datetime.date(2050, 1, 22), 'NAM', 'STRICKLETT'),
     (datetime.date(2050, 1, 23), 'BOEGLI', 'NAM'),
     (datetime.date(2050, 1, 24), 'BOEGLI', 'VANLOO'),
     (datetime.date(2050, 1, 25), 'THUN', 'VANLOO'),
     (datetime.date(2050, 1, 26), 'HIMEBAUGH', 'THUN'),
     (datetime.date(2050, 1, 27), 'HIMEBAUGH', 'MAJKA'),
     (datetime.date(2050, 1, 28), 'LEICK', 'MAJKA'),
     (datetime.date(2050, 1, 29), 'GAHR', 'LEICK'),
     (datetime.date(2050, 1, 30), 'GAHR', 'MOSKOW'),
     (datetime.date(2050, 1, 31), 'BOEHMLER', 'MOSKOW'),
     (datetime.date(2050, 2, 1), 'BOEHMLER', 'KERRISON'),
     (datetime.date(2050, 2, 2), 'KERRISON', 'PARROW'),
     (datetime.date(2050, 2, 3), 'PARROW', 'ROKUS'),
     (datetime.date(2050, 2, 4), 'DEKAT', 'ROKUS'),
     (datetime.date(2050, 2, 5), 'DEKAT', 'LINEGAR'),
     (datetime.date(2050, 2, 6), 'LINEGAR', 'ZDUNICH'),
     (datetime.date(2050, 2, 7), 'LYCKE', 'ZDUNICH'),
     (datetime.date(2050, 2, 8), 'FORCHIONE', 'LYCKE'),
     (datetime.date(2050, 2, 9), 'FORCHIONE', 'WIDMER'),
     (datetime.date(2050, 2, 10), 'CHARRON', 'WIDMER'),
     (datetime.date(2050, 2, 11), 'CHARRON', 'KOPASZ'),
     (datetime.date(2050, 2, 12), 'KOPASZ', 'RUDQUIST'),
     (datetime.date(2050, 2, 13), 'RIPPETH', 'RUDQUIST'),
     (datetime.date(2050, 2, 14), 'JENNETT', 'RIPPETH'),
     (datetime.date(2050, 2, 15), 'JENNETT', 'STERLACCI'),
     (datetime.date(2050, 2, 16), 'NIMBLETT', 'STERLACCI'),
     (datetime.date(2050, 2, 17), 'NIMBLETT', 'VILLALOBO'),
     (datetime.date(2050, 2, 18), 'SPANO', 'VILLALOBO'),
     (datetime.date(2050, 2, 19), 'CIARLEGLIO', 'SPANO'),
     (datetime.date(2050, 2, 20), 'CIARLEGLIO', 'FLIFLET'),
     (datetime.date(2050, 2, 21), 'CIARDIELLO', 'FLIFLET'),
     (datetime.date(2050, 2, 22), 'CIARDIELLO', 'TUDOR'),
     (datetime.date(2050, 2, 23), 'JULY', 'TUDOR'),
     (datetime.date(2050, 2, 24), 'JULY', 'KOTTE'),
     (datetime.date(2050, 2, 25), 'COFFEN', 'KOTTE'),
     (datetime.date(2050, 2, 26), 'COFFEN', 'CRIPPIN'),
     (datetime.date(2050, 2, 27), 'CRIPPIN', 'STRAUBINGER'),
     (datetime.date(2050, 2, 28), 'GRIJALVA', 'STRAUBINGER'),
     (datetime.date(2050, 3, 1), 'GRIJALVA', 'KUHNLE'),
     (datetime.date(2050, 3, 2), 'CIOCHON', 'KUHNLE'),
     (datetime.date(2050, 3, 3), 'CIOCHON', 'GERSHKOVICH'),
     (datetime.date(2050, 3, 4), 'COKE', 'GERSHKOVICH'),
     (datetime.date(2050, 3, 5), 'COKE', 'MOWDAY'),
     (datetime.date(2050, 3, 6), 'HIRSCHLER', 'MOWDAY'),
     (datetime.date(2050, 3, 7), 'EMBRY', 'HIRSCHLER'),
     (datetime.date(2050, 3, 8), 'EMBRY', 'ZAFAR'),
     (datetime.date(2050, 3, 9), 'YUEN', 'ZAFAR')]



### Checking for Unique Solutions

We solved the puzzle (using only the information participants would have) using the example solution we wrote above. We were lucky and there was only actually one solution (on a previous iteration, we had 4 and just removed a few nodes) so we could leave it as it was.

We shuffled our input.


```python
random.shuffle(meetings)
```

And formatted the datetimes.


```python
formatted = [(m[0].strftime("%Y-%m-%d"), m[1], m[2]) for m in meetings]
```

And saved as a DataFrame and CSV.


```python
df = pd.DataFrame(formatted)
```


```python
df.to_csv("cgmnt_input07.csv", header=False, index=False)
```

