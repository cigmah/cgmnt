module View.PuzzlesAuth exposing (view)

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


view meta authToken data =
    { title = "My Active Puzzles"
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

        basePage =
            case data of
                Success (PuzzlesAll activeData) ->
                    mainContainer activeData.active

                Success (PuzzlesDetail activeData selectedPuzzle _) ->
                    mainContainer activeData.active

                Loading ->
                    div [] []

                NotAsked ->
                    div [] []

                Failure error ->
                    div [] []

        puzzleModal =
            case data of
                Success (PuzzlesAll activeData) ->
                    div [] []

                Success (PuzzlesDetail activeData selectedPuzzle submissionData) ->
                    detailPuzzle selectedPuzzle.puzzle selectedPuzzle.input submissionData <| PuzzlesMsg OnDeselectActivePuzzle

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
                    [ text "Active Puzzles" ]
                , h2 [ class "subtitle" ]
                    [ text "Active puzzles that you are yet to solve!" ]
                ]
            ]
        ]


mainContainer puzzles =
    div [] [ lazy (\_ -> banner) Nothing, section [ class "hero-body" ] [ div [ class "container" ] [ puzzleContainer puzzles <| PuzzlesMsg << OnSelectActivePuzzle ] ] ]
