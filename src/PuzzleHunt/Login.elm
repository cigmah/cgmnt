module PuzzleHunt.Login exposing (decodeAuthToken, encodeLogin, encodeSendToken, handleLoginEvent, handleOnChangeLoginEmail, handleOnChangeLoginToken, handleOnLogin, handleOnSendToken, handleReceivedLogin, handleReceivedSendToken, handleToggleLoginModal)

import Http
import Json.Decode as Decode
import Json.Encode as Encode
import Shared.ApiBase exposing (apiBase)
import Shared.Init exposing (emptyLogin, emptyRegister)
import Shared.Ports exposing (cache)
import Shared.Types exposing (LoginEvent(..), LoginInformation, Model, Msg(..), Route(..))


handleLoginEvent msg model =
    case msg of
        ToggleLoginModal ->
            handleToggleLoginModal model

        OnChangeLoginEmail email ->
            handleOnChangeLoginEmail model email

        OnChangeLoginToken token ->
            handleOnChangeLoginToken model token

        OnSendToken ->
            handleOnSendToken model

        OnLogin ->
            handleOnLogin model

        ReceivedSendToken result ->
            handleReceivedSendToken model result

        ReceivedLogin result ->
            handleReceivedLogin model result

        OnLogout ->
            ( { model | authToken = Nothing }, cache <| Encode.string "" )


handleToggleLoginModal model =
    let
        loginState =
            case model.loginInformation of
                Just loginInformation ->
                    case loginInformation.isLoadingSendToken of
                        False ->
                            case loginInformation.isLoadingLogin of
                                True ->
                                    Just loginInformation

                                False ->
                                    Nothing

                        True ->
                            Just loginInformation

                Nothing ->
                    Just emptyLogin
    in
    ( { model | loginInformation = loginState }, Cmd.none )


handleOnChangeLoginEmail model email =
    case model.loginInformation of
        Just info ->
            ( { model | loginInformation = Just { info | email = email } }, Cmd.none )

        Nothing ->
            ( model, Cmd.none )


handleOnChangeLoginToken model token =
    case model.loginInformation of
        Just info ->
            ( { model | loginInformation = Just { info | token = token } }, Cmd.none )

        Nothing ->
            ( model, Cmd.none )


handleOnSendToken model =
    case model.loginInformation of
        Just info ->
            let
                cmd =
                    Http.post
                        { url = apiBase ++ "auth/email/"
                        , body = info |> encodeSendToken |> Http.jsonBody
                        , expect = Http.expectString <| LoginMsg << ReceivedSendToken
                        }
            in
            ( { model | loginInformation = Just { info | isLoadingSendToken = True } }, cmd )

        Nothing ->
            ( model, Cmd.none )


handleOnLogin model =
    case model.loginInformation of
        Just info ->
            let
                cmd =
                    Http.post
                        { url = apiBase ++ "callback/auth/"
                        , body = info |> encodeLogin |> Http.jsonBody
                        , expect = Http.expectJson (LoginMsg << ReceivedLogin) decodeAuthToken
                        }
            in
            ( { model | loginInformation = Just { info | isLoadingLogin = True } }, cmd )

        Nothing ->
            ( model, Cmd.none )


handleReceivedSendToken model result =
    case model.loginInformation of
        Just info ->
            case result of
                Ok value ->
                    ( { model | loginInformation = Just { info | isLoadingSendToken = False, sendTokenResponse = Just value, message = Nothing } }, Cmd.none )

                Err error ->
                    case error of
                        Http.Timeout ->
                            ( { model | loginInformation = Just { info | isLoadingSendToken = False, sendTokenResponse = Nothing, message = Just "Sorry, the request timed out." } }, Cmd.none )

                        Http.NetworkError ->
                            ( { model | loginInformation = Just { info | isLoadingSendToken = False, sendTokenResponse = Nothing, message = Just "There was a network error." } }, Cmd.none )

                        Http.BadStatus code ->
                            case code of
                                400 ->
                                    ( { model | loginInformation = Just { info | isLoadingSendToken = False, sendTokenResponse = Nothing, message = Just "Hmm, we don't have that email in our registration list. Have you registered? Or maybe a typo?" } }, Cmd.none )

                                _ ->
                                    ( { model | loginInformation = Just { info | isLoadingSendToken = False, sendTokenResponse = Nothing, message = Just <| "There was an error with code " ++ String.fromInt code } }, Cmd.none )

                        _ ->
                            ( { model | loginInformation = Just { info | isLoadingSendToken = False, sendTokenResponse = Nothing, message = Just "There was an error." } }, Cmd.none )

        Nothing ->
            ( model, Cmd.none )


handleReceivedLogin model result =
    case model.loginInformation of
        Just info ->
            case result of
                Ok value ->
                    ( { model
                        | authToken = Just value
                        , loginInformation = Just { info | isLoadingLogin = False, message = Nothing }
                      }
                    , cache (Encode.string value)
                    )

                Err error ->
                    case error of
                        Http.Timeout ->
                            ( { model
                                | authToken = Nothing
                                , loginInformation = Just { info | isLoadingLogin = False, message = Just "Sorry, the request timed out" }
                              }
                            , Cmd.none
                            )

                        Http.BadStatus code ->
                            let
                                message =
                                    case code of
                                        400 ->
                                            "That token doesn't seem to be correct. Maybe a typo or maybe it's expired?"

                                        _ ->
                                            "There was an error with code " ++ String.fromInt code
                            in
                            ( { model
                                | authToken = Nothing
                                , loginInformation = Just { info | isLoadingLogin = False, message = Just message }
                              }
                            , Cmd.none
                            )

                        _ ->
                            ( { model
                                | authToken = Nothing
                                , loginInformation = Just { info | isLoadingLogin = False, message = Just "There was an error." }
                              }
                            , Cmd.none
                            )

        Nothing ->
            ( model, Cmd.none )


encodeSendToken : LoginInformation -> Encode.Value
encodeSendToken info =
    Encode.object
        [ ( "email", Encode.string info.email ) ]


encodeLogin : LoginInformation -> Encode.Value
encodeLogin info =
    Encode.object
        [ ( "token", Encode.string info.token ) ]


decodeAuthToken : Decode.Decoder String
decodeAuthToken =
    Decode.field "token" Decode.string
