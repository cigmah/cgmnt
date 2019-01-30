module Page.Nav exposing (navMenu)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Route
import Viewer


navMenu toggleMsg navActive maybeViewer =
    nav [ class "navbar" ]
        [ div [ class "navbar-brand" ]
            [ a [ class "navbar-item", Route.href Route.Home ]
                [ text "CIGMAH Puzzle Hunt 2019" ]
            , div [ class "navbar-burger burger", onClick toggleMsg ]
                [ span [] [], span [] [], span [] [] ]
            ]
        , div [ classList [ ( "navbar-menu", True ), ( "is-active", navActive ) ] ]
            [ div [ class "navbar-start" ] <|
                navbarLink Route.Home [ text "Home" ]
                    :: navbarLink Route.Resources [ text "Resources" ]
                    :: navbarLink Route.Archive [ text "Archive" ]
                    :: []
            , div [ class "navbar-end" ] <| viewMenu maybeViewer
            ]
        ]


navbarLink route linkContent =
    a [ classList [ ( "navbar-item", True ) ], Route.href route ]
        [ p [ class "nav-link" ] linkContent ]


viewMenu maybeViewer =
    let
        linkTo =
            navbarLink
    in
    case maybeViewer of
        Just viewer ->
            let
                username =
                    Viewer.username viewer
            in
            [ div [ class "navbar-item has-dropdown is-hoverable" ]
                [ div [ class "navbar-link" ] [ text "Puzzle Hunt" ]
                , div [ class "navbar-dropdown" ]
                    [ linkTo Route.Dashboard [ text "Dashboard" ]
                    , linkTo Route.OpenPuzzles [ text "Open Puzzles" ]
                    , linkTo Route.ClosedPuzzles [ text "Closed Puzzles" ]
                    , linkTo Route.Leaderboard [ text "Leaderboard" ]
                    , linkTo Route.Submissions [ text "Submissions" ]
                    , li [ class "navbar-item" ] [ p [] [ text username ] ]
                    , li [ class "navbar-item" ] [ a [ Route.href Route.Logout ] [ text "Logout" ] ]
                    ]
                ]
            ]

        Nothing ->
            [ linkTo Route.Login [ text "Login" ] ]
