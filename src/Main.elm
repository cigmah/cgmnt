module Main exposing (main)

import App
import Browser
import Handlers
import Json.Decode as Decode
import Types exposing (..)


main : Program Decode.Value Model Msg
main =
    Browser.application
        { init = App.init
        , view = App.view
        , update = App.update
        , subscriptions = App.subscriptions
        , onUrlChange = ChangedUrl
        , onUrlRequest = ClickedLink
        }
