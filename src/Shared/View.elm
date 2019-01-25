module Shared.View exposing (view)

import About.Components
import Browser
import Contact.Components
import Home.Components
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import NotFound.Components
import PuzzleHunt.Components
import Shared.Router exposing (Route(..))
import Shared.Types exposing (Model)
import Shared.Update exposing (Msg)


view : Model -> Browser.Document Msg
view model =
    case model.route of
        Home ->
            Home.Components.viewHome model

        About ->
            About.Components.viewAbout model

        PuzzleHunt ->
            PuzzleHunt.Components.viewPuzzleHuntInfo model

        Contact ->
            Contact.Components.viewContact model

        NotFound ->
            NotFound.Components.viewNotFound model
