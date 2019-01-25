module Shared.Components exposing (navBar)

import Html exposing (a, div, img, nav, span, text)
import Html.Attributes exposing (class, height, href, src)
import Html.Events exposing (onClick)
import Shared.Update exposing (Msg(..))


navBar model =
    let
        navbarMenuClass =
            case model.componentStates.navbarMenuActive of
                True ->
                    "navbar-menu is-active"

                False ->
                    "navbar-menu"
    in
    nav [ class "navbar" ]
        [ div [ class "navbar-brand" ]
            [ a [ class "navbar-item", href "/" ]
                [ img [ src "./icon.png", height 28 ] [], text "CIGMAH" ]
            , div
                [ class "navbar-burger", onClick ToggleBurgerMenu ]
                [ span [] [], span [] [], span [] [], span [] [] ]
            ]
        , div [ class navbarMenuClass ]
            [ div [ class "navbar-start" ]
                [ a [ class "navbar-item", href "/" ]
                    [ text "Home" ]
                , a [ class "navbar-item", href "/#/about" ]
                    [ text "About" ]
                , a [ class "navbar-item", href "/#/puzzle-hunt-info" ]
                    [ text "Puzzle Hunt 2019" ]
                , a [ class "navbar-item", href "/#/contact" ]
                    [ text "Contact" ]
                ]
            ]
        ]
