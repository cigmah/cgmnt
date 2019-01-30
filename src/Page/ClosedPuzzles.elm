module Page.ClosedPuzzles exposing (Model, Msg, init, subscriptions, toSession, update, view)

import Api
import Decoders exposing (decoderArchiveData)
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
    | Accepted (WebData ClosedData)


type alias ClosedData =
    { complete : ArchiveData
    , incomplete : ArchiveData
    }



-- DECODERS


decoderClosedData : Decoder ClosedData
decoderClosedData =
    Decode.map2 ClosedData
        (Decode.field "complete" decoderArchiveData)
        (Decode.field "incomplete" decoderArchiveData)


init : Session -> ( Model, Cmd Msg )
init session =
    case session of
        LoggedIn _ viewer ->
            ( { session = session, state = Accepted Loading }
            , Api.get "puzzles/inactive/" (Just <| Viewer.cred viewer) ReceivedClosedData decoderClosedData
            )

        Guest _ ->
            ( { session = session, state = Denied }
            , Cmd.none
            )


toSession : Model -> Session
toSession model =
    model.session



-- UPDATE


type Msg
    = GotSession Session
    | ReceivedClosedData (WebData ClosedData)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotSession session ->
            ( { model | session = session }, Cmd.none )

        ReceivedClosedData response ->
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
                    [ div [] [ text "TEST" ]
                    ]
                ]
            ]
        ]
