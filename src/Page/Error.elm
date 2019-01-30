module Page.Error exposing (errorPage, whoopsPage)

import Html exposing (..)
import Html.Attributes exposing (..)


whoopsPage =
    div [ class "hero is-fullheight-with-navbar" ]
        [ div [ class "hero-body" ]
            [ div [ class "container" ]
                [ h1 [ class "title" ] [ text "Whoops!" ]
                , h2 [ class "subtitle" ] [ text "You need to be logged in to see this page." ]
                ]
            ]
        ]


errorPage =
    div [ class "hero is-fullheight-with-navbar" ]
        [ div [ class "hero-body" ]
            [ div [ class "container" ]
                [ h1 [ class "title" ] [ text "Whoops!" ]
                , h2 [ class "subtitle" ] [ text "There was an error when loading this data. Contact us!" ]
                ]
            ]
        ]
