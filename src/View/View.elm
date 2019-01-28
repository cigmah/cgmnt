module View.View exposing (view)

import Browser
import Msg.Msg exposing (..)
import Types.Types exposing (..)
import View.About
import View.Archive
import View.CompletedAuth
import View.Contact
import View.Home
import View.Leader
import View.Login
import View.LoginAuth
import View.NotFound
import View.PuzzlesAuth


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

        LeaderTotal leaderTotalData ->
            View.Leader.viewTotal model.meta leaderTotalData

        LeaderPuzzle leaderPuzzleData ->
            View.Leader.viewPuzzle model.meta leaderPuzzleData

        Login loginState ->
            View.Login.view model.meta loginState

        LoginAuth authToken ->
            View.LoginAuth.view model.meta authToken

        PuzzlesAuth authToken webData ->
            View.PuzzlesAuth.view model.meta authToken webData

        CompletedAuth authToken webData ->
            View.CompletedAuth.view model.meta authToken webData

        _ ->
            View.NotFound.view model.meta
