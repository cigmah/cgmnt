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


view : Model -> WebData (List Prize) -> ( String, Html Msg )
view model prizeListWebData =
    let
        title =
            "Prizes - CIGMAH"

        body =
            webDataWrapper prizeListWebData (makeBody model)
    in
    ( title, body )


makeBody : Model -> List Prize -> Html Msg
makeBody model prizeListWebData =
    div [ class "container" ]
        [ div [ class "prizes" ] [ table [] (List.map prizeToRow data) ]
        ]


prizeToRow : Prize -> Html Msg
prizeToRow prize =
    tr []
        [ td [ class "lessen" ] [ text <| Handlers.posixToMonth prize.awardedDatetime ]
        , td [ class "strengthen" ] [ text prize.username ]
        , td [ class "lessen" ] [ text "[", text <| prizeToString prize.prizeType, text "]" ]
        , td [ class "" ] [ text "-> ", text prize.note ]
        ]


prizeToString : PrizeType -> String
prizeToString prize =
    case prize of
        AbstractPrize ->
            "Abstract Set"

        BeginnerPrize ->
            "Beginner Set"

        ChallengePrize ->
            "Challenge Set"

        PuzzlePrize ->
            "Puzzle"

        GrandPrize ->
            "Grand Prize"
