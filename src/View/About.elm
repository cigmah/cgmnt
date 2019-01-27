module View.About exposing (aboutBox, body, view)

import Content.About as Content
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Html.Lazy exposing (..)
import Markdown
import View.NavBar exposing (navBar)


view model =
    { title = "About CIGMAH"
    , body = body model
    }


aboutBox title textMarkdown =
    article [ class "message is-primary" ]
        [ div [ class "message-header" ]
            [ h2 [ class "has-text-weight-bold" ] [ text title ] ]
        , div
            [ class "message-body" ]
            [ div [ class "content" ] <| Markdown.toHtml Nothing textMarkdown ]
        ]


body model =
    [ lazy2 navBar model.authToken model.navBarMenuActive
    , section [ class "hero is-primary" ]
        [ div [ class "hero-body" ]
            [ div [ class "container" ]
                [ h1 [ class "title" ] [ text "About CIGMAH" ]
                , h2 [ class "subtitle" ] [ text "Frequently Asked Questions" ]
                ]
            ]
        ]
    , section [ class "hero" ]
        [ div [ class "hero-body" ]
            [ div [ class "container" ]
                [ aboutBox "Why should doctors be interested in coding?" Content.whyLearn
                , aboutBox "Shouldn't doctors be concentrating on learning medicine?" Content.butConcentrate
                , aboutBox "What can coding do for doctors?" Content.whatCanDo
                , aboutBox "What does CIGMAH do?" Content.whatCIGMAH
                , aboutBox "What is this website made from?" Content.thisSite
                ]
            ]
        ]
    ]
