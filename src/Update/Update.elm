module Update.Update exposing (init, update)

import Browser
import Browser.Navigation as Nav
import Functions.Functions exposing (..)
import Functions.Ports exposing (..)
import Json.Decode as Decode
import Json.Encode as Encode
import Msg.Msg exposing (..)
import Task
import Time
import Types.Init as Init
import Types.Types exposing (..)
import Url exposing (Url)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LinkClicked urlRequest ->
            handleLinkClicked model urlRequest

        UrlChanged url ->
            handleUrlChanged model url

        NewTime time ->
            ( { model | currentTime = Just time }, Cmd.none )

        GetCurrentTime ->
            ( model, Task.perform NewTime Time.now )

        ToggleBurgerMenu ->
            ( { model | navBarMenuActive = not model.navBarMenuActive }, Cmd.none )

        OnLogout ->
            ( { model | authToken = Nothing }, cache <| Encode.string "" )

        ArchiveMsg event ->
            ( model, Cmd.none )

        LeaderMsg event ->
            ( model, Cmd.none )

        DashMsg event ->
            ( model, Cmd.none )

        CompletedMsg event ->
            ( model, Cmd.none )

        SubmissionMsg event ->
            ( model, Cmd.none )


init : Decode.Value -> Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url key =
    let
        value =
            Decode.decodeValue Decode.string flags

        route =
            fromUrl url

        start =
            Init.model key route
    in
    case value of
        Ok token ->
            case route of
                _ ->
                    ( { start | authToken = Just token }
                    , Cmd.none
                    )

        Err _ ->
            ( start, Cmd.none )


updateLogin model msg =
    case msg of
        ToggleLoginModal ->
            handleToggleLoginModal model

        OnChangeLoginEmail email ->
            handleOnChangeLoginEmail model email

        OnChangeLoginToken token ->
            handleOnChangeLoginToken model token

        OnSendToken ->
            handleOnSendToken model

        OnLogin ->
            handleOnLogin model

        ReceivedSendToken result ->
            handleReceivedSendToken model result

        ReceivedLogin result ->
            handleReceivedLogin model result


handleToggleLoginModal model =
    ( model, Cmd.none )


handleOnChangeLoginEmail model email =
    ( model, Cmd.none )


handleOnChangeLoginToken model token =
    ( model, Cmd.none )


handleOnSendToken model =
    ( model, Cmd.none )


handleOnLogin model =
    ( model, Cmd.none )


handleReceivedSendToken model result =
    ( model, Cmd.none )


handleReceivedLogin model result =
    ( model, Cmd.none )
