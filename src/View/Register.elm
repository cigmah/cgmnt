module View.Register exposing (encodeRegister, handleOnChangeRegisterEmail, handleOnChangeRegisterFirstName, handleOnChangeRegisterLastName, handleOnChangeRegisterUsername, handleOnRegister, handleReceivedRegister, handleRegisterEvent, handleToggleRegisterModal)

import Http
import Json.Decode as Decode
import Json.Encode as Encode
import Shared.ApiBase exposing (apiBase)
import Shared.Init exposing (emptyLogin, emptyRegister)
import Shared.Types exposing (Model, Msg(..), RegisterEvent(..), RegisterInformation, Route(..))


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
