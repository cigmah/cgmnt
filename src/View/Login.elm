module View.Login exposing (form, modal)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Msg.Msg exposing (..)
import Types.Init as Init
import Types.Types exposing (..)


modal model =
    let
        modalClass =
            case model.loginInformation of
                Just _ ->
                    "modal is-active"

                Nothing ->
                    "modal"
    in
    div [ class modalClass ]
        [ div [ class "modal-background", onClick <| DashMsg <| LoginMsg ToggleLoginModal ] []
        , div [ class "modal-content" ] [ form model ]
        , button [ class "modal-close is-large", onClick <| DashMsg <| LoginMsg ToggleLoginModal ] []
        ]


form model =
    let
        loginParams =
            case model.loginInformation of
                Just info ->
                    info

                Nothing ->
                    Init.login

        loadingSendTokenClass =
            case loginParams.isLoadingSendToken of
                True ->
                    " is-loading "

                False ->
                    ""

        loadingLoginClass =
            case loginParams.isLoadingLogin of
                True ->
                    " is-loading "

                False ->
                    ""

        sendTokenResponse =
            case loginParams.sendTokenResponse of
                Just _ ->
                    { class = " is-success ", text = "Sent!" }

                Nothing ->
                    { class = " is-info is-outlined ", text = "Send Token" }

        notification =
            case loginParams.message of
                Just message ->
                    div [ class <| "notification has-text-centered is-danger" ]
                        [ text message
                        ]

                Nothing ->
                    div [] []
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
                            , onInput <| DashMsg << LoginMsg << OnChangeLoginEmail
                            ]
                            []
                        ]
                    , div [ class "control" ]
                        [ button
                            [ class <| "button " ++ loadingSendTokenClass ++ sendTokenResponse.class
                            , onClick <| DashMsg <| LoginMsg OnSendToken
                            ]
                            [ text sendTokenResponse.text ]
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
                        , onInput <| DashMsg << LoginMsg << OnChangeLoginToken
                        ]
                        []
                    ]
                ]
            , notification
            ]
        , footer [ class "card-footer" ]
            [ div [ class "card-footer-item" ]
                [ button
                    [ class <| "button is-medium is-fullwidth is-info is-outlined" ++ loadingLoginClass
                    , onClick <| DashMsg <| LoginMsg OnLogin
                    ]
                    [ text "Login" ]
                ]
            ]
        ]
