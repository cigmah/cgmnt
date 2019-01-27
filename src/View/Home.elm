module View.Home exposing (view)

import Content.Home as Content
import Functions.Functions exposing (timeStringWithDefault)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Markdown
import Time exposing (Posix, millisToPosix)
import View.NavBar exposing (navBar)


view model =
    { title = "CIGMAH Puzzle Hunt 2019"
    , body = body model
    }


body model =
    let
        -- Hard coded for now, corresponds to 2019/09/21 5PM AEST
        endTime =
            millisToPosix 1569049200000

        tagline =
            case model.currentTime of
                Just currentTime ->
                    timeStringWithDefault currentTime endTime "The Hunt has ended." "The Hunt ends in "

                Nothing ->
                    "Getting the time..."
    in
    [ navBar model
    , section [ class "hero is-dark is-fullheight-with-navbar" ]
        [ div [ class "hero-body" ]
            [ div [ class "container has-text-centered" ]
                [ h1 [ class "title " ]
                    [ text tagline ]
                , h2 [ class "subtitle" ]
                    [ text "Coding Interest Group in Medicine And Healthcare Puzzle Hunt 2019" ]
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
