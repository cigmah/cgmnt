module Pages.Utils.Nav exposing (navMenu)

import Html exposing (..)
import Html.Attributes exposing (class, height, href, src)
import Html.Events exposing (onClick)
import Html.Lazy exposing (..)
import RemoteData exposing (RemoteData(..), WebData)
import Types.Msg exposing (..)
import Types.Types exposing (..)


navMenu : Maybe User -> Bool -> Html Msg
navMenu userMaybe navActive =
    let
        navMenuClass =
            if navActive then
                "navbar-menu is-active"

            else
                "navbar-menu"

        logInOutButton =
            case userMaybe of
                Just _ ->
                    a [ class "navbar-item" ] [ text "Logout" ]

                Nothing ->
                    a [ class "navbar-item", href "/#/login" ] [ text "Login" ]

        authMenu =
            case userMaybe of
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
                [ class "navbar-burger" ]
                [ span [] [], span [] [], span [] [], span [] [] ]
            ]
        , div [ class navMenuClass ]
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
                [ logInOutButton ]
            ]
        ]
