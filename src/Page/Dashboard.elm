module Page.Dashboard exposing (Model, Msg, init, subscriptions, toSession, update, view)

import Api
import Decoders exposing (decoderThemeData)
import Html exposing (Html, div, h1, text)
import Html.Attributes exposing (class)
import Html.Lazy exposing (..)
import Json.Decode as Decode
import Page.Nav exposing (navMenu)
import RemoteData exposing (RemoteData(..), WebData)
import Session exposing (Session(..))
import Types exposing (..)
import Viewer



-- MODEL


type alias Model =
    { session : Session
    , state : State
    , navActive : Bool
    }


type State
    = Denied
    | Accepted (WebData DashData)


type alias DashData =
    { numSolved : Int
    , currentThemes : List ThemeData
    , nextTheme : ThemeData
    , totalPoints : Int
    }


decoderDashData =
    Decode.map4 DashData
        (Decode.field "num_solved" Decode.int)
        (Decode.field "current" <| Decode.list decoderThemeData)
        (Decode.field "next" decoderThemeData)
        (Decode.field "total" Decode.int)


init : Session -> ( Model, Cmd Msg )
init session =
    case session of
        LoggedIn _ viewer ->
            ( { session = session, state = Accepted Loading, navActive = False }
            , Api.get "dashboard/" (Just <| Viewer.cred viewer) ReceivedData decoderDashData
            )

        Guest _ ->
            ( { session = session, state = Denied, navActive = False }
            , Cmd.none
            )


toSession : Model -> Session
toSession model =
    model.session



-- UPDATE


type Msg
    = GotSession Session
    | ReceivedData (WebData DashData)
    | ToggledNavMenu


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ReceivedData response ->
            ( { model | state = Accepted response }, Cmd.none )

        GotSession session ->
            ( { model | session = session }, Cmd.none )

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
    { title = "Puzzle Hunt Dashboard"
    , content = navMenuLinked model <| mainHero
    }


mainHero =
    div [ class "hero is-primary is-fullheight-with-navbar" ]
        [ div [ class "hero-body" ]
            [ div [ class "container" ]
                [ div [ class "columns is-multiline" ]
                    [ div [] [ text "Dashboard" ]
                    ]
                ]
            ]
        ]
