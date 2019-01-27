module View.Archive exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Html.Lazy exposing (..)
import Msg.Msg exposing (..)
import RemoteData exposing (WebData)
import Types.Types exposing (..)
import View.NavBar exposing (navBar)


view model =
    { title = "Puzzle Archive"
    , body = body model
    }


body : Model -> List (Html Msg)
body model =
    [ lazy2 navBar model.authToken model.navBarMenuActive
    , div [] []
    ]
