module Page exposing (Page(..), view, viewErrors)

import Api exposing (Cred)
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
    , body = viewHeader page maybeViewer :: content :: [ viewFooter ]
    }


viewHeader : Page -> Maybe Viewer -> Html msg
viewHeader page maybeViewer =
    nav [ class "navbar" ]
        [ div [ class "navbar-brand" ]
            [ a [ class "navbar-item", Route.href Route.Home ]
                [ text "CIGMAH Puzzle Hunt 2019" ]
            , a [ class "navbar-burger burger" ]
                [ span [] [], span [] [], span [] [] ]
            ]
        , div [ class "navbar-menu" ]
            [ div [ class "navbar-start" ] <|
                navbarLink page Route.Home [ text "Home" ]
                    :: navbarLink page Route.Resources [ text "Resources" ]
                    :: navbarLink page Route.Archive [ text "Archive" ]
                    :: []
            , div [ class "navbar-end" ] <| viewMenu page maybeViewer
            ]
        ]


viewMenu : Page -> Maybe Viewer -> List (Html msg)
viewMenu page maybeViewer =
    let
        linkTo =
            navbarLink page
    in
    case maybeViewer of
        Just viewer ->
            let
                username =
                    Viewer.username viewer
            in
            [ linkTo Route.Dashboard [ text "Dashboard" ]
            , linkTo Route.OpenPuzzles [ text "Open Puzzles" ]
            , linkTo Route.ClosedPuzzles [ text "Closed Puzzles" ]
            , linkTo Route.Leaderboard [ text "Leaderboard" ]
            , linkTo Route.Submissions [ text "Submissions" ]
            ]

        Nothing ->
            [ linkTo Route.Login [ text "Login" ] ]



--[ linkTo Route.Login [ text "Sign in" ]
--, linkTo Route.Register [ text "Sign up" ]
--]


viewFooter : Html msg
viewFooter =
    footer []
        [ div [ class "container" ]
            [ text "footer" ]
        ]


navbarLink : Page -> Route -> List (Html msg) -> Html msg
navbarLink page route linkContent =
    li [ classList [ ( "navbar-item", True ), ( "active", isActive page route ) ] ]
        [ a [ class "nav-link", Route.href route ] linkContent ]


isActive : Page -> Route -> Bool
isActive page route =
    case ( page, route ) of
        ( Home, Route.Home ) ->
            True

        ( Resources, Route.Resources ) ->
            True

        ( Archive, Route.Archive ) ->
            True

        ( Login, Route.Login ) ->
            True

        _ ->
            False


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
