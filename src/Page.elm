module Page exposing (Page(..), view, viewErrors)

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
    | Dashboard
    | OpenPuzzles
    | ClosedPuzzles
    | Leaderboard
    | Submissions


view : Maybe Viewer -> Page -> { title : String, content : Html msg } -> Document msg
view maybeViewer page { title, content } =
    { title = title ++ ""
    , body = content :: [ viewFooter ]
    }



--[ linkTo Route.Login [ text "Sign in" ]
--, linkTo Route.Register [ text "Sign up" ]
--]


viewFooter : Html msg
viewFooter =
    footer []
        [ div [ class "container" ]
            [ text "footer" ]
        ]


{-| Render dismissable errors. We use this all over the place!
-}
viewErrors : msg -> List String -> Html msg
viewErrors dismissErrors errors =
    if List.isEmpty errors then
        Html.text ""

    else
        div
            [ class "error-messages"
            , style "position" "fixed"
            , style "top" "0"
            , style "background" "rgb(250, 250, 250)"
            , style "padding" "20px"
            , style "border" "1px solid"
            ]
        <|
            List.map (\error -> p [] [ text error ]) errors
                ++ [ button [ onClick dismissErrors ] [ text "Ok" ] ]
