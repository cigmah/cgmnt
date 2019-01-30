module Page.Resources exposing (Model, Msg, init, subscriptions, toSession, update, view)

import Html exposing (Html, div, h1, text)
import Html.Attributes exposing (class)
import Html.Lazy exposing (..)
import Page.Nav exposing (navMenu)
import Session exposing (Session)



-- MODEL


type alias Model =
    { session : Session
    , navActive : Bool
    }


init : Session -> ( Model, Cmd Msg )
init session =
    ( { session = session, navActive = False }
    , Cmd.none
    )


toSession : Model -> Session
toSession model =
    model.session


type Msg
    = ToggledNavMenu



-- UPDATE


update msg model =
    case msg of
        ToggledNavMenu ->
            ( { model | navActive = not model.navActive }, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub ()
subscriptions model =
    Sub.none



-- VIEW


navMenuLinked model body =
    div [] [ lazy3 navMenu ToggledNavMenu model.navActive (Session.viewer model.session), body ]


view model =
    { title = "Resources"
    , content = navMenuLinked model <| div [] [ h1 [] [ text "This is the resources page." ] ]
    }
