module Views.Login exposing (view)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Html.Lazy exposing (..)
import RemoteData exposing (RemoteData(..), WebData)
import Types exposing (..)
import Views.Shared exposing (..)


loginForm : Email -> Bool -> Bool -> EmailToken -> Bool -> Html Msg
loginForm email isLoadingEmail isDisabledEmail emailToken isLoadingEmailToken =
    let
        sendTokenText =
            if isDisabledEmail then
                "Token Sent"

            else if isLoadingEmail then
                "Loading"

            else
                "Send Token"
    in
    Html.form [ class "login", onSubmit Ignored ]
        [ div [ class "login-first-line" ]
            [ input [ type_ "email", placeholder "Email", value email, onInput (LoginMsg << ChangedLoginEmail), disabled (isDisabledEmail || isLoadingEmail) ] []
            , button [ onClick <| LoginMsg ClickedSendEmail, disabled (isDisabledEmail || isLoadingEmail) ] [ text sendTokenText ]
            ]
        , div [ class "login-second-line" ]
            [ input [ type_ "text", placeholder "Token", value emailToken, onInput (LoginMsg << ChangedToken), disabled (not isDisabledEmail || isLoadingEmailToken) ] []
            , button [ onClick <| LoginMsg ClickedLogin, disabled (not isDisabledEmail || isLoadingEmailToken) ] [ text "Login" ]
            ]
        ]


view : Model -> LoginState -> Html Msg
view model loginState =
    let
        loginBody =
            case loginState of
                InputEmail email sendEmailResponseWebData ->
                    case sendEmailResponseWebData of
                        Success _ ->
                            loginForm email False True "" False

                        Loading ->
                            loginForm email True False "" False

                        _ ->
                            loginForm email False False "" False

                InputToken email sendEmailResponse emailToken credentialsWebData ->
                    case credentialsWebData of
                        Success _ ->
                            div []
                                [ text "You've successfully logged in. "
                                , br [] []
                                , br [] []
                                , a [ routeHref HomeRoute ] [ text "Head back to the home page to start tackling the open puzzles." ]
                                ]

                        Loading ->
                            loginForm email False True emailToken True

                        _ ->
                            loginForm email False True emailToken False
    in
    div []
        [ h1 [] [ text "Login" ]
        , div [ class "footnote" ] [ text "First, enter your email and press Send Token. A temporary login token will be sent to your email. Then, input the login token and press Login." ]
        , loginBody
        ]
