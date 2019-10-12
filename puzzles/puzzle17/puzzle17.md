

# What Dipstick?

> This puzzle was released on 2019-07-13, and was the Abstract puzzle for the theme *Small Code*. 

You're feeling very drowsy. You can't tell if it's your tiredness, your desperation, or your silent anger at the architects who designed this library, but you're starting to get a bit emotional. Inside, you're berating yourself at becoming emotional over such a silly thing - how will you cope with the inevitable difficulties of real medical care if you can't even handle being Lost in a Library? - but you take a breath and close your eyes. Your head is foggy but you try to clear it anyway and just focus on your breath for a while.

It's 5:00am. Facing North, you walk through the corridor on the 5th wall.

![Imgur](https://i.imgur.com/YyRDeaE.gif)

You turn on the computer in the middle of the room. A screen comes up with a urine dipstick in the middle. You've never had much confidence in the sensitivity or specificity of the urine dipstick, but you had to admire its convenience and practicality. 

---

![Imgur](https://i.imgur.com/B1xSlMm.png?1)

Your task is to associate the **most** likely urine dipstick abnormalities with 8 different scenarios. 

After you click the Start button, you will be shown a scenario on screen along with a normal dipstick above it. You need to modify the dipstick to match the scenario. Each scenario has either 1 or 2 abnormalities, and you only get one click per abnormalitiy. Click on coloured tiles above/below the dipstick to change them. You can hover over the coloured tiles to show its description. 

After you have made the number of clicks corresponding to the number of abnormalities in the scenario, your dipstick will be checked. If it is correct, you will be shown an explanation and proceed to the next level. If it is incorrect, you will be shown a failure screen and will have to restart from the start screen again. 

As urine dipsticks are neither sensitive nor specific for most conditions, you should select the **most** strongly associated abnormality/abnormalities with the condition described in the scenario. 

There are 8 levels (and therefore 8 scenarios). After you have completed the 8th scenario, you will be shown a 3-digit code to submit as your submission.

---

You sigh and click Start.

# Input

[Play the puzzle at https://http://what-will-the-dipstick-look-like.netlify.com.](http://what-will-the-dipstick-look-like.netlify.com/)

This puzzle has been tested on Chrome, Safari and Firefox on a desktop computer. It is not designed for mobile devices.

# Statement

State the digit code shown after successfully completing the 8 scenarios.


# References

Written by the CIGMAH Puzzle Hunt Team.

We referenced a number of resources including [LITFL](https://litfl.com/dipstick-urinalysis/) and [Simerville et al 2005](https://www.aafp.org/afp/2005/0315/p1153.html) when making the scenarios for this puzzle.

# Answer

The correct solution was `294`.

# Explanation

# Map Hint

You are glad you remember how to interpret urine dipsticks. Who knows how many investigations those thin strips of paper have prompted over the years; some warrented, some perhaps not. 

You open the file `map_hint.txt`. 

```
The L- and D- prefixes corerspond to L- and D- enantiomers.
```

Enantiomers? What are those? You severely regret your forgetfulness of preclinical biochemistry. 

# Writer's Notes

This puzzle was a fairly straightforward puzzle, relying mostly on medical knowledge and taking the format of single-select and multi-select EMQs in the appearance of a urine dipstick. There is unfortunately going to be some ambiguity going from scenario -> dipstick as opposed to dipstick -> scenario given that there is often considerable variation, but we tried our best to choose scenarios where this was as unambiguous as possible (or at least, there would be one or two very-strongly-associated abnormalities that would overshadow any other possible abnormalities).

This was also a good learning opportunity for us. It's always very nerve-wracking for us to put in questions based on medical knowledge given that we're students. We tried our best with researching ambiguities. For one, multiple myeloma was originally going to be one of the scenarios, but we found out urine dipsticks don't pick up light chains. 

Like our other interactive puzzles, the code will be open-sourced after the puzzlehunt ends.

