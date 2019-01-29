module Page.Resources exposing (Model, init, subscriptions, toSession, view)

import Html exposing (Html, div, h1, text)
import Html.Attributes exposing (class)
import Session exposing (Session)



-- MODEL


type alias Model =
    Session


init : Session -> ( Model, Cmd () )
init session =
    ( session
    , Cmd.none
    )


toSession : Model -> Session
toSession session =
    session



-- UPDATE
-- SUBSCRIPTIONS


subscriptions : Model -> Sub ()
subscriptions model =
    Sub.none



-- VIEW


view : { title : String, content : Html () }
view =
    { title = "Resources"
    , content = div [] [ h1 [] [ text "This is the resources page." ] ]
    }
