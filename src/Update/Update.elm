module Update.Update exposing (init, update)

import Browser
import Browser.Navigation as Nav
import Functions.Decoders exposing (..)
import Functions.Handlers as Handlers
import Functions.Ports exposing (..)
import Http exposing (Error(..))
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

        LeaderTotalMsg event ->
            updateLeaderTotal model event

        LeaderPuzzleMsg event ->
            ( model, Cmd.none )

        PuzzlesMsg event ->
            updatePuzzles model event

        CompletedMsg event ->
            updateCompleted model event

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

                OnDeselectArchivePuzzle ->
                    case archiveData of
                        Success (ArchiveDetail puzzleList _) ->
                            ( { model | route = Archive (Success (ArchiveFull puzzleList)) }, Cmd.none )

                        _ ->
                            ( model, Cmd.none )

                _ ->
                    ( model, Cmd.none )

        _ ->
            ( model, Cmd.none )


updateCompleted model msg =
    case model.route of
        CompletedAuth authToken archiveData ->
            case msg of
                ReceivedCompleted receivedData ->
                    ( { model | route = CompletedAuth authToken receivedData }, Cmd.none )

                OnSelectCompletedPuzzle puzzle ->
                    case archiveData of
                        Success (ArchiveFull puzzleList) ->
                            ( { model | route = CompletedAuth authToken (Success (ArchiveDetail puzzleList puzzle)) }, Cmd.none )

                        _ ->
                            ( model, Cmd.none )

                OnDeselectCompletedPuzzle ->
                    case archiveData of
                        Success (ArchiveDetail puzzleList _) ->
                            ( { model | route = CompletedAuth authToken (Success (ArchiveFull puzzleList)) }, Cmd.none )

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


updatePuzzles model msg =
    case model.route of
        PuzzlesAuth authToken (Success (PuzzlesAll puzzlesData)) ->
            case msg of
                OnSelectActivePuzzle puzzle ->
                    ( { model | route = PuzzlesAuth authToken (Success (PuzzlesDetail puzzlesData { puzzle = puzzle, input = "" } NotAsked)) }, Cmd.none )

                _ ->
                    ( model, Cmd.none )

        PuzzlesAuth authToken (Success (PuzzlesDetail puzzlesData selectedPuzzle webData)) ->
            case msg of
                OnDeselectActivePuzzle ->
                    Handlers.onDeselectActivePuzzle model authToken puzzlesData webData

                OnChangeInput newInput ->
                    let
                        newSelectedPuzzle =
                            { selectedPuzzle | input = newInput }
                    in
                    ( { model | route = PuzzlesAuth authToken (Success (PuzzlesDetail puzzlesData newSelectedPuzzle webData)) }, Cmd.none )

                OnPostSubmission ->
                    case webData of
                        Loading ->
                            ( model, Cmd.none )

                        _ ->
                            Handlers.onPostSubmission model authToken puzzlesData selectedPuzzle

                ReceivedSubmissionResponse newSubmitData ->
                    case newSubmitData of
                        Failure (BadStatus e) ->
                            case e.status.code of
                                412 ->
                                    let
                                        decodedErrorData =
                                            Decode.decodeString decodeTooSoonSubmit e.body
                                    in
                                    case decodedErrorData of
                                        Ok tooSoonData ->
                                            let
                                                tooSoonWebData =
                                                    Success (TooSoonSubmit tooSoonData)
                                            in
                                            ( { model | route = PuzzlesAuth authToken (Success (PuzzlesDetail puzzlesData selectedPuzzle tooSoonWebData)) }, Cmd.none )

                                        Err decodeErr ->
                                            ( { model | route = PuzzlesAuth authToken (Success (PuzzlesDetail puzzlesData selectedPuzzle newSubmitData)) }, Cmd.none )

                                _ ->
                                    ( { model | route = PuzzlesAuth authToken (Success (PuzzlesDetail puzzlesData selectedPuzzle newSubmitData)) }, Cmd.none )

                        _ ->
                            ( { model | route = PuzzlesAuth authToken (Success (PuzzlesDetail puzzlesData selectedPuzzle newSubmitData)) }, Cmd.none )

                _ ->
                    ( model, Cmd.none )

        PuzzlesAuth authToken Loading ->
            case msg of
                ReceivedActiveData newData ->
                    Handlers.receivedActiveData model authToken newData

                _ ->
                    ( model, Cmd.none )

        _ ->
            ( model, Cmd.none )


updateLeaderTotal model msg =
    case model.route of
        LeaderTotal Loading ->
            case msg of
                ReceivedLeaderTotal receivedData ->
                    ( { model | route = LeaderTotal receivedData }, Cmd.none )

                _ ->
                    ( model, Cmd.none )

        _ ->
            ( model, Cmd.none )
