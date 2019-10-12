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


view : Meta -> WebData PrizeData -> ( String, Html Msg )
view meta webData =
    let
        title =
            "Prizes - CIGMAH"

        body =
            case webData of
                Loading ->
                    loadingPage

                Success data ->
                    prizesContent data

                Failure e ->
                    case e of
                        BadStatus metadata ->
                            errorPage metadata.body

                        NetworkError ->
                            errorPage "There's something wrong with your network or with accessing the backend - check your internet connection first and check the console for any network errors."

                        _ ->
                            errorPage "Unfortunately, we don't yet know what this error is. :(  "

                NotAsked ->
                    errorPage "The request didn't go through - try refreshing!"
    in
    ( title, body )


prizesContent : PrizeData -> Html Msg
prizesContent data =
    div [ class "main" ]
        [ div [ class "container" ]
            [ div [ class "prizes" ] [ table [] (List.map prizeToRow data) ]
            ]
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
