

# Out of Sync

> This puzzle was released on 2019-03-09, and was the Abstract puzzle for the theme *Automatic, Automata*. 

It's 1:00am. Facing North, you walk through the corridor on the 4th wall.

![Image](https://i.imgur.com/bLr5ykb.gif)

You pick up the book on the table. It says *Crab Canon - Out of Sync*. What's a crab canon? 

You start reading it.

> ## Crab Canon - Out of Sync

> ACHILLES: Ah! Well! Of course! I found it!

> TORTOISE: What an unusual thing. 

> ACHILLES: A PUMP! A Primitive Universal Miniature PUMP, of course. 

> TORTOISE: But what does "PUMP" mean?

> ACHILLES: But I just told you. It's recursive.

> TORTOISE: Mm...I'm still not quite sure I understand that acronym. 

> ACHILLES: Never mind that, I've already told you. At any rate, I've got its genome, and I'm on a mission. I'm going to use the PUMP Interactive Gene Live Editing Terminal (PIGLET) to find two very special codons.

> TORTOISE: And what might those be? 

> ACHILLES: "Havoc". "Order". I don't know, but I suppose it'd be like that. 

> TORTOISE: Well of course. But why?

> ACHILLES: I've made a mess of it already. But if I can find those two codons, I can reset the system.

> TORTOISE. And you'll just try messing around with PIGLET to figure it out?

> ACHILLES: No, no, no. There's a system to the madness.

> TORTOISE: The codons? Because I personally think they're bizarre. 

> ACHILLES: I disagree strongly. You know why, right?

> TORTOISE: ...the codons? Because I personally think they're bizarre?

> ACHILLES: No, no, no! There's a system to the madness.

> TORTOISE. And you'll just try messing around with PIGLET to figure it out.

> ACHILLES: I've made a mess of it already. But if I can find those two codons, I can reset the system.

> TORTOISE: Well of course. But why?

> ACHILLES: Havoc, order, I don't know. But I suppose it'd be like that. 

> TORTOISE: And what might those be? 

> ACHILLES: Never mind that! I've already told you at any rate - I've got its genome, and I'm on a mission. I'm going to use the PUMP Interactive Gene Live Editing Terminal (PIGLET) to find two very special codons!

> TORTOISE: Mm...I'm still not quite sure I understand that acronym. 

> ACHILLES: But I just told you. It's recursive.

> TORTOISE: But what does "PUMP" mean?

> ACHILLES: A PUMP! A Primitive Universal Miniature PUMP, of course. 

> TORTOISE: What an unusual thing. 

> ACHILLES: Ah, well of course! I found it!

> *Crab Canon - Out of Sync*

What a strange piece of text. It barely makes any sense. Well, you suppose this is what the UMAT (or whatever they call it nowadays) was trying to get out of future doctors - being able to make sense out of a big mess of facts. Or something like that. 

You open the computer and, much to your surprise, it opens directly into an interactive graphical interface - PIGLET. Ah! And it comes with it's own set of instructions. Perfect. Maybe the whole Crab Canon thing wasn't really relevant...

# Input

[Edit the PUMP on the PUMP Interactive Gene Live Editing Terminal (PIGLET)](https://cgmnt-achilles-tortoise-piglet.netlify.com/).

Your goal is to find the **Havoc** codon (which **cannot** be present in an orderly pump), and the **Order** codon (which **must** be present in an orderly pump). An orderly pump looks like the below:

![Image](https://lh3.googleusercontent.com/mLRC3L9VcFtwS27f6FHk_wBt6vR9uQxRpa4oDTC6mE7tMXJk4sqslERZvFWLgjGdR0w5wlpU2NVSQ-tyN1RwQfcrj_7Cc-Qp0XxMgE7b2UTd-VdNz8SkKd-vTXGCpUQHEG4V2jimMQ=w800)

# Statement

State the "Havoc", then the "Order" codon. (e.g. `ABC DEF`)


# References

Written by the CIGMAH Puzzle Hunt Team with reference to *Gödel, Escher, Bach: An Eternal Golden Braid* by Douglas Hofstadter.

We also thank [brendanzab](https://github.com/brendanzab) for his useful advice on optimising our WebGL animation.

# Answer

The correct solution was `PMP MPM`.

# Explanation

# Map Hint

You give yourself a pat on the back. If only all ailments could be cured by toggling a few nucleotides!

You open `map_hint.txt`. It has only two words:

```text
tabula recta
```

Hm. Well on to the next room...

# Writer's Notes

## Context

For our "Automatic, Automata"-themed month, we thought it would be fitting to have an interactive visualisation of a cellular automata given they had some clear applications to biology. A cellular automata model of a heart is [not](https://www.ncbi.nlm.nih.gov/pubmed/8812071) [a](https://www.ncbi.nlm.nih.gov/pubmed/27087101) [new concept](https://www.researchgate.net/publication/270451596_3D_Heart_Modeling_with_Cellular_Automata_Mass-Spring_System_and_CUDA), but we chose to implement ours from scratch in [Elm with WebGL](https://package.elm-lang.org/packages/elm-explorations/webgl/latest/) so we could control the parameters explicitly and make it into a puzzle. Our model is greatly simplified and probably approximates a single ventricle moreso than a heart, but hopefully should get similar ideas across.

## Explanation of Model

The model consists primarily of cells wrapped on a sphere.

Each cell possesses the following information:

1. 3D polar coordinates
2. A phase

There are four possible phases for our cell, which we chose to mimic the four phases of the cardiac action potential:

1. A resting phase, during which the cell may be stimulated to enter the depolarisation phase
2. A depolarisation phase, during which the cell may stimulate neighbouring cells to enter the depolarisation phase
3. A first refractory period, during which it cannot be further excited
4. A second refractory period, during which it cannot be further excited

The cell, once depolarised, proceeds (with each new generation) from the depolarisation phase, to the first refractory phase, to the second refractory phase, to a resting phase. Once in the resting phase, it can stay dormant, or be stimulated again.

Whether the cell is stimulated to re-enter the depolarisation phase is dependent on its [Moore neighbourhood](https://en.wikipedia.org/wiki/Moore_neighborhood) i.e. the "directly" neighbouring cells. This is where the genome comes in - each codon maps to a certain integer:

1. MMM maps to 1
2. MMP maps to 2
3. MPM maps to 3
4. MPP maps to 2
5. PMM maps to 1
6. PMP maps to 0
7. PPM maps to 1
8. PPP maps to 2

The genome, which consists of four codons, therefore represents four integers. Whether a resting cell depolarises depends on whether the number of its depolarised neighbours (only the depolarisation phase, not the refractory periods) is in the set of integers represented by the genome. For example, if the genome was `MMM MPP PMP PPM`, this would map to `1 2 0 1` and thus any resting cell would depolarise in the next generation if there were either 0, 1 or 2 (but not any other number) neighbouring depolarised cells in the current generation.

From these mappings, it should therefore be clear to see why the `Havoc` codon and the `Order` codon are indeed the way they are - the orderly, continuous "wave" occurs because of the propogations from the autonomous node at the top (which actually consists of 22 wedges) down the sides of the sphere. As each "row" cell connects to the row underneath it by 3 neighbours, a 3-neighbourhood codon is required for such a propogation. Having a genome set to all 3-neighbourhood codons makes the model quite resistant to perturbation as 3-neighbourhoods for this four-phase cell model are fairly rare. 

It should also be clear why the `Havoc` codon disrupts such an orderly wave. The orderly wave leaves many resting cells exposed to other resting cells, and zero-neighbourhood depolarisations would cause the pump to continuously implode.

The rhythm trace doesn't actually reflect the way real heart ECGs are done, but was good enough for our purposes. Our trace consists simply of the sum of the scalar projection of each cell's vector (from the North pole to the cell's position) on the longitudinal axis, multiplied by a modifier determined by the phase (with refractory phases contributing a negative modifier). Again, this isn't entirely reflective of true heart traces, but we thought it might make distinguishing distinct patterns easier.

We intend to make the Elm source code for this puzzle public once this year's puzzle hunt has ended. It consists mostly of transforming the cell coordinates to triangles to define a mesh, and subsequently transforming the mesh by the cell's state at each frame. 

As for the flavour text - we thought randomly guessing codons was no fun. Our solution codons just "happened" to be palindromes, so we couldn't resist being a little bit cheeky and putting a little bit of GEB in our puzzle. It was great fun for us at least.

