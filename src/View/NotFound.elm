module View.NotFound exposing (body, view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Html.Lazy exposing (..)
import Markdown
import View.NavBar exposing (..)


view model =
    { title = "Page Not Found"
    , body = body model
    }


body model =
    [ lazy2 navBar model.authToken model.navBarMenuActive
    , section [ class "hero is-dark is-fullheight-with-navbar" ]
        [ div [ class "hero-body" ]
            [ div [ class "container" ]
                [ h1 [ class "title" ]
                    [ text "This page doesn't exist." ]
                , h2 [ class "subtitle" ]
                    [ text "We're sorry. Go "
                    , a [ href "/", class "has-text-link" ] [ text "home" ]
                    , text "?"
                    ]
                ]
            ]
        ]
    ]
