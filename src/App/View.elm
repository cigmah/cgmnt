module App.View exposing (view)

import Browser
import Html exposing (div)
import Pages.Home.View
import Types.Msg exposing (..)
import Types.Types exposing (..)


view : Model -> Browser.Document Msg
view model =
    case model.route of
        RouteNoAuth pageNoAuth ->
            case pageNoAuth of
                Home registerInfo registerWebData ->
                    Pages.Home.View.view model.meta registerInfo registerWebData

                _ ->
                    { title = "NONE", body = [ div [] [] ] }

        RouteWithAuth userWebData pageWithAuth ->
            case pageWithAuth of
                _ ->
                    { title = "NONE", body = [ div [] [] ] }
