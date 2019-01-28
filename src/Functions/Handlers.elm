module Functions.Handlers exposing (getCurrentTime, init, linkClicked, newTime, onLogout, onRegister, toggleBurgerMenu, urlChanged)

import Browser exposing (UrlRequest)
import Browser.Navigation as Nav
import Functions.ApiBase exposing (apiBase)
import Functions.Decoders exposing (..)
import Functions.Functions exposing (fromUrl)
import Functions.Ports exposing (cache)
import Functions.Requests exposing (..)
import Json.Decode as Decode
import Json.Encode as Encode
import Msg.Msg exposing (..)
import RemoteData exposing (RemoteData(..), WebData)
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
    urlChanged start url


linkClicked : Model -> UrlRequest -> ( Model, Cmd Msg )
linkClicked model urlRequest =
    let
        meta =
            model.meta
    in
    case urlRequest of
        Browser.Internal url ->
            ( { model | meta = { meta | navBarMenuActive = False } }, Nav.pushUrl model.key (Url.toString url) )

        Browser.External href ->
            ( model, Nav.load href )


urlChanged : Model -> Url -> ( Model, Cmd Msg )
urlChanged model url =
    let
        newModel =
            { model | route = fromUrl model.meta.authToken url }
    in
    case newModel.route of
        Archive NotAsked ->
            ( { newModel | route = Archive Loading }, getArchive )

        _ ->
            ( newModel, Cmd.none )


newTime : Model -> Posix -> ( Model, Cmd Msg )
newTime model time =
    let
        meta =
            model.meta
    in
    ( { model | meta = { meta | currentTime = Just time } }, Cmd.none )


getCurrentTime : Model -> ( Model, Cmd Msg )
getCurrentTime model =
    ( model, Task.perform NewTime Time.now )


toggleBurgerMenu : Model -> ( Model, Cmd Msg )
toggleBurgerMenu model =
    let
        meta =
            model.meta
    in
    ( { model | meta = { meta | navBarMenuActive = not meta.navBarMenuActive } }, Cmd.none )


onLogout : Model -> ( Model, Cmd Msg )
onLogout model =
    let
        meta =
            model.meta
    in
    ( { model | meta = { meta | authToken = Nothing } }, cache <| Encode.string "" )


onRegister : Model -> RegisterInfo -> WebData Message -> ( Model, Cmd Msg )
onRegister model registerInfo webData =
    case webData of
        Success _ ->
            ( model, Cmd.none )

        _ ->
            ( { model | route = Home registerInfo Loading }, postRegister registerInfo )
