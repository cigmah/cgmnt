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
            updateRegister event model

        LoginMsg event ->
            ( model, Cmd.none )

        ArchiveMsg event ->
            updateArchive event model

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


updateRegister : RegisterEvent -> Model -> ( Model, Cmd Msg )
updateRegister msg model =
    case model.route of
        Home registerInfo registerData ->
            case msg of
                OnChangeRegisterUsername input ->
                    ( { model | route = Home { registerInfo | username = input } registerData }, Cmd.none )

                OnChangeRegisterEmail input ->
                    ( { model | route = Home { registerInfo | email = input } registerData }, Cmd.none )

                OnChangeRegisterFirstName input ->
                    ( { model | route = Home { registerInfo | firstName = input } registerData }, Cmd.none )

                OnChangeRegisterLastName input ->
                    ( { model | route = Home { registerInfo | lastName = input } registerData }, Cmd.none )

                _ ->
                    ( model, Cmd.none )

        _ ->
            ( model, Cmd.none )


updateArchive : ArchiveEvent -> Model -> ( Model, Cmd Msg )
updateArchive msg model =
    case model.route of
        Archive archiveData ->
            case msg of
                ReceivedArchive receivedData ->
                    ( { model | route = Archive receivedData }, Cmd.none )

                _ ->
                    ( model, Cmd.none )

        _ ->
            ( model, Cmd.none )
