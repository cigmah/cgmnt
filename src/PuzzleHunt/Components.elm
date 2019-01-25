module PuzzleHunt.Components exposing (viewPuzzleHuntInfo)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Markdown
import PuzzleHunt.Content as Content
import Shared.Components exposing (navBar)
import Shared.Update exposing (Msg(..))


viewPuzzleHuntInfo model =
    { title = "CIGMAH PuzzleHunt"
    , body = bodyPuzzleHuntInfo model
    }


bodyPuzzleHuntInfo model =
    [ navBar model
    , section [ class "hero is-dark is-fullheight-with-navbar" ]
        [ registerModal model
        , loginModal model
        , div [ class "hero-body" ]
            [ div [ class "container" ]
                [ h1 [ class "title" ]
                    [ text "CIGMAH Puzzle Hunt 2019" ]
                , h2 [ class "subtitle" ]
                    [ text "Testing Phase" ]
                , div [ class "buttons has-addons" ]
                    [ span [ class "button is-large is-dark is-inverted is-outlined", onClick ToggleRegisterModal ]
                        [ text "Register" ]
                    , span [ class "button is-large is-dark is-inverted is-outlined", onClick ToggleLoginModal ]
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
            case model.componentStates.registerModalActive of
                True ->
                    "modal is-active"

                False ->
                    "modal"
    in
    div [ class modalClass ]
        [ div [ class "modal-background", onClick ToggleRegisterModal ] []
        , div [ class "modal-content" ] [ registerForm model ]
        , button [ class "modal-close is-large", onClick ToggleRegisterModal ] []
        ]


registerForm model =
    div [ class "card" ]
        [ div [ class "card-header has-background-danger" ] [ span [ class "card-header-title has-text-white" ] [ text "User Registration" ] ]
        , div [ class "card-content" ]
            [ div [ class "field" ]
                [ label [ class "label" ] [ text "Username" ]
                , div [ class "control" ] [ input [ class "input", type_ "text", placeholder "smithy" ] [] ]
                ]
            , div [ class "field" ]
                [ label [ class "label" ] [ text "Email" ]
                , div [ class "control" ] [ input [ class "input", type_ "text", placeholder "john.smith@email.com" ] [] ]
                ]
            , div [ class "field" ]
                [ label [ class "label" ] [ text "First Name" ]
                , div [ class "control" ] [ input [ class "input", type_ "text", placeholder "John" ] [] ]
                ]
            , div [ class "field" ]
                [ label [ class "label" ] [ text "Last Name" ]
                , div [ class "control" ] [ input [ class "input", type_ "text", placeholder "Smith" ] [] ]
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
            case model.componentStates.loginModalActive of
                True ->
                    "modal is-active"

                False ->
                    "modal"
    in
    div [ class modalClass ]
        [ div [ class "modal-background", onClick ToggleLoginModal ] []
        , div [ class "modal-content" ] [ loginForm model ]
        , button [ class "modal-close is-large", onClick ToggleLoginModal ] []
        ]


loginForm model =
    div [ class "card" ]
        [ div [ class "card-header has-background-info" ] [ span [ class "card-header-title has-text-white" ] [ text "User Login" ] ]
        , div [ class "card-content" ]
            [ div [ class "field" ]
                [ label [ class "label" ] [ text "Email" ]
                , div [ class "field has-addons" ]
                    [ div [ class "control is-expanded" ]
                        [ input [ class "input", type_ "text", placeholder "john.smith@email.com" ] [] ]
                    , div [ class "control" ]
                        [ button [ class "button is-info is-outlined" ] [ text "Send Token" ]
                        ]
                    ]
                ]
            , div [ class "field" ]
                [ label [ class "label" ] [ text "Token" ]
                , div [ class "control" ] [ input [ class "input", type_ "text", placeholder "000000" ] [] ]
                ]
            ]
        , footer [ class "card-footer" ]
            [ div [ class "card-footer-item" ]
                [ button [ class "button is-medium is-fullwidth is-info is-outlined" ] [ text "Login" ] ]
            ]
        ]
