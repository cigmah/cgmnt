module Page.OpenPuzzles exposing (Model, Msg, init, subscriptions, toSession, update, view)

import Api
import Decoders exposing (decodePuzzleSet, decodeThemeData)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Html.Lazy exposing (..)
import Iso8601
import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline exposing (optional, required)
import Json.Encode as Encode
import RemoteData exposing (RemoteData(..), WebData)
import Session exposing (Session(..))
import Time exposing (Posix)
import Types exposing (..)
import Viewer exposing (Viewer(..))



-- MODEL


type alias Model =
    { session : Session
    , state : State
    }


type State
    = Denied
    | Unloaded (WebData OpenData)
    | Full OpenData
    | Detail OpenData SelectedPuzzleInfo (WebData SubmissionResponse)
    | Completed OpenData SelectedPuzzleInfo OkSubmitData


type alias OpenData =
    { complete : List LimitedPuzzleData
    , incomplete : List LimitedPuzzleData
    }


type alias SelectedPuzzleInfo =
    { puzzle : LimitedPuzzleData
    , input : String
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
        |> required "theme" decodeThemeData
        |> required "puzzle_set" decodePuzzleSet
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


init : Session -> ( Model, Cmd Msg )
init session =
    case session of
        LoggedIn _ viewer ->
            ( { session = session, state = Unloaded Loading }
            , Api.get "puzzles/active/" (Just <| Viewer.cred viewer) ReceivedOpenData decoderOpenData
            )

        Guest _ ->
            ( { session = session, state = Denied }, Cmd.none )


toSession : Model -> Session
toSession model =
    model.session



-- UPDATE


type Msg
    = GotSession Session
    | ReceivedOpenData (WebData OpenData)


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



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Session.changes GotSession (Session.navKey model.session)



-- VIEW


view : Model -> { title : String, content : Html Msg }
view model =
    { title = "CIGMAH"
    , content = mainHero
    }


mainHero =
    div [ class "hero is-primary is-fullheight-with-navbar" ]
        [ div [ class "hero-body" ]
            [ div [ class "container" ]
                [ div [ class "columns is-multiline" ]
                    [ div [] [ text "OPEN PUZZLE PLACEHOLDER" ]
                    ]
                ]
            ]
        ]
