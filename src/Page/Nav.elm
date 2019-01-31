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
                    , ( Route.Submissions, "My Submissions" )
                    ]
    in
    nav
        [ class "flex lg:h-12 items-center pin-t pin-x w-screen fixed shadow justify-between flex-wrap bg-grey-lighter"
        , classList [ ( "h-12", not navActive ) ]
        ]
        [ div [ class "flex items-center text-grey-dark mr-6 p-6" ]
            [ span [ class "font-semibold text-xl" ]
                [ text "CIGMAH" ]
            ]
        , div [ class "block lg:hidden p-4", onClick toggleMsg ]
            [ button [ class "flex items-center h-full px-3 py-2 border rounded text-grey border-grey hover:text-grey-darker hover:border-grey-darker" ]
                [ text "Menu" ]
            ]
        , div [ class "w-full h-full items-center flex-grow lg:flex lg:items-center lg:w-auto", classList [ ( "block", navActive ), ( "hidden", not navActive ) ] ]
            [ div [ class "text-sm h-full items-center lg:flex-grow" ] <|
                List.map navLink
                    mainLinks
            ]
        ]


navLink : ( Route, String ) -> Html msg
navLink ( route, name ) =
    a [ Route.href route, class "block h-full w-32 lg:inline-block hover:bg-grey-light hover:text-grey-darker ml-2 mt-2 mb-2 lg:mt-0 lg:mb-0 px-3 py-4 lg:text-center no-underline text-grey-dark  mr-4" ]
        [ span [] [ text name ] ]
