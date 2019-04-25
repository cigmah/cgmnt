module Views.Login exposing (view)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Html.Lazy exposing (..)
import RemoteData exposing (RemoteData(..), WebData)
import Types exposing (..)
import Views.Shared exposing (..)


view : Meta -> LoginState -> ( String, Html Msg )
view meta loginState =
    let
        title =
            "Login - CIGMAH"

        body =
            case ( meta.auth, loginState ) of
                ( Public, InputEmail email sendEmailResponseDataWebData ) ->
                    loginPage loginState

                ( Public, InputToken email sendEmailResponseData token credentialsWebData ) ->
                    loginPage loginState

                ( User credentials, _ ) ->
                    loginPage (InputToken "" "" "" (Success credentials))

                ( _, _ ) ->
                    notFoundPage
    in
    ( title, body )


loginPage state =
    let
        isTokenDisabled =
            case state of
                InputToken _ _ _ NotAsked ->
                    False

                InputToken _ _ _ (Failure e) ->
                    False

                InputToken _ _ _ Loading ->
                    False

                _ ->
                    True

        sendTokenText =
            case state of
                InputEmail _ Loading ->
                    "Loading..."

                InputToken _ _ _ _ ->
                    "Sent."

                _ ->
                    "Send Token"

        loginText =
            case state of
                InputToken _ _ _ Loading ->
                    "Loading..."

                _ ->
                    "Login"

        messageDiv =
            case state of
                InputEmail _ (Failure e) ->
                    [ text "We're sorry, there was an issue with sending a token to your email. Maybe you haven't registered? Or a typo?" ]

                InputToken _ _ _ (Failure e) ->
                    [ text "We're sorry, that token didn't work. Is it right? Maybe it's expired? Maybe there was some other error?" ]

                InputToken _ _ _ (Success credentials) ->
                    [ text <| "Great, you've logged in successfully! Welcome to the puzzle hunt, " ++ credentials.username ++ ". "
                    , text "You can now start "
                    , a [ routeHref PuzzleListRoute ] [ text "tackling the open puzzles" ]
                    , text " or "
                    , a [ routeHref HomeRoute ] [ text "head to your dashboard." ]
                    ]

                _ ->
                    []

        isFormHidden =
            case state of
                InputToken _ _ _ (Success _) ->
                    True

                _ ->
                    False

        onSubmitMessage =
            case state of
                InputEmail _ Loading ->
                    []

                InputEmail _ _ ->
                    [ onSubmit LoginClickedSendEmail ]

                InputToken _ _ _ Loading ->
                    []

                InputToken _ _ _ _ ->
                    [ onSubmit LoginClickedLogin ]

                _ ->
                    []
    in
    div [ class "main" ]
        [ div [ class "container" ]
            [ div [ class "center" ]
                [ div [ classList [ ( "hide", isFormHidden ) ] ]
                    [ ul [ class "login-list" ]
                        [ li [] [ text "Make sure you have registered first." ]
                        , li [] [ text "Input your email and press Send Token." ]
                        , li [] [ text "We'll automatically send you a login token." ]
                        , li [] [ text "Then input the login token." ]
                        ]
                    , Html.form (class "login" :: onSubmitMessage)
                        [ div [ class "form-control" ]
                            [ input [ disabled (not isTokenDisabled), type_ "email", placeholder "Email", onInput LoginChangedEmail ] []
                            , button [ class "small-button", disabled (not isTokenDisabled), onClick LoginClickedSendEmail ] [ text "Send Token" ]
                            ]
                        , div [ class "form-control" ]
                            [ input [ disabled isTokenDisabled, type_ "text", placeholder "Login Token", onInput LoginChangedToken ] [] ]
                        , button [ disabled isTokenDisabled, onClick LoginClickedLogin ] [ text "Login" ]
                        ]
                    ]
                , div [ class "login message" ] messageDiv
                ]
            ]
        ]
