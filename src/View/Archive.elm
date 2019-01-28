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
import View.Puzzle exposing (..)


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

        basePage =
            case data of
                Success (ArchiveFull puzzles) ->
                    mainContainer puzzles

                Success (ArchiveDetail puzzles selectedPuzzle) ->
                    mainContainer puzzles

                Loading ->
                    div [] []

                NotAsked ->
                    div [] []

                Failure error ->
                    div [] []

        puzzleModal =
            case data of
                Success (ArchiveFull puzzles) ->
                    div [] []

                Success (ArchiveDetail puzzles selectedPuzzle) ->
                    detailPuzzle selectedPuzzle "" Nothing <| ArchiveMsg OnDeselectArchivePuzzle

                Loading ->
                    div [] []

                NotAsked ->
                    div [] []

                Failure error ->
                    div [] []
    in
    [ lazy2 navBar meta.authToken meta.navBarMenuActive
    , lazy loadingModal isLoading
    , basePage
    , puzzleModal
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


mainContainer puzzles =
    div [] [ lazy (\_ -> banner) Nothing, section [ class "hero-body" ] [ div [ class "container" ] [ puzzleContainer puzzles <| ArchiveMsg << OnSelectArchivePuzzle ] ] ]
