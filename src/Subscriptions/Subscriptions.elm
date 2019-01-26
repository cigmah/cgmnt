module Subscriptions.Subscriptions exposing (subscriptions)

import Msg.Msg exposing (..)
import Time exposing (every)
import Types.Types exposing (..)


subscriptions : Model -> Sub Msg
subscriptions model =
    case model.route of
        Dash _ _ ->
            case model.authToken of
                Just _ ->
                    every 1000 (\x -> GetCurrentTime)

                Nothing ->
                    Sub.none

        _ ->
            Sub.none
