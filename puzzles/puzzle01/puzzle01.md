

# Lost in a Library

> This puzzle was released on 2019-02-23, and was the Meta puzzle for the theme *Meta*.

> *The universe (which others call the Library) is composed of an indefinite and
> perhaps infinite number of hexagonal galleries, with vast air shafts between,
> surrounded by very low railings.*

> *-- Jorge Luis Borges, "The Library of Babel" (Translated by James E Irby)*

![Imgur](https://i.imgur.com/Ix8Urkt.gif)

1. You're the new medical intern. Congrats.
2. But you're lost in your hospital's library. The *Medical Library of Babel*.
3. How? Why? It doesn't matter.
4. It's 12am. The first ward round starts at 9am. So you've got nine hours.

5. Every room in the library is hexagonal.

![Imgur](https://i.imgur.com/rciyOCA.gif)

6. Most rooms connect to at least two other rooms.
7. A number of rooms are dead-ends.
8. One room is the exit.

9. Each room contains a puzzle.
10. The puzzle of this room (the start room) is the Map of the Medical Library of Babel.
11. That sounds useful, but...
12.  It's not intelligible. At least, not yet.


13. Your task is to escape the library.
14. Each puzzle, you will step into a new room.
15. To orient you as you step through rooms, the walls are numbered as shown.

![Orient](https://lh3.googleusercontent.com/rjYOi_AV5yK1CRi_IMvwHyqMGfFa_Z-UnzQMlvyE_E4USCMlH2TNa7yEpIF5Fo6MeY8cLzVJ--r-8rQorrtje79rSWDsPY-WMu6gmD1uUt1VUmU5vcTR7UkQE2zZ6OarGNieYWi9=w400)

16. When you complete a puzzle, you unlock a new hint about the map.


17. Go through rooms, collect map hints and decipher the map.
18. Once you've deciphered the map, determine which room you started in by backtracking your steps and matching it with the map.
19. Finally, determine which room is the exit on the map.
20. All possible exits on the map are labelled with two letters.
21. There is a puzzle on the deciphered map to determine which is the true exit and not a dead-end.

22. Submit your answer as the **label of the exit** and the minimum number of rooms **between** the start room and the exit. For example, in the following arbitrary example (your actual map is much more complicated), your answer would be `E-F 4`, noting that you are counting the number of rooms *between* the start and exit non-inclusive.

![Example](https://i.imgur.com/Cbn2dq9.png)

Please also note that while the labels have a hyphen for legibility, it does not matter whether or not you include the hyphen in your answer. The only thing that matters for submission is the correct letters and digits in the correct order - whitespace, punctuation and capitalisation are ignored.

<details>
<summary>
An earlier version of this puzzle appeared from February to April. It contains the same information but is considerably more verbose. We have included it for posterity.
</summary>
<blockquote>
  <p>The universe (which others call the Library) is composed of an indefinite and
  perhaps infinite number of hexagonal galleries, with vast air shafts between,
  surrounded by very low railings.</p>
  <p>-- Jorge Luis Borges, "The Library of Babel" (Translated by James E Irby)</p>
</blockquote>
<p>After five long and arduous years of medical school, you've finally managed to
secure the internship of your dreams - a coveted spot at The Hospital of Babel
("The Big One"). You were drained by those many hours using Anki to memorise
anything from the Krebs cycle to the history of Neville Barnes forceps; but
finally, the real medical journey begins. You're a doctor! You swell with pride
at the feeling you might actually be able to help - even if it's just as a
glorified paper pusher for a few years.</p>
<p>Today's your first day as an intern. You heard the parking at the hospital was
atrocious, so you arranged to arrive 10 hours early to your placement just to be
extra sure (you'd hate to be late to the first ward round!).</p>
<p>Seeing as you're early, you decide to explore the area. You notice a building
with a sign - The Medical Library of Babel. Maybe the library will have some
interesting books? Good printers? A place to sleep?</p>
<p>You enter The Medical Library of Babel, and step into a dimly-lit hexagonal
antechamber. In the middle of the antechamber is a sign with some letters (the name of the antechamber), but
you can't quite make them out in the darkness.</p>
<p>You walk through the antechamber into the first room. It's a hexagonal room
with either a bookshelf or a door on each wall. The doors lead to other
almost-identical hexagonal rooms, which themselves branch into other
almost-identical hexagonal rooms. Before you know it, curiosity gets the better
of you and you start going from room to room, marvelling at how this library is
arranged - a gigantic library of near-identical hexagonal rooms!</p>
<p>After going through rooms for what seems like hours, you stop and realise
you have no idea from which direction you came from. Like a madman, you'd simply
been walking from room to room laughing at how absurd the arrangement was. But
now you're completely lost.</p>
<p>You check your watch. It's 12am - you were told to arrive at 9am, so you have
nine hours. </p>
<p>While walking through the rooms in the library, you've noticed that in the
center of each room is a small table with a library computer and a book. The
library computer contains a digital version of the book and a password-locked
file, <code>map_hint.txt</code> (and a full development environment, of course).</p>
<p>In this particular room, the cover of the book on the table says Map of the
Medical Library of Babel . Ah! How fortunate - you can use this to find your way
out!</p>
<p>Unfortunately, it seems to be nothing but a seemingly random collection of
letters...so much for a map. But you do notice a handwritten note on the inside
cover: "Collect hints from computers." You suppose this refers to the
password-locked <code>map_hint.txt</code> files in each computer. You think that, maybe if
you go through the book on the table in each room, you'll be able to find the
password and get a map hint.</p>
<p>You check your inventory - you have a watch, compass, phone and
stethoscope. Your phone has no reception (and there's no WiFi available). To
orient yourself, you decide to use your compass and number the rooms in order
when facing North from 1 to 6.</p>
<p></p>
<p>This way, you can map out the exact path you take from now on through the
library by noting down each wall number you pass through when facing North. Even if you don't have the map right
now, this information might come in handy if you can decipher it.</p>
<p>So here's your plan - you'll go through rooms, noting down what path you take,
and try to collect map hints from each room's computer by reading the book on
each room's table (<code>puzzles</code>) and trying to find the password
(<code>solutions</code>). </p>
<p>Sweat starts to form on your brow as you contemplate your situation. Will you be
able to decipher the map? Will you ever find your way out of this gigantic library?
Will you be late to the first ward round?</p>
</details>

## Input

[cgmnt_input01.txt](https://drive.google.com/open?id=1SjJCONvkEu8ksDVHFxiqxwNYWa5ewdAu) (723KB)

## Statement

State the correct label of the exit on the map and the minimum number of rooms between the start room and the exit, non-inclusive. (e.g. `E-F 4`).


## References

Written by the CIGMAH Puzzle Hunt team.

## Answer

The correct solution was `L-V 41`.

## Explanation

### Aftermath

Eureka! You can finally get out of this infernal library. And it's only 8am - there's still time!

You run through the rooms back to your start room with the Map of the Medical Library of Babel. You're panting and sweating but you can do this. You smile and start laughing as you run through the path you've traced to the exit.

After darting through what seems like a thousand identical hexagonal rooms, you finally come across what looks like daylight. It's been so long since you saw the Sun (not really) or heard the birds chirping (not really); how welcoming these simple pleasures can be!

You step out of the library, grinning and laughing like a madman at how you've managed to get through this ordeal. You get a few stares from the people passing by, but you're sleep-deprived and thought you would be lost in the depths of an infinite library forever. You deserve this moment.

But you've still got to find your ward team. It's getting close to the official start time - no chances of being early and making a good impression anymore - but you can still make it!

You enter the main hospital building feeling like the protagonist of an adventure novel. You're so close.

And yet...where is this Ward 2837E that you are supposed to go to? Your smile fades as you realise how big the hospital is and how astronomically small your chances are of finding your ward team are in the next thirty seconds. You peer around the corner looking for the reception desk, but you can't seem to find it anywhere either. If only there was a map...

### Solution

#### Answer


```python
"L-V 41"
```


#### Writer's Notes

We ended up deciding on this puzzle after deciding that the theme for the puzzle hunt would be *The Library of Babel* by Jorge Luis Borges. Our choice of theme underwent several iterations - from unicode, to a epidemiology-based infection source finder, to *The Little Prince*, to *1984*. We decided on *The Library of Babel* given it's accessibility as a short story, and the flexibility of books being a source of data.

When we decided to make the puzzle an "escape" puzzle, we intended for there to be four steps:

1. Decode the map image from some text data
2. Determine the exit (unmarked)
3. Determine the room in which you started (unmarked)
4. Determine the shortest path from the start room to the exit

We created the initial map as an [SVG](https://en.wikipedia.org/wiki/Scalable_Vector_Graphics) using Elm. Although we could have hand-crafted the map using any image manipulation software, our time constraints (and the need to release the meta puzzle first) meant that we wanted a solution that we could change easily and programatically, and could distill down into a set of coordinates of hexagonal nodes that we could use path-finding algorithms on to verify the puzzle solution. Using Elm also made it easy for us to prototype the map using communal computers in the browser with [Ellie](https://ellie-app.com/new) without having to install anything; a logistical consideration that was important for us to keep our puzzle-writing portable.

That being said, our map did turn out to be mostly "hand-tuned" in the end. Time constraints meant we couldn't make the map as complex as we originally would have liked, but the end result was good enough for our needs - the path-finding step was one of only four steps in the puzzle, after all.

We defined three components to the map:

  - Rings:  hexagonal rings around the origin (with some nodes taken out to prevent easy solving by "going around a ring").
  - Tendrils: winding paths which were the main source of end nodes (i.e. potential exits).
  - Spokes: vertical columns (again, with some nodes taken out to prevent easy solving).

Combining these three elements resulted in the map below.

![](https://drive.google.com/uc?id=16nr85iZg8idjo0IE3DtFw1YJtjns6MKK)

Using Elm's `Debug.log`, we could also get a list of the hexagon nodes (using the coordinate system described below).


```python
nodes = set([(0,1),(1,1),(0,-1),(-1,-1),(1,0),(1,1),(-1,0),(-1,-1),(0,-1),(1,0),(-1,0),(0,1),(0,3),(1,3),(2,3),(0,-3),(-1,-3),(-2,-3),(3,0),(3,1),(3,2),(-3,0),(-3,-1),(-3,-2),(0,-3),(1,-2),(2,-1),(-3,0),(-2,1),(-1,2),(0,5),(1,5),(2,5),(4,5),(5,5),(0,-5),(-1,-5),(-2,-5),(-4,-5),(-5,-5),(5,0),(5,1),(5,2),(5,4),(5,5),(-5,0),(-5,-1),(-5,-2),(-5,-4),(-5,-5),(0,-5),(1,-4),(2,-3),(4,-1),(5,0),(-5,0),(-4,1),(-3,2),(-1,4),(0,5),(0,7),(1,7),(2,7),(4,7),(5,7),(6,7),(0,-7),(-1,-7),(-2,-7),(-4,-7),(-5,-7),(-6,-7),(7,0),(7,1),(7,2),(7,4),(7,5),(7,6),(-7,0),(-7,-1),(-7,-2),(-7,-4),(-7,-5),(-7,-6),(0,-7),(1,-6),(2,-5),(4,-3),(5,-2),(6,-1),(-7,0),(-6,1),(-5,2),(-3,4),(-2,5),(-1,6),(0,11),(1,11),(2,11),(4,11),(5,11),(6,11),(8,11),(9,11),(10,11),(0,-11),(-1,-11),(-2,-11),(-4,-11),(-5,-11),(-6,-11),(-8,-11),(-9,-11),(-10,-11),(11,0),(11,1),(11,2),(11,4),(11,5),(11,6),(11,8),(11,9),(11,10),(-11,0),(-11,-1),(-11,-2),(-11,-4),(-11,-5),(-11,-6),(-11,-8),(-11,-9),(-11,-10),(0,-11),(1,-10),(2,-9),(4,-7),(5,-6),(6,-5),(8,-3),(9,-2),(10,-1),(-11,0),(-10,1),(-9,2),(-7,4),(-6,5),(-5,6),(-3,8),(-2,9),(-1,10),(0,15),(1,15),(2,15),(4,15),(5,15),(6,15),(8,15),(9,15),(10,15),(12,15),(13,15),(14,15),(0,-15),(-1,-15),(-2,-15),(-4,-15),(-5,-15),(-6,-15),(-8,-15),(-9,-15),(-10,-15),(-12,-15),(-13,-15),(-14,-15),(15,0),(15,1),(15,2),(15,4),(15,5),(15,6),(15,8),(15,9),(15,10),(15,12),(15,13),(15,14),(-15,0),(-15,-1),(-15,-2),(-15,-4),(-15,-5),(-15,-6),(-15,-8),(-15,-9),(-15,-10),(-15,-12),(-15,-13),(-15,-14),(0,-15),(1,-14),(2,-13),(4,-11),(5,-10),(6,-9),(8,-7),(9,-6),(10,-5),(12,-3),(13,-2),(14,-1),(-15,0),(-14,1),(-13,2),(-11,4),(-10,5),(-9,6),(-7,8),(-6,9),(-5,10),(-3,12),(-2,13),(-1,14),(0,17),(1,17),(2,17),(4,17),(5,17),(6,17),(8,17),(9,17),(10,17),(12,17),(13,17),(14,17),(16,17),(17,17),(0,-17),(-1,-17),(-2,-17),(-4,-17),(-5,-17),(-6,-17),(-8,-17),(-9,-17),(-10,-17),(-12,-17),(-13,-17),(-14,-17),(-16,-17),(-17,-17),(17,0),(17,1),(17,2),(17,4),(17,5),(17,6),(17,8),(17,9),(17,10),(17,12),(17,13),(17,14),(17,16),(17,17),(-17,0),(-17,-1),(-17,-2),(-17,-4),(-17,-5),(-17,-6),(-17,-8),(-17,-9),(-17,-10),(-17,-12),(-17,-13),(-17,-14),(-17,-16),(-17,-17),(0,-17),(1,-16),(2,-15),(4,-13),(5,-12),(6,-11),(8,-9),(9,-8),(10,-7),(12,-5),(13,-4),(14,-3),(16,-1),(17,0),(-17,0),(-16,1),(-15,2),(-13,4),(-12,5),(-11,6),(-9,8),(-8,9),(-7,10),(-5,12),(-4,13),(-3,14),(-1,16),(0,17),(2,3),(3,4),(3,5),(2,5),(1,5),(1,6),(2,7),(3,8),(3,9),(2,9),(1,9),(1,10),(2,11),(3,12),(3,13),(2,13),(1,13),(1,14),(2,15),(3,16),(3,17),(2,17),(1,17),(1,18),(2,19),(-10,-4),(-11,-5),(-11,-6),(-10,-6),(-9,-6),(-9,-7),(-10,-8),(-11,-9),(-11,-10),(-10,-10),(-9,-10),(-9,-11),(-10,-12),(-11,-13),(-11,-14),(-10,-14),(-9,-14),(-9,-15),(-10,-16),(-11,-17),(-11,-18),(-10,-18),(-9,-18),(-9,-19),(-10,-20),(3,-2),(4,-1),(5,-1),(5,-2),(5,-3),(6,-3),(7,-2),(8,-1),(9,-1),(9,-2),(9,-3),(10,-3),(11,-2),(12,-1),(13,-1),(13,-2),(13,-3),(14,-3),(15,-2),(16,-1),(17,-1),(17,-2),(17,-3),(18,-3),(19,-2),(-3,4),(-4,3),(-5,3),(-5,4),(-5,5),(-6,5),(-7,4),(-8,3),(-9,3),(-9,4),(-9,5),(-10,5),(-11,4),(-12,3),(-13,3),(-13,4),(-13,5),(-14,5),(-15,4),(-16,3),(-17,3),(-17,4),(-17,5),(-18,5),(-19,4),(4,10),(5,11),(6,11),(6,10),(6,9),(7,9),(8,10),(9,11),(10,11),(10,10),(10,9),(11,9),(12,10),(13,11),(14,11),(14,10),(14,9),(15,9),(16,10),(17,11),(18,11),(18,10),(18,9),(19,9),(20,10),(-4,-10),(-5,-11),(-6,-11),(-6,-10),(-6,-9),(-7,-9),(-8,-10),(-9,-11),(-10,-11),(-10,-10),(-10,-9),(-11,-9),(-12,-10),(-13,-11),(-14,-11),(-14,-10),(-14,-9),(-15,-9),(-16,-10),(-17,-11),(-18,-11),(-18,-10),(-18,-9),(-19,-9),(-20,-10),(8,5),(9,6),(9,7),(8,7),(7,7),(7,8),(8,9),(9,10),(9,11),(8,11),(7,11),(7,12),(8,13),(9,14),(9,15),(8,15),(7,15),(7,16),(8,17),(9,18),(9,19),(8,19),(7,19),(7,20),(8,21),(-4,-5),(-5,-6),(-5,-7),(-4,-7),(-3,-7),(-3,-8),(-4,-9),(-5,-10),(-5,-11),(-4,-11),(-3,-11),(-3,-12),(-4,-13),(-5,-14),(-5,-15),(-4,-15),(-3,-15),(-3,-16),(-4,-17),(-5,-18),(-5,-19),(-4,-19),(-3,-19),(-3,-20),(-4,-21),(5,2),(6,3),(7,3),(7,2),(7,1),(8,1),(9,2),(10,3),(11,3),(11,2),(11,1),(12,1),(13,2),(14,3),(15,3),(15,2),(15,1),(16,1),(17,2),(18,3),(19,3),(19,2),(19,1),(20,1),(21,2),(-5,-3),(-6,-4),(-7,-4),(-7,-3),(-7,-2),(-8,-2),(-9,-3),(-10,-4),(-11,-4),(-11,-3),(-11,-2),(-12,-2),(-13,-3),(-14,-4),(-15,-4),(-15,-3),(-15,-2),(-16,-2),(-17,-3),(-18,-4),(-19,-4),(-19,-3),(-19,-2),(-20,-2),(-21,-3),(7,1),(6,0),(6,-1),(7,-1),(8,-1),(8,-2),(7,-3),(6,-4),(6,-5),(7,-5),(8,-5),(8,-6),(7,-7),(6,-8),(6,-9),(7,-9),(8,-9),(8,-10),(7,-11),(6,-12),(6,-13),(7,-13),(8,-13),(8,-14),(7,-15),(-4,1),(-3,2),(-3,3),(-4,3),(-5,3),(-5,4),(-4,5),(-3,6),(-3,7),(-4,7),(-5,7),(-5,8),(-4,9),(-3,10),(-3,11),(-4,11),(-5,11),(-5,12),(-4,13),(-3,14),(-3,15),(-4,15),(-5,15),(-5,16),(-4,17),(13,5),(14,6),(14,7),(13,7),(12,7),(12,8),(13,9),(14,10),(14,11),(13,11),(12,11),(12,12),(13,13),(14,14),(14,15),(13,15),(12,15),(12,16),(13,17),(14,18),(14,19),(13,19),(12,19),(12,20),(13,21),(2,-1),(1,-2),(1,-3),(2,-3),(3,-3),(3,-4),(2,-5),(1,-6),(1,-7),(2,-7),(3,-7),(3,-8),(2,-9),(1,-10),(1,-11),(2,-11),(3,-11),(3,-12),(2,-13),(1,-14),(1,-15),(2,-15),(3,-15),(3,-16),(2,-17),(5,7),(4,6),(3,6),(3,7),(3,8),(2,8),(1,7),(0,6),(-1,6),(-1,7),(-1,8),(-2,8),(-3,7),(-4,6),(-5,6),(-5,7),(-5,8),(-6,8),(-7,7),(-8,6),(-9,6),(-9,7),(-9,8),(-10,8),(-11,7),(7,6),(8,7),(9,7),(9,6),(9,5),(10,5),(11,6),(12,7),(13,7),(13,6),(13,5),(14,5),(15,6),(16,7),(17,7),(17,6),(17,5),(18,5),(19,6),(20,7),(21,7),(21,6),(21,5),(22,5),(23,6),(1,1),(2,2),(4,4),(6,6),(7,7),(8,8),(10,10),(11,11),(12,12),(13,13),(15,15),(16,16),(18,18),(-1,-1),(-2,-2),(-4,-4),(-6,-6),(-7,-7),(-8,-8),(-10,-10),(-11,-11),(-12,-12),(-13,-13),(-15,-15),(-16,-16),(-18,-18)])
```

After creating the map base, we manually coloured the end nodes (nodes with only one wall adjoining another node) and labelled the map using [Inkscape](https://inkscape.org).

We verified the number of end nodes by checking whether each of the nodes had an adjacent node in the set. The coordinate system and adjacent nodes are fairly simple:

![](https://drive.google.com/uc?id=1sylUdiq-QUdR5Uw-dsAprdViu2P3qsh_)


```python
def get_adjacent_nodes(node):
  """ Returns a set of adjacent nodes.

  Nodes are defined as an (x,y) tuple per the coordinate system above."""

  x = node[0]
  y = node[1]

  adjacent_nodes = [(x-1, y-1),
                    (x  , y-1),
                    (x+1, y  ),
                    (x+1, y+1),
                    (x  , y+1),
                    (x-1, y  )]

  adjacent_set = set(adjacent_nodes)

  return adjacent_set
```


```python
## End nodes are only connected to one other node
ends = [node for node in nodes if len(get_adjacent_nodes(node).intersection(nodes)) == 1]
```


```python
len(ends)
```




    40



This agrees with our manual colouring of 40 nodes.

When we realised that 40 nodes could act as ends, we thought about how we could differentiate the exit point with a puzzle. Some of our ideas included labelling end nodes with end-arteries and one non-end-artery or as solid or hollow viscera.

We eventually decided to use amino acids as the puzzle, and to specify the exit point as a amino acid that almost every medical student learns due to its relevance in sickle cell anaemia - valine. As there are 20 amino acids derived from the genes, we doubled up using D- and L- enantiomers (with the exception of glycine, which we simply used G for). We expected participants to recognise the D- and L- prefixes as referring to isomers (and to notice the doubled G), and make the inference that the second letter corresponded to the [one-letter codes of amino acids](https://en.wikipedia.org/wiki/Amino_acid#Table_of_standard_amino_acid_abbreviations_and_properties).


We added a small symbolic hint to point to `L-V` as the correct end node.

![](https://drive.google.com/uc?id=1w9ovFsTDyiYKm9NI5yra4RYEWWYCIGv1)

To determine the start node, we decided to have each puzzle take place in a room and to describe the protagonist's movement through the rooms in each puzzle's scenario. The final puzzle would lead to one of the non-exit dead-ends. We wanted this path to correspond to only one starting node in the map, and for this correspondence to only emerge in the final month of the puzzle.

We selected the the start node by following one of the tendrils on the lower-left side of the map and tracing it back 24 steps, which led to the coordinate `(14,5)`. We now wanted to verify that the 24 steps leading to the dead-end was indeed unique for that node.

![](https://drive.google.com/uc?id=1CkRfxQKzfDiFF7pJLPKeco4uI3-0O5JL)


```python
from itertools import cycle, islice

## Ported from the Elm code used to make map
x_rep = [ 1, 1, 0, -1, -1, 0 ]

y_rep = [ 2, 3, 3, 3, 4, 5 ]

## Minus 1 from y_rep as the original was relative to (0,1)
y_rep = list(map(lambda x: x - 1, y_rep))

def make_tendril(length):
  """Generates a list of coordinates of a tendril given the tendril length"""

  # Does not include the starting node, so minus 1 from length
  length = length - 1

  # Generate xs up until length by repeating x_rep
  xs = islice(cycle(x_rep), length)

  # Define the length of a tendril unit
  unit = len(y_rep)

  # Generate the y-offset for length > tendril length
  y_add = islice([adder
                 for adder in range(length // unit + 1)
                  for i in range(unit)]
                , length)

  # Sum the repeated y_rep with the y-offsets
  ys = [4 * adder + y for (adder, y) in zip(y_add, cycle(y_rep))]

  # Add the starting node
  coords = [(0,0)] + list(zip(xs, ys))

  return coords
```

As the coordinate `(14,7)` corresponds to the second node of a tendril, we remove the first two nodes of the tendril steps.


```python
path_tendril = make_tendril(25)

## Remove first two nodes
steps = path_tendril[2:]

## Recalibrate steps to be relative to (0,0)
## The first node is (1,2), so we subtract this
steps = list(map(lambda s: (s[0] - 1, s[1] - 2), steps))

```

Then we add two remaining steps, which were detours in the tendril path to (hopefully) make it unique. These are located at index 16 and 18 (0-indexing) of the path.


```python
print(steps[15])
print(steps[16])
```

    (-2, 9)
    (-1, 10)



```python
steps.insert(16, (-2, 10))
steps.insert(18, (0, 10))
```

As an aside, we can get the steps we need to specify in each puzzle's scenario text.


```python
## TODO Find better way to do this!
def get_wall_num(coordinate):
  if coordinate == (-1, -1):
    return 1
  elif coordinate == (0, -1):
    return 2
  elif coordinate == (1, 0):
    return 3
  elif coordinate == (1, 1):
    return 4
  elif coordinate == (0, 1):
    return 5
  elif coordinate == (-1, 0):
    return 6
  else:
    return None

times = [12] + list(range(1, 8))
mins = ["00", "20", "40"]

for i, step in enumerate(steps):
  if i != 0:
    relative = (step[0] - steps[i-1][0], step[1] - steps[i-1][1])

    wall_num = get_wall_num(relative)

    base = "PUZZLE NO. {}: It's {}:{}am. Facing North, you walk through the corridor on the {}th wall."

    print(base.format(i+1, times[(i-1) // 3], mins[(i-1) % 3], wall_num))
```

    PUZZLE NO. 2: It's 12:00am. Facing North, you walk through the corridor on the 6th wall.
    PUZZLE NO. 3: It's 12:20am. Facing North, you walk through the corridor on the 6th wall.
    PUZZLE NO. 4: It's 12:40am. Facing North, you walk through the corridor on the 5th wall.
    PUZZLE NO. 5: It's 1:00am. Facing North, you walk through the corridor on the 4th wall.
    PUZZLE NO. 6: It's 1:20am. Facing North, you walk through the corridor on the 4th wall.
    PUZZLE NO. 7: It's 1:40am. Facing North, you walk through the corridor on the 5th wall.
    PUZZLE NO. 8: It's 2:00am. Facing North, you walk through the corridor on the 6th wall.
    PUZZLE NO. 9: It's 2:20am. Facing North, you walk through the corridor on the 6th wall.
    PUZZLE NO. 10: It's 2:40am. Facing North, you walk through the corridor on the 5th wall.
    PUZZLE NO. 11: It's 3:00am. Facing North, you walk through the corridor on the 4th wall.
    PUZZLE NO. 12: It's 3:20am. Facing North, you walk through the corridor on the 4th wall.
    PUZZLE NO. 13: It's 3:40am. Facing North, you walk through the corridor on the 5th wall.
    PUZZLE NO. 14: It's 4:00am. Facing North, you walk through the corridor on the 6th wall.
    PUZZLE NO. 15: It's 4:20am. Facing North, you walk through the corridor on the 6th wall.
    PUZZLE NO. 16: It's 4:40am. Facing North, you walk through the corridor on the 5th wall.
    PUZZLE NO. 17: It's 5:00am. Facing North, you walk through the corridor on the 5th wall.
    PUZZLE NO. 18: It's 5:20am. Facing North, you walk through the corridor on the 3th wall.
    PUZZLE NO. 19: It's 5:40am. Facing North, you walk through the corridor on the 3th wall.
    PUZZLE NO. 20: It's 6:00am. Facing North, you walk through the corridor on the 5th wall.
    PUZZLE NO. 21: It's 6:20am. Facing North, you walk through the corridor on the 5th wall.
    PUZZLE NO. 22: It's 6:40am. Facing North, you walk through the corridor on the 6th wall.
    PUZZLE NO. 23: It's 7:00am. Facing North, you walk through the corridor on the 6th wall.
    PUZZLE NO. 24: It's 7:20am. Facing North, you walk through the corridor on the 5th wall.
    PUZZLE NO. 25: It's 7:40am. Facing North, you walk through the corridor on the 4th wall.


We can then define a function that takes a starting node, and returns all the nodes in the path.


```python
def path_nodes(node, steps):
  """Returns a set of all nodes in a predefined path of steps.

  Args
    node: an (x,y) tuple of the starting node
    steps: list of (x,y) tuples of nodes relative to (0,0)

  """

  path = set(map(lambda step: (step[0] + node[0],
                                step[1] + node[1]),
                  steps))

  return path
```

Let's first verify that the each of the nodes in the path is indeed in the map.


```python
def check_path(node, steps, nodes):
  """Checks whether all nodes in a path are in a set of nodes.

  Args
    node: an (x,y) tuple of the starting node of the path
    steps: a list of (x,y) tuples of nodes relative to (0,0)
    nodes: the set of all nodes

  Returns a boolean.

  """
  candidate = path_nodes(node, steps)
  present = candidate.intersection(nodes)
  return len(candidate) == len(present)
```


```python
check_path((14, 7), steps, nodes)
```




    True



Great. We can now iterate through all members of the set and determine whether this path only exists for one node in the set.


```python
[node for node in nodes if check_path(node, steps, nodes)]
```




    [(14, 7), (8, -13)]



Ah, so the path itself is not unique...but on closer inspection, we can see this path doesn't end on an end node. So we're safe - we just need to make sure for the last puzzle to mention that we hit a dead end!

![](https://drive.google.com/uc?id=1_QGdHpcG5pQzbl3Nlqfgx0vCPE_4myXo)

Finally, we need to determine the shortest path length.

We'll do this with a very simple adjacency-based [breadth-first search](https://en.wikipedia.org/wiki/Breadth-first_search) and iterate through each step until we hit the end node. Essentially, we'll determine all adjacent polygons that exist in nodes, starting from the start polygon, and just keep on expanding.


```python
current_nodes = [(14, 7)]
destination = (-21, -3)
found = False
num_rooms = 0 # Do not include the start room

while found == False and num_rooms < 70:
  candidates = [adj_node
                for node in current_nodes
                for adj_node in get_adjacent_nodes(node)]
  candidate_set = set(candidates).intersection(nodes)
  if destination in candidates:
    found = True
    print(num_rooms)
  else:
    current_nodes = candidate_set
    num_rooms += 1
```

    41


This number excludes both the start and end rooms, which we did because we didn't want the answer to be 42 (the answer to life, the universe and everything) and it seemed more natural to exclude both rooms than include both rooms. We made sure to specify that the answer should exclude both rooms when we wrote the meta puzzle and supplied an example to illustrate that fact.

We verified this manually and found the following path.

![](https://drive.google.com/uc?id=1YNmcbk9-b3XPOkTrNYhtmAxtSSDz1AGz)

While the path is not as complex as we would have liked (and could be solved manually without having to use an algorithm to find the solution), we decided it was good enough for our purposes. Plus, when we tried solving the map path manually before writing the search algorithm, we didn't find the 41-room path on the first try (though admittedly, we are not experienced maze solvers...)

To help discourage guessing, we mandated a delay for subsequent submissions when an incorrect answer was submitted. This was $2^{(x - 1)}$ minutes for the $x$th incorrect solution. Since the meta puzzle would be released a full 7 months before the end of the puzzlehunt, it'd be great if we could ensure that constant guessing from the start of the puzzle hunt would not result in a correct answer in any reasonable time. This is particularly a worry since our solution is a relatively small number. Let's say, for instance, a participant guesses the minimum answer would be 20 rooms (for whatever reason, or upon discovery of the map).


```python
sum([2**(x-1) for x in range(41-20)]) / 60 / 24
```




    728.1774305555556



So it would take 728 days if they guessed from 20 upwards to 41. It's not a guarantee (a high-risk high-reward guesser might, for example, start from 30 or 40 if they expect it to be difficult and have determined the map), but it's good enough for us.


Now that we had the puzzle laid out when the map was determined, we just had to encode the map. We decided to use a very simple HTML file as the container, and hide the map as a base64-encoded SVG in the HTML with an instruction to find the map image. We would then encode the HTML file using a Vigenere cipher with a key introduced in another puzzle.

We base64 encoded the SVG and placed it in the HTML file, deleting the string ";base64" from the data URI of the image source.

We then used the Vigenere cipher with a key chosen from the text of the original Spanish of *The Library of Babel* with the diacritics removed. We ignored punctuation and spaces for both the key and the text; in the text, punctuation and spaces were simply skipped and return as is. Capitalisation was preserved to ensure the fidelity of the base64 SVG.


```python
import string
import re

def translate(text, alphabet, key, encode=True):
  """Translate text with a Vigenere cipher."""

  # Preprocess key to ensure all punctuation is removed and in consistent case
  key = re.sub(r"[^\w]", "", key).lower()
  key_size = len(key)

  alphabet_size = len(alphabet)

  i = 0

  new_text = []

  for text_char in text:
    cipher_char = text_char.lower()

    if cipher_char in alphabet:

      shift_char = key[i % key_size]

      cipher_index = alphabet.find(cipher_char)
      shift_index = alphabet.find(shift_char)

      if encode:
        new_char = alphabet[(cipher_index + shift_index) % alphabet_size]
      else: # decode
        new_char = alphabet[(cipher_index - shift_index) % alphabet_size]

      # If uppercase, make the new character uppercase
      if text_char.upper() == text_char:
        new_char = new_char.upper()

      i += 1

      new_text.append(new_char)

    # If not in alphabet, return directly and don't increase iterator posn.
    else:
      new_text.append(text_char)

  return "".join(new_text)

```


```python
alphabet = string.ascii_lowercase

## Key is a quote from Spanish text of Library of Babel with diacritics removed.
key = """En algun anaquel de algun hexagono (razonaron los hombres) debe
         existir un libro que sea la cifra y el compendio perfecto de todos los
         demas: algun bibliotecario lo ha recorrido y es analogo a un dios."""


def encode(text):
  """ Encode text using an alphabet and key for a Vigenere cipher."""

  # Using global alphabet and key
  return translate(text, alphabet, key, encode=True)


def decode(text):
  """ Decode text using an alphabet and key for a Vignere cipher."""

  # Using global alphabet and key
  return translate(text, alphabet, key, encode=False)
```

We ran this in our own Python environment using the below script:

```python
with open("container.html") as infile:
  new_text = encode(infile.read())
  with open("input.txt", "w+") as outfile:
    outfile.write(new_text)

with open("input.txt") as infile:
  new_text = decode(infile.read())
  with open("output.txt", "w+") as outfile:
    outfile.write(new_text)
```


```python
import requests

input_url = "https://drive.google.com/uc?id=1SjJCONvkEu8ksDVHFxiqxwNYWa5ewdAu"
text = requests.get(input_url).text
```


```python
result = decode(text)
```


```python
from google.colab import files


filename = 'result.html'

with open(filename, 'w') as f:
  f.write(result)

files.download(filename)
```

Great! We now had the `input.txt`. And that was our meta puzzle done!

Th necessary information to solve this puzzle includes:

- Determining how to decipher the input - which requires knowledge of the type of cipher and the key (and perhaps some implementation details such as ignoring punctuation, keeping capitalisation)
- Determining how to display the svg image - base64
- Determining how to find the start room (back tracking, identity of the final room)
- Determing how to find the exit (amino acids, sickle cell)
- Determining how to find the shortest distance

> July 13th 2019: We planned the hints for each puzzle, but ended up changing those hints depending on what progress people had with the map. One participant managed to decode the map only a day or so after its release without the key or any of the hints (!) - a combination of our fault for not making the cipher key longer (perhaps we should have used the entire book...but we weren't sure about its copyright status in Australia), and a testament to the sheer skill of the participant who managed to do so. We received the first attempt with the correct exit during June and the attempts at the path length were so close that we double-checked our own solution.

#### Elm Code for Map Creation

Dependencies:

- `ianmackenzie/elm-geometry`
- `ianmackenzie/elm-geometry-svg`
- `elm/svg`



```elm
module Main exposing (main)

import Browser
import Geometry.Svg as Svg
import Html exposing (Html, button, div, text)
import Html.Events exposing (onClick)
import List
import Point2d exposing (Point2d)
import Polygon2d exposing (Polygon2d)
import Svg exposing (Svg, svg)
import Svg.Attributes as Attributes
import Tuple
import Vector2d


type Model
    = NoModel


initialModel : Model
initialModel =
    NoModel


type Msg
    = NoOp


update : Msg -&gt; Model -&gt; Model
update msg model =
    case msg of
        NoOp -&gt;
            model


view : Model -&gt; Html Msg
view model =
    div [] [ svg [ Attributes.viewBox "-75 -75 150 150 " ] hexagons ]


baseVertices : List Point2d
baseVertices =
    List.map Point2d.fromCoordinates [ ( -1, 1.73 ), ( 1, 1.73 ), ( 2, 0 ), ( 1, -1.73 ), ( -1, -1.73 ), ( -2, 0 ) ]


makeVertices : ( Float, Float ) -&gt; List Point2d
makeVertices origin =
    List.map (\p -&gt; Point2d.translateBy (Vector2d.fromComponents origin) p) baseVertices


makeHexagon : ( Float, Float ) -&gt; Polygon2d
makeHexagon origin =
    Polygon2d.singleLoop &lt;| makeVertices origin


makeHexagonSvg : ( Float, Float ) -&gt; Svg msg
makeHexagonSvg origin =
    Svg.polygon2d [ Attributes.stroke "white", Attributes.strokeWidth "0.5", Attributes.fill "grey" ] &lt;| makeHexagon origin


hexagons =
    List.map hexagonCubeCoord &lt;| (List.concat &lt;| List.map rings [ 1, 3, 5, 7, 11, 15, 17 ]) ++ tendrils ++ spokes


spokes : List ( Float, Float )
spokes =
    let
        dists =
            List.map toFloat &lt;| [ 1, 2, 4, 6, 7, 8, 10, 11, 12, 13, 15, 16, 18 ]
module Main exposing (main)

import Browser
import Geometry.Svg as Svg
import Html exposing (Html, button, div, text)
import Html.Events exposing (onClick)
import List
import Point2d exposing (Point2d)
import Polygon2d exposing (Polygon2d)
import Svg exposing (Svg, svg)
import Svg.Attributes as Attributes
import Tuple
import Vector2d


type Model
    = NoModel


initialModel : Model
initialModel =
    NoModel


type Msg
    = NoOp


update : Msg -&gt; Model -&gt; Model
update msg model =
    case msg of
        NoOp -&gt;
            model


view : Model -&gt; Html Msg
view model =
    div [] [ svg [ Attributes.viewBox "-75 -75 150 150 " ] hexagons ]


baseVertices : List Point2d
baseVertices =
    List.map Point2d.fromCoordinates [ ( -1, 1.73 ), ( 1, 1.73 ), ( 2, 0 ), ( 1, -1.73 ), ( -1, -1.73 ), ( -2, 0 ) ]


makeVertices : ( Float, Float ) -&gt; List Point2d
makeVertices origin =
    List.map (\p -&gt; Point2d.translateBy (Vector2d.fromComponents origin) p) baseVertices


makeHexagon : ( Float, Float ) -&gt; Polygon2d
makeHexagon origin =
    Polygon2d.singleLoop &lt;| makeVertices origin


makeHexagonSvg : ( Float, Float ) -&gt; Svg msg
makeHexagonSvg origin =
    Svg.polygon2d [ Attributes.stroke "white", Attributes.strokeWidth "0.5", Attributes.fill "grey" ] &lt;| makeHexagon origin


hexagons =
    let
        nodes = (List.concat &lt;| List.map rings [ 1, 3, 5, 7, 11, 15, 17 ]) ++ tendrils ++ spokes
        _ = Debug.log "nodes" nodes
    in
    List.map hexagonCubeCoord nodes


spokes : List ( Float, Float )
spokes =
    let
        dists =
            List.map toFloat &lt;| [ 1, 2, 4, 6, 7, 8, 10, 11, 12, 13, 15, 16, 18 ]

        negatives =
            List.map (\x -&gt; 0 - x) dists
    in
    List.concat &lt;|
        [ List.map2 Tuple.pair dists dists
        , List.map2 Tuple.pair negatives negatives
        ]


takeHalf : List a -&gt; List a
takeHalf list =
    case list of
        x :: y :: xs -&gt;
            x :: takeHalf xs

        _ -&gt;
            list


takeThreeQuarts : List a -&gt; List a
takeThreeQuarts list =
    case list of
        x :: y :: z :: a :: xs -&gt;
            x :: y :: z :: takeThreeQuarts xs

        _ -&gt;
            list


tendrils : List ( Float, Float )
tendrils =
    let
        xRepeat =
            [ 1, 1, 0, -1, -1, 0 ]

        yRepeat =
            [ 2, 3, 3, 3, 4, 5 ]

        tendrilMake unitNum =
            List.map2 Tuple.pair xRepeat &lt;| List.map (\x -&gt; x + (4 * unitNum)) yRepeat

        tendrilBase =
            ( 0, 1 ) :: tendrilMake 0 ++ tendrilMake 1 ++ tendrilMake 2 ++ tendrilMake 3

        tendrilBase2 =
            List.map (\( x, y ) -&gt; ( y, x )) tendrilBase

        translate ( x0, y0 ) =
            List.map (\( x, y ) -&gt; ( x + x0, y + y0 ))

        reflect =
            List.map (\( x, y ) -&gt; ( -x, -y ))
    in
    List.concat &lt;|
        [ translate ( 2, 2 ) tendrilBase
        , translate ( -10, -3 ) &lt;| reflect tendrilBase
        , translate ( 2, -2 ) &lt;| tendrilBase2
        , translate ( -2, 4 ) &lt;| reflect tendrilBase2
        , translate ( 3, 10 ) tendrilBase2
        , translate ( -3, -10 ) &lt;| reflect tendrilBase2
        , translate ( 8, 4 ) &lt;| tendrilBase
        , translate ( -4, -4 ) &lt;| reflect tendrilBase
        , translate ( 4, 2 ) &lt;| tendrilBase2
        , translate ( -4, -3 ) &lt;| reflect tendrilBase2
        , translate ( 7, 2 ) &lt;| reflect tendrilBase
        , translate ( -4, 0 ) &lt;| tendrilBase
        , translate ( 13, 4 ) &lt;| tendrilBase
        , translate ( 2, 0 ) &lt;| reflect tendrilBase
        , translate ( 6, 7 ) &lt;| reflect tendrilBase2
        , translate ( 6, 6 ) &lt;| tendrilBase2
        ]


rings : Int -&gt; List ( Float, Float )
rings circumference =
    let
        rangeCoords =
            List.map toFloat &lt;| List.range 0 circumference

        circumferenceFloat =
            toFloat circumference

        numCoords =
            List.length rangeCoords

        baseList =
            takeThreeQuarts &lt;| List.map2 Tuple.pair rangeCoords &lt;| List.repeat numCoords circumferenceFloat

        flatSide =
            takeThreeQuarts &lt;| List.map2 Tuple.pair rangeCoords &lt;| List.reverse &lt;| List.map (\x -&gt; 0 - x) rangeCoords
    in
    List.concat &lt;|
        [ baseList
        , List.map (\( x, y ) -&gt; ( -x, -y )) &lt;| baseList
        , List.map (\( x, y ) -&gt; ( y, x )) baseList
        , List.map (\( x, y ) -&gt; ( -y, -x )) &lt;| baseList
        , flatSide
        , List.map (\( x, y ) -&gt; ( y, x )) &lt;| flatSide
        ]


hexagonCubeCoord : ( Float, Float ) -&gt; Svg msg
hexagonCubeCoord ( cubeX, cubeY ) =
    let
        x =
            (3 * cubeX) + (-3 * cubeY)

        y =
            (1.73 * cubeX) + (1.73 * cubeY)
    in
    makeHexagonSvg ( x, y )


main : Program () Model Msg
main =
    Browser.sandbox
        { init = initialModel
        , view = view
        , update = update
        }

```

