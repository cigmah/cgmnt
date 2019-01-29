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


view : Maybe Viewer -> Page -> { title : String, content : Html msg } -> Document msg
view maybeViewer page { title, content } =
    { title = title ++ ""
    , body = viewHeader page maybeViewer :: content :: [ viewFooter ]
    }


viewHeader : Page -> Maybe Viewer -> Html msg
viewHeader page maybeViewer =
    nav [ class "navbar navbar-light" ]
        [ div [ class "container" ]
            [ a [ class "navbar-brand", Route.href Route.Home ]
                [ text "NAVBAR" ]
            , ul [ class "nav navbar-nav pull-xs-right" ] <|
                navbarLink page Route.Home [ text "Home" ]
                    :: viewMenu page maybeViewer
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
            [ linkTo Route.Home [ i [ class "ion-compose" ] [], text "\u{00A0}New Post" ]
            ]

        Nothing ->
            [ div [] [ text "NOT LOGGED IN!" ] ]



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
    li [ classList [ ( "nav-item", True ), ( "active", isActive page route ) ] ]
        [ a [ class "nav-link", Route.href route ] linkContent ]


isActive : Page -> Route -> Bool
isActive page route =
    case ( page, route ) of
        ( Home, Route.Home ) ->
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
