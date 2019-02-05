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
    pageBase
        { iconSpan = text "..."
        , isCentered = True
        , colour = "green"
        , titleSpan = text "Bye!"
        , bodyContent = text "Thanks for participating! You've successfully logged out now."
        , outsideMain = pageButton (ChangedRoute HomeRoute) "green" (text "Take me back home!")
        }
