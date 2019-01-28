module View.LoginAuth exposing (view)

import Functions.Functions exposing (safeOnSubmit)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Html.Lazy exposing (..)
import Msg.Msg exposing (..)
import RemoteData exposing (RemoteData(..), WebData)
import Types.Init as Init
import Types.Types exposing (..)
import View.NavBar exposing (navBar)


view meta authToken =
    { title = "Puzzle Hunt Login"
    , body = body meta authToken
    }


body meta authToken =
    [ lazy2 navBar meta.authToken meta.navBarMenuActive
    , section [ class "hero is-primary is-fullheight-with-navbar" ]
        [ div [ class "hero-body" ]
            [ div [ class "container" ]
                [ h2 [ class "subtitle has-text-centered" ]
                    [ text "Puzzle Hunt 2019" ]
                , h1 [ class "title has-text-centered" ] [ text "You are logged in." ]
                , h2 [ class "subtitle has-text-centered" ] [ text "Click on the puzzles menu to start puzzling!" ]
                ]
            ]
        ]
    ]
