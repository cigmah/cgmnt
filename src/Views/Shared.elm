module Views.Shared exposing (Colour, PageBaseData, TableSize(..), errorPage, loremIpsum, navLink, navMenu, navMenuBase, navMenuWithAuth, navMenuWithoutAuth, notFoundPage, pageBase, pageButton, puzzleColour, routeHref, tableCell, tableRow, textWithLoad, userBox)

import Handlers
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Html.Lazy exposing (..)
import Types exposing (..)


routeHref : Route -> Attribute Msg
routeHref targetRoute =
    href (Handlers.routeToString targetRoute)



-- Navmenu


navMenuBase : Bool -> List ( Route, String ) -> Html msg -> List ( Route, String ) -> Html Msg
navMenuBase navActive leftLinks userSpan rightLinks =
    nav
        [ class "flex h-auto items-center pin-t pin-x w-screen fixed border-b-2 border-grey-lighter justify-between text-grey-darker flex-wrap bg-grey-lightest z-50"
        , classList [ ( "h-12", not navActive ) ]
        ]
        [ div [ class "flex items-center align-middle" ]
            [ img [ class "resize w-10 h-10 py-1 px-1", src "icon_inverted.png" ] []
            , span [ class "text-bold text-xl mr-6" ] [ text "CIGMAH" ]
            ]
        , div [ class "block lg:hidden py-2", onClick ToggledNav ]
            [ button [ class "flex focus:outline-none items-center h-full px-4 mr-2 rounded-full bg-grey-lighter text-grey-dark hover:bg-grey-light" ]
                [ div [ class "py-2" ]
                    [ text "Menu" ]
                ]
            ]
        , div [ class "w-full h-full bg-primary lg:flex lg:items-center lg:w-auto lg:bg-primary", classList [ ( "block", navActive ), ( "hidden", not navActive ) ] ]
            [ div [ class "text-sm h-full items-center lg:flex-grow" ] <|
                List.map navLink
                    leftLinks
            ]
        , div
            [ class "w-full h-full flex-grow bg-primary lg:bg-primary lg:flex lg:w-auto"
            , classList [ ( "block", navActive ), ( "hidden", not navActive ) ]
            ]
            [ div [ class "text-sm h-full lg:text-right lg:flex-grow" ] <| List.map navLink rightLinks
            ]
        ]


navLink : ( Route, String ) -> Html Msg
navLink ( route, name ) =
    a [ routeHref route, class "font-normal font-sans text-base text-grey-dark block h-full lg:inline-block hover:bg-grey-lighter hover:text-grey-darker lg:mt-0 lg:mb-0 px-4 py-4 lg:py-4 lg:text-center no-underline mr-4" ]
        [ span [] [ text name ] ]


userBox name =
    p [ class "font-normal font-sans text-base text-grey-darker font-semibold lock h-full lg:inline-block pl-4 lg:mt-0 lg:mb-0 lg:px-6 py-4 lg:py-4 lg:text-center mr-0 lg:mr-4" ]
        [ span [] [ text name ] ]


navMenuWithAuth : Bool -> Credentials -> Html Msg
navMenuWithAuth navActive credentials =
    let
        leftLinks =
            [ ( HomeRoute, "Home" )
            , ( ResourcesRoute, "Resources" )
            , ( PuzzleListRoute, "Puzzles" )
            , ( LeaderboardRoute, "Leaderboard" )
            ]

        userSpan =
            userBox credentials.username

        rightLinks =
            [ ( LogoutRoute, "Logout" ) ]
    in
    navMenuBase navActive leftLinks userSpan rightLinks


navMenuWithoutAuth : Bool -> Html Msg
navMenuWithoutAuth navActive =
    let
        leftLinks =
            [ ( HomeRoute, "Home" )
            , ( ResourcesRoute, "Resources" )
            , ( PuzzleListRoute, "Puzzles" )
            , ( LeaderboardRoute, "Leaderboard" )
            ]

        userSpan =
            span [] []

        rightLinks =
            [ ( RegisterRoute, "Register" )
            , ( LoginRoute, "Login" )
            ]
    in
    navMenuBase navActive leftLinks userSpan rightLinks


navMenu : Bool -> Auth -> Html Msg
navMenu navActive auth =
    case auth of
        User credentials ->
            navMenuWithAuth navActive credentials

        Public ->
            navMenuWithoutAuth navActive



-- Not Found and Error Page


type alias Colour =
    String


pageButton : Msg -> Colour -> Html Msg -> Html Msg
pageButton msg colour textSpan =
    let
        hoverClass =
            "hover:bg-" ++ colour ++ "dark"

        bgClass =
            "bg-" ++ colour

        borderClass =
            "border-" ++ colour
    in
    div
        [ class "flex w-full justify-center" ]
        [ button
            [ class "px-3 py-2 rounded-full border-b-4 w-full md:w-1/2 text-white active:border-0 outline-none focus:outline-none active:outline-none "
            , classList [ ( hoverClass, True ), ( bgClass, True ), ( borderClass, True ) ]
            , onClick msg
            ]
            [ textSpan ]
        ]


