module Page.OpenPuzzles exposing (Model, Msg, init, subscriptions, toSession, update, view)

import Api
import Decoders exposing (decoderPuzzleSet, decoderThemeData)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Html.Lazy exposing (..)
import Http exposing (Error(..))
import Iso8601
import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline exposing (optional, required)
import Json.Encode as Encode exposing (Value)
import Markdown
import Page.Error exposing (..)
import Page.Nav exposing (..)
import Page.Puzzle exposing (..)
import Page.Shared exposing (..)
import RemoteData exposing (RemoteData(..), WebData)
import Session exposing (Session(..))
import Time exposing (Posix)
import Types exposing (..)
import Utils
import Viewer exposing (Viewer(..))



-- MODEL


type alias Model =
    { session : Session
    , state : State
    , navActive : Bool
    }


type State
    = Denied
    | Unloaded (WebData OpenData)
    | Full OpenData
    | Detail OpenData SelectedPuzzleInfo (WebData SubmissionResponse)
    | Completed SelectedPuzzleInfo OkSubmitData


type alias OpenData =
    { complete : List LimitedPuzzleData
    , incomplete : List LimitedPuzzleData
    }


type alias SelectedPuzzleInfo =
    { puzzle : LimitedPuzzleData
    , input : String
    , isCompleted : Bool
    }


type SubmissionResponse
    = OkSubmit OkSubmitData
    | TooSoonSubmit TooSoonSubmitData


type alias OkSubmitData =
    { id : Int
    , submission : String
    , isCorrect : Bool
    , points : Int
    }


type alias TooSoonSubmitData =
    { message : String
    , attempts : Int
    , last : Posix
    , wait : Int
    , next : Posix
    }



-- DECODERS


decoderLimitedPuzzleData : Decoder LimitedPuzzleData
decoderLimitedPuzzleData =
    Decode.succeed LimitedPuzzleData
        |> required "id" Decode.int
        |> required "theme" decoderThemeData
        |> required "puzzle_set" decoderPuzzleSet
        |> required "image_link" Decode.string
        |> required "title" Decode.string
        |> required "body" Decode.string
        |> required "example" Decode.string
        |> required "statement" Decode.string
        |> required "references" Decode.string
        |> optional "input" (Decode.maybe Decode.string) Nothing


decoderOpenData : Decoder OpenData
decoderOpenData =
    Decode.map2 OpenData
        (Decode.field "complete" (Decode.list decoderLimitedPuzzleData))
        (Decode.field "incomplete" (Decode.list decoderLimitedPuzzleData))


decodeOkSubmit : Decoder OkSubmitData
decodeOkSubmit =
    Decode.map4 OkSubmitData
        (Decode.field "id" Decode.int)
        (Decode.field "submission" Decode.string)
        (Decode.field "is_response_correct" Decode.bool)
        (Decode.field "points" Decode.int)


decodeTooSoonSubmit : Decoder TooSoonSubmitData
decodeTooSoonSubmit =
    Decode.map5 TooSoonSubmitData
        (Decode.field "message" Decode.string)
        (Decode.field "num_attempts" Decode.int)
        (Decode.field "last_submission" Iso8601.decoder)
        (Decode.field "wait_time_seconds" Decode.int)
        (Decode.field "next_allowed" Iso8601.decoder)


decodeSubmissionResponse : Decoder SubmissionResponse
decodeSubmissionResponse =
    Decode.map OkSubmit decodeOkSubmit


encoderSubmission : SelectedPuzzleInfo -> Value
encoderSubmission selectedPuzzle =
    Encode.object
        [ ( "puzzle_id", Encode.int selectedPuzzle.puzzle.id )
        , ( "submission", Encode.string selectedPuzzle.input )
        ]


init : Session -> ( Model, Cmd Msg )
init session =
    case session of
        LoggedIn _ viewer ->
            ( { session = session, state = Unloaded Loading, navActive = False }
            , Api.get "puzzles/active/" (Just <| Viewer.cred viewer) ReceivedOpenData decoderOpenData
            )

        Guest _ ->
            ( { session = session, state = Denied, navActive = False }, Cmd.none )


toSession : Model -> Session
toSession model =
    model.session



-- UPDATE


