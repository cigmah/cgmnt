module Shared.Subscriptions exposing (subscriptions)

import Shared.Types exposing (Model)
import Shared.Update exposing (Msg)


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none
