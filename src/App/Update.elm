module App.Update exposing (update)

import Browser
import Browser.Navigation as Nav
import Json.Encode as Encode
import RemoteData exposing (RemoteData(..), WebData)
import Shared.Ports exposing (cache)
import Task
import Time
import Types.Default exposing (..)
import Types.Msg exposing (..)
import Types.Types exposing (..)
import Url exposing (Url)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case model.route of
        RouteNoAuth pageNoAuth ->
            updateNoAuth msg model.meta pageNoAuth

        RouteWithAuth userWebData pageWithAuth ->
            updateWithAuth msg model.meta userWebData pageWithAuth


updateNoAuth : Msg -> Meta -> PageNoAuth -> ( Model, Cmd Msg )
updateNoAuth msg meta pageNoAuth =
    ( Model (RouteNoAuth pageNoAuth) meta, cache <| Encode.string "1" )


updateWithAuth : Msg -> Meta -> WebData User -> PageWithAuth -> ( Model, Cmd Msg )
updateWithAuth msg meta userWebData pageWithAuth =
    ( Model (RouteWithAuth userWebData pageWithAuth) meta, Cmd.none )
