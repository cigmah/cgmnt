module Page.Home exposing (Model, Msg, init, subscriptions, toSession, update, view)

import Api
import Decoders exposing (decoderLeaderTotal)
import Html exposing (Html, div, h1, text)
import Html.Attributes exposing (class)
import Html.Lazy exposing (..)
import Json.Decode as Decode exposing (Decoder)
import Json.Encode as Encode
import Page.Nav exposing (navMenu)
import RemoteData exposing (RemoteData(..), WebData)
import Session exposing (Session)
import Types exposing (..)



-- MODEL


type alias Model =
    { session : Session
    , navActive : Bool
    , username : String
    , email : String
    , firstName : String
    , lastName : String
    , miniLeader : WebData LeaderTotalData
    , registerResponse : WebData Response
    }


type alias Response =
    String


init : Session -> ( Model, Cmd Msg )
init session =
    ( { session = session
      , navActive = False
      , username = ""
      , email = ""
      , firstName = ""
      , lastName = ""
      , miniLeader = Loading
      , registerResponse = NotAsked
      }
    , Api.get "submissions/leaderboard/mini/" Nothing ReceivedMiniLeader decoderLeaderTotal
    )


decoderRegister =
    Decode.succeed "Registration was succesful!"


encoderRegister : Model -> Encode.Value
encoderRegister model =
    Encode.object
        [ ( "username", Encode.string model.username )
        , ( "email", Encode.string model.email )
        , ( "first_name", Encode.string model.firstName )
        , ( "last_name", Encode.string model.lastName )
        ]


toSession : Model -> Session
toSession model =
    model.session



-- UPDATE


type Msg
    = ChangeRegisterUsername String
    | ChangeRegisterEmail String
    | ClickedRegister
    | ReceivedRegisterResponse (WebData Response)
    | ReceivedMiniLeader (WebData LeaderTotalData)
    | GotSession Session
    | ToggledNavMenu


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ChangeRegisterUsername input ->
            ( { model | username = input }, Cmd.none )

        ChangeRegisterEmail input ->
            ( { model | email = input }, Cmd.none )

        ClickedRegister ->
            case model.registerResponse of
                Success _ ->
                    ( model, Cmd.none )

                _ ->
                    ( { model | registerResponse = Loading }
                    , Api.post "users/" (Session.cred model.session) ReceivedRegisterResponse decoderRegister (encoderRegister model)
                    )

        ReceivedRegisterResponse response ->
            ( { model | registerResponse = response }, Cmd.none )

        ReceivedMiniLeader response ->
            ( { model | miniLeader = response }, Cmd.none )

        ToggledNavMenu ->
            ( { model | navActive = not model.navActive }, Cmd.none )

        GotSession session ->
            ( { model | session = session }, Cmd.none )



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
    , content = navMenuLinked model <| mainHero
    }


mainHero =
    div [ class "hero is-primary is-fullheight-with-navbar" ]
        [ div [ class "hero-body" ]
            [ div [ class "container" ]
                [ div [ class "columns is-multiline" ]
                    [ tableColumn
                    , registerColumn
                    ]
                ]
            ]
        ]


tableColumn =
    div [ class "column" ]
        [ div [ class "title" ] [ text "Leaderboard" ] ]


registerColumn =
    div [ class "column" ]
        [ div [ class "title" ] [ text "Registration" ] ]
