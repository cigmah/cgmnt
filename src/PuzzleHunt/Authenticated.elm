module PuzzleHunt.Authenticated exposing (bodyPuzzleHunt)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Markdown
import PuzzleHunt.Content as Content
import Shared.Components exposing (navBar)
import Shared.Types exposing (Msg(..))


bodyPuzzleHunt model token =
    [ navBar model, div [] [ text <| "PLACEHOLDER FOR PORTAL. DEBUG TOKEN IS " ++ token ] ]
