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
    span [ class "inline-block font-semibold lowercase rounded-full px-3 py-1 text-sm text-white", classList [ ( colour, True ) ] ]
        [ text <| "#" ++ Utils.puzzleSetString puzzleSet ]


tagSetPlaceholder =
    span [ class "inline-block font-semibold lowercase rounded-full px-3 py-1 text-sm text-grey-light bg-grey-light" ]
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
        [ div [ class "m-3 bg-white rounded-lg shadow  verflow-hidden " ]
            [ div [ class "w-full h-32 overflow-hidden resize" ]
                [ img [ class "w-full bg-grey-lighter" ] [] ]
            , div [ class "px-6 pt-4" ]
                [ div [ class "font-light text-lg " ] [ loadingState <| text <| slice 0 20 loremIpsum ] ]
            , div [ class "px-6 pt-2 pb-4" ] [ tagSetPlaceholder ]
            ]
        ]


loadingPuzzlePage =
    div [ class "" ]
        [ div [ class "h-16" ] []
        , h1 [ class "font-sans font-normal text-2xl  border-grey-light border-b-4 text-primary rounded-lg rounded-b-none  p-3 mt-8 mb-4" ] [ loadingState <| text "Unsolved Puzzles" ]
        , div [ class "block md:flex md:flex-wrap" ] <| List.repeat 4 puzzleCardPlaceholder
        , hr [] []
        , h1 [ class "font-sans font-normal text-2xl  border-grey-light border-b-4 text-primary rounded-lg rounded-b-none  p-3 mt-8 mb-4" ] [ loadingState <| text "Solved Puzzles" ]
        , div [ class "block md:flex md:flex-wrap" ] <| List.repeat 4 puzzleCardPlaceholder
        ]


detailPuzzle puzzle onDeselectEvent =
    div []
        [ div [ class "h-16 pin-t fixed bg-grey-lighter w-full" ]
            [ div [ class "content" ]
                [ button [ class "mt-3 mb-3 p-3 bg-grey rounded shadow text-white hover:bg-grey-dark", onClick onDeselectEvent ]
                    [ text "Back to Puzzles" ]
                ]
            ]
        , div [ class "content" ]
            [ div [ class "pt-24" ]
                [ div [ class "font-normal font-sans text-4xl pb-3" ] <| Markdown.toHtml Nothing puzzle.title
                , div [ class "" ] <| Markdown.toHtml Nothing puzzle.body
                , div [ class "bg-white mt-3 mb-3 rounded font-light shadow p-4 border-grey border-l-8" ] <| Markdown.toHtml Nothing puzzle.example
                , div [ class "" ] <| Markdown.toHtml Nothing puzzle.statement
                ]
            ]
        ]
