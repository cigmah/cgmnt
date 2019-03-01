module Views.Format exposing (view)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Html.Lazy exposing (..)
import Markdown
import RemoteData exposing (RemoteData(..), WebData)
import Types exposing (..)
import Views.Shared exposing (..)


view : Meta -> ( String, Html Msg )
view meta =
    let
        body =
            div [] [ viewBody ]
    in
    ( "Format - CIGMAH", body )


viewBody =
    pageBase
        { iconSpan = span [ class "fas fa-info-circle" ] []
        , isCentered = False
        , colour = "pink"
        , titleSpan = text "Format"
        , bodyContent = div [ class "markdown" ] <| Markdown.toHtml Nothing content
        , outsideMain = div [] []
        }



-- CONTENT


content =
    """


The puzzle hunt will run from March 9th to September 30th and consists of 25 puzzles - 1 meta puzzle and 24 regular puzzles.

![Puzzle Hunt Format](https://lh3.googleusercontent.com/yb8rWMmthZQwEy1IpsPCinnKq-K0-XsV4vsDWfhvc_AnyTyxkeA4DAjs4v94MHB8FwROGnmloze0uS9w_8ipn7aGA_BSajTDsK7iBK4HNmBKxaQX-HBmESLZbq_rFRkE9n1gjT1s6w=w1400)

# The Puzzles

The meta puzzle and the first three regular puzzles are released approximately two weeks before the start of the puzzle hunt.

  - The meta puzzle "frames" the stroyline of the puzzle hunt and relies on information from all of the other puzzles.
  - The first three regular puzzles are there to help participants understand the flow of the puzzle hunt - these do not contribute to scores or prizes and the solution is immediately available.

All regular puzzles are classified as Abstract, Beginner or Challenge.

- Abstract puzzles do not require any explicit coding to solve, and are the most "puzzle-like." Most often, they are in the form of graphics, audio, videos, mini games or text which require some element of medical or biomedical knowledge to complete. Often, these puzzles are created with code and we reveal the code used to make them on completion of the puzzle.
- Beginner puzzles are intended to help beginner coders learn coding skills. Each beginner puzzle is written with objectives and a medical context in mind. We provide Jupyter notebooks which walk through the puzzle in a fill-in-the-blank style to help beginners get started.
- Challenge puzzles, like beginner puzzles, are written with an objective and medical context in mind; however, these generally cover more advanced concepts and we do not provide a walkthrough for these puzzles.

# Submissions and Points

All puzzles are accessible without logging in. If you would like to participate, then you may register and start logging in immediately. Registration is free and requires only a username and email. We only use your email to send you a login token and liaise with you if you win a prize.

A submission box will be available for puzzles once logged in. You can simply enter your answer and submit.


## Correct Submissions

If the answer is correct, you will be awarded points based on the puzzle and how many participants have solved it before you. Puzzles are worth a base amount of 100 points; the first solver is awarded 100 points, the second solver is awarded 99 points and so on. The 100th solver and beyond will be awarded zero points (but the puzzle will still be marked as complete).

The Challenge puzzles are worth double points (i.e. the first solver is awarded 200 points, the second 198 points), and the meta puzzle is worth quadruple points.

## Incorrect Submissions

If a submission is incorrect, a message will show above the submission box indicating as such.

There is no point penalty for an incorrect submission, but you will have to wait a short period of time before submitting again. This starts at 1 minute and increases exponentially for every incorrect submission. There is no penalty for trying to submit during the cooloff period - your answers will simply not be read and you will be told when you can next submit.

# Prizes

We award a Puzzle Prize for the first solver of each puzzle (except the first three regular puzzles), and four Total Prizes:

1. Grand prize, for the participant with the most total points
2. Challenge prize for the participant with the most total points of puzzles in the Challenge set
3. Beginner prize for the participant with the most total points of puzzles in the Beginner set
4. Abstract prize for the participant with the most total points of puzzles in the Abstract set.

The four total prizes are awarded in that order, and must go to four unique participants.

For more information and a list of prize winners, please see the Prizes tab.

Prizes will be announced at the beginning of October.

"""
