module Shared.Types exposing (Model)

import Browser.Navigation as Nav
import Shared.Router exposing (Route)
import Url exposing (Url)


type alias Model =
    { key : Nav.Key
    , route : Route
    , navbarMenuActive : Bool
    , registerInformation : Maybe RegisterInformation
    , loginInformation : Maybe LoginInformation
    }


type alias RegisterInformation =
    { username : String
    , email : String
    , firstName : String
    , lastName : String
    }


type alias LoginInformation =
    { email : String
    , token : String
    }
