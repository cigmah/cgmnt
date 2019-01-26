module Shared.Subscriptions exposing (subscriptions)

import Shared.Types exposing (Model, Msg(..), Route(..))
import Time exposing (every)


subscriptions : Model -> Sub Msg
subscriptions model =
    case model.route of
        PuzzleHunt ->
            case model.authToken of
                Just _ ->
                    every 1000 (\x -> GetCurrentTime)

                Nothing ->
                    Sub.none

        _ ->
            Sub.none
