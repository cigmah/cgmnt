

# Metabolic Mayhem

> This puzzle was released on 2019-02-23, and was the Abstract puzzle for the theme *Text Books (Sample)*. 

> *This is a sample puzzle in the Abstract set. This puzzle isn't worth any points
> or prizes itself, but it contributes to the meta puzzle and helps introduce the
> puzzle hunt format. The solution text for this sample puzzle (as well as the other sample puzzles) is available from the following link: [![Azure Notebooks](https://notebooks.azure.com/launch.svg)](https://notebooks.azure.com/cigmah-cgmnt/projects/cgmnt) This solution text is normally only revealed after a puzzle is completed.* 

<br>

It's 12:00am. You're currently in the room containing the *Map of the Medical
Library of Babel*. Facing North, you enter the door on the 6th wall.

![Imgur](https://i.imgur.com/P0kBruj.gif)

You walk up to the book on the table and read the title - *Metabolic Mayhem*.
You open it.

It contains only a single sentence.

> Open the digital version of the book on the computer.

You open the digital version of the book on the computer and it starts playing
an animation. In the middle of the animation is a big button saying `State:
Normal`. Pressing the button in the middle changes it to `State: Pathological`.

You flip the state a few times, testing your Spot the Difference skills. Your
pathology teaching in 3rd year has trained you well for this moment.

You realise the animation is depicting a metabolic pathway in the body in two
states - one normal state, and one which reflects a certain gene mutation known
to cause disease. And thanks to your preclinical education, you think you know
what the gene mutation is!

# Input

[View the animation](https://cigmah.github.io/cgmnt-metabolic-mayhem/). 

GIFs are provided below.

## Normal

![Normal](https://lh3.googleusercontent.com/owvwMfrtLBkUTjoLla8njLxA0lFtfRuMYbqf6oZJ9M-hKDgEacWZCyzOV9YMY7AuQBcwTct3-a6Nbt1m263s5nPjElSvUdzXVR-nTblFmHcHcMYNIO1AW9MuQgKF1kZsjLkxAt_hLQ=w2400)

## Pathological

![Pathological](https://lh3.googleusercontent.com/069TGeuI8enesHX9CrO4RPCo6lOKmOY4tcPsWamV1Zx8acdnlKs7O8mGjbMRskzA6RPf1Sv9fg4AfZQqT225m0D_FWzaW8KcJ7tBCuU3PgrQbjmnACYP7MU4iXjL2SQdPhvxkL6uLQ=w800)

# Statement

State the HUGO Gene Symbol of the gene mutation responsible for the pathology depicted. (e.g. `CFTR`)


# References

Written by the CIGMAH Puzzle Hunt team.

# Answer

The correct solution was `LDLR`.

# Explanation

# Map Hint

Eureka! You give yourself a pat on the back for retaining your knowledge about lipoproteins way back from your first year of medicine. 

Smirking, you open the file `map_hint.txt`. It contains only one line:

```txt
The map is enciphered.
```

Well, duh. So much for a hint! You can only hope that the other hints are more helpful...

# Writer's Notes

## Context

Our medical curriculum started off with metabolism, and we had to learn many of the metabolic pathways throughout the body. We wanted to experiment with using code to generate graphics (partly to show that coding could be a fun hobby!) and thought that illustrating a metabolic pathway with an abstract generated animation would be a neat fit.

We took this out of the regular puzzles and made it into a sample because we thought interpreting it would be too ambiguous for a fair puzzle. We wanted all of our puzzles to have definitive answers and to be deducible using critical thinking (and a bit of creativity). While we tried our best to make the animation represent a certain pathway unambiguously, making it abstract leaves it open to many (possibly equally-valid) interpretations. Rest assured that the remainder of our abstract puzzles have a much more definitive right answer!

## Planning

We chose **lipoprotein metabolism** as our pathway as it was something we thought was relevant to both preclinical and clinical students. To make the animation specific to this pathway (and not the million other things that circulate through the blood), we wanted to implement:

1. The exogenous pathway (chylomicrons), depicting the transfer of triglycerides and the gradual reduction in size of chylomicrons as they circulate (to be picked up by the liver)
2. The endogenous pathway (VLDL, IDL, LDL), also depicting the transfer of triglycerides and the gradual reduction in size (from VLDL, to IDL, to LDL), and being picked up by the liver - this time, much more visibly by LDL receptors.
3. A pathological variant, where the LDL particles no longer bind to the LDL receptors and instead accumulate in the blood to portray the effects of an **LDLR mutation** (often associated with familial hypercholesterolaemia)

We wanted to use [Elm](https://elm-lang.org/) to create the animation, like our frontend, as we really liked the language and it was easy to prototype right in the browser. Unfortunately for us, Elm's packages for animation are much less mature than JavaScript's (and many other languages for that matter), so we ended up doing most of the calculations to update each frame ourselves. Thankfully, our animation was simple enough to make this feasible.

The [source code is on GitHub in our public CIGMAH organisation](https://github.com/cigmah/cgmnt-metabolic-mayhem/tree/canvas), though it's unfortunately very messy since we prototyped it quickly. We hope at some stage to clean it up much more nicely, but we'll describe an overview of how it works below in the Generation section (and hopefully introduce you to The Elm Architecture at the same time!)

## Explanation

Here's a labelled diagram of what we intended each item to represent:

![Labelled](https://lh3.googleusercontent.com/AsY65yw_tUDgWhnuEDMtaA5XUezsTwf0DA0HlXlwtiTZlafM012uTSV-rRTrNAt092ILTwlmKnosF92jBXfCdJj7Q7q5Nhwerv_CCfDpjf1CoGI9em9lQawdefGuvu-rRZKhlXK-SA=w800)

When the state is flipped to `Pathological`, the LDL receptors no longer bind to LDL particles and LDL begins to accumulate in the blood (in a simplistic way in this animation). This can occur due to an **LDLR** gene mutation as seen in **familial hypercholesterolaemia**.

While we realise this model is heavily oversimplified, we hope it illustrates some very basic concepts (e.g. the "circulation" of lipoproteins, and a superficial difference between the endogenous and exogenous lipoprotein pathways.)

## Generation

That's it for explaining the content of the animation. If you'd like to know how this animation was generated, read on!

> Note - this isn't actually a good way to do animation in the browser. It's just a bit of fun!

Here's a diagram showing a quick rundown of how the animation works.

![Overview](https://lh3.googleusercontent.com/Q--HLe-i5XZf5weK2gEXYglZJjQzNqatBPMi269q2wxYu7juHkUZ1_6_8oMBBl3NgFufuBrDmqS_KwC7sIg0RP5_AT-pU9p2at2WrEDPXP3BNbQ7bHgJGp8oyJXC08KMMBi58jSGKg=w600)

We'll go through step by step.

### Initial State

Our animation starts by setting an *initial* `state`. The `state` refers the whole state of everything that goes onto the screen. By defining an initial state, we can calculate the next state using the values of the previous state, and then just keep repeating that calculation over and over again to run our animation.

For example, here are the list of variables that are defined in the initial state of our animation:

```
{ frame = 0
, runState = Stopped
, pathologyState = Normal
, cMicronList = []
, liver = liverInit
, lProteinList = []
, lProteinTakerList = Nothing
, inertTakerList = inertTakerListInit
, lipase = lipaseInit
, random = 0
}
```

Here, the `liverInit`, `inertTakerListInit` and `lipaseInit` variables refer to records which hold more "initial value" data:

```

liverInit =
    { x = -200 
    , y = 0    
    }
    
inertTakerListInit = 
    [
        { startFrame = 0
        , angleRadians = someRandomNumber
        , proportions = anotherRandomNumber
        }
    etc.
    ]

lipaseInit = 
    [
        { positionRadians = aNumber },
    etc. 
    ]

```

The actual numbers here aren't too important at the moment.


Out `state` holds:

1. `frame` - the number of frames that have passed since the start. We use this in the animation to track when things appear on screen, and how much time has passed since that thing has appeared.
2. `runState` - whether the animation is currently playing or not. We start the animation in its Stopped state. When the animation is in the Playing state, we *subscribe* the animation to instructions from the browser to draw more states. The instructions from the browser occur many times per second (e.g. 60 times per second).
3. `pathologyState` - whether the animation is currently showing the normal state, or the pathology state. This determines how we update the next frame.
4. `cMicronList` - a list of chylomicrons that are on the screen.
5. `liver` - a record that describes the position of the liver on the screen.
6. `lProteinList` - a list of lipoproteins that are on the screen.
7. `lProteinTakerList` - maybe a list of lipoprotein "takers" (i.e. the receptors which take the lipoproteins into the liver) currently on screen.
8. `inertTakerList` a list of "inert takers" (takers which come out of the liver but don't actually touch the chylomicrons or lipoproteins)
9. `lipase` - a list of lipoprotein lipases that are on the screen. 
10. `random` - a variable to store a random number that we can access during the animation.

### Initial Drawing

After setting an initial state, the animation sends a message to the browser to draw the state on to the screen. For the moment, since our initial state is quite bare, we don't have much to draw - we really only have to draw the liver and the inert takers.

### Updating the State

Once the state is drawn, we are "done" for that frame.

However, if the `runState` is `Playing`, then the animation listens to instructions from the browser to draw another state. 

When that instruction is received, we have to calculate what values the next state should have. We have to write a function that takes the old state, and returns an entirely new state.

![State Function](https://lh3.googleusercontent.com/82yv280WtnPQ1tC9NV9N6zFL1V7KHzfeYWW485L-3UtBRrW4dUQ0BKCTJhmsCvPOIzBJ-yM41H84ziBRei2QhsfqoepIAHdJ0Bj219pP8UsNYBGVJ15PtUsSbce6OrBCV3xJ1hNd_Q=w500)

Here's an overview of how the new variables are calculated:

#### Frame

Frame is easy - we just add one to `frame` of the old state!

#### runState

We don't change this (we have a button in the centre of the screen (the Start/Stop) button which changes the value of this instead). So this is just equal to the `runState` of the previous state.

#### pathologyState

Like `runState`, we don't change this value, and this is just equal to the `pathologyState` of the previousState.

#### cMicronList

This is where the fun starts!

---

We wanted to add a new chylomicron every 20 frames or so, so we have a simple `if` statement that checks whether the new frame number modulus 20 is equal to 0, and to add a chylomicron if this is `True`.

Every chylomicron starts with the following data:

```
    { x = 400
    , y = 200
    , pulse = Nothing
    , triglycerideSize = aSizeNumber
    , startFrame = newFrameNumber
    }
```

(Again, the numbers themselves aren't terribly important here).

So every chylomicron starts in the same position. The `pulse` here refers to some data that determines the "triglyceride pulse" that comes out of the chylomicron particle, and contains data with this sort of shape:

```
    { startFrame : Int
    , currentRadius : Float
    }
```

Initially, the pulse is set to `Nothing` (which you might think of as similar to `null` or `None` values if you've worked with languages like JavaScript or Python before).

---

Whether or not we add a new chylomicron, we also have to update the values of all the other chylomicrons in `cMicronList` too.

The path of the chylomicrons is fairly simple - it runs in a straight line across the screen until it reaches the circulation circle, after which is joins the circle and cycles through it.

We implemented this using some basic trigonometry. First, we checked whether the current position (`x`, `y`) of the chylomicron satisfies the equation of the circulation circle at the origin. Since we're dealing with discrete values and the `x` values don't increase atomically, we had to implement some error buffer around this value, but the principle is the same.

If the chylomicron is *not* in the circulation circle (i.e. at the start), then we simply add a value to the `x` position to move it horizontally.

However, if the chylomicron *is* in the circulation circle, then we have to do a number of things:

1. We find the next `x` and `y` value by finding the current angle of the chylomicron relative to a horizontal line at the origin of the circle, adding a value to this angle, then recomputing the `x` and `y` value using `sin` and `cos` functions.
2. If the age of the chylomicron (in frames - we can find it by taking away the `startFrame` from the new frame number) modulus 20 is 0 (so one pulse per 20 frames) and there is no pulse, we initialise a pulse wave.
3. If there is already a pulse, then we increase its `currentRadius` by a certain value such that the `currentRadius` exceeds a known value (e.g. the width of the circulation track) after 19 frames. If it exceeds this value already, we remove the pulse and set it to `Nothing`.
4. We reduce the `triglycerideSize` by a certain value, so the chylomicron only reduces in size once it is in the circulation. If the `triglycerideSize` is below a certain threshold (e.g. 0), then we remove the chylomicron from the list entirely so we don't have to worry about calculating things for it anymore.

After all this, we have the new state of our chylomicrons!

#### Liver

We don't have to change anything here. The liver stays in the same position - the animation of the liver is purely done in the rendering step using the `random` value of the state.

#### lProteinList

The manipulations for `lProteinList` are very similar to those we have to do for `cMicronList` (with the exception that lipoproteins always stay within the circle, so we don't have to check it).

The main difference here, however, is that the update of `lProteinList` depends on the value of `pathologyState` in the state. If the `pathologyState` is `Normal`, we can do everything as above - however, if it is `Pathological`, then we skip the step where the `triglycerideSize` decreases after a certain threshold, skip the pulsing step, and skip the removal step so the lipoproteins persist in the animation - in effect, once it reaches the size of an LDL particle, we only move it around the circle and nothing else.

(Though we should note, we do remove a lipoprotein after a certain period of time just to avoid making the list longer and longer indefinitely - it's just that this period of time is significantly longer than that of the `Normal` state).


#### lProteinTakerList

The takers have the following shape:

```
    { startFrame : Int
    , takeX : Float
    , takeY : Float
    , proportion : Float
    }
```

If we removed a lipoprotein from `lProteinList`, then we make a new taker for it and set `takeX` and `takeY` to the position of the lipoprotein when we removed it and set the `proportion` to 1 and `startFrame` to 0. 

If this list had other elements in it, then we reduce each element's `proportion` by a certain value depending on how old the taker is. If the taker is older than say 20 frames (i.e. the taker stays on screen for 20 frames only), then we remove it from the list. 

The idea is that we can render the taker as a line from the liver origin to (`takeX`, `takeY`) and by gradually reducing its `proportion`, make it appear the line is "taking" the lipoprotein at (`takeX`, `takeY`) into the liver!

#### inertTakerList

We do a similar thing for `inertTakerList` as `lProteinTakerList`, though we don't have to record `takeX`/`takeY` since the takers are inert (and have a fixed radius). We simply reduce the proportion by a set value. If the age of the taker is greater than a certain threshold, we remove it.

If the current frame modulus a certain number (equal to the longevity of a taker so we can keep the number of takers constant) is 0, then we add a new taker at a random angle (using the `random` value of the state) and set its `proportion` to 1.

#### Lipase

These lipoprotein lipases are just moving around the screen in a circle.

All we have to do is add a constant to their value `positionRadians`. 

#### Random

This stores a random value that we can use in our animation. Random values in Elm are a little harder to access than say JavaScript of Python because of the nature of the Elm language, which is why we store this every frame than say just calling a random value on demand. 

To update this value, we "step" the random value (i.e. get the next "random" value from the previous random value and seed).

> Just a note - we've talked about "changing" and "removing" things from the list, but it's important to note that Elm uses pure functions only (i.e. we *don't* change any of the original values - we can only take an input and generate an output and do *nothing else*). What we really mean by "changing" and "removing" things is that these changes and removals are *reflected* in the output state - i.e. when we make the output, we make it so that it incorporates all these changes and removals, but we don't actually ever change the input.

That's our new state calculated!

### Draw the State

We then draw the new state on the screen. This is pretty simple - we can translate most of the items in the state into shapes and be done with it, since we have the `x` and `y` positions of most of the "objects" of the animation (or we can calculate it, e.g. from the `positionRadians` of the lipase).

We did try to add a bit of flavour - we generated multiple circles of two different rotations for the lipoproteins and varied the widths of the circles depending on the age of the lipoprotein - so we could make the lipoprotein appear like a wireframe 3D version (at least, sort of). We did the same for the liver (though the width was random instead of evenly varied).

We essentially just map the state onto shapes that can be rendered. We originally rendered the animation frame using SVG, but found it was too slow, so we switched to HTML5 Canvas instead which was (slightly) faster.

### Repeat 

And now we simply have to repeat the steps above - wait for the browser instruction to draw a new state, calculate the new state, then draw it!

