module Page.Shared exposing (PuzzlePageType(..), fullPuzzlePage, loadingState, loremIpsum, puzzleCard, textWithLoad)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Html.Lazy exposing (..)
import Markdown
import RemoteData exposing (RemoteData(..), WebData)
import String exposing (slice)
import Types exposing (..)
import Utils


loadingState isLoading textMsg =
    case isLoading of
        True ->
            span [ class "text-grey-lighter bg-grey-lighter rounded" ] [ textMsg ]

        False ->
            textMsg


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


type PuzzlePageType a
    = ArchivePublic (List (PuzzleData a))
    | ArchiveUser (List (PuzzleData a)) (List (PuzzleData a))
    | Open (List (PuzzleData a)) (List (PuzzleData a))


puzzleCard isLoading onClickPuzzle puzzle =
    let
        colour =
            case puzzle.set of
                A ->
                    "red-light"

                B ->
                    "teal"

                C ->
                    "green"

                M ->
                    "grey-dark"

        onClickPuzzleAttrs =
            case onClickPuzzle of
                Nothing ->
                    []

                Just event ->
                    [ onClick (event puzzle) ]
    in
    div
        [ class "block w-full md:w-1/2 lg:w-1/3 xl:w-1/4 p-3" ]
        [ div
            ([ class "group w-full rounded-lg cursor-pointer active:border-b-0 " ] ++ onClickPuzzleAttrs)
            [ div
                [ class "flex flex-col group-hover:opacity-75 items-center align-center justify-center rounded-t-lg" ]
                [ img
                    [ class "resize rounded-full h-24 w-24", src puzzle.imagePath ]
                    []
                ]
            , div
                [ class "inline-flex w-full justify-center" ]
                [ div
                    [ class "flex flex-wrap items-center py-4 px-2 rounded-tr text-white" ]
                    [ div
                        [ class "px-2 pb-1 pt-0 text-lg w-full rounded-b text-sm text-grey-darkest text-center" ]
                        [ span [ class "text-xs pr-2" ] [ textWithLoad isLoading <| "№ " ++ String.fromInt puzzle.id ]
                        , textWithLoad isLoading <| puzzle.title
                        ]
                    , div
                        [ class "ml-1 inline-flex flex-wrap w-full justify-center items-center pb-2" ]
                        [ div
                            [ class <|
                                String.concat [ "px-2 py-1 mt-1 text-xs rounded-full mr-2 ", "bg-" ++ colour ]
                            , classList [ ( "text-" ++ colour, isLoading ), ( "text-white", not isLoading ) ]
                            ]
                            [ text <| Utils.puzzleSetString puzzle.set ]
                        , div
                            [ class "px-2 py-1 mt-1 text-xs rounded-full bg-grey-light mr-2"
                            , classList [ ( "text-grey-light", isLoading ), ( "text-grey-darker", not isLoading ) ]
                            ]
                            [ text puzzle.theme.theme ]
                        ]
                    , div
                        [ class "px-2 pb-2 pt-0 text-xs w-full text-center rounded-b text-grey-dark" ]
                        [ textWithLoad isLoading <| String.concat [ Utils.posixToString puzzle.theme.openDatetime, " - ", Utils.posixToString puzzle.theme.closeDatetime ] ]
                    ]
                ]
            ]
        ]


fullPuzzlePage isLoading errorMsg puzzlePageType onClickPuzzle =
    let
        pageTitle =
            case puzzlePageType of
                ArchivePublic _ ->
                    "Puzzle Archive"

                ArchiveUser _ _ ->
                    "My Puzzle Archive"

                Open _ _ ->
                    "Open Puzzles"

        introText =
            case puzzlePageType of
                ArchivePublic _ ->
                    div [] []

                ArchiveUser _ _ ->
                    div []
                        [ span
                            [ class "text-xl" ]
                            [ p
                                []
                                [ textWithLoad isLoading "These puzzles have closed." ]
                            ]
                        , br
                            []
                            []
                        , p
                            []
                            [ textWithLoad isLoading "They now contain both the original puzzle, and our own solution writeup. Click on a puzzle to view it." ]
                        , br
                            []
                            []
                        , p
                            []
                            [ textWithLoad isLoading "Puzzles you didn't solve during the puzzle hunt:" ]
                        , br
                            []
                            []
                        ]

                Open _ _ ->
                    div [] []

        unsolvedPuzzles =
            case puzzlePageType of
                ArchivePublic puzzles ->
                    div [ class "flex flex-wrap" ] <| List.map (puzzleCard isLoading onClickPuzzle) puzzles

                ArchiveUser puzzles _ ->
                    div [ class "flex flex-wrap" ] <| List.map (puzzleCard isLoading onClickPuzzle) puzzles

                Open puzzles _ ->
                    div [ class "flex flex-wrap" ] <| List.map (puzzleCard isLoading onClickPuzzle) puzzles

        solvedText =
            case puzzlePageType of
                ArchivePublic _ ->
                    div [] []

                ArchiveUser _ _ ->
                    div
                        [ class "pt-3 pb-2" ]
                        [ p
                            []
                            [ textWithLoad isLoading "Puzzles you solved during the puzzle hunt:" ]
                        ]

                Open _ _ ->
                    div [] []

        solvedPuzzles =
            case puzzlePageType of
                ArchivePublic _ ->
                    div [] []

                ArchiveUser _ puzzles ->
                    div [ class "flex flex-wrap" ] <| List.map (puzzleCard isLoading onClickPuzzle) puzzles

                Open _ puzzles ->
                    div [ class "flex flex-wrap" ] <| List.map (puzzleCard isLoading onClickPuzzle) puzzles

        errorDiv =
            case errorMsg of
                Just message ->
                    div
                        [ id "message-box", class "flex pin-b pin-x h-auto p-4 pb-6 fixed bg-grey-light text-grey-darkest justify-center text" ]
                        [ span
                            [ class "text-center md:w-3/4 " ]
                            [ text "Hmm, it looks like there was an error. Let us know!" ]
                        ]

                Nothing ->
                    div [] []
    in
    div
        [ class "px-8 bg-grey-lightest" ]
        [ div
            [ class "mb-4 flex flex-wrap content-center justify-center items-center pt-16" ]
            [ div
                [ class "block lg:w-5/6" ]
                [ div
                    [ class "inline-flex flex justify-center w-full" ]
                    [ div
                        [ class "flex items-center  sm:text-xl justify-center  px-5 py-3 rounded-l-lg font-black bg-teal  border-b-2 border-teal-dark"
                        , classList [ ( "text-white", not isLoading ), ( "text-teal", isLoading ) ]
                        ]
                        [ span
                            [ class "fas fa-book-reader" ]
                            []
                        ]
                    , div
                        [ class "flex items-center  w-full p-3 px-5 rounded-r-lg text-grey-darkest sm:text-lg font-bold uppercase bg-grey-lighter border-b-2 border-grey" ]
                        [ textWithLoad isLoading pageTitle ]
                    ]
                , div
                    [ class "block w-full my-3 bg-white rounded-lg p-6 pb-2 w-full text-base border-b-2 border-grey-light" ]
                    [ introText
                    , unsolvedPuzzles
                    , solvedText
                    , solvedPuzzles
                    ]
                ]
            ]
        , errorDiv
        ]
