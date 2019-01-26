module PuzzleHunt.Authenticated exposing (bodyPuzzleHunt)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Markdown
import PuzzleHunt.Content as Content
import Shared.Components exposing (navBar)
import Shared.Types exposing (Msg(..))


bodyPuzzleHunt model token =
    [ navBar model
    , section [ class "hero is-success" ]
        [ div [ class "hero-body" ]
            [ div [ class "container" ]
                [ h1 [ class "title" ] [ text "Puzzle Hunt 2019 Portal" ]
                , h2 [ class "subtitle" ] [ text "The next set is ___ and opens at ___" ]
                ]
            ]
        ]
    ]
