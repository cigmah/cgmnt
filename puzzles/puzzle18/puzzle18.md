

# Peak Flow Diary

> This puzzle was released on 2019-07-13, and was the Beginner puzzle for the theme *Small Code*. 

Your eyelids are drooping. You push through. 

It's 5:20am. Facing North, you walk through the corridor on the 3rd wall.

![Imgur](https://i.imgur.com/R6k9Eo6.gif)

You turn on the computer in the middle of the room. A clinical scenario pops up.

---

Annie, a 19 year old woman with asthma, has been experiencing asthma flareups since moving to Melbourne. To help monitor her flareups, she's been meticulously recording her [Peak Expiratory Flow (PEF)](https://en.wikipedia.org/wiki/Peak_expiratory_flow) measurements at home and recording her best-of-three PEF every day for a year (364 days) since Monday 1st of January 2018. She hasn't missed a single day. 

She's recorded these measurements using Notepad on Windows, entering a new number on a new line every day. There are exactly 364 lines in her digital peak flow diary - 52 weeks of 7 days. The first line corresponds to her PEF on Monday January 1st 2018, the second line corresponds to her PEF on Tuesday January 2nd 2018, the third corresponds to Wednesday January 3rd 2018, and so on. 

Annie moves around every day as she juggles multiple part-time jobs. On Mondays, she works as an administrator in the inner city and stays with her partner in an apartment complex. On Tuesdays, she works as a hairdresser in the suburbs. On Wednesdays, she drives out to Cranbourne to work as a receptionist. On Thursdays, she travels out to her family's farm, and so on. 

*But*, Annie's life is highly regular and her schedule repeats every week - so she is regularly at the same place on any given Monday, or Tuesday, or Wednesday, etc. of a week. As a result, her Monday PEFs are usually consistent between Mondays, her Tuesday PEFs are usually consistent between Tuesdays, etc. - but her measurements between *different* weekdays are highly variable i.e. her Monday PEFs are not directly comparable with her Tuesday PEFs. 

Annie recalls one day in which she had a really bad flareup of her asthma, but does not remember what day it was (the year is long!). She wants you to find that day so she can check her journal (which she also writes in every day) and see if there was anything special about that day that triggered it.

---

**Your task** is to determine on **what date** Annie's PEF was the most standard deviations *below* her mean relative to all other samples on that weekday (i.e. when her PEF [z-score](https://en.wikipedia.org/wiki/Standard_score), standardised by weekday, is lowest). Weekday refers to one of Monday, Tuesday, Wednesday, Thursday, Friday, Saturday or Sunday. 

In other words, instead of directly finding the lowest PEF measurement from the 364 days, you decide to standardise them by weekday i.e. you calculate the mean and standard deviation PEF of all the Mondays, then calculate the z-scores of all the Mondays using the Monday sample mean and standard deviation; then, you do the same for Tuesdays, Wednesdays, and so on. After doing so, each of the 364 days will have a standardised z-score which you can then compare globally. You need to find the date when her standardised z-score was lowest (it will be a negative z-score) and submit it as eight digits in the format YYYYMMDD (e.g. February 25th 2018 corresponds to `20180225`).

---

# Input

Your puzzle input is [`cgmnt_input18.txt` (2.5kB, .txt)](https://drive.google.com/open?id=1IzRkSQbmOryWq924NPGr65ug60hlidYb).

# Statement

On what date was Annie's PEF z-score (calculated against other PEFs on that weekday) the lowest? Express your answer as eight digits in the format YYYYMMDD e.g. `20180225`.


# References

Written by the CIGMAH Puzzle Hunt Team.

# Answer

The correct solution was `20180629`.

# Explanation

# Map Hint

You are glad that you can group peak flow measurements by weekday. 

You open the file `map_hint.txt`. 

```
The letters on each exit of the map correspond to one-letter codes of amino acids.
```

You question whether you remember anything about amino acids. 

# Writer's Notes

We apologise for the clumsy wording in the puzzle. The actual solution to this puzzle is very simple as it lends itself very well to an array programming approach, given that the year's worth of peak flow measurements (or more precisely, the 364 days of peak flow measurements) can be expressed as a `52x7` matrix of float values. When the data is reshaped in this manner, one need only calculate the mean and standard deviation along columns (giving a `1x7` row matrix for the means, and for the standard deviations) then subtract the mean row vector from every row in the original `52x7` data matrix, divide each row by the standard deviation row vector, then find the index of the lowest z-score and map it to the corresponding date. Most array languages or libraries (e.g. Python's `numpy`) will handle the array broadcasting automatically, so no loops are explicitly required. 

The `scipy.stats` library for Python does, in fact, even have a [`zscore`](https://docs.scipy.org/doc/scipy/reference/generated/scipy.stats.zscore.html#scipy.stats.zscore) function which takes an `axis` keyword to operate along a specified dimension, so one can write this contrived Python one-liner (excluding the import statements) to glue together array functions in a series of function calls:

(Code written like that below is a horror to maintain, but for a one-off use-case like this...)

```python
from numpy import argmin, reshape, loadtxt
from datetime import datetime, timedelta
from scipy.stats import zscore

print(datetime(2018,1,1) + timedelta(days=argmin(zscore(reshape(loadtxt('cgmnt_input18.txt'), (-1,7)), axis=0).flatten()).item()))
```
```
2018-06-29 00:00:00
```

It almost feels like cheating. We haven't needed to write any of the functions that do all the hard work - they're all just an import away. 

For fun, here's a few more solutions.

Here's one in the Julia programming language, which touts itself as language with dynamic typing and Python-like syntax (and Matlab-like syntax) with the speed of compiled languages. Our experience with Julia has been relatively pleasant from a language point-of-view, but practically hindered by the fact that it has relatively fewer libraries than Python. Still, it has first-class support for arrays and this, coupled with its concise lambda syntax and dot and pipe operators for element-wise application and function chaining respectively, can make for fairly concise solutions too (and without the imported `zscore` function this time). Julia is 1-indexed (as opposed to Python and most other programming languages, which are 0-indexed), so there are some modifications that need to be made as a result.

```julia
using Statistics
using Dates
using DelimitedFiles

# Minus 1 at the end as Julia is 1-indexed
readdlm("cgmnt_input18.txt")                      |> 
    x -> reshape(x, (7,52))                       |> 
    x -> (x .- mean(x, dims=2)) ./ std(x, dims=2) |> 
    x -> reshape(x, 7*52)                         |> 
    argmin                                        |> 
    x -> Date(2018,1,1) + Dates.Day(x-1)
```
And here's one in the [J programming language](https://www.jsoftware.com/#/), a descendent of the APL family. J is infamous for looking like line noise, but we wanted to have a go with it since it (and the APL language family) are array-based languages with automatic broadcasting and succinct array operations. Many critics of J have said that J is an abomination - unreadable, impractical, and making unnecessary compromises on readability. After having used it for a number of different purposes, we tend to agree. Still, it has interesting ideas and a number of [publically available mathematics books](https://code.jsoftware.com/wiki/Books#Calculus) which are interesting in themselves as they present J/APL as "executable math notation." 

```j
var  =: (+/@(*:@(] - +/ % #)) % #)"1
std  =: %:@var"1
mean =: +/%# 
zs   =: (-"1 mean) %"1 std@:|:

data =: 52 7$>".each cutopen fread 'cgmnt_input18.txt'
day  =: (i.<./),/ zs data
sol  =: todate todayno 2018 1 1 + 0 0, day
```
The first three functions (variance, standard deviation and mean) are available from [JPhrases](https://code.jsoftware.com/wiki/JPhrases/MathStats). 

We would love to see other solutions. This problem is quite small and we have absolutely no doubt someone could come up with shorter solutions than we have. 

Here's what we wrote to generate the dataset. It's not clean, but deadlines are deadlines.

```python
import numpy as np

highest_day = 4
means = [410, 390, 400, 380, 420, 400, 370]
stds  = [20, 15, 25, 20, 20, 25, 30]

days = [np.random.normal(mean, std, (52,)) 
        for mean, std in zip(means, stds)]

flattened = np.reshape(np.stack(days, axis=1), (-1))

# Make a single bad day on the day with the highest mean.
random_week = np.random.randint(10, 52)
random_day = random_week * 7 + highest_day

# Print the random_day
print(random_day)

# Modify in-place
flattened[random_day] = means[highest_day] - (2.5 * stds[highest_day])

with open("output.txt", 'w+') as outfile:
  rounded = ["{0:.2f}".format(val) for val in flattened]
  outfile.write("\n".join(rounded))
```

