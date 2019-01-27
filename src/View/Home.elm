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
                    timeStringWithDefault currentTime endTime "The Puzzle Hunt has ended." "The Puzzle Hunt ends in "

                Nothing ->
                    "Getting the time..."
    in
    [ navBar model
    , section [ class "hero is-dark is-fullheight-with-navbar" ]
        [ div [ class "hero-body" ]
            [ div [ class "container" ]
                [ h1 [ class "title has-text-centered is-family-monospace" ]
                    [ text tagline ]
                , h2 [ class "subtitle has-text-centered" ]
                    [ text "Coding Interest Group in Medicine And Healthcare Puzzle Hunt 2019" ]
                , div [ class "columns is-centered" ]
                    [ div [ class "column has-background-dark is-two-thirds" ]
                        [ div [ class "card" ]
                            [ div [ class "card-header" ] [ span [ class "card-header-title has-text-weight-light is-centered has-text-centered" ] [ text "Want to enter? Registration is free, and we only require a username and email." ] ]
                            , div [ class "card-content" ]
                                [ div [ class "field is-horizontal" ]
                                    [ div [ class "field-label is-normal" ]
                                        [ label [ class "label" ] [ text "Username*" ] ]
                                    , div [ class "field-body  is-expanded" ]
                                        [ div [ class "field" ]
                                            [ div [ class "control is-expanded" ]
                                                [ input [ class "input", type_ "text", placeholder "bms_intern" ]
                                                    []
                                                ]
                                            ]
                                        ]
                                    ]
                                , div [ class "field is-horizontal" ]
                                    [ div [ class "field-label is-normal" ]
                                        [ label [ class "label" ] [ text "Email*" ] ]
                                    , div [ class "field-body" ]
                                        [ div [ class "field" ]
                                            [ div [ class "control" ]
                                                [ input [ class "input", type_ "text", placeholder "roy.basch@bestmedicalschool.com" ]
                                                    []
                                                ]
                                            ]
                                        ]
                                    ]
                                , div [ class "field is-horizontal" ]
                                    [ div [ class "field-label is-normal" ] [ label [ class "label" ] [ text "Name" ] ]
                                    , div [ class "field-body" ]
                                        [ div [ class "field " ]
                                            [ div [ class "control" ]
                                                [ input [ class "input", type_ "text", placeholder "Roy" ]
                                                    []
                                                ]
                                            ]
                                        , div [ class "field" ]
                                            [ div [ class "control" ]
                                                [ input [ class "input", type_ "text", placeholder "Basch" ]
                                                    []
                                                ]
                                            ]
                                        ]
                                    ]
                                , div [ class "field is-horizontal" ]
                                    [ div [ class "field-body" ]
                                        [ div [ class "field " ]
                                            [ div [ class "control" ]
                                                [ button [ class "button is-medium is-danger is-fullwidth" ]
                                                    [ text "Register" ]
                                                ]
                                            ]
                                        ]
                                    ]
                                ]
                            ]
                        ]
                    ]
                ]
            ]
        ]
    ]
