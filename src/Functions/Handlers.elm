module Functions.Handlers exposing (getCurrentTime, init, linkClicked, newTime, onLogout, toggleBurgerMenu, urlChanged)

import Browser exposing (UrlRequest)
import Browser.Navigation as Nav
import Functions.ApiBase exposing (apiBase)
import Functions.Decoders exposing (..)
import Functions.Functions exposing (fromUrl)
import Functions.Ports exposing (cache)
import Json.Decode as Decode
import Json.Encode as Encode
import Msg.Msg exposing (..)
import Result
import Task
import Time exposing (Posix)
import Types.Init as Init
import Types.Types exposing (..)
import Url exposing (Url)


init : Decode.Value -> Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url key =
    let
        maybeToken : Maybe AuthToken
        maybeToken =
            Result.toMaybe <| Decode.decodeValue Decode.string flags

        route : Route
        route =
            fromUrl maybeToken url

        start : Model
        start =
            Init.model key route maybeToken
    in
    ( start, Cmd.none )


linkClicked : Model -> UrlRequest -> ( Model, Cmd Msg )
linkClicked model urlRequest =
    case urlRequest of
        Browser.Internal url ->
            ( { model | navBarMenuActive = False }, Nav.pushUrl model.key (Url.toString url) )

        Browser.External href ->
            ( model, Nav.load href )


urlChanged : Model -> Url -> ( Model, Cmd Msg )
urlChanged model url =
    ( { model | route = fromUrl model.authToken url }, Cmd.none )


newTime : Model -> Posix -> ( Model, Cmd Msg )
newTime model time =
    ( { model | currentTime = Just time }, Cmd.none )


getCurrentTime : Model -> ( Model, Cmd Msg )
getCurrentTime model =
    ( model, Task.perform NewTime Time.now )


toggleBurgerMenu : Model -> ( Model, Cmd Msg )
toggleBurgerMenu model =
    ( { model | navBarMenuActive = not model.navBarMenuActive }, Cmd.none )


onLogout : Model -> ( Model, Cmd Msg )
onLogout model =
    ( { model | authToken = Nothing }, cache <| Encode.string "" )
