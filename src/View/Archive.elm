module View.Archive exposing (view)

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


view meta data =
    { title = "Puzzle Archive"
    , body = body meta data
    }


body meta data =
    let
        isLoading =
            case data of
                Loading ->
                    True

                _ ->
                    False

        page =
            case data of
                Success (ArchiveFull puzzles) ->
                    mainContainer puzzles

                Success (ArchiveDetail puzzles selectedPuzzle) ->
                    detailPuzzle selectedPuzzle

                Loading ->
                    div [] []

                NotAsked ->
                    div [] []

                Failure error ->
                    div [] []
    in
    [ lazy2 navBar meta.authToken meta.navBarMenuActive
    , lazy loadingModal isLoading
    , page
    ]


banner =
    section [ class "hero is-dark" ]
        [ div [ class "hero-body" ]
            [ div [ class "container" ]
                [ h1 [ class "title" ]
                    [ text "Puzzle Archive" ]
                , h2 [ class "subtitle" ]
                    [ text "Closed puzzles from this year's Puzzle Hunt." ]
                ]
            ]
        ]


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
                    [ span [ class "tag is-primary" ] [ text "Theme" ]
                    , span [ class "tag" ] [ text puzzle.theme.theme ]
                    ]
                ]
            , div [ class "control" ]
                [ div [ class "tags has-addons" ]
                    [ span [ class "tag is-info" ] [ text "Set" ]
                    , span [ class "tag" ] [ text <| puzzleSetString puzzle.set ]
                    ]
                ]
            , div [ class "control" ]
                [ div [ class "tags has-addons" ]
                    [ span [ class "tag is-dark" ] [ text "Open" ]
                    , span [ class "tag" ] [ text <| posixToString puzzle.theme.openDatetime ]
                    ]
                ]
            , div [ class "control" ]
                [ div [ class "tags has-addons" ]
                    [ span [ class "tag is-dark" ] [ text "Close" ]
                    , span [ class "tag" ] [ text <| posixToString puzzle.theme.closeDatetime ]
                    ]
                ]
            ]
        ]


mainContainer puzzles =
    div [] [ lazy (\_ -> banner) Nothing, section [ class "hero-body" ] [ div [ class "container" ] [ puzzleContainer puzzles ] ] ]


puzzleContainer puzzles =
    div [ class "columns is-multiline" ] <| List.map puzzleCard puzzles


detailPuzzle puzzle =
    let
        solutionSection =
            case puzzle.answer of
                Just answer ->
                    case puzzle.explanation of
                        Just explanation ->
                            section [ class "section" ]
                                [ div [ class "container" ]
                                    [ h1 [ class "title" ] [ text "Solution" ]
                                    , div [ class "message is-danger" ]
                                        [ div [ class "message-body" ] [ text <| "The answer is " ++ answer ++ "." ] ]
                                    , div [ class "content" ]
                                        [ p [] <| Markdown.toHtml Nothing explanation ]
                                    ]
                                ]

                        Nothing ->
                            div [] []

                Nothing ->
                    div [] []
    in
    div []
        [ section [ class "section" ]
            [ div [ class "container" ]
                [ div [ class "level" ]
                    [ div [ class "level-left" ]
                        [ div [ class "level-item" ]
                            [ h1 [ class "title" ] [ text puzzle.title ]
                            ]
                        ]
                    , div
                        [ class "level-right" ]
                        [ div [ class "level-item" ]
                            [ button [ class "button is-info", onClick <| ArchiveMsg OnDeselectPuzzle ] [ text "Back to Puzzles" ]
                            ]
                        ]
                    ]
                , puzzleTags puzzle
                , div [ class "content" ]
                    [ p [] <| Markdown.toHtml Nothing puzzle.body ]
                , div [ class "message" ]
                    [ div [ class "message-body" ] <| Markdown.toHtml Nothing puzzle.example
                    ]
                , div [ class "notification is-info" ] <| Markdown.toHtml Nothing puzzle.statement
                ]
            ]
        , solutionSection
        ]
