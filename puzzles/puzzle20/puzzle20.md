

# Code Broadcast

> This puzzle was released on 2019-08-10, and was the Abstract puzzle for the theme *"Code"*. 

You're starting to accept that you may not make it out. 

It's 6:00am. Facing North, you walk through the corridor on the 5th wall.

![Metarom](https://i.imgur.com/yDxLdwW.gif)

This room doesn't have a computer. There's only a radio. You hear voices conversing over the radio, as if you're unintentionally eavesdropping. You can't make much sense over what they're saying though. Maybe they're using some sort of code.

# Input

[Read a live text transcript of the broadcast at https://code-broadcast-over-wire.netlify.com](https://code-broadcast-over-wire.netlify.com/). The broadcast is approximately 2 minutes long. It is set to loop for your convenience.

# Statement

Submit the underlying six-letter single-word message being transmitted in the broadcast.


# References

Written by the CIGMAH Puzzle Hunt Team.

# Answer

The correct solution was `MALADY`.

# Explanation

# Map Hint

You wonder what these two people are talking about, or why they need to converse in code. 

But there's no computer in this room. No way to get a `map_hint.txt`. You look around - you did your job, right? - so where's your map hint? That's not fair. 

After searching the room, you concede that maybe there is no map hint and the radio broadcast is not meant for you. It keeps looping. You're getting a bit creeped out, so you shut it off. And you walk towards the door, leaving the radio behind you.

# Writer's Notes

This puzzle was intentionally vague. The broadcast transmits a message using a code made of WHO ICD-11 codes. 

In order, the codes described and the levels on which they are found are:

- MC12 (level 1)
- 4A41 (level 2)
- LA14.07 (level 1)
- 1A22 (level 2)
- 1D01 (level 2)
- 4A4Y (level 4)

Taking the level-th character of each of the ICD-11 codes spells out the word MALADY. 

As an aside, the transcript is not actually being broadcast - it indexes into the message based on the client's system time modulus the length of the transcript. A liberal use of extra spaces (which are condensed into a single space when rendered to the HTML) makes it possible to simulate speaking pauses in the message.

