module Views.Prizes exposing (view)

import Browser
import Handlers
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Html.Lazy exposing (..)
import Http exposing (Error(..))
import Markdown
import RemoteData exposing (RemoteData(..), WebData)
import Types exposing (..)
import Views.Shared exposing (..)


prizeTypeToString : PrizeType -> String
prizeTypeToString prizeType =
    case prizeType of
        AbstractPrize ->
            "Abstract"

        BeginnerPrize ->
            "Beginner"

        ChallengePrize ->
            "Challenge"

        PuzzlePrize ->
            "Puzzle"

        GrandPrize ->
            "Grand"


tableRow : Prize -> Html Msg
tableRow prize =
    tr []
        [ td [] [ a [ routeHref <| UserRoute prize.username ] [ text <| prize.username ] ]
        , td [] [ text <| prizeTypeToString prize.prizeType ]
        , td [] [ text <| Handlers.posixToMonth prize.awardedDatetime ]
        , td [] [ text <| prize.note ]
        ]


view : Model -> List Prize -> Html Msg
view model prizeList =
    div []
        [ h1 [] [ text "Prizes" ]
        , div [ class "footnote" ]
            [ text "There are two broad types of prizes - Puzzle Prizes and Total Prizes."
            , br [] []
            , br [] []
            , text "Puzzle Prizes (value 10 AUD) are awarded each month for the fastest solver for each puzzle, with a limit of one Puzzle Prize per participant a month."
            , br [] []
            , br [] []
            , text "Total Prizes are awarded at the end of the Puzzle Hunt for the participant with the most points out of all the puzzles (150 AUD) and separately out of the Challenge (50 AUD), Beginner (50 AUD) and Abstract (50 AUD) puzzles, with a limit of one Total Prize per participant."
            ]
        , table [] <|
            tr []
                [ th [] [ text "Username" ]
                , th [] [ text "Prize Type" ]
                , th [] [ text "Awarded" ]
                , th [] [ text "Notes" ]
                ]
                :: List.map tableRow prizeList
        ]
