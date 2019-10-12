module Views.Logout exposing (view)

import Browser
import Handlers
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Html.Lazy exposing (..)
import RemoteData exposing (RemoteData(..), WebData)
import Time
import Types exposing (..)
import Views.Shared exposing (..)


view : Meta -> ( String, Html Msg )
view meta =
    ( "Logout - CIGMAH", logoutPage )


logoutPage : Html Msg
logoutPage =
    div [ class "main" ]
        [ div [ class "loading-container" ]
            [ text "You've succesfully logged out."
            , br [] []
            , text "Thanks for your participation."
            ]
        ]
