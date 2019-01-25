module About.Components exposing (aboutBox, bodyAbout, viewAbout)

import About.Content as Content
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Markdown
import Shared.Components exposing (navBar)


viewAbout model =
    { title = "About CIGMAH"
    , body = bodyAbout model
    }


aboutBox title textMarkdown =
    article [ class "message is-primary" ]
        [ div [ class "message-header" ]
            [ h2 [ class "has-text-weight-bold" ] [ text title ] ]
        , div
            [ class "message-body" ]
            [ div [ class "content" ] <| Markdown.toHtml Nothing textMarkdown ]
        ]


bodyAbout model =
    [ navBar model
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
