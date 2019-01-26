module Main exposing (main)

import Browser.Hash as Hash
import Json.Decode as Decode
import Msg.Msg exposing (..)
import Subscriptions.Subscriptions exposing (subscriptions)
import Types.Types exposing (..)
import Update.Update exposing (init, update)
import View.View exposing (view)


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
