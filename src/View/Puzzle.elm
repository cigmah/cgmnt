module View.Puzzle exposing (detailPuzzle, puzzleCard, puzzleContainer, puzzleTags)

import Functions.Functions exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Html.Lazy exposing (..)
import Markdown
import Msg.Msg exposing (..)
import RemoteData exposing (RemoteData(..), WebData)
import Types.Types exposing (..)


puzzleCard : PuzzleData -> Html Msg
puzzleCard puzzle =
    div [ class "column is-one-third-desktop is-half-tablet" ]
        [ div [ class "card" ]
            [ div [ class "card-image" ]
                [ figure [ class "image is-2by1" ]
                    [ img [ src "https://bulma.io/images/placeholders/1280x960.png", alt "Placeholder" ] []
                    ]
                ]
            , div [ class "card-content" ]
                [ div [ class "media" ]
                    [ div [ class "media-content" ]
                        [ p [ class "subtitle" ] [ text puzzle.title ] ]
                    ]
                , puzzleTags puzzle
                ]
            , footer [ class "card-footer" ]
                [ button [ class "button is-fullwidth", onClick <| ArchiveMsg <| OnSelectArchivePuzzle puzzle ] [ text "Open" ] ]
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


puzzleContainer puzzles =
    div [ class "columns is-multiline" ] <| List.map puzzleCard puzzles


detailPuzzle puzzle =
    let
        solutionSection =
            case puzzle.answer of
                Just answer ->
                    section [ class "content" ]
                        [ div [ class "container" ]
                            [ h1 [ class "title" ] [ text "Solution" ]
                            , div [ class "message is-danger" ]
                                [ div [ class "message-body" ] [ text <| "The answer is " ++ answer ++ "." ] ]
                            ]
                        ]

                Nothing ->
                    div [] []

        explanationSection =
            case puzzle.explanation of
                Just explanation ->
                    div [ class "content" ]
                        [ p [] <| Markdown.toHtml Nothing explanation ]

                Nothing ->
                    div [] []
    in
    div [ class "modal is-active" ]
        [ div [ class "modal-background" ] []
        , div [ class "modal-card" ]
            [ header [ class "modal-card-head" ]
                [ p [ class "modal-card-title" ]
                    [ text "Fractal Geometry in Cancer" ]
                , button [ class "delete is-medium", onClick <| ArchiveMsg OnDeselectPuzzle ] []
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
                    , solutionSection
                    , explanationSection
                    ]
                ]
            , footer [ class "modal-card-foot" ]
                [ p [] [ text "TEST" ] ]
            ]
        ]
