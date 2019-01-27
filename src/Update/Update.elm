module Update.Update exposing (init, update)

import Browser
import Browser.Navigation as Nav
import Functions.Handlers as Handlers
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
            Handlers.linkClicked model urlRequest

        UrlChanged url ->
            Handlers.urlChanged model url

        NewTime time ->
            Handlers.newTime model time

        GetCurrentTime ->
            Handlers.getCurrentTime model

        ToggleBurgerMenu ->
            Handlers.toggleBurgerMenu model

        OnLogout ->
            Handlers.onLogout model

        RegisterMsg event ->
            ( model, Cmd.none )

        LoginMsg event ->
            ( model, Cmd.none )

        ArchiveMsg event ->
            ( model, Cmd.none )

        LeaderMsg event ->
            ( model, Cmd.none )

        PuzzlesMsg event ->
            ( model, Cmd.none )

        CompletedMsg event ->
            ( model, Cmd.none )

        SubmissionMsg event ->
            ( model, Cmd.none )


init : Decode.Value -> Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url key =
    Handlers.init flags url key


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
