module Page.Puzzle exposing (detailPuzzle, explanationSection, puzzleCard, puzzleTags, solutionSection)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Markdown
import RemoteData exposing (RemoteData(..), WebData)
import Types exposing (..)
import Utils exposing (..)


puzzleCard onSelectEvent puzzle =
    div [ class "column is-one-third-desktop is-half-tablet" ]
        [ div [ class "card puzzle", onClick <| onSelectEvent puzzle ]
            [ div [ class "card-image" ]
                [ figure [ class "image is-2by1" ]
                    [ img [ src puzzle.imagePath, alt "Placeholder" ] []
                    ]
                ]
            , div [ class "card-content" ]
                [ div [ class "media" ]
                    [ div [ class "media-content" ]
                        [ p [ class "subtitle" ] [ text puzzle.title ] ]
                    ]
                , puzzleTags puzzle
                ]
            ]
        ]


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


detailPuzzle puzzle onDeselectEvent =
    div [ class "modal is-active" ]
        [ div [ class "modal-background" ] []
        , div [ class "modal-card" ]
            [ header [ class "modal-card-head" ]
                [ p [ class "modal-card-title" ]
                    [ text puzzle.title ]
                , button [ class "delete is-medium", onClick onDeselectEvent ] []
                ]
            , div [ class "modal-card-body" ]
                [ puzzleTags puzzle
                , div [ class "container" ]
                    [ div [ class "content" ]
                        [ p [] <| Markdown.toHtml Nothing puzzle.body ]
                    , div [ class "message" ]
                        [ div [ class "message-body" ] <| Markdown.toHtml Nothing puzzle.example
                        ]
                    , div [ class "notification is-info" ] <| Markdown.toHtml Nothing puzzle.statement
                    , hr [] []
                    , solutionSection puzzle
                    , explanationSection puzzle
                    ]
                ]
            ]
        ]
