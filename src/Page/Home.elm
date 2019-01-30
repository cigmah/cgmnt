module Page.Home exposing (Model, Msg, init, subscriptions, toSession, update, view)

import Api
import Html exposing (Html, div, h1, text)
import Html.Attributes exposing (class)
import Json.Decode as Decode exposing (Decoder)
import Json.Encode as Encode
import RemoteData exposing (RemoteData(..), WebData)
import Session exposing (Session)



-- MODEL


type alias Model =
    { session : Session
    , username : String
    , email : String
    , firstName : String
    , lastName : String
    , response : WebData Response
    }


type alias Response =
    String


init : Session -> ( Model, Cmd Msg )
init session =
    ( { session = session
      , username = ""
      , email = ""
      , firstName = ""
      , lastName = ""
      , response = NotAsked
      }
    , Cmd.none
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
    | GotSession Session


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ChangeRegisterUsername input ->
            ( { model | username = input }, Cmd.none )

        ChangeRegisterEmail input ->
            ( { model | email = input }, Cmd.none )

        ClickedRegister ->
            case model.response of
                Success _ ->
                    ( model, Cmd.none )

                _ ->
                    ( { model | response = Loading }
                    , Api.post "users/" (Session.cred model.session) ReceivedRegisterResponse decoderRegister (encoderRegister model)
                    )

        ReceivedRegisterResponse response ->
            ( { model | response = response }, Cmd.none )

        GotSession session ->
            ( { model | session = session }, Cmd.none )



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
