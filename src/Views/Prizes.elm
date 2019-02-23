module Views.Prizes exposing (view)

import Browser
import Handlers
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Html.Lazy exposing (..)
import Markdown
import RemoteData exposing (RemoteData(..), WebData)
import Types exposing (..)
import Views.Shared exposing (..)


view : Meta -> WebData PrizeData -> ( String, Html Msg )
view meta webData =
    let
        title =
            "Prizes - CIGMAH"

        body =
            case webData of
                Loading ->
                    prizesLoading

                Success data ->
                    prizesBody data

                _ ->
                    errorPage ""
    in
    ( title, body )


prizesBody data =
    pageBase
        { iconSpan = span [ class "fas fa-award" ] []
        , isCentered = False
        , colour = "green"
        , titleSpan = text "Prizes"
        , bodyContent = prizesContent data
        , outsideMain = div [] []
        }


prizesLoading =
    pageBase
        { iconSpan = span [ class "text-grey bg-grey" ] [ text "__" ]
        , isCentered = False
        , colour = "grey"
        , titleSpan = span [] []
        , bodyContent = div [] [ span [ class "text-grey-lighter bg-grey-lighter rounded-lg" ] [ text <| loremIpsum ], br [] [], span [ class "text-grey-lighter bg-grey-lighter rounded-lg" ] [ text <| loremIpsum ], br [] [], div [ class "mt-4 rounded h-32 w-full bg-grey-light" ] [] ]
        , outsideMain = div [] []
        }


markdownContent =
    """

We offer two broad types of prizes - Puzzle Prizes and Total Prizes. If you are awarded a prize, we will liaise with you via email, so please ensure your email is valid when you register.

<br>

Puzzle Prizes are awarded to the first solver of each puzzle (except for the first three puzzles i.e. the three sample puzzles).

As Puzzle Prizes, we offer a choice of either:

<br>

  - A $10 Gift Card to any store of your choice, subject to approval. We are open to any stores that will provide $10 gift cards, for example Coles Group and Myer Gift Cards or JB Hi-Fi. Unfortunately, we cannot offer cash prizes for the Puzzle Prizes.
  - A $15 donation on the prizewinner's behalf to a charity of your choice. If you permit us to do so, we will also record the charity that you chose along with your username on this page. We would like to encourage participants to share causes they are passionate about and hope efforts in the puzzle hunt can go towards places in need.

A single participant cannot win more than one Puzzle Prize a month.

<br>

Total Prizes are awarded at the end of the puzzle hunt to the participants with the greatest total amount of points in one of four categories:

<br>

1. Grand prize, for the participant with the most total points
2. Challenge prize for the participant with the most total points of puzzles in the Challenge set
3. Beginner prize for the participant with the most total points of puzzles in the Beginner set
4. Abstract prize for the participant with the most total points of puzzles in the Abstract set.

We award the prizes in that order, and each prize must go to a different participant.

The Total Prizes are currently unannounced.

You can see the current log of prizewinners below.

<br>

"""


prizesContent : PrizeData -> Html Msg
prizesContent data =
    div []
        [ div [ class "markdown" ] <|
            Markdown.toHtml Nothing markdownContent
        , prizesTable data
        ]


prizesTable : PrizeData -> Html Msg
prizesTable data =
    tableMaker [ "Awarded Month", "User", "Prize", "Notes" ] data


tableRowExtended isHeader strList =
    let
        classes =
            if isHeader then
                "w-full bg-grey-light text-sm text-grey-darker"

            else
                "w-full bg-grey-lightest text-center hover:bg-grey-lighter text-grey-darkest"
    in
    tr [ class classes ] <| List.map2 (\x y -> tableCell x y isHeader) (List.repeat 5 "w-auto") strList


tableMaker : List String -> PrizeData -> Html Msg
tableMaker headerList unitList =
    let
        prizeToString prize =
            case prize of
                AbstractPrize ->
                    "Abstract Prize"

                BeginnerPrize ->
                    "Beginner Prize"

                ChallengePrize ->
                    "Challenge Prize"

                PuzzlePrize ->
                    "Puzzle Prize"

                GrandPrize ->
                    "Grand Prize"
    in
    div
        [ id "table-block", class "block py-2" ]
        [ table
            [ class "w-full" ]
          <|
            tableRow ThinTable True headerList
                :: List.map (\x -> tableRow ThinTable False [ Handlers.posixToMonth x.awardedDatetime, x.username, prizeToString x.prizeType, x.note ]) unitList
        ]
