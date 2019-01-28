module View.Leader exposing (bodyPuzzle, bodyTotal, leaderTableTotal, makeRowTotal, makeTableHeadings, viewPuzzle, viewTotal)

import Functions.Functions exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Html.Lazy exposing (..)
import List
import Markdown
import Msg.Msg exposing (..)
import RemoteData exposing (RemoteData(..), WebData)
import Types.Types exposing (..)
import View.LoadingModal exposing (loadingModal)
import View.NavBar exposing (navBar)
import View.Puzzle exposing (..)


viewTotal meta data =
    { title = "Leaderboard Totals"
    , body = bodyTotal meta data
    }


bodyTotal meta data =
    let
        isLoading =
            case data of
                Loading ->
                    True

                _ ->
                    False

        leaderBody =
            case data of
                Success unwrapped ->
                    lazy leaderTableTotal unwrapped

                _ ->
                    div [] []
    in
    [ lazy2 navBar meta.authToken meta.navBarMenuActive
    , lazy loadingModal isLoading
    , leaderBody
    ]


viewPuzzle meta data =
    { title = "Leaderboard By Puzzle"
    , body = bodyPuzzle meta data
    }


leaderTableTotal : LeaderTotalData -> Html Msg
leaderTableTotal data =
    let
        headings =
            makeTableHeadings [ "Rank", "Username", "Total Points" ]

        numRows =
            List.length data

        dataRows =
            List.map2 makeRowTotal (List.range 1 numRows) data

        tableBody =
            table [ class "table is-hoverable is-fullwidth" ]
                [ headings
                , tbody [] dataRows
                ]
    in
    div []
        [ section [ class "hero is-primary" ]
            [ div [ class "hero-body" ]
                [ div [ class "container" ]
                    [ h1 [ class "title" ] [ text "Leaderboard" ]
                    , h2 [ class "subtitle" ] [ text "By Total Points" ]
                    ]
                ]
            ]
        , section [ class "hero" ]
            [ div [ class "hero-body" ]
                [ div [ class "container" ]
                    [ div [ class "columns is-centered" ]
                        [ div [ class "column is-two-thirds" ] [ tableBody ]
                        ]
                    ]
                ]
            ]
        ]


makeTableHeadings : List String -> Html Msg
makeTableHeadings headingList =
    let
        makeRow heading =
            th [ class "has-background-info has-text-white" ] [ text heading ]
    in
    thead []
        [ tr [] <| List.map makeRow headingList ]


makeRowTotal : Int -> LeaderTotalUser -> Html Msg
makeRowTotal rank data =
    tr []
        [ td [] [ text <| String.fromInt rank ]
        , td []
            [ text data.username ]
        , td [] [ text <| String.fromInt data.total ]
        ]


bodyPuzzle meta data =
    [ lazy2 navBar meta.authToken meta.navBarMenuActive, div [] [] ]
