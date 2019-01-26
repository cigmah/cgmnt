module View.Contact exposing (body, view)

import Content.Contact as Content
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Markdown
import View.NavBar exposing (navBar)


view model =
    { title = "Contact CIGMAH"
    , body = body model
    }


body model =
    [ navBar model
    , section [ class "hero is-primary" ]
        [ div [ class "hero-body" ]
            [ div [ class "container" ]
                [ h1 [ class "title" ]
                    [ text "Contact Us" ]
                , h2 [ class "subtitle" ]
                    [ text "Questions, Issues, Suggestions etc." ]
                ]
            ]
        ]
    , section [ class "hero" ]
        [ div [ class "hero-body" ]
            [ div [ class "message container is-info" ]
                [ div [ class "message-header" ]
                    [ h2 [] [ text "Contact Email" ] ]
                , div [ class "message-body" ]
                    [ div [ class "content" ]
                        [ text "Drop us a line at ", a [ href "mailto:cigmah.contact@gmail.com" ] [ text "cigmah.contact@gmail.com" ], text "." ]
                    , div [ class "content" ] [ text "We'd love to hear from you!" ]
                    ]
                ]
            , div [ class "message container is-danger" ]
                [ div [ class "message-header" ]
                    [ h2 [] [ text "Help Wanted!" ] ]
                , div [ class "message-body" ]
                    [ div [ class "content" ] <| Markdown.toHtml Nothing Content.helpWanted
                    ]
                ]
            ]
        ]
    ]
