module Page exposing (Page(..), view)

import Api exposing (Cred, logout)
import Browser exposing (Document)
import Html exposing (Html, a, button, div, footer, i, img, li, nav, p, span, text, ul)
import Html.Attributes exposing (class, classList, href, style)
import Html.Events exposing (onClick)
import Route exposing (Route)
import Session exposing (Session)
import Viewer exposing (Viewer)


type Page
    = Other
    | Home
    | Resources
    | Archive
    | Login
    | Register
    | OpenPuzzles
    | ClosedPuzzles
    | Leaderboard
    | Submissions


view : Maybe Viewer -> Page -> { title : String, content : Html msg } -> Document msg
view maybeViewer page { title, content } =
    { title = title ++ ""
    , body = [ div [] <| content :: [] ]
    }


viewFooter : Html msg
viewFooter =
    footer []
        [ div []
            []
        ]
