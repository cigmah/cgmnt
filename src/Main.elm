module Main exposing (main)

import Browser.Hash as Hash
import Json.Decode as Decode
import Shared.Init exposing (init)
import Shared.Subscriptions exposing (subscriptions)
import Shared.Types exposing (Model, Msg(..))
import Shared.Update exposing (update)
import Shared.View exposing (view)


main : Program Decode.Value Model Msg
main =
    Hash.application
        { view = view
        , init = init
        , update = update
        , subscriptions = subscriptions
        , onUrlRequest = LinkClicked
        , onUrlChange = UrlChanged
        }
