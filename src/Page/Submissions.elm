module Page.Submissions exposing (Model, Msg, init, subscriptions, toSession, update, view)

import Html exposing (Html, div, h1, text)
import Html.Attributes exposing (class)
import RemoteData exposing (RemoteData(..), WebData)
import Session exposing (Session)



-- MODEL


type alias Model =
    { session : Session
    }


init : Session -> ( Model, Cmd Msg )
init session =
    ( { session = session }
    , Cmd.none
    )


toSession : Model -> Session
toSession model =
    model.session



-- UPDATE


type Msg
    = GotSession Session


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
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
                    [ div [] [ text "TEST" ]
                    ]
                ]
            ]
        ]
