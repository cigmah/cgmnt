module Page.Shared exposing (detailPuzzle, loadingPuzzlePage, loadingState, loremIpsum, puzzleCard, puzzleCardPlaceholder)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Html.Lazy exposing (..)
import Markdown
import String exposing (slice)
import Types exposing (..)
import Utils


loadingState textMsg =
    span [ class "text-grey-light bg-grey-light rounded" ] [ textMsg ]


loremIpsum =
    """ Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do
eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim
veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo
consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum
dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident,
sunt in culpa qui officia deserunt mollit anim id est laborum.
"""


tagSet puzzleSet =
    let
        colour =
            case puzzleSet of
                A ->
                    "bg-red-light"

                B ->
                    "bg-blue-light"

                C ->
                    "bg-primary-light"

                M ->
                    "bg-pink-light"
    in
    span [ class "inline-block font-semibold lowercase rounded-full mt-2 px-3 py-1 text-sm text-white", classList [ ( colour, True ) ] ]
        [ text <| "#" ++ Utils.puzzleSetString puzzleSet ]


tagSetPlaceholder =
    span [ class "inline-block font-semibold lowercase rounded-full mt-2 px-3 py-1 text-sm text-grey-light bg-grey-light" ]
        [ loadingState <| text <| slice 0 8 loremIpsum ]


puzzleCard : (FullPuzzleData -> msg) -> FullPuzzleData -> Html msg
puzzleCard clickedPuzzleEvent puzzle =
    div [ class "md:w-1/2 lg:w-1/4" ]
        [ div [ class "m-3 bg-white rounded-lg shadow overflow-hidden cursor-pointer hover:shadow-md", onClick (clickedPuzzleEvent puzzle) ]
            [ div [ class "w-full h-32 overflow-hidden resize" ]
                [ img [ class "w-full", src puzzle.imagePath ] [] ]
            , div [ class "px-6 pt-4" ]
                [ div [ class "font-light text-lg " ] [ text <| "#" ++ String.fromInt puzzle.id ++ " " ++ puzzle.title ] ]
            , div [ class "px-6 pt-2 pb-4" ] [ tagSet puzzle.set ]
            ]
        ]


puzzleCardPlaceholder =
    div [ class "md:w-1/2 lg:w-1/4" ]
        [ div [ class "m-3 bg-white rounded-lg shadow  overflow-hidden " ]
            [ div [ class "w-full h-32 overflow-hidden resize" ]
                [ img [ class "w-full bg-grey-lighter border-white" ] [] ]
            , div [ class "px-6 pt-4" ]
                [ div [ class "font-light text-lg " ] [ loadingState <| text <| slice 0 20 loremIpsum ] ]
            , div [ class "px-6 pt-2 pb-4" ] [ tagSetPlaceholder ]
            ]
        ]


loadingPuzzlePage =
    div [ class "" ]
        [ div [ class "h-16" ] []
        , h1 [ class "font-sans font-normal text-2xl border-grey-light border-b-4 text-primary rounded-lg rounded-b-none  p-3 mt-8 mb-4" ] [ loadingState <| text "Unsolved Puzzles" ]
        , div [ class "block md:flex md:flex-wrap" ] <| List.repeat 4 puzzleCardPlaceholder
        , hr [] []
        , h1 [ class "font-sans font-normal text-2xl  border-grey-light border-b-4 text-primary rounded-lg rounded-b-none  p-3 mt-8 mb-4" ] [ loadingState <| text "Solved Puzzles" ]
        , div [ class "block md:flex md:flex-wrap" ] <| List.repeat 4 puzzleCardPlaceholder
        ]


puzzleTagsList puzzle =
    div [ class "md:flex md:inline-flex text-sm" ]
        [ tagSet puzzle.set
        , div [ class "inline-flex ml-2 mt-2 bg-primary-light text-white rounded-full px-3 py-1" ] [ text puzzle.theme.theme ]
        , div [ class " ml-2 mt-2 inline-flex" ]
            [ div [ class "bg-primary-light rounded-l px-3 py-1 text-white" ] [ text "Start" ]
            , div [ class "bg-grey-light px-3 py-1 rounded-r text-grey-darkest" ] [ text <| Utils.posixToString puzzle.theme.openDatetime ]
            ]
        , div [ class "ml-2 mt-2 inline-flex" ]
            [ div [ class "bg-primary-light px-3 py-1 rounded-l text-white" ] [ text "End" ]
            , div [ class "bg-grey-light px-3 py-1 rounded-r text-grey-darkest" ] [ text <| Utils.posixToString puzzle.theme.closeDatetime ]
            ]
        ]


detailPuzzle puzzle onDeselectEvent =
    div [ class "" ]
        [ div [ class "h-16 pin-t pin-x fixed bg-grey shadow w-full" ]
            [ div [ class "content" ]
                [ button [ class "m-2 px-5 py-3 font-normal hover:bg-white rounded-full border-2 hover:text-grey-dark bg-grey text-white border-grey-light hover:border-white", onClick onDeselectEvent ]
                    [ text "Back to Puzzles" ]
                ]
            ]
        , div [ class "content" ]
            [ div [ class "pt-24" ]
                [ div [ class "font-semibold font-sans text-4xl text-primary rounded-t border-b-4 pb-4 border-primary pb-3" ] <| Markdown.toHtml Nothing puzzle.title
                , div [ class "mb-3 mt-3 w-full" ] [ puzzleTagsList puzzle ]
                , div [ class "markdown" ] <| Markdown.toHtml Nothing puzzle.body
                , div [ class "bg-white mt-3 mb-3 rounded font-light shadow p-4 pt-2 border-primary rounded-l-none border-l-8 markdown" ] <| Markdown.toHtml Nothing puzzle.example
                , div [ class "markdown" ] <| Markdown.toHtml Nothing puzzle.statement
                ]
            ]
        ]
