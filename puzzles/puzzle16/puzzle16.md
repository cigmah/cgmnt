

# STI Bugs 'n' Drugs

> This puzzle was released on 2019-06-15, and was the Challenge puzzle for the theme *Game Night*.

You can do this. You'll make it out of here. You'll finish your internship. You'll learn how to help your patients the best you can. You've made it this far. You remember that you need to have faith in yourself, even when the world is so quiet and empty here.

It's 4:40am. Facing North, you walk through the corridor on the 5th wall.

![Imgur](https://i.imgur.com/cEUykIm.gif)

You turn on the computer in the middle of the room. A game pops up on the screen. The title of the game is *STI Bugs 'n' Drugs*.

---

Here's the instructions.

![Imgur](https://i.imgur.com/Hsqi5a5.gif)

*STI Bugs 'n' Drugs* is a tile matching game based on common pathogens and antimicrobials. Your goal is to get through 6 rounds of clearing bugs from the board by clicking on antimicrobials.

Each round begins with a randomly generated board of tiles. You can hover over each tile to see its description. Each tile is either a bug (circled) or a drug (with a shortened name).

Drugs are clickable. When you click on a drug, it will react with its corresponding bug to its left and its right (i.e. only on its horizontal row) until it reaches a bug it does not react with. For this game, each drugs corresponds with one bug and each bug corresponds with one drug.

When tiles are cleared, tiles above will drop to fill the empty spaces.

Here is a short summary of the bugs and the drugs for this game compared to their actual recommendations, based on information from the [Australian STI Management Guidelines](http://www.sti.guidelines.org.au/):

<table>
<tbody>
<tr>
<td>Bug</td>
<td>Recommended Treatment</td>
<td>Drug For This Game</td>
</tr>
<tr>
<td>Chlamydia trachomatis</td>
<td>Doxycycline OR azithromycin</td>
<td>Doxycycline</td>
</tr>
<tr>
<td>Neisseria gonorrhoea</td>
<td>Ceftriaxone AND azithromycin</td>
<td>Ceftriaxone</td>
</tr>
<tr>
<td>Haemophilus ducreyi</td>
<td>Azithromycin OR ceftriaxone OR ciprofloxacin</td>
<td>Azithromycin</td>
</tr>
<tr>
<td>Mycoplasma genitalium</td>
<td>(Doxycycline AND moxifloxacin) OR (Doxycycline AND azithromycin)</td>
<td>Moxifloxacin</td>
</tr>
<tr>
<td>Treponema pallidum</td>
<td>Benzathine benzylpenicillin</td>
<td>Benzathine benzylpenacillin</td>
</tr>
<tr>
<td>Trichomonas vaginalis</td>
<td>Metronidazole OR tinidazole</td>
<td>Metronidazole</td>
</tr>
<tr>
<td>Candida spp.</td>
<td>Clotrimazole</td>
<td>Clotrimazole</td>
</tr>
<tr>
<td>HSV</td>
<td>Valacyclovir</td>
<td>Valacyclovir</td>
</tr>
</tbody>
</table>

<details>
<summary> Click to show details regarding the bugs and drugs</summary>
<ol>
<li><p><i>Chlamydia trachomatis, serovars D-F</i>, a gram-negative bacterium. The recommended pharmacological  treatment for uncomplicated infection is doxycycline <i>or</i> azithromycin, but for this game, it only reacts with <i>doxycycline</i>.</p></li>
<li><p><i>Neisseria gonorrhoea</i>, a gram-negative diplococci. The recommended pharmacological treatment is ceftriaxone <i>and</i> azithromycin, but for this game, it only reacts with <i>ceftriaxone</i>. </p></li>
<li><p><i>Haemophilus ducreyi</i>, a gram-negative coccobacillus associated with <i>chancroid</i> and, on staining, often appears in a "school of fish" pattern. The recommended pharmacological treatment is azithromycin <i>or</i> ceftriaxone <i>or</i> ciprofloxacin, but for this game, it only reacts with <i>azithromycin</i>. </p></li>
<li><p><i>Mycoplasma genitalium</i>, a small flask-shaped bacterium. The recommended pharmacological treatment is doxycycline followed by azithromycin if macrolide susceptible, but very high rates of macrolide-resistance amongst risk groups in Australia (e.g. up to 80% in men who have sex with men and 50% in heterosexual women and men) mean that treatment with doxycycline followed by <i>moxifloxacin</i> is recommended where resistance is suspected. For this game, mycoplasma only reacts with <i>moxifloxacin</i>. </p></li>
<li><p><i>Treponema pallidum</i>, a spirochete seen on dark field microscopy associated with <i>syphillis</i>. The recommended pharmacological treatment is benzathine benzylpenicillin (aka benzathine penicillin G). In this game, treponema pallidum reacts with <i>benzathine benzylpenicillin (G)</i>.</p></li>
<li><p><i>Trichomonas vaginalis</i>, a parasite associated with profuse, frothy vaginal discharge. The recommended pharmacological treatment is metronidazole or tinidazole. For this game, trichomonas reacts with <i>metronidazole</i>.</p></li>
<li><p><i>Candida species</i>, fungi associated with candidiasis which often appear with budding yeasts or pseudohyphae on microscopy. The recommended pharmacological treatment is clotrimazole cream. For this game, candida reacts with clotrimazle. </p></li>
<li><p><i>Herpes simplex virus</i>, a virus associated with oral and genita lherpes. The recommended pharmacological treatment is valacyclovir. For this game, HSV reacts with valacyclovir. </p></li>
</ol>
</details>

Your task is to clear *all* the bugs and drugs from the board each round. You will need to be strategic about the order in which you click the drugs.

After you have completed 6 rounds, you will be shown a codeword to submit as your answer.

---

You hope you remember your knowledge of antimicrobials and have the patience to plan ahead before you start clicking tiles. It's time to do some *debugging*.

## Input

[Play the game at https://cgmnt-sti-symbolic-debugify.netlify.com/](https://cgmnt-sti-symbolic-debugify.netlify.com/).

This game works best on Chrome, Safari or Firefox on a desktop computer.

## Statement

State the codeword shown after successfully completing 6 rounds of the game.


## References

Written by the CIGMAH Puzzle Hunt Team.

We referenced the [Australian STI Management Guidelines](http://www.sti.guidelines.org.au/) when making this puzzle.

## Answer

The correct solution was `AZOLE`.

## Explanation

### Map Hint

You feel proud for having been able to match tiles, but you realise your knowledge of bugs and drugs will quiclky become outdated and feel a little helpless.

You open the file `map_hint.txt`.

```text

At this point, you should have enough information to decipher the map.

You still need more information to solve the puzzle. Consider the letters and the puzzle below the map. The letters and the puzzle correspond to something biomedically-related, but what?

The exit/antichamber, by the way, is *not* L-E.

```

You press onwards.

### Writer's Notes

The source code for this puzzle will be released on the CIGMAH GitHub organisation after the puzzle hunt. A longer writeup will accompany this puzzle on the main CIGMAH website when we get time.

The puzzles for this theme were intended to be little games to test aspects of medical knowledge. All three puzzles were written in [Elm](https://elm-lang.org/), like most of our interactive puzzles.

This puzzle was also a challenge to write in Elm because of its stateful, array-based nature. We settled on a heavy simplification of the game logic (initially, we intended for the drugs to react with bugs above as well).

We also originally intended for drugs and bugs in this game to have a many-to-many matching relationship, but our random level generation method was not able to guarantee that each level was solvable if we did so. We therefore limited each bug to one drug and each drug to one bug. While this is not quite as faithful to the recommended guidelines, it greatly simplifies our ability to ensure that each randomly generated level is solvable.

To solve each round, one need only focus on the bottom row of cells. Where there is more than one clickable drug on the bottom row, then one needs to do a bit of logical reasoning to decide which drug on the bottom row to click. Depending on the generated level, this might be easy or hard. A good rule of thumb is to make sure you don't get rid of a drug if there are still bugs above that need to matched with it.

We also had to temper the difficulty of this puzzle. Originally, we aimed to reach a width of 10 cells on the last level, but realised this was extremely difficult to solve (though, we believe, still definitively solvable). We settled on a width of 6 cells as an upper limit.

