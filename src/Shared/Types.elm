module Shared.Types exposing (DashboardData, HuntEvent(..), LoginEvent(..), LoginInformation, Model, Msg(..), RegisterEvent(..), RegisterInformation, Route(..), ThemeData)

import Browser
import Browser.Navigation as Nav
import Http
import Time exposing (Posix)
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
    , currentTime : Maybe Posix
    , authToken : Maybe String
    , navbarMenuActive : Bool
    , registerInformation : Maybe RegisterInformation
    , loginInformation : Maybe LoginInformation
    , huntDashboardInformation : Maybe HuntDashboardInformation
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


type alias HuntDashboardInformation =
    { isLoading : Bool
    , data : Maybe DashboardData
    , message : Maybe String
    }


type alias DashboardData =
    { current : List ThemeData
    , next : Maybe ThemeData
    }


type alias ThemeData =
    { id : Int
    , year : Int
    , theme : String
    , tagline : String
    , openDatetime : Posix
    , closeDatetime : Posix
    }


type Msg
    = LinkClicked Browser.UrlRequest
    | UrlChanged Url
    | NewTime Posix
    | GetCurrentTime
    | ToggleBurgerMenu
    | RegisterMsg RegisterEvent
    | LoginMsg LoginEvent
    | HuntMsg HuntEvent


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
    | OnLogout


type HuntEvent
    = OnDashboardLoad
    | ReceivedDashboardData (Result Http.Error DashboardData)
