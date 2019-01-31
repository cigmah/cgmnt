module Page.Puzzle exposing (explanationSection, puzzleTags, solutionSection)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Markdown
import RemoteData exposing (RemoteData(..), WebData)
import Types exposing (..)
import Utils exposing (..)


puzzleTags puzzle =
    div [ class "content" ]
        [ div [ class "field is-grouped is-grouped-multiline" ]
            [ div [ class "control" ]
                [ div [ class "tags has-addons" ]
                    --[ span [ class "tag is-primary" ] [ text "Theme" ]
                    [ span [ class "tag is-primary" ] [ text puzzle.theme.theme ]
                    ]
                ]
            , div [ class "control" ]
                [ div [ class "tags has-addons" ]
                    --[ span [ class "tag is-info" ] [ text "Set" ]
                    [ span [ class "tag is-info" ] [ text <| puzzleSetString puzzle.set ]
                    ]
                ]
            , div [ class "control" ]
                [ div [ class "tags has-addons" ]
                    [ span [ class "tag has-background-grey-lighter" ] [ text "Open" ]
                    , span [ class "tag" ] [ text <| posixToString puzzle.theme.openDatetime ]
                    ]
                ]
            , div [ class "control" ]
                [ div [ class "tags has-addons" ]
                    [ span [ class "tag has-background-grey-lighter" ] [ text "Close" ]
                    , span [ class "tag" ] [ text <| posixToString puzzle.theme.closeDatetime ]
                    ]
                ]
            ]
        ]


solutionSection puzzle =
    section [ class "content" ]
        [ div [ class "container" ]
            [ h1 [ class "title" ] [ text "Solution" ]
            , div [ class "message is-danger" ]
                [ div [ class "message-body" ] [ text <| "The answer is " ++ puzzle.answer ++ "." ] ]
            ]
        ]


explanationSection puzzle =
    div [ class "content" ]
        [ p [] <| Markdown.toHtml Nothing puzzle.explanation ]
