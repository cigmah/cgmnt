

# Tarsal Tumble

> This puzzle was released on 2019-04-06, and was the Abstract puzzle for the theme *Pretty Pictures*.

It's 2:00am. Facing North, you walk through the corridor on the 6th wall.

![Image](https://i.imgur.com/sPf4Zeb.gif)

You wonder why the *Hospital of Babel* has such a strange library. And what anyone could want with so many identical rooms...

You open the book on the table. It's called *Tarsal Tumble*.

It only has one line:

> *Play the game and enter the digit code.*

You take a look at the computer, wondering what might come up. You've never liked the tarsal bones...

<br>

> *Tarsal Tumble* is a falling blocks game. Your goal is to construct a foot out of tarsal blocks within the time limit.

![Imgur](https://i.imgur.com/Zikz99c.gif)

> On the right-hand board is a *superior view* of the *left foot*. A shadow outline is there to guide you.When you place a correct tarsal block in the correct position on the right-hand board, it will flash green and stay in place.

![Imgur](https://i.imgur.com/3bPndk3.gif)

> However, if you place an incorrect tarsal block in the right-hand board, it will flash red and disappear. Any tarsal which overlaps with the right-hand board will be considered as "in the right-hand board."

![Imgur](https://i.imgur.com/379PkJ6.gif)

> The tarsal blocks will come in a random order. The name of the *next* tarsal block is indicated in the upper right-hand corner (but not the shape). You will need to pay careful attention to the names of the next blocks, as you will not be given the name of the current block once it ticks over - be careful not to get confused!

> When you get a tarsal that you do not want to use, you can place it on the left-hand board. The left-hand board works like the falling block games you're used to. You can clear rows to gain extra space.

![Imgur](https://i.imgur.com/oKtEGDB.gif)

> You have a time limit, starting at 120 seconds, and a point score, starting at 0. These will change with the following events:

> 1. If you correctly place a tarsal on the right-hand board, you earn 30 extra seconds.
> 2. If you clear a row/s on the left-hand board, you earn 10 extra seconds and 50 points per row.
> 3. If you incorrectly place a tarsal on the right-hand board, both your remaining time and points are *halved*, rounding down.

> It is thus in your best interests to minimise the number of tarsal you place incorrectly on the right-hand board. While you may find it easier to place large blocks on the right (since they disappear if they are incorrect), you should be careful at judging what compromises you can make.

> There are two failure conditions:

> 1. You run out of time, or
> 2. You overflow the left-hand board.

> If you successfully build the foot out of tarsals within the time limit, you will automatically be taken to another screen and presented with the digit code.

> Good luck!

<br>

## Input

[Play](https://cgmnt-tarsal-tumble-player.netlify.com).

## Statement

State the digit code found after successfully completing the game.


## References

Written by the CIGMAH Puzzle Hunt team.

## Answer

The correct solution was `813`.

## Explanation

### Map Hint

Take that! You definitely showed that game who's boss. You wish you had other opportunities to use your video game prowess in real life...

You open `map_hint.txt`. It contains the following:

```text

Key is original of:

    On some shelf in some hexagon (men reasoned) there must exist
    a book which is the formula and perfect compendium of all the
    rest: some librarian has gone through it and he is analogous
    to a god.

```

You wonder. Could such a book exist in this medical library?

### Writer's Notes

#### Objectives

1. Provide an interactive way to learn tarsals.

#### Context

Gamification has the potential to provide additional motivation for learning, particularly for memory-heavy subjects which often require a lot of rote study. Making some small browser-based games was one of our major ideas for CIGMAH at its inception, as we found a lot of material in medical school to be very high-volume and wanted to provide a slightly more "game-like" way of approaching our studies. Rest assured, this is not the end of medically-themed browser-based games for us!

We implemented this falling blocks game in Elm from scratch, partly for our own learning, and partly so that extending it would be easy. This means that the implementation may not be the most optimised, but it provided a lot of fun for us to work out how to code the physics and collisions of the game from first principles. We originally wanted to make this game mobile-friendly, but time pressures this month meant we couldn't deliver in time for the puzzle release - but it's on our radar.

We also did the music and sound effects, as per our principle of minimising our use of external data at CIGMAH. We didn't get time to extend the music and ended up looping at a rather strange point, but we had a lot of fun making it. More information about how we compose our music/sound FX are available on our CIGMAH About page on our home website.

Apologies in advance that our Writer's Notes section for this puzzle is quite sparse - again, time pressures and a small team make for compromises. We'd love to have more on our team to help us, so if you've reached this solution text, please consider it!

The code for this puzzle will be released publicly to our CIGMAH GitHub repository upon the end of the puzzle hunt. It's two big Elm files so we haven't included in our solution text as we do for when we generate our data using Python, but there's nothing hush about it. It's Elm code you'd expect from a small team with time pressures with plenty of room for improvement!

