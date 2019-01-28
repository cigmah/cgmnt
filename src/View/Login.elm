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
    [ lazy2 navBar meta.authToken meta.navBarMenuActive
    , section [ class "hero is-primary is-fullheight-with-navbar" ]
        [ div [ class "hero-body" ]
            [ div [ class "container" ]
                [ h1 [ class "subtitle has-text-centered" ]
                    [ text "Puzzle Hunt 2019" ]
                , h1 [ class "title has-text-centered" ] [ text "Login" ]
                , lazy renderBody loginState
                ]
            ]
        ]
    ]


renderBody loginState =
    let
        tokenField =
            case loginState of
                InputEmail _ (Success _) ->
                    div [] []

                _ ->
                    div [ class "field is-horizontal" ]
                        [ div [ class "field-label is-normal" ]
                            [ label [ class "label" ] [ text "Token" ] ]
                        , div [ class "field-body  is-expanded" ]
                            [ div [ class "field" ]
                                [ div [ class "control is-expanded" ]
                                    [ button [ class "button is-info is-fullwidth", type_ "submit" ]
                                        [ text "Send Token" ]
                                    ]
                                ]
                            ]
                        ]

        message =
            div [] []

        submitMsg =
            case loginState of
                InputEmail _ _ ->
                    LoginMsg OnSendToken

                InputToken _ _ _ ->
                    LoginMsg OnLogin
    in
    div [ class "columns is-centered" ]
        [ div [ class "column is-two-thirds" ]
            [ div [ class "card" ]
                [ Html.form
                    [ class "card-content"
                    , safeOnSubmit submitMsg
                    ]
                    [ loginField "Email" "roy.basch@bestmedicalschool.com" "email" <| LoginMsg << OnChangeLoginEmail
                    , tokenField
                    ]
                , message
                ]
            ]
        ]


loginField : String -> String -> String -> (String -> Msg) -> Html Msg
loginField fieldLabel fieldPlaceholder fieldType fieldOnChange =
    div [ class "field is-horizontal" ]
        [ div [ class "field-label is-normal" ]
            [ label [ class "label" ] [ text fieldLabel ] ]
        , div [ class "field-body  is-expanded" ]
            [ div [ class "field" ]
                [ div [ class "control is-expanded" ]
                    [ input [ class "input", type_ fieldType, placeholder fieldPlaceholder, onInput fieldOnChange ]
                        []
                    ]
                ]
            ]
        ]
