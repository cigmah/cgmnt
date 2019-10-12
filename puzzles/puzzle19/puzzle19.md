

# HPV Profiling

> This puzzle was released on 2019-07-13, and was the Challenge puzzle for the theme *Small Code*. 

If only you could get some sleep. But still, you press on. 

It's 5:40am. Facing North, you walk through the corridor on the 3rd wall.

![Imgur](https://i.imgur.com/qMBzfie.gif)

You turn on the computer in the middle of the room. A message comes up.

---

Good morning keen student doctor,

I have a great summer vacation project for you! I've got some data on [HPV screening test results](http://www.cancerscreening.gov.au/internet/screening/publishing.nsf/Content/guide-to-understanding-your-cervical-screening-test-results) that look like this:

```text
Patient ID: 0001
Location: Azure Meadows

    HPV 16:             Not detected
    HPV 18:             Not detected
    HPV (not 16/18):    Not detected
    
    Liquid based cytology (LBC): Not performed.

RECOMMENDATION: Rescreen in 5 years.
```

I've got 2500 patients with data that looks like the above, each with their location (and there are 20 locations in total). Every patient in the dataset had a good sample - no "unsatisfactory samples" in *my* dataset!

I'm investigating the prevalence of HPV types in different locations. What I want to do is profile each location by the **ratio of detected HPV16 to detected HPV18** in this dataset. Ultimately, I want to find the **location with the highest HPV16 to HPV18 ratio**.  

You can assume all three results (i.e. HPV16, HPV18 and HPV-not-16/18) are independent. I imagine you'll have to tally up every time HPV16 is detected for a patient in a particular location, and tally up every time HPV18 is detected for a patient in a particular location, then divide the two numbers for each location and compare them. If both are detected in a single sample, still record them in both your tallies. I can confirm that each location has at least one detection each of HPV16 and HPV18 amongst its patients.

There's a lot of data to go through, so it'll be about 2 weeks full-time. Hope you can help us!

Dr Bertha Sweet

Obstetrician & Gynaecologist

---

You briefly reflect on whether a person's name might affect their occupational choice later in life.

# Input

Your puzzle input is [`cgmnt_input19.txt` (840.7kB, .txt)](https://drive.google.com/open?id=1gqaQBmhHDYisF-u1IXvJCXKLsh5uXTMM).

# Statement

Submit the name of the location which has the highest ratio of HPV16 to HPV18 detections.


# References

Written by the CIGMAH Puzzle Hunt Team.

The data for this puzzle is generated data. The code to generate the data is available after the puzzle is solved. The result template is based on [sample results from the Cancer Council website](https://wiki.cancer.org.au/australia/Guidelines:Cervical_cancer/Screening/Sample_cervical_screening_reports).

# Answer

The correct solution was `Honeydew Mountains`.

# Explanation

# Map Hint

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

# Writer's Notes

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

# DEFINING CONSTANTS

# HPV Results
HPV_16 = 0
HPV_18 = 1
HPV_OTHER = 2
HPV_TYPES = [HPV_16, HPV_18, HPV_OTHER]

# LBC Results
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

# CONVENIENCE FUNCTIONS

def make_recommendation(hpv_types: List[int]) -> str:
  if (HPV_16 in hpv_types) or (HPV_18 in hpv_types):
    lbc_result = random.choice(LBC_RESULTS)
    return RESULT_TEMPLATE.format(
      result=LBC_RESULT_STRINGS[lbc_result],
      recommendation="Refer for colposcopy."
    )
  elif (HPV_OTHER in hpv_types): 
    lbc_result = random.choice(LBC_RESULTS)
    if lbc_result == LBC_HSIL:
      return RESULT_TEMPLATE.format(
        result=LBC_RESULT_STRINGS[lbc_result],
        recommendation="Refer for colposcopy."
      )
    else:
      return RESULT_TEMPLATE.format(
        result=LBC_RESULT_STRINGS[lbc_result],
        recommendation="Repeat test in 12 months."
      )
  else:
    return RESULT_TEMPLATE.format(
      result="Not performed.",
      recommendation="Rescreen in 5 years."
    )

def make_result(hpv_types : List[int]) -> str:

  def bool_to_result(val : bool) -> str:
    if val:
      return "DETECTED"
    return "Not detected"

  template = """
    HPV 16:             {hpv_16}
    HPV 18:             {hpv_18}
    HPV (not 16/18):    {hpv_other}
    """

  return template.format(
    hpv_16 = bool_to_result(HPV_16 in hpv_types),
    hpv_18 = bool_to_result(HPV_18 in hpv_types),
    hpv_other = bool_to_result(HPV_OTHER  in hpv_types),
  )

def make_patient(id: int) -> str:
  location = random.choice(LOCATIONS)
  location_ratio = LOCATION_RATIOS[location]

  # Global HPV prevalence of 0.40
  if random.random() < 0.4:
    # With replacement, then convert to set to remove duplicates
    # Not exactly going to reflect ratios, but close enough!
    hpvs = list(set(random.choices(HPV_TYPES, weights=location_ratio, k=3)))
  else:
    hpvs = []

  result = make_result(hpvs)
  recommendation = make_recommendation(hpvs)

  return FULL_TEMPLATE.format(
    id=id,
    location=location,
    result=result,
    recommendation=recommendation,
  )

patients = [make_patient(i) for i in range(1, 2501)]

with open("output.txt", "w") as outfile:
  outfile.write(("\n" + "-" * 80 + "\n").join(patients))

for location in LOCATIONS:
  location_ratio = LOCATION_RATIOS[location]
  print(f"{location}:\t{location_ratio[0] / location_ratio[1]:.2f}")
```

