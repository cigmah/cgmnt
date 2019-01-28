module View.SubmissionsAuth exposing (view)

import Functions.Functions exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Html.Lazy exposing (..)
import Markdown
import Msg.Msg exposing (..)
import RemoteData exposing (RemoteData(..), WebData)
import Types.Types exposing (..)
import View.LoadingModal exposing (loadingModal)
import View.NavBar exposing (navBar)
import View.Table exposing (..)


view meta authToken data =
    { title = "My Submissions"
    , body = body meta authToken data
    }


body meta authToken data =
    let
        isLoading =
            case data of
                Loading ->
                    True

                _ ->
                    False

        submissionsWrapper =
            case data of
                Success unwrapped ->
                    submissionsBody unwrapped

                _ ->
                    div [] []
    in
    [ lazy2 navBar meta.authToken meta.navBarMenuActive
    , lazy loadingModal isLoading
    , submissionsHeader
    , submissionsWrapper
    ]


submissionsHeader =
    section [ class "hero is-primary" ]
        [ div [ class "hero-body" ]
            [ div [ class "container" ]
                [ h1 [ class "title" ] [ text "Submissions" ]
                , h2 [ class "subtitle" ] [ text "Your puzzle submissions." ]
                ]
            ]
        ]


submissionsBody data =
    let
        headings =
            makeTableHeadings [ "Puzzle", "Theme", "Set", "Submission Time", "Submission", "Status", "Points" ]

        numRows =
            List.length data

        dataRows =
            List.map makeRowUserSubmission data

        tableBody =
            table [ class "table is-hoverable is-fullwidth" ]
                [ headings
                , tbody [] dataRows
                ]
    in
    section [ class "hero" ]
        [ div [ class "hero-body" ]
            [ div [ class "container" ]
                [ div [ class "columns is-centered" ]
                    [ div [ class "column" ] [ tableBody ]
                    ]
                ]
            ]
        ]


makeRowUserSubmission dataRow =
    let
        makeStatus isCorrect =
            case isCorrect of
                True ->
                    "Correct"

                False ->
                    "Incorrect"
    in
    tr []
        [ td [] [ text <| dataRow.puzzleTitle ]
        , td [] [ text <| dataRow.theme ]
        , td [] [ text <| puzzleSetString dataRow.set ]
        , td [] [ text <| posixToString dataRow.submissionDatetime ]
        , td [] [ text <| dataRow.submission ]
        , td [] [ text <| makeStatus dataRow.isCorrect ]
        , td [] [ text <| String.fromInt dataRow.points ]
        ]
