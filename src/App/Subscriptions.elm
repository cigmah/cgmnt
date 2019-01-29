module App.Subscriptions exposing (subscriptions)

import Time exposing (every)
import Types.Msg exposing (..)
import Types.Types exposing (..)


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



--every 1000 (\x -> GetCurrentTime)
