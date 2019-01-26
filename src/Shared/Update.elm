port module Shared.Update exposing (update)

import Browser
import Browser.Navigation as Nav
import Json.Decode as Decode
import Json.Encode as Encode
import PuzzleHunt.Hunt
import PuzzleHunt.Login
import PuzzleHunt.Register
import Shared.Init exposing (emptyLogin, emptyRegister)
import Shared.Router exposing (fromUrl)
import Shared.Types exposing (LoginEvent(..), LoginInformation, Model, Msg(..), RegisterEvent(..), RegisterInformation, Route(..))
import Task
import Time
import Url exposing (Url)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LinkClicked urlRequest ->
            handleLinkClicked model urlRequest

        UrlChanged url ->
            let
                route =
                    fromUrl url
            in
            case route of
                PuzzleHunt ->
                    case model.authToken of
                        Just token ->
                            PuzzleHunt.Hunt.handleOnDashboardLoad { model | route = fromUrl url }

                        Nothing ->
                            ( { model | route = fromUrl url }, Cmd.none )

                _ ->
                    ( { model | route = fromUrl url }, Cmd.none )

        NewTime time ->
            ( { model | currentTime = Just time }, Cmd.none )

        GetCurrentTime ->
            ( model, Task.perform NewTime Time.now )

        ToggleBurgerMenu ->
            ( { model | navbarMenuActive = not model.navbarMenuActive }, Cmd.none )

        RegisterMsg event ->
            PuzzleHunt.Register.handleRegisterEvent event model

        LoginMsg event ->
            PuzzleHunt.Login.handleLoginEvent event model

        HuntMsg event ->
            PuzzleHunt.Hunt.handleHuntEvent event model


handleLinkClicked model urlRequest =
    case urlRequest of
        Browser.Internal url ->
            ( { model | navbarMenuActive = False }, Nav.pushUrl model.key (Url.toString url) )

        Browser.External href ->
            ( model, Nav.load href )
