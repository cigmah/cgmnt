module Page.Register exposing (Model, Msg, init, subscriptions, toSession, update, view)

import Api
import Decoders exposing (decoderThemeData)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Lazy exposing (..)
import Json.Decode as Decode
import Json.Encode as Encode
import Page.Error exposing (..)
import Page.Nav exposing (navMenu)
import RemoteData exposing (RemoteData(..), WebData)
import Session exposing (Session(..))
import Types exposing (..)
import Utils
import Viewer



-- MODEL


type alias Model =
    { session : Session
    , state : State
    , navActive : Bool
    }


type alias RegisterInfo =
    { username : String
    , email : String
    , firstName : String
    , lastName : String
    }


type State
    = NewUser RegisterInfo (WebData Response)
    | AlreadyUser


init : Session -> ( Model, Cmd Msg )
init session =
    case session of
        LoggedIn _ viewer ->
            ( { session = session, state = AlreadyUser, navActive = False }
            , Cmd.none
            )

        Guest _ ->
            ( { session = session
              , state = NewUser { username = "", email = "", firstName = "", lastName = "" } NotAsked
              , navActive = False
              }
            , Cmd.none
            )


toSession : Model -> Session
toSession model =
    model.session


decoderRegister =
    Decode.succeed "Registration was succesful!"


encoderRegister : RegisterInfo -> Encode.Value
encoderRegister registerInfo =
    Encode.object
        [ ( "username", Encode.string registerInfo.username )
        , ( "email", Encode.string registerInfo.email )
        , ( "first_name", Encode.string registerInfo.firstName )
        , ( "last_name", Encode.string registerInfo.lastName )
        ]


type alias Response =
    String


type Msg
    = ChangeRegisterUsername String
    | ChangeRegisterEmail String
    | ChangeRegisterFirstName String
    | ChangeRegisterLastName String
    | ClickedRegister
    | ToggledNavMenu
    | ReceivedRegisterResponse (WebData Response)
    | GotSession Session


update msg model =
    case ( msg, model.state ) of
        ( _, NewUser _ (Success _) ) ->
            ( model, Cmd.none )

        ( _, AlreadyUser ) ->
            ( model, Cmd.none )

        ( ChangeRegisterUsername input, NewUser info webData ) ->
            ( { model | state = NewUser { info | username = input } webData }, Cmd.none )

        ( ChangeRegisterEmail input, NewUser info webData ) ->
            ( { model | state = NewUser { info | email = input } webData }, Cmd.none )

        ( ChangeRegisterFirstName input, NewUser info webData ) ->
            ( { model | state = NewUser { info | firstName = input } webData }, Cmd.none )

        ( ChangeRegisterLastName input, NewUser info webData ) ->
            ( { model | state = NewUser { info | lastName = input } webData }, Cmd.none )

        ( ClickedRegister, NewUser info webData ) ->
            ( { model | state = NewUser info Loading }
            , Api.post "users/" (Session.cred model.session) ReceivedRegisterResponse decoderRegister (encoderRegister info)
            )

        ( ToggledNavMenu, _ ) ->
            ( { model | navActive = not model.navActive }, Cmd.none )

        ( ReceivedRegisterResponse response, NewUser info _ ) ->
            ( { model | state = NewUser info response }, Cmd.none )

        ( GotSession session, _ ) ->
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
    { title = "Puzzle Hunt Dashboard"
    , content = navMenuLinked model <| mainHero model
    }


mainHero model =
    div [] []
