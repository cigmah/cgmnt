

# Base In Balance

> This puzzle was released on 2019-06-15, and was the Abstract puzzle for the theme *Game Night*. 

Maybe being lost in a library isn't so bad. There are much worse places to be lost in, like a dark forest, or the belly of a whale.

It's 4:00am. Facing North, you walk through the corridor on the 6th wall.

![Imgur](https://i.imgur.com/GxTQZ2F.gif)

You take a look at the computer in the middle of the room. A game window pops up with the title *Base in Balance*. 

A bead of sweat arises on your brow. Acid-base disturbances were never your strong point.

---

Here are the instructions. 

![Imgur](https://i.imgur.com/aFSprt3.gif)

*Base in Balance* is a 60 second game to test your reaction speeds to different acid-base disturbances.  

At the top of the screen, you are shown a balanced bar with a ball on top of it. Below it, you have a text box. At the bottom, you have two buttons - a *Left* and *Right* button.

Every 10 seconds, a random acid-base disturbance will be shown on the screen. The bar will automatically tilt towards either the left or right, depending on whether the acid-base disturbance is *most* associated with acidosis or alkalosis respectively (you do not need to distinguish whether it is metabolic or respiratory in cause). You may think of the "left" and "right" as directions of pH movement. The bar only has three angles of tilt - left, even, and right - so tilts do not accumulate.

You must re-balance the bar using the *Left* and *Right* buttons (or the left or right arrowkeys on your keyboard) and ensure that the ball does not fall off. If the ball falls off, you must start again. 

You must maintain the ball on the bar for 60 seconds (i.e. after 6 disturbances are shown). On the right hand corner of the text box, you can see your timer in seconds, and an indicator indicating if the ball is in danger (green for good, amber for "be careful" and red for "oh no!")

But why would you need the indicator if you can see the bar? Well...

![Imgur](https://i.imgur.com/DoBeMqz.gif)

After the first 2 disturbances are shown, someone conveniently puts a curtain in front of the balancing bar. You will be unable to see the ball or bar. You will have to use your knowledge of acid-base disturbances and the indicator to ensure the ball does not fall off. 

If you manage to keep the ball on the bar for 60 seconds successfully, you will be shown a codeword. Submit the codeword as your answer.

---

A ball, a balancing bar, and some acid-base knowledge...how hard could it be?

# Input

[Play at https://cgmnt-base-balance-ball-borders.netlify.com/](https://cgmnt-base-balance-ball-borders.netlify.com/).

This game works best on Chrome, Safari or Firefox on a desktop computer.

# Statement

State the codeword shown after successfully completing 60 seconds of the game without letting the ball fall off the bar.


# References

Written by the CIGMAH Puzzle Hunt Team. We found the [Anaesthesia MCQ Acid Base Book](https://www.anaesthesiamcq.com/AcidBaseBook/) a helpful resource when writing this puzzle.

# Answer

The correct solution was `BICARB`.

# Explanation

# Map Hint

You feel proud of your ability to balance things. Then you realise you have no work-life balance and you stop feeling proud and just feel a little sad. 

You open the file `map_hint.txt`.

```text

The map is an SVG contained in the deciphered HTML 
file. 

It is encoded in base64 directly in the HTML file, 
so you must specify this encoding in the data URL 
in the src attribute of the image to view it in the
browser.

```

Maybe you'll get that map after all.

# Writer's Notes

The source code for this puzzle will be released on the CIGMAH GitHub organisation after the puzzle hunt. A longer writeup will accompany this puzzle on the main CIGMAH website when we get time.

The puzzles for this theme were intended to be little games to test aspects of medical knowledge. All three puzzles were written in [Elm](https://elm-lang.org/), like most of our interactive puzzles.

The implementation of this puzzle was the easiest of the three, as the logic is fairly simple. It was harder to determine what would be an acceptable level of difficulty, particularly once the curtain blocks the view as it becomes very difficult without feedback. We therefore made the game fairly short. There are 24 acid-base disturbances in total, though only 6 are selected per play.

The aesthetic design of the game is loosely based off that of Magikarp Jump.

