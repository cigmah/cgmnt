module Views.Leaderboard exposing (view)

import Browser
import Handlers
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Html.Lazy exposing (..)
import Http exposing (Error(..))
import RemoteData exposing (RemoteData(..), WebData)
import Types exposing (..)
import Views.Shared exposing (..)


view : Model -> WebData (List UserAggregate) -> ( String, Html Msg )
view model userAggregateListWebData =
    let
        title =
            "Leaderboard - CIGMAH"

        body =
            webDataWrapper userAggregateListWebData (makeBody model)
    in
    ( title, body )


makeBody : Model -> List UserAggregate -> Html Msg
makeBody model userAggregateList =
    div [ class "main" ]
        [ div [ class "container" ]
            [ div
                [ class "leaderboard" ]
                [ table [] <| List.map2 makeTotalRow (List.range 1 10) userAggregateList ]
            ]
        ]


makeTotalRow : Int -> UserAggregate -> Html Msg
makeTotalRow rank data =
    tr []
        [ td [ class "lessen" ] [ text <| String.fromInt rank ]
        , td [ class "strengthen" ] [ text data.username ]
        , td [ class "lessen" ] [ text "[", text <| String.fromInt data.totalGrand, text "]" ]
        ]
