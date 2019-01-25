module Shared.Init exposing (emptyLogin, emptyRegister, init)

import Browser.Navigation as Nav
import Shared.Router exposing (fromUrl)
import Shared.Types exposing (Model, Msg, Route(..))
import Url exposing (Url)


init : () -> Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url key =
    ( { key = key
      , route = fromUrl url
      , authToken = Nothing
      , navbarMenuActive = False
      , registerInformation = Nothing
      , loginInformation = Nothing
      }
    , Cmd.none
    )


emptyLogin =
    { email = ""
    , token = ""
    , isLoadingSendToken = False
    , sendTokenResponse = Nothing
    , isLoadingLogin = False
    , message = Nothing
    }


emptyRegister =
    { username = ""
    , email = ""
    , firstName = ""
    , lastName = ""
    , isLoading = False
    , message = Nothing
    , response = Nothing
    }
