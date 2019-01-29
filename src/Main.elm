module Main exposing (main)

import App.Init
import App.Subscriptions
import App.Update
import App.View
import Browser.Hash as Hash
import Json.Decode as Decode
import Types.Msg exposing (Msg(..))
import Types.Types exposing (Model)


main : Program Decode.Value Model Msg
main =
    Hash.application
        { view = App.View.view
        , init = App.Init.init
        , update = App.Update.update
        , subscriptions = App.Subscriptions.subscriptions
        , onUrlRequest = LinkClicked
        , onUrlChange = UrlChanged
        }
