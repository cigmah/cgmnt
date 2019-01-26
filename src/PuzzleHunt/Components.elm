module PuzzleHunt.Components exposing (viewPuzzleHunt)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Markdown
import PuzzleHunt.Authenticated
import PuzzleHunt.Content as Content
import PuzzleHunt.NotAuthenticated
import Shared.Components exposing (navBar)
import Shared.Init exposing (emptyLogin, emptyRegister)
import Shared.Types exposing (LoginEvent(..), Msg(..), RegisterEvent(..))


viewPuzzleHunt model =
    case model.authToken of
        Nothing ->
            { title = "CIGMAH PuzzleHunt"
            , body = PuzzleHunt.NotAuthenticated.bodyPuzzleHunt model
            }

        Just token ->
            { title = "PuzzleHunt Portal"
            , body = PuzzleHunt.Authenticated.bodyPuzzleHunt model token
            }
