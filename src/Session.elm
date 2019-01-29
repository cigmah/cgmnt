module Session exposing (Session(..), changes, cred, fromViewer, navKey, viewer)

import Api exposing (Cred)
import Browser.Navigation as Nav
import Time exposing (Posix)
import Viewer exposing (Viewer)


type Session
    = LoggedIn Nav.Key Viewer
    | Guest Nav.Key


type alias AuthToken =
    String


viewer : Session -> Maybe Viewer
viewer session =
    case session of
        LoggedIn _ val ->
            Just val

        Guest _ ->
            Nothing


cred : Session -> Maybe Cred
cred session =
    case session of
        LoggedIn _ val ->
            Just (Viewer.cred val)

        Guest _ ->
            Nothing


navKey session =
    case session of
        LoggedIn key _ ->
            key

        Guest key ->
            key


changes : (Session -> msg) -> Nav.Key -> Sub msg
changes toMsg key =
    Api.viewerChanges (\maybeViewer -> toMsg (fromViewer key maybeViewer)) Viewer.decoder


fromViewer : Nav.Key -> Maybe Viewer -> Session
fromViewer key maybeViewer =
    case maybeViewer of
        Just viewerVal ->
            LoggedIn key viewerVal

        Nothing ->
            Guest key
