module PuzzleHunt.Components exposing (viewPuzzleHunt)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Markdown
import PuzzleHunt.Content as Content
import Shared.Components exposing (navBar)
import Shared.Init exposing (emptyLogin, emptyRegister)
import Shared.Types exposing (LoginEvent(..), Msg(..), RegisterEvent(..))


viewPuzzleHunt model =
    case model.authToken of
        Nothing ->
            { title = "CIGMAH PuzzleHunt"
            , body = bodyPuzzleHunt model
            }

        Just token ->
            { title = "PuzzleHunt Portal"
            , body = [ navBar model, div [] [ text <| "PLACEHOLDER FOR PORTAL. DEBUG TOKEN IS " ++ token ] ]
            }


bodyPuzzleHunt model =
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
                    emptyRegister

        registerColour =
            case registerParams.response of
                Just _ ->
                    "success"

                Nothing ->
                    "danger"

        loadingStatus =
            case registerParams.isLoading of
                True ->
                    "is-loading"

                False ->
                    ""

        errorStatus =
            case registerParams.message of
                Just message ->
                    div [ class <| "notification has-text-centered is-" ++ registerColour ]
                        [ text message
                        ]

                Nothing ->
                    div [] []

        maybeFooter =
            case registerParams.response of
                Just _ ->
                    div [] []

                Nothing ->
                    footer [ class "card-footer" ]
                        [ div [ class "card-footer-item" ]
                            [ button
                                [ class <| "button is-medium is-fullwidth is-outlined is-" ++ registerColour ++ " " ++ loadingStatus
                                , onClick <| RegisterMsg OnRegister
                                ]
                                [ text "Register" ]
                            ]
                        ]
    in
    div [ class "card" ]
        [ div [ class <| "card-header has-background-" ++ registerColour ] [ span [ class "card-header-title has-text-white" ] [ text "User Registration" ] ]
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
            , errorStatus
            ]
        , maybeFooter
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
                    emptyLogin

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
                            , onInput <| LoginMsg << OnChangeLoginEmail
                            ]
                            []
                        ]
                    , div [ class "control" ]
                        [ button
                            [ class <| "button " ++ loadingSendTokenClass ++ sendTokenResponse.class
                            , onClick <| LoginMsg OnSendToken
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
                        , onInput <| LoginMsg << OnChangeLoginToken
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
                    , onClick <| LoginMsg OnLogin
                    ]
                    [ text "Login" ]
                ]
            ]
        ]
