module Page.Dashboard exposing (Model, Msg, init, subscriptions, toSession, update, view)

import Api
import Decoders exposing (decoderThemeData)
import Html exposing (Html, div, h1, text)
import Html.Attributes exposing (class)
import Json.Decode as Decode
import RemoteData exposing (RemoteData(..), WebData)
import Session exposing (Session(..))
import Types exposing (..)
import Viewer



-- MODEL


type alias Model =
    { session : Session
    , state : State
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
            ( { session = session, state = Accepted Loading }
            , Api.get "dashboard/" (Just <| Viewer.cred viewer) ReceivedData decoderDashData
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
    | ReceivedData (WebData DashData)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ReceivedData response ->
            ( { model | state = Accepted response }, Cmd.none )

        GotSession session ->
            ( { model | session = session }, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Session.changes GotSession (Session.navKey model.session)



-- VIEW


view : Model -> { title : String, content : Html Msg }
view model =
    { title = "Puzzle Hunt Dashboard"
    , content = mainHero
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
