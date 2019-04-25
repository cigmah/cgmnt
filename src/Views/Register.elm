module Views.Register exposing (view)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Html.Lazy exposing (..)
import Http exposing (Error(..))
import RemoteData exposing (RemoteData(..), WebData)
import Types exposing (..)
import Views.Shared exposing (..)


view : Meta -> RegisterState -> ( String, Html Msg )
view meta registerState =
    let
        title =
            "Register - CIGMAH"

        body =
            case ( meta.auth, registerState ) of
                ( Public, NewUser userData registerResponseDataWebData ) ->
                    registerPage registerState

                ( User credentials, AlreadyUser ) ->
                    registerPage registerState

                ( _, _ ) ->
                    errorPage "Sorry, it looks like we don't have any extra info on this!"
    in
    ( title, body )


registerPage : RegisterState -> Html Msg
registerPage state =
    let
        messageText =
            case state of
                NewUser _ (Success _) ->
                    [ text "Registration was successful! Head over to the ", a [ routeHref LoginRoute ] [ text "login tab" ], text " to start logging in!" ]

                NewUser _ (Failure e) ->
                    case e of
                        BadStatus errorData ->
                            case errorData.status.code of
                                400 ->
                                    [ text "There was a problem with that username or email - either they were invalid (make sure there are no spaces!) or they're taken. Either way, you'll have to change one or both of them (sorry!)" ]

                                code ->
                                    [ text <| "It seems like there was an error...sorry about that. Let us know! To help us, let us know that the status code was " ++ String.fromInt code ]

                        NetworkError ->
                            [ text "There was something wrong with the network. Is your internet working?" ]

                        _ ->
                            [ text "It seems like there was an error...sorry about that. Let us know!" ]

                AlreadyUser ->
                    [ text "You've already registered...in fact, you're logged in right now!" ]

                _ ->
                    []

        hideForm =
            case state of
                NewUser _ (Success _) ->
                    True

                AlreadyUser ->
                    True

                _ ->
                    False

        buttonText =
            case state of
                NewUser _ Loading ->
                    "Loading..."

                _ ->
                    "Register"
    in
    div [ class "main" ]
        [ div [ class "container" ]
            [ div [ class "center" ]
                [ div [ classList [ ( "hide", hideForm ) ] ]
                    [ ul [ class "register-list" ]
                        [ li [] [ text "We email you login tokens to verify your identity." ]
                        , li [] [ text "We don't spam you or share your email." ]
                        , li [] [ text "Don't use your email as your username." ]
                        , li [] [ text "After registering, go to the login tab." ]
                        ]
                    , Html.form [ class "register", onSubmit RegisterClicked ]
                        [ div [ class "form-control" ]
                            [ input [ type_ "text", placeholder "Username*", onInput RegisterChangedUsername ] [] ]
                        , div
                            [ class "form-control" ]
                            [ input [ type_ "email", placeholder "Email*", onInput RegisterChangedEmail ] [] ]
                        , div
                            [ class "form-control" ]
                            [ input [ type_ "text", placeholder "First Name", onInput RegisterChangedFirstName ] [] ]
                        , div
                            [ class "form-control" ]
                            [ input [ type_ "text", placeholder "Last Name", onInput RegisterChangedLastName ] [] ]
                        , button [] [ text buttonText ]
                        ]
                    ]
                , div [ class "register message" ] messageText
                ]
            ]
        ]
