

# Troubled Test

> This puzzle was released on 2019-02-23, and was the Challenge puzzle for the theme *Text Books (Sample)*. 

> *This is a sample puzzle in the Challenge set. This puzzle isn't worth any
> points or prizes itself, but it contributes to the meta puzzle and helps
> introduce the puzzle hunt format. It's also worth a look to practise basic
> text processing and data analysis. The solution text for this sample puzzle (as well as the other sample puzzles) is available from the following link: [![Azure Notebooks](https://notebooks.azure.com/launch.svg)](https://notebooks.azure.com/cigmah-cgmnt/projects/cgmnt) This solution text is normally only revealed after a puzzle is completed.*

<br>

It's 12:40am. Facing North, you head through the corridor on the 5th wall.

![Image](https://i.imgur.com/zgobFvR.gif)

You pick up the book on the table. The cover says *Lupus Diagnoses Skyrocket: Pathology Labs in Question*. You open it up and read the first page.

> **LUPUS DIAGNOSES SKYROCKET: PATHOLOGY LABS IN QUESTION**

> A new diagnosis is sweeping through Autoville: Lupus. Lupus is an autoimmune
> disease - a disease where some of the body's own immune cells attack other
> cells. Some of the symptoms of lupus include a facial rash, joint pain and
> fatigue.

> While the prevalence of lupus in Autoville was only 20 in 100,000 three years
> ago, a recent study by the Autoville Autoimmune Disease Association has shown
> a staggering increase in the number of lupus diagnoses to 100 in 100,000 this
> year - an increase of five times.

> The Autoville Autoimmune Disease Association has stated that they have begun
> an investigation into the matter.

> "We don't believe this reflects an actual increase in the number of people
> with lupus. What we believe has occurred, according to preliminary evidence,
> is an error at one of the pathology labs when detecting one of the markers 
> for lupus in the blood, and unfortunately this has continued without being
> discovered sooner."

> "No one diagnoses lupus based on the results of one, or even multiple, blood
> tests. But it *is* possible the patients who make up this sudden increase had a
> similar disease process which, when combined with the results of the blood
> test, led clinicians to make a diagnosis when it would not have ordinarily
> been made."

> "Whether or not these constitute misdiagnoses is not clear at this point. If
> that is indeed the case, then we can assure patients and their families that
> we will be providing support and information services for all those affected."

> A spokesperson from H&E Pathology, one of Autoville's many pathology
> providers, says that H&E Pathology will assist with the investigation.

> "We take the accuracy of our tests very seriously. Pathology underlies so much
> of the healthcare system that we can't afford to make these sorts of mistakes.
> H&E Pathology will be cooperating with the Autoville Autoimmune Disease
> Association to get to the bottom of this issue, and we hope other pathology
> providers will follow suit."

> The investigation is expected to be completed within the next month.

It sounds like a news transcript. Misdiagnoses...that doesn't sound good.

You read the next page.

> Dear Mr Arthur,

> We have identified the pathology branch with the malfunctioning test. We can
> confirm the malfunction only affects one of the auto-antibody tests the lab
> provides. We are currently doing a final check and will contact you as soon as
> we are prepared to do so. I am afraid

That's it. It looks like it was cut off. The next pages all look like pathology
reports for various auto-antibody tests.

You have a think - it seems like a malfunction in an auto-antibody test at one
specific pathology branch was responsible for an increase in lupus diagnoses
(though you recall this was only a small part of the SLE diagnostic
criteria...perhaps Autoville used different criteria.). Most likely, the
malfunction caused an increase in false positives. You have lots of pathology
reports for different auto-antibody tests for different branches. If you apply a
bit of statistics, maybe you can find whether there is a pathology branch which
had a *significantly* different proportion of positive results for that
auto-antibody (though you still don't know which one.)

It's time to look at those pathology reports...

# Input

[cgmnt_input04.txt](https://drive.google.com/open?id=1Zm-TMyNlFe-g6MZ4wiWiQWqUK4Hxb7C9) (15MB)

Compressed versions:

- [cgmnt_input04.txt.gzip](https://drive.google.com/uc?id=1hqqn7b_2HMQu2KO_5VZ76p36Ab00FFZR) (414KB)
- [cgmnt_input04.txt.zip](https://drive.google.com/uc?id=1fvcQlUmbgYeG7kAf5YOOAnrIzuzSBL_a) (477KB)

# Statement

State the ID of the pathology branch with the malfunctioning test.


# References

Written by the CIGMAH Puzzle Hunt team.

<br>

To generate the input data, we used some information from the [Wikipedia Autoantibody page](https://en.wikipedia.org/wiki/Autoantibody) licensed under Creative Commons.

# Answer

The correct solution was `53562`.

# Explanation

# Map Hint

You reflect on the events this news transcript reveals. You wonder what happened in the aftermath - what were patients told? Were they truly misdiagnosed? And how could Autoville let the error of a single pathology branch create such an impact on patients' lives? 

You open `map_hint.txt`. It has only a single line:

```txt
The map itself is an SVG image.
```

Hmm. That's not very helpful unfortunately. But it's only the third room - you still have plenty of time to explore the other hints. Maybe they'll get more helpful as you explore more rooms...

# Writer's Notes

## Objectives

Our objectives for this puzzle were to incorporate:

1. Text processing, including regular expressions
2. Basic statistical analysis

When planning the puzzle, we intended the solving steps to be:

1. Parse the pathology reports into a branch ID and antibody results
2. Use some statistical test (e.g. chi-squared test) to determine the significance level of of branch ID's effect on the antibody result
3. Determine the pathology branch ID of the "significantly different" branch



## Context

Some basic data analysis skills are always a great idea for clinicians and researchers. Understanding epidemiology is crucial for medical professionals, even if they don't touch the analyses underlying it. *Evidence-based medicine* is practically an end-product of data analysis, and we believe that, although medical professionals may not necessarily *need* to conduct analyses themselves, it is an absolutely useful skill to learn (or, at the very least, understand thoroughly!). By not understanding the tools that we use, we make ourselves susceptible to possessing only a superficial understanding of how things came to be and losing the ability to critically think.

Calculating statistics manually, however, is laborious and error-prone. Coding is enormously helpful here. There are many ecosystems built around data analysis, perhaps the most eminent being that of [R](https://www.r-project.org/) , [Matlab](https://www.mathworks.com/products/matlab.html) (*proprietary*) and [SPSS](https://www.ibm.com/au-en/analytics/spss-statistics-software) (*propietary*). Thankfully, Python also has a great (and open!) data science ecosystem built around libraries such as [Numpy](http://www.numpy.org/), [Pandas](https://pandas.pydata.org/) and [scikit-learn](https://scikit-learn.org/stable/).

This puzzle is only a very simple example, but hopefully one which demonstrates how data mirroring real-life reports could be analysed in a very simple way to provide some useful information. Finding how a pathology branch ID is correlated with antibody positivity is essentially the same problem as determining how any multi-class categorical variable correlates with a binary outcome (e.g. how a place of residence might correlate with the number of cholera cases.)

## Example Solution

> Our example solutions are just one way of solving the puzzle. They're not necessarily the best way, or even a good way!

Loading data:


```python
import requests

input_url = "https://drive.google.com/uc?id=1Zm-TMyNlFe-g6MZ4wiWiQWqUK4Hxb7C9"
text = requests.get(input_url).text
```

Processing data:


```python
import re
import pandas as pd
import scipy.stats as stats

# Regexes
antibody_regex = re.compile(r'-{80}\n*(.*?)\t+((?:POSITIVE)|(?:NEGATIVE))', re.DOTALL)
branch_regex = re.compile(r'PATHOLOGY BRANCH: (\d+)')

# Process text to list of (branch_id, test, result) tuples
data = [(branch_regex.search(report).group(1), *result) 
         for report in text.split("="*80)
         for result in antibody_regex.findall(report)]

# Convert data to Pandas DataFrame
columns = ["branch_id", "assay_name", "assay_result"]
df = pd.DataFrame(data, columns=columns)

# Create contingency tables on branch_id x [test, result]
cross = pd.crosstab(df.branch_id, [df.assay_name, df.assay_result])

# Generate statistics for each test's contingency table
tests = list(set([c[0] for c in cross.columns]))
analyses = [(test, stats.chi2_contingency(cross[test])) for test in tests]

# Find the minimum p-value and assert < 0.05
min_p = min([a[1] for test, a in analyses])
assert min_p < 0.05

# Find the analysis with the lowest p-value
selected = [(test, analysis) for test, analysis in analyses if analysis[1] == min_p][0]

# Find the antibody test for which this analysis occurred
selected_test = selected[0]

# Find the difference between the observed and expected frequencies for this analysis
data_test = cross[selected_test]
diffs = data_test - selected[1][3]

# Find the branch with the max positive difference for this analysis
selected_branch = diffs[diffs["POSITIVE"] == max(diffs["POSITIVE"])].index.item()

print(selected_test)
print(selected_branch)
```

    Anti-Smith (ENA), Qualitative 
    53562


The solution works by:

1. Splitting the data into per-patient reports, and extracting the branch ID and antibodies with their results from each pathology report
2. Converting the extracted data into a Pandas dataframe (for easy analysis, given the amount of utilities Pandas provides)
3. Creating contingency tables for each branch ID and antibody test on the test result
4. Using Pandas to calculate statistics for each contingency table, including the chi-squared statistic, p-value and expected value matrix
5. Finding the minimum p-value and asserting that it must be below 0.05 (somewhat arbitrary, but a convention). If it is not, raise an error.
6. Determining the data for which the minimum p-value occurred (indicating a the branch ID made a "significant" difference to the antibody outcome)
7. Finding, from this data, the branch which contributed the most positive deviation of positive results from the expected frequencies.

This solution makes a number of assumptions about the data (e.g. that a p-value below 0.05 exists, or that this p-value was contributed by the branch which had the greatest positive deviation). We prototyped this solution initially using a REPL which helped us analyse the data step by step, but we have put it into a single Python script above for convenience.

## Extra Notes

We'll have a quick look at a few of these steps.

After processing our data using some standard string processing and regular expressions, our data looks something like this (we'll print the first five rows):


```python
df[:5]
```




<div>
<table class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>branch_id</th>
      <th>assay_name</th>
      <th>assay_result</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>87638</td>
      <td>p-ANCA, Qualitative</td>
      <td>NEGATIVE</td>
    </tr>
    <tr>
      <th>1</th>
      <td>87638</td>
      <td>Anti-amphiphysin, Qualitative</td>
      <td>NEGATIVE</td>
    </tr>
    <tr>
      <th>2</th>
      <td>87638</td>
      <td>Anti-eTG, Qualitative</td>
      <td>POSITIVE</td>
    </tr>
    <tr>
      <th>3</th>
      <td>87638</td>
      <td>Anti-Ma, Qualitative</td>
      <td>NEGATIVE</td>
    </tr>
    <tr>
      <th>4</th>
      <td>87638</td>
      <td>Anti-SSA/Ro autoantibodies (ENA), Qualitative</td>
      <td>NEGATIVE</td>
    </tr>
  </tbody>
</table>
</div>



We can actually stop here and briefly graph the data as a bar chart of the relative frequency of positive results for each branch ID, for each antibody test.


```python
freqs = df.replace(["NEGATIVE", "POSITIVE"], [0, 1]).groupby(["branch_id", "assay_name"]).mean()

import matplotlib.pyplot as plt
plt.style.use("default")

ax = freqs.unstack().plot(kind='bar', figsize=(12,10)).legend(bbox_to_anchor=(1, 1))
```

![Graph](https://lh3.googleusercontent.com/nL-Eh2zOYZ0e6F2AJmocq0LIFkyN4aQqi5uA135V0gIlM8kjoieaVzreA4MSeYKAVipbtHbRGvVxbGuxAEY5v7fLBAM9rOLAN1V2j2wHpIUKBgywTok6fbTPU90res9SJjVPdzm3=w1200)

It just so happens that the largest peak is also our answer. We should have probably made it a bit less obvious when generating our data. The other large peaks are test results which didn't occur very often, so have large errors. 

If we plot a very crude SEMs on top of this, we can see the standard errors of the means are quite large (it's not a pretty graphic, but we didn't feel the need to make it pretty...)


```python
sems = df.replace(["NEGATIVE", "POSITIVE"], [0, 1]).groupby(["branch_id", "assay_name"]).sem()
ax = freqs.unstack().plot(kind='bar', yerr=sems.unstack(), figsize=(12,10)).legend(bbox_to_anchor=(1, 1))
```

![Errors](https://lh3.googleusercontent.com/hr1RmU52RDviegU05cgKcSkctDFbds5hv3btAWwCwTk3QC2iwtZhCZ65qb6n1mHx67UnbbDxY9KwhGsqPXOf0oxPc08Q7E00exRnaBsyZxLkkqfNZ3mJNnhK7ROXwPZnR3rx_-Vu=w1200)

An astute observer might remark that the answer bar (53562, Anti-Smith antibodies) actually has a comparitively smaller SEM than many of the other large bars - though we think it would be hard to make any inference "for sure" about this data purely from inspection of this diagram. 

Our contingency table of the data (e.g. for Anti-Smith antibodies) looks a bit like this:


```python
cross["Anti-Smith (ENA), Qualitative "]
```




<div>
<table class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th>assay_result</th>
      <th>NEGATIVE</th>
      <th>POSITIVE</th>
    </tr>
    <tr>
      <th>branch_id</th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>07136</th>
      <td>160</td>
      <td>6</td>
    </tr>
    <tr>
      <th>13431</th>
      <td>123</td>
      <td>7</td>
    </tr>
    <tr>
      <th>22660</th>
      <td>130</td>
      <td>4</td>
    </tr>
    <tr>
      <th>24663</th>
      <td>127</td>
      <td>3</td>
    </tr>
    <tr>
      <th>48116</th>
      <td>119</td>
      <td>5</td>
    </tr>
    <tr>
      <th>53562</th>
      <td>87</td>
      <td>37</td>
    </tr>
    <tr>
      <th>55605</th>
      <td>121</td>
      <td>5</td>
    </tr>
    <tr>
      <th>61482</th>
      <td>149</td>
      <td>6</td>
    </tr>
    <tr>
      <th>61789</th>
      <td>150</td>
      <td>4</td>
    </tr>
    <tr>
      <th>81075</th>
      <td>125</td>
      <td>7</td>
    </tr>
    <tr>
      <th>81492</th>
      <td>129</td>
      <td>3</td>
    </tr>
    <tr>
      <th>83183</th>
      <td>128</td>
      <td>2</td>
    </tr>
    <tr>
      <th>87638</th>
      <td>153</td>
      <td>7</td>
    </tr>
    <tr>
      <th>90941</th>
      <td>160</td>
      <td>3</td>
    </tr>
    <tr>
      <th>95272</th>
      <td>115</td>
      <td>10</td>
    </tr>
  </tbody>
</table>
</div>



When we run the chi-squared test on this table to see whether the branch ID is independent of the antibody results, we get results that look something like this:


```python
stats.chi2_contingency(cross["Anti-Smith (ENA), Qualitative "])
```




    (171.40385769496152,
     3.5633515152280256e-29,
     14,
     array([[157.32182254,   8.67817746],
            [123.20383693,   6.79616307],
            [126.99472422,   7.00527578],
            [123.20383693,   6.79616307],
            [117.517506  ,   6.482494  ],
            [117.517506  ,   6.482494  ],
            [119.41294964,   6.58705036],
            [146.89688249,   8.10311751],
            [145.94916067,   8.05083933],
            [125.09928058,   6.90071942],
            [125.09928058,   6.90071942],
            [123.20383693,   6.79616307],
            [151.63549161,   8.36450839],
            [154.47865707,   8.52134293],
            [118.46522782,   6.53477218]]))



In this output, the tuple values correspond to the following:

1. The first value is the chi-squared statistic (the sum of normalised squared differences between the observed and expected frequencies).
2. The second value is the p-value (which is *very* small for this case, suggesting that no, the branch ID is *not* independent of the antibody results). 
3. The third value corresponds to the degrees of freedom.
4. The fourth value is an array of the expected outcomes (calculated from the marginals).

We like reading documentation - it's super helpful. The information on what value corresponds to what is available from the [scipy documentation for `chi2_contingency`](https://docs.scipy.org/doc/scipy/reference/generated/scipy.stats.chi2_contingency.html).

Out of curiosity, we can check how many results had a p-value below 0.05:


```python
[a[1] for test, a in analyses if a[1] < 0.05]
```




    [0.03852813286638996, 3.5633515152280256e-29]



So we can see there are actually two p-values below 0.05 (which is not terribly unexpected given that p-values correspond to probabilities, and we have a lot of null hypotheses to test in this data!) - though one is indeed much smaller than the other. We think that a statistics professor somewhere would be angry at us if we said that one of these is more significant than the other purely by virtue of being lower, so we'll just have a look at what the other significant value was:


```python
[(test, analysis) for test, analysis in analyses if analysis[1] < 0.05]
```




    [('Anti-Ma, Qualitative ',
      (24.618288488409586,
       0.03852813286638996,
       14,
       array([[11.74025974,  0.25974026],
              [12.71861472,  0.28138528],
              [12.71861472,  0.28138528],
              [19.56709957,  0.43290043],
              [23.48051948,  0.51948052],
              [13.6969697 ,  0.3030303 ],
              [13.6969697 ,  0.3030303 ],
              [12.71861472,  0.28138528],
              [10.76190476,  0.23809524],
              [13.6969697 ,  0.3030303 ],
              [17.61038961,  0.38961039],
              [ 8.80519481,  0.19480519],
              [17.61038961,  0.38961039],
              [18.58874459,  0.41125541],
              [18.58874459,  0.41125541]]))),
     ('Anti-Smith (ENA), Qualitative ',
      (171.40385769496152,
       3.5633515152280256e-29,
       14,
       array([[157.32182254,   8.67817746],
              [123.20383693,   6.79616307],
              [126.99472422,   7.00527578],
              [123.20383693,   6.79616307],
              [117.517506  ,   6.482494  ],
              [117.517506  ,   6.482494  ],
              [119.41294964,   6.58705036],
              [146.89688249,   8.10311751],
              [145.94916067,   8.05083933],
              [125.09928058,   6.90071942],
              [125.09928058,   6.90071942],
              [123.20383693,   6.79616307],
              [151.63549161,   8.36450839],
              [154.47865707,   8.52134293],
              [118.46522782,   6.53477218]])))]



So it's an Anti-Ma antibody test, which is not typically associated with SLE. We can also see that the number of occurrences of this antibody test at all is much lower. All suggestive, nothing definitive, but good enough for us.

## Data Generation

Our scenario is, like many of our puzzle scenarios, "unrealistic" in terms of narrative, but the data format and analysis principles should be similar.

We scraped a list of auto-antibodies from the [Wikipedia Autoantibody page](https://en.wikipedia.org/wiki/Autoantibody) (CC BY-SA license).


```python
import requests

text_html = requests.get("https://en.wikipedia.org/wiki/Autoantibody").text
```


```python
import re

# We only need the data container in the table with class "wikitable"
ab_html_match = re.search(r'<table class="wikitable">[\s\S]*</table>', text_html)

if ab_html_match:
    ab_html = ab_html_match.group(0)
```

> Note - we initially captured the data using a regular expression, but learned an important lesson: don't use regular expressions to parse HTML (unless it's *really* simple). It's too easy to miss edge cases or your regex becomes..."messy". We eventually did use an HTML parser for our actual data generation.


```python
# Don't do this. We are ashamed of it.
# Let this be a reminder of how every day we stray further...

antibody_regex = r'(?:<a.*>)?((?:[aA]nti[^<]+)|(?:[^a>]+antibod(?:y|ies)))(?:</a>)?(?:<sup.*><a.*>.*</a></sup>)?(?:\n)?'
auto_abs_capture = re.findall(r'<tr>\n<td.*?>{}</td>(?:\n<td.*?>{})?[\s\S]*?title=".*?">([^<]*).*?</a>(?:</sup>)?\n</td></tr>'.format(antibody_regex, antibody_regex),
                      ab_html)
```


```python
# See a few examples of what we captured
# The table formatting was irregular, so regex wasn't a particularly good idea in this case...
# The antibodies were contained in two columns; a "category" column and, sometimes, a specific column
# We wanted to capture the more specific version where present, which is why some of the capture values in the tuple are blank
# We also wanted to clean out links and reference markup, which is why our antibody_regex is so messy
auto_abs_capture[:5]
```




    [('Antinuclear antibodies',
      'Anti-SSA/Ro autoantibodies',
      'systemic lupus erythematosus'),
     ('Anti-centromere antibodies', '', 'CREST syndrome'),
     ('Anti-dsDNA', '', 'SLE'),
     ('Anti-Jo1', '', 'inflammatory myopathy'),
     ('Anti-RNP', '', 'Mixed Connective Tissue Disease')]




```python
# Clean up
auto_abs = [ab 
            for capture in auto_abs_capture 
            for i, ab in enumerate(capture)
            if ab and ((i == 0 and not capture[i+1]) or (i == 1)) ]

descriptions = [capture[2] for capture in auto_abs_capture]

abs_full = list(zip(auto_abs, descriptions))

# Add these back because our regex didn't capture certain antibody names (e.g. due to interfering markup, or not being labelled as an antibody)
abs_full += [("Rheumatoid factor", "rheumatoid arthritis"), 
             ("c-ANCA", "granulomatosis with polyangiitis"),
             ("p-ANCA", "microscopic polyangiitis, eosinophilic granulomatosis with polyangiitis, systemic vasculitides (non-specific)"),
             ("Anti-SSB/La autoantibodies", "Primary Sjogren's syndrome")]

# Remove this as we replaced it with a more specific version
abs_full.remove(('Anti-neutrophil cytoplasmic antibody', 'granulomatosis with polyangiitis'))
```

We decided that the ENA panel antibodies would always co-occur and labelled them. 


```python
enas = [
    'Anti-SSA/Ro autoantibodies',
    'Anti-SSB/La autoantibodies',
    'Anti-RNP',
    'Anti-Smith',
    'Anti-Jo1',
    'Anti-topoisomerase antibodies'
]

ena_full = []

ena_full = [(data[0] + " (ENA)", data[1]) for data in abs_full if data[0] in enas]
abs_full = [data for data in abs_full if data[0] not in enas]
```

Now that we had a list of antibodies and some descriptions, we defined a template for our pathology reports. The description text for our simulated data is almost useless, but is not particularly important for this puzzle; we have included it to increase the similarity of these reports to proper pathology reports.


```python
template = """
PATIENT ID: {patient_id}
DATE OF BIRTH: REDACTED
SEX: REDACTED

COLLECTION DATETIME: {collection_datetime}
SPECIMEN ID: {specimen_id}
SPECIMEN: SERUM

RECEIVED DATETIME: {received_datetime}
REPORTED DATETIME: {reported_datetime}

PATHOLOGY PROVIDER: {provider}
PATHOLOGY BRANCH: {branch_id}

RESULTS:
{results}

Signed off by REDACTED, {provider}.
"""

results_template = """

{ab}, Qualitative \t\t{result}

INTERPRETATION:

A positive {ab} result is most often associated with {description}. 
There is, however, limited information on the positive or negative predicted value of this test and we recommend that clinicians correlate this finding clinically.
A positive {ab} result may also be seen in connection with other autoimmune pathologies, and should be interpreted in the context of other findings in consultation with clinical and biochemical criteria.

"""

separator_thin = "\n" + "-" * 80 + "\n"
separator_thick = "\n\n" + "=" * 80 + "\n\n"
```

We selected one of the auto-antibodies - Anti-Smith - which is often thought of as "lupus-specific". We didn't want participants to be able to guess which antibody was the false positive, even though specifying lupus limited the possible antibodies that could act in this role.

We decided on an arbitrary number of pathology branches - 15 - and an arbitrary number of reports - 3000 (200 records each). We hoped this would be enough to make any difference between hospitals obvious. 

We then made random generator functions for each of the variables.


```python
malfunction_ab = "Anti-Smith (ENA)"
```


```python
from datetime import datetime
import random

num_reports = 3000
num_branches = 15

def get_datetimes():
    start = 1893456000 # 2030/01/01
    end = 1924992000 # 2031/01/01
    collection = random.randint(start, end)
    received = collection + random.randint(120, 6000) # 2 to 100 mins
    reported = received + random.randint(120, 6000) # 2 to 100 mins
    times = [collection, received, reported]
    return [datetime.fromtimestamp(t).strftime('%Y-%m-%d %H:%M') for t in times]


providers = [
    "H&E Pathology",
    "Giemsa",
    "PAS Pathological Adjunct Service",
    "Silver Diagnostics",
    "Mallory Labs"
]


def pad(num):
    return "{0:05d}".format(num)

# Must be unique, but also must look random
patient_ids = list(map(pad, random.sample(range(100000), k=num_reports)))
specimen_ids = list(map(pad, random.sample(range(100000), k=num_reports)))
branch_ids_choices = list(map(pad, random.sample(range(100000), k=num_branches)))

branch_id_provider_choices = list(zip(random.choices(providers, k=num_branches), branch_ids_choices))
```

We defined the base probabilities of an antibody being positive as a random number between 0.01 and 0.05. We couldn't make these too low, since we were afraid there wouldn't be enough data. To explain the seemingly high prevalence of positive antibody results, we reasoned that most clinicians in Autoville would only be asking for the test if they had reasonable suspicion it would be positive.

We decided on a probability between 0.2 and 0.3 as the probability of the malfunctioning test to be positive at the culprit branch.


```python
ena_data = [(ena[0], ena[1], random.uniform(0.01, 0.05)) for ena in ena_full]
abs_data = [(ab[0], ab[1], random.uniform(0.01, 0.05)) for ab in abs_full]
```


```python
malfunction_prob = random.uniform(0.2, 0.3)
```

Then we selected the branch ID with the malfunctioning machine.


```python
malfunction_branch = random.choice(branch_ids_choices)
```

We defined a function to generate antibodies and their results using their respective probabilities.


```python
def get_results(branch_id):
    # Choose between 2 and 4 antibodies other than ENA
    chosen = random.sample(abs_data, random.randint(2, 4))
    # ENA arbitrarily included in approx 70% of reports
    use_ena = random.random()
    if use_ena <= 0.7:
        chosen += ena_data
    result_choices = ["POSITIVE", "NEGATIVE"]
  
    results = []
  
    for test in chosen:
        if test[0] == malfunction_ab and branch_id == malfunction_branch:
          weights = [malfunction_prob, 1 - malfunction_prob]
        else:
          weights = [test[2], 1 - test[2]]
        results.append(random.choices(result_choices, weights=weights, k=1))

    return zip(chosen, results)
```

We defined a function to generate a pathology report with the required variables.


```python
def get_report(patient_id, specimen_id, branch_id_provider):
    collection, received, reported = get_datetimes()
    branch_id = branch_id_provider[1]
    provider = branch_id_provider[0]
    res_data = get_results(branch_id)
  
    result_strings = [results_template.format(ab=d[0][0],
                                            result=d[1][0],
                                            description=d[0][1])
                      for d in res_data]
    result_block = separator_thin + separator_thin.join(result_strings) + separator_thin

    report = template.format(patient_id=patient_id,
                           collection_datetime=collection,
                           specimen_id=specimen_id,
                           received_datetime=received,
                           reported_datetime=reported,
                           provider=provider,
                           branch_id=branch_id,
                           results=result_block
                          )
    return report  
```

We now generate the reports for our sets of `patient_ids`, `specimen_ids` and `branch_ids`.


```python
branch_id_providers = random.choices(branch_id_provider_choices, k=num_reports)
```


```python
reports = [get_report(*ids) for ids in zip(patient_ids, specimen_ids, branch_id_providers)]
```

We can finally get the final text as a string.


```python
text = separator_thick.join(reports).encode("ascii")
```

And we can save it!

Since the file is quite large, we'll save a gzipped and a txt version and offer both.


```python
filename = 'cgmnt_input04.txt'

with open(filename, 'wb') as f:
    f.write(text)
```


```python
import gzip

with gzip.open(filename + ".gzip", 'wb') as f:
    f.write(text)
```

It's quite a large file, unfortunately, but it'll have to do.


```python
print(malfunction_branch)
```

```
53562
```

