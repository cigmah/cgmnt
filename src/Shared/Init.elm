module Shared.Init exposing (emptyLogin, emptyRegister, init)

import Browser.Navigation as Nav
import Json.Decode as Decode
import PuzzleHunt.Hunt exposing (emptyHuntDashboard)
import Shared.Router exposing (fromUrl)
import Shared.Types exposing (HuntEvent(..), Model, Msg, Route(..))
import Url exposing (Url)


init : Decode.Value -> Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url key =
    let
        value =
            Decode.decodeValue Decode.string flags

        route =
            fromUrl url

        defaultModel =
            { key = key
            , route = route
            , authToken = Nothing
            , currentTime = Nothing
            , navbarMenuActive = False
            , registerInformation = Nothing
            , loginInformation = Nothing
            , huntDashboardInformation = Nothing
            }
    in
    case value of
        Ok token ->
            case route of
                PuzzleHunt ->
                    PuzzleHunt.Hunt.handleOnDashboardLoad { defaultModel | authToken = Just token }

                _ ->
                    ( { defaultModel | authToken = Just token }
                    , Cmd.none
                    )

        Err _ ->
            ( defaultModel, Cmd.none )


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
