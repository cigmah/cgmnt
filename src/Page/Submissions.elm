module Page.Submissions exposing (Model, Msg, init, subscriptions, toSession, update, view)

import Api
import Decoders exposing (decoderPuzzleSet, decoderThemeSet)
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
    | Accepted (WebData SubmissionsData)


type alias SubmissionsData =
    List UserSubmission


type alias UserSubmission =
    { username : String
    , puzzleTitle : String
    , theme : String
    , set : PuzzleSet
    , submissionDatetime : Posix
    , submission : String
    , isCorrect : Bool
    , points : Int
    }


init : Session -> ( Model, Cmd Msg )
init session =
    case session of
        LoggedIn _ viewer ->
            ( { session = session, state = Accepted Loading }
            , Api.get "submissions/user/" (Just <| Viewer.cred viewer) ReceivedData decoderSubmissionsData
            )

        Guest _ ->
            ( { session = session, state = Denied }
            , Cmd.none
            )


decoderUserSubmission : Decoder UserSubmission
decoderUserSubmission =
    Decode.map8 UserSubmission
        (Decode.field "user" <| Decode.field "username" Decode.string)
        (Decode.field "puzzle" <| Decode.field "title" Decode.string)
        (Decode.field "puzzle" <| Decode.field "theme" <| Decode.field "theme" Decode.string)
        (Decode.field "puzzle" <| Decode.field "puzzle_set" decoderPuzzleSet)
        (Decode.field "submission_datetime" Iso8601.decoder)
        (Decode.field "submission" Decode.string)
        (Decode.field "is_response_correct" Decode.bool)
        (Decode.field "points" Decode.int)


decoderSubmissionsData : Decoder SubmissionsData
decoderSubmissionsData =
    Decode.list decoderUserSubmission


toSession : Model -> Session
toSession model =
    model.session



-- UPDATE


type Msg
    = GotSession Session
    | ReceivedData (WebData SubmissionsData)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotSession session ->
            ( { model | session = session }, Cmd.none )

        ReceivedData response ->
            ( { model | state = Accepted response }, Cmd.none )



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
                    [ div [] [ text "Submissions" ]
                    ]
                ]
            ]
        ]
