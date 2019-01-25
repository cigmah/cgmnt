module Shared.Types exposing (LoginEvent(..), LoginInformation, Model, Msg(..), RegisterEvent(..), RegisterInformation, Route(..))

import Browser
import Browser.Navigation as Nav
import Http
import Url exposing (Url)


type Route
    = Home
    | About
    | PuzzleHunt
    | Contact
    | NotFound


type alias Model =
    { key : Nav.Key
    , route : Route
    , authToken : Maybe String
    , navbarMenuActive : Bool
    , registerInformation : Maybe RegisterInformation
    , loginInformation : Maybe LoginInformation
    }


type alias RegisterInformation =
    { username : String
    , email : String
    , firstName : String
    , lastName : String
    , isLoading : Bool
    , response : Maybe String
    , message : Maybe String
    }


type alias LoginInformation =
    { email : String
    , token : String
    , isLoadingSendToken : Bool
    , sendTokenResponse : Maybe String
    , isLoadingLogin : Bool
    , message : Maybe String
    }


type Msg
    = LinkClicked Browser.UrlRequest
    | UrlChanged Url
    | ToggleBurgerMenu
    | RegisterMsg RegisterEvent
    | LoginMsg LoginEvent


type RegisterEvent
    = ToggleRegisterModal
    | OnChangeRegisterEmail String
    | OnChangeRegisterUsername String
    | OnChangeRegisterFirstName String
    | OnChangeRegisterLastName String
    | OnRegister
    | ReceivedRegister (Result Http.Error String)


type LoginEvent
    = ToggleLoginModal
    | OnChangeLoginEmail String
    | OnChangeLoginToken String
    | OnLogin
    | OnSendToken
    | ReceivedSendToken (Result Http.Error String)
    | ReceivedLogin (Result Http.Error String)
