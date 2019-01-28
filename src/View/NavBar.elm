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

        loginoutButton =
            case authToken of
                Just _ ->
                    a [ class "navbar-item", onClick <| OnLogout ] [ text "Logout" ]

                Nothing ->
                    a [ class "navbar-item", href "/#/login" ] [ text "Login" ]

        authMenu =
            case authToken of
                Just _ ->
                    div [ class "navbar-item has-dropdown is-hoverable" ]
                        [ p [ class "navbar-link" ] [ text "Puzzle Hunt Portal" ]
                        , div [ class "navbar-dropdown" ]
                            [ a [ class "navbar-item", href "/#/my-puzzles/" ] [ text "My Active Puzzles" ]
                            , a [ class "navbar-item", href "/#/my-completed" ] [ text "My Completed Puzzles" ]
                            , a [ class "navbar-item", href "/#/my-submissions" ] [ text "My Submissions" ]
                            ]
                        ]

                _ ->
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
                , a [ class "navbar-item", href "/#/contact" ]
                    [ text "Contact" ]
                , a [ class "navbar-item", href "/#/resources" ]
                    [ text "Resources" ]
                , a [ class "navbar-item", href "/#/archive" ]
                    [ text "Archive" ]
                , a [ class "navbar-item", href "/#/leaderboard" ]
                    [ text "Leaderboard" ]
                , authMenu
                ]
            , div [ class "navbar-end" ]
                [ loginoutButton ]
            ]
        ]