type Msg
    = GotSession Session
    | ReceivedOpenData (WebData OpenData)
    | ReceivedSubmissionResponse (WebData SubmissionResponse)
    | ClickedPuzzle Bool LimitedPuzzleData
    | ChangedSubmission String
    | ClickedSubmit
    | ClickedBackToFull
    | ToggledNavMenu


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotSession session ->
            ( { model | session = session }, Cmd.none )

        ReceivedOpenData response ->
            case response of
                Success openData ->
                    ( { model | state = Full openData }, Cmd.none )

                _ ->
                    ( { model | state = Unloaded response }, Cmd.none )

        ClickedPuzzle isCompleted puzzle ->
            case model.state of
                Full openData ->
                    ( { model | state = Detail openData { puzzle = puzzle, input = "", isCompleted = isCompleted } NotAsked }, Cmd.none )

                _ ->
                    ( model, Cmd.none )

        ChangedSubmission input ->
            case model.state of
                Detail openData selectedPuzzleInfo submissionResponseWebData ->
                    ( { model | state = Detail openData { selectedPuzzleInfo | input = input } submissionResponseWebData }, Cmd.none )

                _ ->
                    ( model, Cmd.none )

        ClickedSubmit ->
            case model.state of
                Detail openData selectedPuzzleInfo submissionResponseWebData ->
                    ( { model | state = Detail openData selectedPuzzleInfo Loading }
                    , Api.post "submissions/" (Session.cred model.session) ReceivedSubmissionResponse decodeSubmissionResponse (encoderSubmission selectedPuzzleInfo)
                    )

                _ ->
                    ( model, Cmd.none )

        ReceivedSubmissionResponse response ->
            case model.state of
                Detail openData selectedPuzzleInfo submissionResponseWebData ->
                    case response of
                        Success (OkSubmit okSubmitData) ->
                            case okSubmitData.isCorrect of
                                True ->
                                    ( { model | state = Completed selectedPuzzleInfo okSubmitData }, Cmd.none )

                                _ ->
                                    ( { model | state = Detail openData selectedPuzzleInfo response }, Cmd.none )

                        Failure (BadStatus e) ->
                            case e.status.code of
                                412 ->
                                    let
                                        decodedErrorData =
                                            Decode.decodeString decodeTooSoonSubmit e.body
                                    in
                                    case decodedErrorData of
                                        Ok tooSoonData ->
                                            ( { model | state = Detail openData selectedPuzzleInfo (Success (TooSoonSubmit tooSoonData)) }, Cmd.none )

                                        Err _ ->
                                            ( { model | state = Detail openData selectedPuzzleInfo response }, Cmd.none )

                                _ ->
                                    ( { model | state = Detail openData selectedPuzzleInfo response }, Cmd.none )

                        _ ->
                            ( { model | state = Detail openData selectedPuzzleInfo response }, Cmd.none )

                _ ->
                    ( model, Cmd.none )

        ClickedBackToFull ->
            case model.state of
                Detail _ _ Loading ->
                    ( model, Cmd.none )

                Detail openData _ _ ->
                    ( { model | state = Full openData }, Cmd.none )

                Completed selectedPuzzleInfo okSubmitData ->
                    ( { model | state = Unloaded Loading }
                    , Api.get "puzzles/active/" (Session.cred model.session) ReceivedOpenData decoderOpenData
                    )

                _ ->
                    ( model, Cmd.none )

        ToggledNavMenu ->
            ( { model | navActive = not model.navActive }, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Session.changes GotSession (Session.navKey model.session)



-- VIEW


navMenuLinked model body =
    div [] [ lazy3 navMenu ToggledNavMenu model.navActive (Session.viewer model.session), body ]


view : Model -> { title : String, content : Html Msg }
view model =
    { title = "CIGMAH"
    , content = navMenuLinked model <| mainHero model
    }


mainHero model =
    let
        mainBody =
            case model.state of
                Unloaded Loading ->
                    div [ class "pageloader is-active" ] []

                Unloaded _ ->
                    errorPage

                Denied ->
                    whoopsPage

                Full openData ->
                    div [] []

                --puzzleContainer openData
                Detail _ selectedPuzzle submissionResponse ->
                    div [] []

                --detailPuzzleLimited selectedPuzzle ClickedBackToFull ChangedSubmission ClickedSubmit submissionResponse
                Completed selectedPuzzle okSubmitData ->
                    div [] []

        --completedPage selectedPuzzle okSubmitData ClickedBackToFull
    in
    mainBody
