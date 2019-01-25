module Shared.Subscriptions exposing (subscriptions)

import Shared.Types exposing (Model, Msg)


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none
