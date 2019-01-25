module Shared.Update exposing (Msg(..), update)

import Browser
import Browser.Navigation as Nav
import Shared.Router exposing (fromUrl)
import Shared.Types exposing (Model)
import Url exposing (Url, toString)


type Msg
    = LinkClicked Browser.UrlRequest
    | UrlChanged Url
    | ToggleBurgerMenu
    | ToggleRegisterModal
    | OnChangeRegisterEmail String
    | OnChangeRegisterUsername String
    | OnChangeRegisterFirstName String
    | OnChangeRegisterLastName String
    | ToggleLoginModal
    | OnChangeLoginEmail String
    | OnChangeLoginToken String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LinkClicked urlRequest ->
            handleLinkClicked model urlRequest

        UrlChanged url ->
            ( { model | route = fromUrl url }, Cmd.none )

        ToggleBurgerMenu ->
            ( { model | navbarMenuActive = not model.navbarMenuActive }, Cmd.none )

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

        ToggleLoginModal ->
            handleToggleLoginModal model

        OnChangeLoginEmail email ->
            handleOnChangeLoginEmail model email

        OnChangeLoginToken token ->
            handleOnChangeLoginToken model token


handleLinkClicked model urlRequest =
    case urlRequest of
        Browser.Internal url ->
            ( { model | navbarMenuActive = False }, Nav.pushUrl model.key (toString url) )

        Browser.External href ->
            ( model, Nav.load href )


handleToggleLoginModal model =
    let
        loginState =
            case model.loginInformation of
                Just loginInformation ->
                    Nothing

                Nothing ->
                    Just { email = "", token = "" }
    in
    ( { model | loginInformation = loginState }, Cmd.none )


handleToggleRegisterModal model =
    let
        registerState =
            case model.registerInformation of
                Just registerInformation ->
                    Nothing

                Nothing ->
                    Just { username = "", email = "", firstName = "", lastName = "" }
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
