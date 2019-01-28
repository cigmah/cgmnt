module View.View exposing (view)

import Browser
import Msg.Msg exposing (..)
import Types.Types exposing (..)
import View.About
import View.Archive
import View.Contact
import View.Home
import View.Login
import View.NotFound


view : Model -> Browser.Document Msg
view model =
    case model.route of
        Home registerInfo registerData ->
            View.Home.view model.meta registerInfo registerData

        About ->
            View.About.view model.meta

        Contact ->
            View.Contact.view model.meta

        Archive archiveData ->
            View.Archive.view model.meta archiveData

        Login loginState ->
            View.Login.view model.meta loginState

        _ ->
            View.NotFound.view model.meta
