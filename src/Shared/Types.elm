module Shared.Types exposing (ComponentStates, Model)

import Browser.Navigation as Nav
import Shared.Router exposing (Route)
import Url exposing (Url)


type alias Model =
    { key : Nav.Key, route : Route, componentStates : ComponentStates }


type alias ComponentStates =
    { navbarMenuActive : Bool
    , registerModalActive : Bool
    , loginModalActive : Bool
    }
