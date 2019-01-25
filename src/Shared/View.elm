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
import Shared.Types exposing (Model, Msg, Route(..))


view : Model -> Browser.Document Msg
view model =
    case model.route of
        Home ->
            Home.Components.viewHome model

        About ->
            About.Components.viewAbout model

        PuzzleHunt ->
            PuzzleHunt.Components.viewPuzzleHunt model

        Contact ->
            Contact.Components.viewContact model

        NotFound ->
            NotFound.Components.viewNotFound model
