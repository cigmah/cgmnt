module Page.Nav exposing (navMenu)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Route exposing (Route)
import Session exposing (Session(..))
import Viewer


navMenu toggleMsg navActive maybeViewer =
    let
        mainLinks =
            case maybeViewer of
                Nothing ->
                    [ ( Route.Home, "Home" )
                    , ( Route.Archive, "Archive" )
                    , ( Route.Leaderboard, "Leaderboard" )
                    , ( Route.Resources, "Resources" )
                    ]

                Just viewer ->
                    [ ( Route.Home, "Home" )
                    , ( Route.Archive, "Archive" )
                    , ( Route.Leaderboard, "Leaderboard" )
                    , ( Route.OpenPuzzles, "Puzzles" )
                    , ( Route.Submissions, "Submissions" )
                    ]

        user =
            case maybeViewer of
                Just viewer ->
                    userBox (Viewer.username viewer)

                Nothing ->
                    span [] []

        rightLinks =
            case maybeViewer of
                Nothing ->
                    [ ( Route.Login, "Login" ) ]

                Just viewer ->
                    [ ( Route.Logout, "Logout" ) ]
    in
    nav
        [ class "flex h-auto items-center pin-t pin-x w-screen fixed shadow justify-between text-white flex-wrap bg-primary lg:h-12"
        , classList [ ( "h-12", not navActive ) ]
        ]
        [ div [ class "flex items-center align-middle  mr-6 ml-4" ]
            [ span [ class "font-semibold text-xl " ]
                [ text "CIGMAH" ]
            ]
        , div [ class "block lg:hidden p-4", onClick toggleMsg ]
            [ button [ class "flex items-center h-full px-2 py-2 mr-2 border rounded border-white text-white hover:bg-white hover:text-primary" ]
                [ text "Menu" ]
            ]
        , div [ class "w-full h-full bg-primary lg:flex lg:items-center lg:w-auto lg:bg-primary", classList [ ( "block", navActive ), ( "hidden", not navActive ) ] ]
            [ div [ class "text-sm h-full items-center lg:flex-grow" ] <|
                List.map navLink
                    mainLinks
            ]
        , div
            [ class "w-full h-full flex-grow bg-primary lg:bg-primary lg:flex lg:w-auto"
            , classList [ ( "block", navActive ), ( "hidden", not navActive ) ]
            ]
            [ div [ class "text-sm h-full lg:text-right lg:flex-grow" ] <| user :: List.map navLink rightLinks
            ]
        ]


navLink : ( Route, String ) -> Html msg
navLink ( route, name ) =
    a [ Route.href route, class "font-normal font-sans text-base text-white block h-full lg:inline-block hover:bg-primary-dark lg:mt-0 lg:mb-0 px-4 py-4 lg:py-4 lg:text-center no-underline mr-4" ]
        [ span [] [ text name ] ]


userBox name =
    p [ class "font-normal font-sans text-base text-white font-semibold bg-primary-dark lock h-full lg:inline-block pl-4 lg:mt-0 lg:mb-0 lg:px-6 py-4 lg:py-4 lg:text-center mr-0 lg:mr-4" ]
        [ span [] [ text name ] ]
