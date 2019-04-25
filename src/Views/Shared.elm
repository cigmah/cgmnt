module Views.Shared exposing (Colour, PageBaseData, TableSize(..), errorPage, loadingPage, loremIpsum, navLink, navMenu, navMenuBase, navMenuWithAuth, navMenuWithoutAuth, notFoundPage, pageBase, pageButton, puzzleColour, puzzleLoadingPage, puzzleSetSpan, routeHref, tableCell, tableRow, textWithLoad, userBox)

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


colourThemeToToggleString colourTheme =
    case colourTheme of
        Dark ->
            "lighten"

        Light ->
            "darken"


navMenuBase : Bool -> List ( Route, String, Bool ) -> Html Msg -> List ( Route, String, Bool ) -> ColourTheme -> Html Msg
navMenuBase navActive leftLinks userSpan rightLinks colourTheme =
    nav
        [ class "nav" ]
    <|
        List.concat
            [ List.map navLink leftLinks
            , [ span
                    [ style "padding-right" "1em"
                    , style "color" "var(--foreground-inactive)"
                    ]
                    [ text "|" ]
              ]
            , [ userSpan ]
            , List.map navLink rightLinks
            , [ span
                    [ style "padding-right" "1em"
                    , style "color" "var(--foreground-inactive)"
                    ]
                    [ text "|" ]
              , span
                    [ class "theme-switch", onClick ToggledTheme ]
                    [ text <| colourThemeToToggleString colourTheme ]
              ]
            ]


navLink : ( Route, String, Bool ) -> Html Msg
navLink ( route, name, active ) =
    let
        extraStyles =
            if active then
                [ style "color" "var(--foreground)"
                , style "font-weight" "bold"
                ]

            else
                []
    in
    a
        (routeHref route :: extraStyles)
        [ text name ]


userBox name =
    span
        [ style "padding-right" "1em"
        , style "color" "var(--foreground)"
        , style "font-weight" "bold"
        ]
        [ text name ]


navMenuWithAuth : Bool -> Credentials -> Page -> ColourTheme -> Html Msg
navMenuWithAuth navActive credentials page colourTheme =
    let
        active =
            Handlers.pageActive page

        leftLinks =
            [ ( HomeRoute, "info", active.home )
            , ( PuzzleListRoute, "puzzles", active.puzzles )
            , ( LeaderboardRoute, "leaderboard", active.leaderboard )
            , ( PrizesRoute, "prizes", active.prizes )
            ]

        userSpan =
            userBox credentials.username

        rightLinks =
            [ ( LogoutRoute, "logout", False ) ]
    in
    navMenuBase navActive leftLinks userSpan rightLinks colourTheme


navMenuWithoutAuth : Bool -> Page -> ColourTheme -> Html Msg
navMenuWithoutAuth navActive page colourTheme =
    let
        active =
            Handlers.pageActive page

        leftLinks =
            [ ( HomeRoute, "info", active.home )
            , ( PuzzleListRoute, "puzzles", active.puzzles )
            , ( LeaderboardRoute, "leaderboard", active.leaderboard )
            , ( PrizesRoute, "prizes", active.prizes )
            ]

        userSpan =
            span [] []

        rightLinks =
            [ ( RegisterRoute, "register", active.register )
            , ( LoginRoute, "login", active.login )
            ]
    in
    navMenuBase navActive leftLinks userSpan rightLinks colourTheme


navMenu : Bool -> Auth -> Page -> ColourTheme -> Html Msg
navMenu navActive auth page colourTheme =
    case auth of
        User credentials ->
            navMenuWithAuth navActive credentials page colourTheme

        Public ->
            navMenuWithoutAuth navActive page colourTheme



-- Not Found and Error Page


type alias Colour =
    String


pageButton : Msg -> Colour -> Html Msg -> Html Msg
pageButton msg colour textSpan =
    let
        bgClass =
            "bg-" ++ colour

        borderClass =
            "border-" ++ colour ++ "-dark"
    in
    div
        [ class "flex w-full justify-center" ]
        [ div [ class "border-t-2 border-grey-lightest active:border-t-4 hover:border-t-0 w-full flex items-center justify-center" ]
            [ button
                [ class "px-3 py-2 rounded-lg border-b-2 w-full md:w-1/2 text-white active:border-b-0 hover:border-b-4 outline-none focus:outline-none active:outline-none "
                , classList [ ( bgClass, True ), ( borderClass, True ) ]
                , onClick msg
                ]
                [ textSpan ]
            ]
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


loadingPage : Html Msg
loadingPage =
    div [ class "main" ]
        [ div [ class "loading-container" ]
            [ div [ class "loader" ] []
            ]
        ]


puzzleLoadingPage : Html Msg
puzzleLoadingPage =
    div [ class "main" ]
        [ div [ class "puzzle-container" ]
            [ div [ class "puzzle" ]
                [ div
                    [ style "display" "flex"
                    , style "justify-content" "center"
                    , style "align-content" "center"
                    , style "align-items" "center"
                    , style "height" "100%"
                    ]
                    [ div [ class "loading-container" ]
                        [ div [ class "loader" ] []
                        ]
                    ]
                ]
            ]
        ]


notFoundPage : Html Msg
notFoundPage =
    div [ class "main" ]
        [ div [ class "loading-container" ]
            [ text "that page wasn't found."
            ]
        ]


errorPage : String -> Html Msg
errorPage errorString =
    div [ class "main" ]
        [ div [ class "loading-container", style "max-width" "600px" ]
            [ text "There was an error. Here's what we know."
            , br [] []
            , text errorString
            ]
        ]



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
                    [ "w-1/5", "w-2/5", "w-1/5", "w-1/5" ]

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


puzzleSetSpan isLoading puzzleSet =
    span
        [ class "px-2 rounded "
        , classList [ ( "text-white text-sm bg-" ++ puzzleColour puzzleSet, not isLoading ), ( "bg-grey-light text-grey-light", isLoading ) ]
        ]
        [ text <| Handlers.puzzleSetString puzzleSet ]
