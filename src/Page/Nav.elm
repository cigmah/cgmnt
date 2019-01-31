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
        , div [ class "w-full h-full bg-primary-light lg:flex lg:items-center lg:w-auto lg:bg-primary", classList [ ( "block", navActive ), ( "hidden", not navActive ) ] ]
            [ div [ class "text-sm h-full items-center lg:flex-grow" ] <|
                List.map navLink
                    mainLinks
            ]
        , div
            [ class "w-full h-full flex-grow bg-primary-light lg:bg-primary lg:flex lg:w-auto"
            , classList [ ( "block", navActive ), ( "hidden", not navActive ) ]
            ]
            [ div [ class "text-sm h-full lg:text-right lg:flex-grow" ] <| user :: List.map navLink rightLinks
            ]
        ]


navLink : ( Route, String ) -> Html msg
navLink ( route, name ) =
    a [ Route.href route, class "font-normal font-sans text-lg text-white block h-full lg:inline-block hover:bg-primary-dark  ml-1 mt-2 mb-2 lg:mt-0 lg:mb-0 px-2 py-2 lg:py-4 lg:text-center no-underline mr-4" ]
        [ span [] [ text name ] ]


userBox name =
    p [ class "font-normal font-sans text-lg text-primary font-semibold bg-grey-lighter block h-full lg:inline-block ml-2 mt-2 mb-2 mb-2 lg:mt-0 lg:mb-0 px-2 lg:px-6 py-2 lg:py-4 lg:text-center mr-4" ]
        [ span [] [ text name ] ]
