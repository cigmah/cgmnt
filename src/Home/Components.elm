module Home.Components exposing (viewHome)

import Home.Content as Content
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Markdown
import Shared.Components exposing (navBar)


viewHome model =
    { title = "CIGMAH - Coding Interest Group in Medicine and Healthcare"
    , body = bodyHome model
    }


bodyHome model =
    [ navBar model
    , section [ class "hero is-primary is-fullheight-with-navbar" ]
        [ div [ class "hero-body" ]
            [ div [ class "container" ]
                [ h1 [ class "title" ]
                    [ text "CIGMAH" ]
                , h2 [ class "subtitle" ]
                    [ text "Coding Interest Group in Medicine And Healthcare" ]
                , div [ class "message" ]
                    [ div [ class "message-body content" ] <|
                        Markdown.toHtml
                            Nothing
                            Content.homeIntroText
                    ]
                , div [ class "message is-info" ]
                    [ div [ class "message-header" ]
                        [ text "News [2019-01-21]"
                        , span [ class "icon" ] [ i [ class "fas fa-info-circle" ] [] ]
                        ]
                    , div [ class "message-body content" ] <|
                        Markdown.toHtml Nothing Content.homeNotification
                    ]
                ]
            ]
        ]
    ]
