module View.NavBar exposing (navBar)

import Html exposing (..)
import Html.Attributes exposing (class, height, href, src)
import Html.Events exposing (onClick)
import Html.Lazy exposing (..)
import Msg.Msg exposing (..)
import Types.Types exposing (..)


navBar : Maybe AuthToken -> Bool -> Html Msg
navBar authToken navBarMenuActive =
    let
        navBarMenuClass =
            if navBarMenuActive then
                "navbar-menu is-active"

            else
                "navbar-menu"

        logoutButton =
            case authToken of
                Just _ ->
                    a [ class "navbar-item", onClick <| OnLogout ] [ text "Logout" ]

                Nothing ->
                    div [] []
    in
    nav [ class "navbar" ]
        [ div [ class "navbar-brand" ]
            [ a [ class "navbar-item", href "/" ]
                [ img [ src "./icon.png", height 28 ] [], text "CIGMAH Puzzle Hunt 2019" ]
            , div
                [ class "navbar-burger", onClick ToggleBurgerMenu ]
                [ span [] [], span [] [], span [] [], span [] [] ]
            ]
        , div [ class navBarMenuClass ]
            [ div [ class "navbar-start" ]
                [ a [ class "navbar-item", href "/" ]
                    [ text "Home" ]
                , a [ class "navbar-item", href "/#/about" ]
                    [ text "About" ]
                , a [ class "navbar-item", href "/#/puzzle-hunt" ]
                    [ text "Puzzle Hunt 2019" ]
                , a [ class "navbar-item", href "/#/contact" ]
                    [ text "Contact" ]
                ]
            , div [ class "navbar-end" ]
                [ logoutButton ]
            ]
        ]
