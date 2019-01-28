module Update.Update exposing (init, update)

import Browser
import Browser.Navigation as Nav
import Functions.Handlers as Handlers
import Functions.Ports exposing (..)
import Json.Decode as Decode
import Json.Encode as Encode
import Msg.Msg exposing (..)
import RemoteData exposing (RemoteData(..), WebData)
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
            updateRegister model event

        LoginMsg event ->
            updateLogin model event

        ArchiveMsg event ->
            updateArchive model event

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


updateRegister : Model -> RegisterEvent -> ( Model, Cmd Msg )
updateRegister model msg =
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

                OnRegister ->
                    Handlers.onRegister model registerInfo registerData

                ReceivedRegister receivedData ->
                    ( { model | route = Home registerInfo receivedData }, Cmd.none )

        _ ->
            ( model, Cmd.none )


updateArchive model msg =
    case model.route of
        Archive archiveData ->
            case msg of
                ReceivedArchive receivedData ->
                    ( { model | route = Archive receivedData }, Cmd.none )

                OnSelectArchivePuzzle puzzle ->
                    case archiveData of
                        Success (ArchiveFull puzzleList) ->
                            ( { model | route = Archive (Success (ArchiveDetail puzzleList puzzle)) }, Cmd.none )

                        _ ->
                            ( model, Cmd.none )

                OnDeselectPuzzle ->
                    case archiveData of
                        Success (ArchiveDetail puzzleList _) ->
                            ( { model | route = Archive (Success (ArchiveFull puzzleList)) }, Cmd.none )

                        _ ->
                            ( model, Cmd.none )

                _ ->
                    ( model, Cmd.none )

        _ ->
            ( model, Cmd.none )


updateLogin model msg =
    case model.route of
        Login loginState ->
            case loginState of
                InputEmail email webData ->
                    case msg of
                        OnChangeLoginEmail input ->
                            ( { model | route = Login (InputEmail input webData) }, Cmd.none )

                        OnSendEmail ->
                            Handlers.onSendEmail model email webData

                        ReceivedSendEmail responseData ->
                            Handlers.receivedSendEmail model email webData responseData

                        _ ->
                            ( model, Cmd.none )

                InputToken email emailResponse token tokenResponse ->
                    case msg of
                        OnChangeLoginToken input ->
                            ( { model | route = Login (InputToken email emailResponse input tokenResponse) }, Cmd.none )

                        OnLogin ->
                            Handlers.onLogin model email emailResponse token tokenResponse

                        ReceivedLogin responseData ->
                            Handlers.receivedLogin model email emailResponse token tokenResponse responseData

                        _ ->
                            ( model, Cmd.none )

        _ ->
            ( model, Cmd.none )
