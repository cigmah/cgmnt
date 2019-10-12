

# Worst Offender

> This puzzle was released on 2019-06-15, and was the Beginner puzzle for the theme *Game Night*. 

You wonder what books are contained in this medical library. Or why it is so empty. Or maybe this place is so large that the population within it simply becomes diluted. SCP-3008 comes to mind and you shudder involuntarily. 

It's 4:20am. Facing North, you walk through the corridor on the 6th wall.

![Imgur](https://i.imgur.com/xyX9tRY.gif)

You turn on the computer in the middle of the room. A game pops up with the words *Worst Offender*. It looks like a card game. You have fond memories of playing *Hearts* on a Windows XP computer, though you never really understood how it worked. 

---

Here's the instructions.

![Imgur](https://i.imgur.com/UTEq757.gif)

*Worst Offender* is a 4-player trick-taking game with cards base on antipsychotics. The aim of the game is to take the most tricks. You play as Diane against Alex, Beatrice and Charles.

Every game first begins by dealing 8 cards to each player and drawing a list of 8 side effects, for 8 rounds of play (with each round offering one trick).

The deck consists of 8 antipsychotic cards, each repeated 8 times for a full deck of 64 cards:

```elm

type Card
    = Haloperidol
    | Chlorpromazine
    | Aripiprazole
    | Clozapine
    | Olanzapine
    | Quetiapine
    | Risperidone
    | Ziprasidone

```

At the start of the game, each player is given 8 random cards from the deck; leftover cards are discarded.

Then, 8 side effects are randomly drawn from the following:

```elm

type SideEffect
    = Anticholinergic
    | Dyslipidaemia
    | Extrapyramidal
    | Hyperprolactinaemia
    | NeurolepticMalignantSyndrome
    | PosturalHypotension
    | ProlongedQt
    | Sedation
    | Seizures
    | SexualDysfunction
    | Diabetes
    | WeightGain

```

You can see which side effects are drawn for your game, in order, in the top left corner.

The first round then begins. 

Each round, a side effect is shown in the center of the board. Players take turns in playing one of the antipsychotic cards in their hand, starting with Alex for the first round, or the taker of the last trick for every subsequent round (or if there was no taker, then the person who last went first). 

When all four players have played a card, the frequency of the side effect occuring for each antipsychotic is evaluated and displayed. The side effect profile of each antipsychotic is based on information from [this journal article by Hamer & Muench 2010](https://www.aafp.org/afp/2010/0301/p617.html). 

The player who played the "worst offender" out of the four cards in play (i.e. the antipsychotic which *most* frequently causes the side effect) takes the trick. If there is a tie during a round (which is not uncommon!), then no one takes the trick.

This process continues for 8 rounds until everyone has played all their cards. At the end, the number of tricks each player has taken is evaluated.

You have almost complete information in this game and can see everyone's cards, as well as what side effects will be in play in what order. You may use this information to strategise. 

Your goal is to win "outright" i.e. by the end of the game, to have taken the most tricks. If another player has the same number of tricks as you, that is a tie and you have not won outright. 

If you win outright, you will be shown a codeword to submit as your submission.

---

It's been a while since you've done your psychiatry rotations. You hope you have retained your knowledge of psychopharmacology.

# Input

[Play the game at https://cgmnt-worst-offender-psychopharmocards.netlify.com/](https://cgmnt-worst-offender-psychopharmocards.netlify.com/).

This game works best on Chrome or Firefox on a desktop computer. Safari has some known colour issues.

# Statement

State the codeword shown after successfully winning a game of *Worst Offender* outright.


# References

Written by the CIGMAH Puzzle Hunt Team.

We referenced [Hamer & Muench 2010](https://www.aafp.org/afp/2010/0301/p617.html) when coding the side effect profiles of each card in this game.

# Answer

The correct solution was `ZIPR`.

# Explanation

# Map Hint

You feel proud for retaining your knowledge of psychopharmacology, but then remember that you have never prescribed anything in your life before. As a new intern, the thought of prescribing in real life scares you. 

You open the file `map_hint.txt`.

```text

By now, you should have enough information to decipher the map.

Consider what other information you need. By now, you have probably guessed how you need to find the start room. The information needed to definitively determine the start room may not come for a few puzzles more. 

The start room is one of the grey hexagons.

```

That's not much of a hint.

# Writer's Notes

The source code for this puzzle will be released on the CIGMAH GitHub organisation after the puzzle hunt. A longer writeup will accompany this puzzle on the main CIGMAH website when we get time.

The puzzles for this theme were intended to be little games to test aspects of medical knowledge. All three puzzles were written in [Elm](https://elm-lang.org/), like most of our interactive puzzles.

This puzzle was the hardest of the three to implement, simply because there was so much state to keep track of and a lot of game state changes were computer-initiated, rather than user-initiated. In a pure functional language like Elm, this was particularly difficult where side effects are prohibited (outside of very specific contexts). 

The game is relatively simple for a player who knows the side effects. None of the CPU players are particularly good - Alex always plays his third best card, Beatrice always plays her second best card, and Charles just plays his worst card.

However, unlike our other games, we could not guarantee that you would get a hand that could win on ever randomised game. Originally, Beatrice played her best card each round, but we thought winning would be significantly more difficult given that ties during a round are so common (in which no one takes a trick). 

Winning this game comes down to having a good hand (like many card games!) but there are certain strategies which are hepful. Having all the cards visible from the start means you can plan ahead. There are inevitably some games which you cannot win since cards are *not* equal (e.g. Aripiprazole and Ziprasidone have comparatively fewer side effect profiles for this game), but we decided that revealing all cards and side effects at the start would, in the case of a shrewd player, allow you to determine whether you had a hope of winning from the outset and simply restart the game if you did not. A restart button might have helped, but there wasn't enough space on the screen.

