module NotFound.Components exposing (viewNotFound)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Markdown
import Shared.Components exposing (navBar)


viewNotFound model =
    { title = "Page Not Found"
    , body = bodyNotFound model
    }


bodyNotFound model =
    [ navBar model
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
