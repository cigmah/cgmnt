module Subscriptions.Subscriptions exposing (subscriptions)

import Msg.Msg exposing (..)
import Time exposing (every)
import Types.Types exposing (..)


subscriptions : Model -> Sub Msg
subscriptions model =
    every 1000 (\x -> GetCurrentTime)
