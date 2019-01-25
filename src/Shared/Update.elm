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


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        componentStates =
            model.componentStates
    in
    case msg of
        LinkClicked urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    ( { model | componentStates = { componentStates | navbarMenuActive = False } }, Nav.pushUrl model.key (toString url) )

                Browser.External href ->
                    ( model, Nav.load href )

        UrlChanged url ->
            ( { model | route = fromUrl url }, Cmd.none )

        ToggleBurgerMenu ->
            ( { model | componentStates = { componentStates | navbarMenuActive = not componentStates.navbarMenuActive } }, Cmd.none )
