module View.View exposing (view)

import Browser
import Msg.Msg exposing (..)
import Types.Types exposing (..)
import View.About
import View.Archive
import View.Contact
import View.Home
import View.NotFound


view : Model -> Browser.Document Msg
view model =
    case model.route of
        Home registerInfo registerData ->
            View.Home.view model

        About ->
            View.About.view model

        Contact ->
            View.Contact.view model

        Archive archiveData ->
            View.Archive.view model

        _ ->
            View.NotFound.view model
