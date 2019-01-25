module Shared.Init exposing (init)

import Browser.Navigation as Nav
import Shared.Router exposing (Route, fromUrl)
import Shared.Types exposing (Model)
import Shared.Update exposing (Msg)
import Url exposing (Url)


init : () -> Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url key =
    ( { key = key
      , route = fromUrl url
      , componentStates =
            { navbarMenuActive = False
            , registerModalActive = False
            , loginModalActive = False
            }
      }
    , Cmd.none
    )
