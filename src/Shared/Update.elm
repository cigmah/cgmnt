module Shared.Update exposing (update)

import Browser
import Browser.Navigation as Nav
import Http
import Json.Decode as Decode
import Json.Encode as Encode
import Shared.ApiBase exposing (apiBase)
import Shared.Init exposing (emptyLogin, emptyRegister)
import Shared.Router exposing (fromUrl)
import Shared.Types exposing (LoginEvent(..), LoginInformation, Model, Msg(..), RegisterEvent(..), RegisterInformation, Route(..))
import Url exposing (Url)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LinkClicked urlRequest ->
            handleLinkClicked model urlRequest

        UrlChanged url ->
            ( { model | route = fromUrl url }, Cmd.none )

        ToggleBurgerMenu ->
            ( { model | navbarMenuActive = not model.navbarMenuActive }, Cmd.none )

        RegisterMsg event ->
            handleRegisterEvent event model

        LoginMsg event ->
            handleLoginEvent event model


handleLinkClicked model urlRequest =
    case urlRequest of
        Browser.Internal url ->
            ( { model | navbarMenuActive = False }, Nav.pushUrl model.key (Url.toString url) )

        Browser.External href ->
            ( model, Nav.load href )


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


handleRegisterEvent msg model =
    case msg of
        ToggleRegisterModal ->
            handleToggleRegisterModal model

        OnChangeRegisterEmail email ->
            handleOnChangeRegisterEmail model email

        OnChangeRegisterUsername username ->
            handleOnChangeRegisterUsername model username

        OnChangeRegisterFirstName firstName ->
            handleOnChangeRegisterFirstName model firstName

        OnChangeRegisterLastName lastName ->
            handleOnChangeRegisterLastName model lastName

        OnRegister ->
            handleOnRegister model

        ReceivedRegister result ->
            handleReceivedRegister model result


handleToggleRegisterModal model =
    let
        registerState =
            case model.registerInformation of
                Just registerInformation ->
                    case registerInformation.isLoading of
                        True ->
                            Just registerInformation

                        False ->
                            Nothing

                Nothing ->
                    Just emptyRegister
    in
    ( { model | registerInformation = registerState }, Cmd.none )


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


handleOnChangeRegisterUsername model username =
    case model.registerInformation of
        Just info ->
            ( { model | registerInformation = Just { info | username = username } }, Cmd.none )

        Nothing ->
            ( model, Cmd.none )


handleOnChangeRegisterEmail model email =
    case model.registerInformation of
        Just info ->
            ( { model | registerInformation = Just { info | email = email } }, Cmd.none )

        Nothing ->
            ( model, Cmd.none )


handleOnChangeRegisterFirstName model firstName =
    case model.registerInformation of
        Just info ->
            ( { model | registerInformation = Just { info | firstName = firstName } }, Cmd.none )

        Nothing ->
            ( model, Cmd.none )


handleOnChangeRegisterLastName model lastName =
    case model.registerInformation of
        Just info ->
            ( { model | registerInformation = Just { info | lastName = lastName } }, Cmd.none )

        Nothing ->
            ( model, Cmd.none )


handleOnRegister model =
    case model.registerInformation of
        Just info ->
            let
                cmd =
                    Http.post
                        { url = apiBase ++ "users/"
                        , body = info |> encodeRegister |> Http.jsonBody
                        , expect = Http.expectString <| RegisterMsg << ReceivedRegister
                        }
            in
            ( { model | registerInformation = Just { info | isLoading = True } }, cmd )

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


handleReceivedRegister model result =
    case model.registerInformation of
        Just info ->
            case result of
                Ok value ->
                    ( { model | registerInformation = Just { info | isLoading = False, response = Just value, message = Just "Registration completed succesfully! Proceed to login." } }, Cmd.none )

                Err error ->
                    case error of
                        Http.Timeout ->
                            ( { model | registerInformation = Just { info | isLoading = False, response = Nothing, message = Just "Sorry, the request timed out!" } }, Cmd.none )

                        Http.NetworkError ->
                            ( { model | registerInformation = Just { info | isLoading = False, response = Nothing, message = Just "There was a network error." } }, Cmd.none )

                        Http.BadStatus code ->
                            case code of
                                400 ->
                                    ( { model | registerInformation = Just { info | isLoading = False, response = Nothing, message = Just <| "Either this username or email has already been registered, or something was wrong with your inputs. Make sure you at least have both a username and a valid email." } }, Cmd.none )

                                _ ->
                                    ( { model | registerInformation = Just { info | isLoading = False, response = Nothing, message = Just <| "There was an error with error code " ++ String.fromInt code ++ "." } }, Cmd.none )

                        _ ->
                            ( { model | registerInformation = Just { info | isLoading = False, response = Nothing, message = Just "There was an error." } }, Cmd.none )

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
                    , Cmd.none
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
                            ( { model
                                | authToken = Nothing
                                , loginInformation = Just { info | isLoadingLogin = False, message = Just <| "There was an error with code " ++ String.fromInt code }
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


encodeRegister : RegisterInformation -> Encode.Value
encodeRegister info =
    Encode.object
        [ ( "username", Encode.string info.username )
        , ( "email", Encode.string info.email )
        , ( "first_name", Encode.string info.firstName )
        , ( "last_name", Encode.string info.lastName )
        ]


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
