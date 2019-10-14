

# Code Broadcast

> This puzzle was released on 2019-08-10, and was the Abstract puzzle for the theme *"Code"*.

You're starting to accept that you may not make it out.

It's 6:00am. Facing North, you walk through the corridor on the 5th wall.

![Metarom](https://i.imgur.com/yDxLdwW.gif)

This room doesn't have a computer. There's only a radio. You hear voices conversing over the radio, as if you're unintentionally eavesdropping. You can't make much sense over what they're saying though. Maybe they're using some sort of code.

## Input

[Read a live text transcript of the broadcast at https://code-broadcast-over-wire.netlify.com](https://code-broadcast-over-wire.netlify.com/). The broadcast is approximately 2 minutes long. It is set to loop for your convenience.

## Statement

Submit the underlying six-letter single-word message being transmitted in the broadcast.


## References

Written by the CIGMAH Puzzle Hunt Team.

## Answer

The correct solution was `MALADY`.

## Explanation

#### Map Hint

You deliberate on whether your name has an effect on you as a person.

You open the file `map_hint.txt`.

```text
The puzzle at the bottom of the map refers to
the identity of the amino acid that corresponds to
the exit.

The full circle represents a normal shaped red blood cell.
The sickle-shaped "circle" represents a sickle cell.

The letters below each "circle" correspond to amino
acids. Well, except there's a question mark instead
of the letters that should be below the sickle cell.

What letters should be below the sickle cell?
That's your exit!
```

Sickle cells and amino acids. You do seem to recall a certain amino acid being mentioned often in your preclinical lectures with regard to sickle cell disease...

#### Writer's Notes

Here's an example solution using the Python standard library. It's not very short, and we are sure you could write this shorter. We would love to see other solutions in the comments.

```python
import re
from collections import Counter

with open("cgmnt_input19.txt") as infile:
  query = re.compile(r"Location: ([\w ]+)\n* +HPV 16: +([\w ]+)\n +HPV 18: +([\w ]+)")
  results = query.findall(infile.read())
  hpv_16s = Counter([result[0] for result in results if result[1] == 'DETECTED'])
  hpv_18s = Counter([result[0] for result in results if result[2] == 'DETECTED'])
  ratios = {k: hpv_16s[k] / hpv_18s[k] for k in hpv_16s.keys()}
  print([r for r in ratios.keys() if ratios[r] >= max(ratios.values())])
```
```
['Honeydew Mountains']
```
And here's all the ratios:

```python
Coral Beach: 0.84
Maroon Island: 1.2142857142857142
Violet Acre: 2.8666666666666667
Snow Hills: 0.7441860465116279
Beige Town: 0.8235294117647058
Yellow Green Hinterlands: 1.0
Honeydew Mountains: 3.0625
Wheat Farm: 0.29545454545454547
Lime City: 2.05
Rosy Brown Street: 2.5238095238095237
Orchid Forest: 1.0434782608695652
Dodger Blue Trench: 1.1714285714285715
Khaki Lane: 2.25
Ivory Fields: 1.0666666666666667
Teal Woods: 0.8571428571428571
Fuchsia Greens: 0.7586206896551724
Navy Reef: 0.13043478260869565
Azure Meadows: 0.1694915254237288
Peru: 0.10416666666666667
Gainsboro Plains: 0.42105263157894735
```

The solution is fairly straightforward once you make a regular expression to parse the text results. This is probably one of the easier Challenge puzzles we've released so far and was not originally the puzzle we were going to release this month for the Challenge, but we did not have enough time to polish the other puzzle.

Here's the generation code for this dataset. Neither clear nor concise, but it did its job.

```python
import random
from typing import List

#### DEFINING CONSTANTS

#### HPV Results
HPV_16 = 0
HPV_18 = 1
HPV_OTHER = 2
HPV_TYPES = [HPV_16, HPV_18, HPV_OTHER]

#### LBC Results
LBC_NEGATIVE = 0
LBC_LSIL = 1
LBC_HSIL = 2

LBC_RESULTS = [LBC_NEGATIVE, LBC_LSIL, LBC_HSIL]

LBC_RESULT_STRINGS = {
  LBC_NEGATIVE: "No intrapethelial lesions identified.",
  LBC_LSIL: "Low-grade squamous intraepithelial lesion (LSIL).",
  LBC_HSIL: "High-grade squamous intraepithelial lesion (HSIL).",
}

RESULT_TEMPLATE = "    Liquid based cytology (LBC): {result}\n\nRECOMMENDATION: {recommendation}\n"

LOCATIONS = [
  "Azure Meadows",
  "Beige Town",
  "Coral Beach",
  "Dodger Blue Trench",
  "Fuchsia Greens",
  "Gainsboro Plains",
  "Honeydew Mountains",
  "Ivory Fields",
  "Khaki Lane",
  "Lime City",
  "Maroon Island",
  "Navy Reef",
  "Orchid Forest",
  "Peru",
  "Rosy Brown Street",
  "Snow Hills",
  "Teal Woods",
  "Violet Acre",
  "Wheat Farm",
  "Yellow Green Hinterlands",
]

def make_random_ratio() -> List[float]:
  # Corresponds to HPV_16, HPV_18, HPV_OTHER
  raws = [random.random(), random.random(), random.random()]
  summed = sum(raws)
  return [r / summed for r in raws]

LOCATION_RATIOS = {location: make_random_ratio() for location in LOCATIONS}

FULL_TEMPLATE = """
Patient ID: {id:04d}
Location: {location}
{result}
{recommendation}"""


### Map Hint

You wonder what these two people are talking about, or why they need to converse in code.

But there's no computer in this room. No way to get a `map_hint.txt`. You look around - you did your job, right? - so where's your map hint? That's not fair.

After searching the room, you concede that maybe there is no map hint and the radio broadcast is not meant for you. It keeps looping. You're getting a bit creeped out, so you shut it off. And you walk towards the door, leaving the radio behind you.

### Writer's Notes

This puzzle was intentionally vague. The broadcast transmits a message using a code made of WHO ICD-11 codes.

In order, the codes described and the levels on which they are found are:

- MC12 (level 1)
- 4A41 (level 2)
- LA14.07 (level 1)
- 1A22 (level 2)
- 1D01 (level 2)
- 4A4Y (level 4)

Taking the level-th character of each of the ICD-11 codes spells out the word MALADY.

As an aside, the transcript is not actually being broadcast - it indexes into the message based on the client's system time modulus the length of the transcript. A liberal use of extra spaces (which are condensed into a single space when rendered to the HTML) makes it possible to simulate speaking pauses in the message.

