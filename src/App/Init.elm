module App.Init exposing (init)

import Browser.Navigation as Nav
import Json.Decode as Decode
import Router.Router exposing (..)
import Types.Msg exposing (Msg(..))
import Types.Types exposing (..)
import Url exposing (Url)


init : Decode.Value -> Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url key =
    let
        maybeToken : Maybe AuthToken
        maybeToken =
            Result.toMaybe <| Decode.decodeValue Decode.string flags
    in
    urlInit maybeToken url key
