

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

## Input

Your puzzle input is [`cgmnt_input19.txt` (840.7kB, .txt)](https://drive.google.com/open?id=1gqaQBmhHDYisF-u1IXvJCXKLsh5uXTMM).

## Statement

Submit the name of the location which has the highest ratio of HPV16 to HPV18 detections.


## References

Written by the CIGMAH Puzzle Hunt Team.

The data for this puzzle is generated data. The code to generate the data is available after the puzzle is solved. The result template is based on [sample results from the Cancer Council website](https://wiki.cancer.org.au/australia/Guidelines:Cervical_cancer/Screening/Sample_cervical_screening_reports).

## Answer

The correct solution was `Honeydew Mountains`.

## Explanation
### CONVENIENCE FUNCTIONS

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

