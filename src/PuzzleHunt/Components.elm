module PuzzleHunt.Components exposing (viewPuzzleHuntInfo)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Markdown
import PuzzleHunt.Content as Content
import Shared.Components exposing (navBar)
import Shared.Types exposing (LoginEvent(..), Msg(..), RegisterEvent(..))


viewPuzzleHuntInfo model =
    { title = "CIGMAH PuzzleHunt"
    , body = bodyPuzzleHuntInfo model
    }


bodyPuzzleHuntInfo model =
    [ navBar model
    , registerModal model
    , loginModal model
    , section [ class "hero is-dark is-fullheight-with-navbar" ]
        [ div [ class "hero-body" ]
            [ div [ class "container" ]
                [ h1 [ class "title" ]
                    [ text "CIGMAH Puzzle Hunt 2019" ]
                , h2 [ class "subtitle" ]
                    [ text "Testing Phase" ]
                , div [ class "buttons has-addons" ]
                    [ span [ class "button is-large is-dark is-inverted is-outlined", onClick <| RegisterMsg ToggleRegisterModal ]
                        [ text "Register" ]
                    , span [ class "button is-large is-dark is-inverted is-outlined", onClick <| LoginMsg ToggleLoginModal ]
                        [ text "Login" ]
                    ]
                ]
            ]
        ]
    , section [ class "hero" ]
        [ div [ class "hero-body" ]
            [ div [ class "container" ]
                [ div []
                    [ div [ class "content" ] <| Markdown.toHtml Nothing Content.puzzleHuntIntroText ]
                ]
            ]
        ]
    , section [ class "hero" ]
        [ div [ class "hero-body" ]
            [ div [ class "message container is-danger" ]
                [ div [ class "message-header" ]
                    [ h2 [] [ text "Never coded before?" ] ]
                , div [ class "message-body" ] [ div [ class "content" ] <| Markdown.toHtml Nothing Content.neverCodedText ]
                ]
            ]
        ]
    ]


registerModal model =
    let
        modalClass =
            case model.registerInformation of
                Just _ ->
                    "modal is-active"

                Nothing ->
                    "modal"
    in
    div [ class modalClass ]
        [ div [ class "modal-background", onClick <| RegisterMsg ToggleRegisterModal ] []
        , div [ class "modal-content" ] [ registerForm model ]
        , button [ class "modal-close is-large", onClick <| RegisterMsg ToggleRegisterModal ] []
        ]


registerForm model =
    let
        registerParams =
            case model.registerInformation of
                Just info ->
                    info

                Nothing ->
                    { username = "", email = "", firstName = "", lastName = "" }
    in
    div [ class "card" ]
        [ div [ class "card-header has-background-danger" ] [ span [ class "card-header-title has-text-white" ] [ text "User Registration" ] ]
        , div [ class "card-content" ]
            [ div [ class "field" ]
                [ label [ class "label" ] [ text "Username" ]
                , div [ class "control" ]
                    [ input
                        [ class "input"
                        , type_ "text"
                        , placeholder "e.g. bms_intern"
                        , value registerParams.username
                        , onInput <| RegisterMsg << OnChangeRegisterUsername
                        ]
                        []
                    ]
                ]
            , div [ class "field" ]
                [ label [ class "label" ] [ text "Email" ]
                , div [ class "control" ]
                    [ input
                        [ class "input"
                        , type_ "text"
                        , placeholder "e.g. roy.basch@bestmedicalschool.com"
                        , value registerParams.email
                        , onInput <| RegisterMsg << OnChangeRegisterEmail
                        ]
                        []
                    ]
                ]
            , div [ class "field" ]
                [ label [ class "label" ] [ text "First Name" ]
                , div [ class "control" ]
                    [ input
                        [ class "input"
                        , type_ "text"
                        , placeholder "e.g. Roy"
                        , value registerParams.firstName
                        , onInput <| RegisterMsg << OnChangeRegisterFirstName
                        ]
                        []
                    ]
                ]
            , div [ class "field" ]
                [ label [ class "label" ] [ text "Last Name" ]
                , div [ class "control" ]
                    [ input
                        [ class "input"
                        , type_ "text"
                        , placeholder "e.g. Basch"
                        , value registerParams.lastName
                        , onInput <| RegisterMsg << OnChangeRegisterLastName
                        ]
                        []
                    ]
                ]
            ]
        , footer [ class "card-footer" ]
            [ div [ class "card-footer-item" ]
                [ button [ class "button is-medium is-fullwidth is-danger is-outlined" ] [ text "Register" ] ]
            ]
        ]


loginModal model =
    let
        modalClass =
            case model.loginInformation of
                Just _ ->
                    "modal is-active"

                Nothing ->
                    "modal"
    in
    div [ class modalClass ]
        [ div [ class "modal-background", onClick <| LoginMsg ToggleLoginModal ] []
        , div [ class "modal-content" ] [ loginForm model ]
        , button [ class "modal-close is-large", onClick <| LoginMsg ToggleLoginModal ] []
        ]


loginForm model =
    let
        loginParams =
            case model.loginInformation of
                Just info ->
                    info

                Nothing ->
                    { email = "", token = "" }
    in
    div [ class "card" ]
        [ div [ class "card-header has-background-info" ] [ span [ class "card-header-title has-text-white" ] [ text "User Login" ] ]
        , div [ class "card-content" ]
            [ div [ class "field" ]
                [ label [ class "label" ] [ text "Email" ]
                , div [ class "field has-addons" ]
                    [ div [ class "control is-expanded" ]
                        [ input
                            [ class "input"
                            , type_ "text"
                            , placeholder "e.g. roy.basch@bestmedicalschool.com"
                            , value loginParams.email
                            , onInput <| LoginMsg << OnChangeLoginEmail
                            ]
                            []
                        ]
                    , div [ class "control" ]
                        [ button [ class "button is-info is-outlined" ] [ text "Send Token" ]
                        ]
                    ]
                ]
            , div [ class "field" ]
                [ label [ class "label" ] [ text "Token" ]
                , div [ class "control" ]
                    [ input
                        [ class "input"
                        , type_ "text"
                        , placeholder "e.g. 000000"
                        , value loginParams.token
                        , onInput <| LoginMsg << OnChangeLoginToken
                        ]
                        []
                    ]
                ]
            ]
        , footer [ class "card-footer" ]
            [ div [ class "card-footer-item" ]
                [ button [ class "button is-medium is-fullwidth is-info is-outlined" ] [ text "Login" ] ]
            ]
        ]
