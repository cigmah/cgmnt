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
        , bodyContent = div [] [ span [ class "text-grey-light bg-grey-light rounded" ] [ text <| loremIpsum ], br [] [], span [ class "text-grey-light bg-grey-light rounded" ] [ text <| loremIpsum ], br [] [], div [ class "mt-4 rounded h-32 w-full bg-grey-lighter" ] [] ]
        , outsideMain = div [] []
        }


markdownContent =
    """

We offer two broad types of prizes - Puzzle Prizes and Total Prizes.

Puzzle Prizes are awarded to the first solver of each puzzle (except for the first three puzzles i.e. the three sample puzzles).

Total Prizes are awarded at the end of the puzzle hunt to the participants with the greatest total amount of points in one of four categories:

  1. Grand total
  2. Challenge set total
  3. Beginner set total
  4. Abstract set total

We award the prizes in that order, and each prize must go to a different participant.

You can see the current log of prizewinners below.

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
    tableMaker [ "Awarded", "User", "Prize", "Notes" ] data


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