type alias PageBaseData =
    { iconSpan : Html Msg
    , isCentered : Bool
    , colour : Colour
    , titleSpan : Html Msg
    , bodyContent : Html Msg
    , outsideMain : Html Msg
    }


pageBase : PageBaseData -> Html Msg
pageBase data =
    let
        hoverClass =
            "hover:bg-" ++ data.colour ++ "dark"

        bgClass =
            "bg-" ++ data.colour

        borderClass =
            "border-" ++ data.colour
    in
    div
        [ class "px-2 md:px-8 bg-grey-lightest" ]
        [ div
            [ class "flex flex-wrap content-center justify-center items-center"
            , classList [ ( "h-screen", data.isCentered ), ( "mt-16 mb-8", not data.isCentered ) ]
            ]
            [ div
                [ class "block md:w-5/6 lg:w-4/5 xl:w-3/4" ]
                [ div
                    [ class "inline-flex flex justify-center w-full" ]
                    [ div
                        [ class <| "flex items-center sm:text-xl justify-center sm:h-12 w-auto px-3 py-3 rounded-l-lg font-black text-white border-b-2 "
                        , classList [ ( hoverClass, True ), ( borderClass, True ), ( bgClass, True ) ]
                        ]
                        [ data.iconSpan
                        ]
                    , div
                        [ class "flex items-center w-full p-3 px-5 sm:h-12 rounded-r-lg text-grey-darkest sm:text-lg font-bold uppercase bg-grey-lighter border-b-2 border-grey" ]
                        [ data.titleSpan ]
                    ]
                , div
                    [ class "block w-full my-3 bg-white rounded-lg p-6 w-full text-base border-b-2 border-grey-light" ]
                    [ data.bodyContent ]
                , data.outsideMain
                ]
            ]
        ]


notFoundPage : Html Msg
notFoundPage =
    pageBase
        { iconSpan = text "..."
        , isCentered = True
        , colour = "red"
        , titleSpan = text "Whoops!"
        , bodyContent = text "It looks like this page wasn't found. Sorry! If you think this was an error, please let us know and we'll be onto it!"
        , outsideMain = pageButton (ChangedRoute HomeRoute) "red" (text "Take me back home!")
        }


errorPage : String -> Html Msg
errorPage errorString =
    pageBase
        { iconSpan = text "..."
        , isCentered = True
        , colour = "pink"
        , titleSpan = text "Oh no..."
        , bodyContent = text <| "It looks like there was an error. Sorry! Here are some of the details: " ++ errorString
        , outsideMain = pageButton (ChangedRoute HomeRoute) "pink" (text "Take me back home!")
        }


logoutPage : Html Msg
logoutPage =
    pageBase
        { iconSpan = text "..."
        , isCentered = True
        , colour = "green"
        , titleSpan = text "Bye!"
        , bodyContent = text "Thanks for participating! You've successfully logged out now."
        , outsideMain = pageButton (ChangedRoute HomeRoute) "green" (text "Take me back home!")
        }



-- Style helpers


puzzleColour : PuzzleSet -> String
puzzleColour puzzleSet =
    case puzzleSet of
        AbstractPuzzle ->
            "red"

        BeginnerPuzzle ->
            "yellow"

        ChallengePuzzle ->
            "green"

        MetaPuzzle ->
            "pink"



-- Loading Helpers


textWithLoad : Bool -> String -> Html Msg
textWithLoad isLoading str =
    case isLoading of
        True ->
            span [ class "text-grey-lighter bg-grey-lighter rounded" ] [ text str ]

        False ->
            text str


loremIpsum =
    """ Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do
eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim
veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo
consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum
dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident,
sunt in culpa qui officia deserunt mollit anim id est laborum.
"""



--- TABLES


tableCell : String -> String -> Bool -> Html Msg
tableCell widthStr str isHeader =
    if isHeader then
        th
            [ class <| "p-1 py-2" ++ widthStr ]
            [ text str ]

    else
        td
            [ class <| "p-1 py-2" ++ widthStr ]
            [ text str ]


type TableSize
    = ThinTable
    | WideTable


tableRow : TableSize -> Bool -> List String -> Html Msg
tableRow tableSize isHeader strList =
    let
        widthList =
            case tableSize of
                ThinTable ->
                    [ "w-1/5", "w-2/5", "w-1/5" ]

                WideTable ->
                    [ "w-1/5", "w-1/5", "w-1/5", "w-1/5", "w-1/5" ]
    in
    let
        classes =
            if isHeader then
                "w-full bg-grey-light text-sm text-grey-darker"

            else
                "w-full bg-grey-lightest text-center hover:bg-grey-lighter text-grey-darkest"
    in
    tr [ class classes ] <| List.map2 (\x y -> tableCell x y isHeader) widthList strList
