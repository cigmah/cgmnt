module View.Login exposing (view)

import Functions.Functions exposing (safeOnSubmit)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Html.Lazy exposing (..)
import Msg.Msg exposing (..)
import RemoteData exposing (RemoteData(..), WebData)
import Types.Init as Init
import Types.Types exposing (..)
import View.NavBar exposing (navBar)


view meta loginState =
    { title = "Puzzle Hunt Login"
    , body = body meta loginState
    }


body meta loginState =
    let
        loginBody =
            case meta.authToken of
                Nothing ->
                    lazy renderBody loginState

                Just token ->
                    h2 [ class "subtitle has-text-centered" ] [ text "Click on the puzzles menu to start puzzling!" ]

        titleText =
            case meta.authToken of
                Nothing ->
                    "Login"

                Just _ ->
                    "You are successfully logged in."
    in
    [ lazy2 navBar meta.authToken meta.navBarMenuActive
    , section [ class "hero is-primary is-fullheight-with-navbar" ]
        [ div [ class "hero-body" ]
            [ div [ class "container" ]
                [ h1 [ class "subtitle has-text-centered" ]
                    [ text "Puzzle Hunt 2019" ]
                , h1 [ class "title has-text-centered" ] [ text titleText ]
                , loginBody
                ]
            ]
        ]
    ]


renderBody loginState =
    let
        loadingState =
            case loginState of
                InputEmail _ Loading ->
                    " is-loading "

                InputToken _ _ _ Loading ->
                    " is-loading "

                _ ->
                    ""

        tokenField =
            case loginState of
                InputToken _ (Success _) _ (Success _) ->
                    loginField "Token" "012345" "text" True <| LoginMsg << OnChangeLoginToken

                InputToken _ (Success _) _ _ ->
                    loginField "Token" "012345" "text" False <| LoginMsg << OnChangeLoginToken

                _ ->
                    loginButton "Token" loadingState "Send Token"

        disabledState =
            case loginState of
                InputToken _ _ _ _ ->
                    True

                _ ->
                    False

        fullSubmit =
            case loginState of
                InputToken _ _ _ (Success _) ->
                    div [] []

                InputToken _ _ _ _ ->
                    loginButton "" loadingState "Login"

                _ ->
                    div [] []

        message =
            case loginState of
                InputToken _ (Success msgEmail) _ (Success msgToken) ->
                    div [ class "card-footer has-background-success has-text-white" ] [ p [ class "card-footer-item" ] [ text "You have successfully logged in!" ] ]

                InputEmail _ (Failure error) ->
                    div [ class "card-footer has-background-info has-text-white" ] [ p [ class "card-footer-item" ] [ text "There was an error with your email." ] ]

                InputToken _ _ _ (Failure error) ->
                    div [ class "card-footer has-background-info has-text-white" ] [ p [ class "card-footer-item" ] [ text "There was an error with your token." ] ]

                InputToken _ (Success msg) _ NotAsked ->
                    div [ class "card-footer has-background-success has-text-white" ] [ p [ class "card-footer-item" ] [ text msg ] ]

                _ ->
                    div [] []

        submitMsg =
            case loginState of
                InputEmail _ _ ->
                    LoginMsg OnSendEmail

                InputToken _ _ _ _ ->
                    LoginMsg OnLogin
    in
    div [ class "columns is-centered" ]
        [ div [ class "column is-two-thirds" ]
            [ div [ class "card" ]
                [ Html.form
                    [ class "card-content"
                    , safeOnSubmit submitMsg
                    ]
                    [ loginField "Email" "roy.basch@bestmedicalschool.com" "email" disabledState <| LoginMsg << OnChangeLoginEmail
                    , tokenField
                    , fullSubmit
                    ]
                , message
                ]
            ]
        ]


loginField : String -> String -> String -> Bool -> (String -> Msg) -> Html Msg
loginField fieldLabel fieldPlaceholder fieldType disabledState fieldOnChange =
    div [ class "field is-horizontal" ]
        [ div [ class "field-label is-normal" ]
            [ label [ class "label" ] [ text fieldLabel ] ]
        , div [ class "field-body  is-expanded" ]
            [ div [ class "field" ]
                [ div [ class "control is-expanded" ]
                    [ input [ class "input", disabled disabledState, type_ fieldType, placeholder fieldPlaceholder, onInput fieldOnChange ]
                        []
                    ]
                ]
            ]
        ]


loginButton labelText loadingState buttonText =
    div [ class "field is-horizontal" ]
        [ div [ class "field-label is-normal" ]
            [ label [ class "label" ] [ text labelText ] ]
        , div [ class "field-body  is-expanded" ]
            [ div [ class "field" ]
                [ div [ class "control is-expanded" ]
                    [ button [ class <| "button is-info is-fullwidth" ++ loadingState, type_ "submit" ]
                        [ text buttonText ]
                    ]
                ]
            ]
        ]
