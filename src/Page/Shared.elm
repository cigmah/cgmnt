module Page.Shared exposing (detailOpenPuzzle, detailPuzzle, detailPuzzleWithSolution, loadingPuzzlePage, loadingState, loremIpsum, puzzleCard, puzzleCardPlaceholder)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Html.Lazy exposing (..)
import Markdown
import RemoteData exposing (RemoteData(..), WebData)
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
                    "bg-primary"

                B ->
                    "bg-secondary"

                C ->
                    "bg-highlight"

                M ->
                    "bg-grey-dark"
    in
    span [ class "inline-block font-semibold lowercase rounded-full mt-2 px-3 py-1 text-sm text-white", classList [ ( colour, True ) ] ]
        [ text <| "#" ++ Utils.puzzleSetString puzzleSet ]


tagSetPlaceholder =
    span [ class "inline-block font-semibold lowercase rounded-full mt-2 px-3 py-1 text-sm text-grey-light bg-grey-light" ]
        [ loadingState <| text <| slice 0 8 loremIpsum ]


puzzleCard clickedPuzzleEvent puzzle =
    div [ class "md:w-1/2 lg:w-1/4" ]
        [ div [ class "m-3 bg-white rounded-lg shadow overflow-hidden cursor-pointer hover:shadow-md", onClick (clickedPuzzleEvent puzzle) ]
            [ div [ class "w-full h-32 overflow-hidden resize" ]
                [ img [ class "w-full resize", src puzzle.imagePath ] [] ]
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
    div [ class "md:flex md:inline-flex text-sm mr-2" ]
        [ div [ class "ml-2 inline-block" ] [ tagSet puzzle.set ]
        , div [ class "inline-flex ml-2 mt-2 bg-grey-darkest text-white rounded-full px-3 py-1" ] [ text puzzle.theme.theme ]
        , div [ class " ml-2 mt-2 inline-flex" ]
            [ div [ class "bg-grey-darker rounded-l-full  px-3 py-1 text-white" ] [ text "Start" ]
            , div [ class "bg-grey-lighter px-3 py-1 rounded-r-full text-grey-darkest" ] [ text <| Utils.posixToString puzzle.theme.openDatetime ]
            ]
        , div [ class "ml-2 mt-2 inline-flex" ]
            [ div [ class "bg-grey-darker px-3 py-1 rounded-l-full text-white" ] [ text "End" ]
            , div [ class "bg-grey-lighter px-3 py-1 rounded-r-full text-grey-darkest" ] [ text <| Utils.posixToString puzzle.theme.closeDatetime ]
            ]
        ]


detailPuzzle puzzle onDeselectEvent headerColour =
    div [ class "" ]
        [ div [ class "h-12 pin-t pin-x fixed shadow w-full", classList [ ( headerColour, True ) ] ]
            [ div [ class "content" ]
                [ button
                    [ class "m px-3 h-12 py-1 font-normal hover:bg-secondary  text-white "
                    , classList [ ( headerColour, True ) ]
                    , onClick onDeselectEvent
                    ]
                    [ text "Back to Puzzles" ]
                ]
            ]
        , div [ class "content bg-white shadow mt-16 p-6 rounded-lg mb-32" ]
            [ div [ class "pt-4" ]
                [ div [ class "xl:flex xl:justify-between xl:flex-wrap" ]
                    [ div [ class "font-light font-sans text-4xl text-black " ] <| Markdown.toHtml Nothing puzzle.title
                    , div [ class "mb-4 mt-2 align-end " ] [ puzzleTagsList puzzle ]
                    ]
                , div [ class "rounded-lg mt-4 mb-3 w-full overflow-hidden resize" ]
                    [ img [ class "w-full resize", src puzzle.imagePath ] [] ]
                , div [ class "markdown" ] <| Markdown.toHtml Nothing puzzle.body
                , div [ class "bg-white mt-8 mb-3 rounded font-light p-4 pt-2 border-grey rounded-l-none border-l-4 markdown overflow-auto" ] <| [ div [ class "font-light pt-3 pb-3 text-xl italic" ] [ text "Example" ] ] ++ Markdown.toHtml Nothing puzzle.example
                , div [ class "markdown pt-3 pb-12 mt-6 font-sans font-light text-center text-xl" ] <| Markdown.toHtml Nothing puzzle.statement
                ]
            ]
        ]


detailOpenPuzzle : SelectedPuzzleInfo -> msg -> (String -> msg) -> msg -> msg -> WebData SubmissionResponse -> Html msg
detailOpenPuzzle selectedPuzzle onDeselectEvent onChangeSubmissionEvent onSubmitEvent removeMsg submissionResponse =
    let
        headerColour =
            case selectedPuzzle.isCompleted of
                True ->
                    "bg-secondary-light"

                False ->
                    "bg-secondary-light"

        message =
            case submissionResponse of
                Loading ->
                    Nothing

                NotAsked ->
                    Nothing

                Success (OkSubmit data) ->
                    case data.isCorrect of
                        False ->
                            Just "Sorry, your submission was incorrect - great attempt though! Have a break and try again later :)"

                        _ ->
                            Nothing

                Success (TooSoonSubmit data) ->
                    Just <| "Your last attempt (" ++ Utils.posixToString data.last ++ ", attempt no. " ++ String.fromInt data.attempts ++ ") was too recent. You can next submit at " ++ Utils.posixToString data.next ++ "."

                _ ->
                    Just "Hm. There was an error with submitting your submission...maybe a network issue? If not, get in contact with us - we'd like to know!"

        messageDiv =
            case message of
                Just messageText ->
                    div [ class "bg-primary text-white p-3 text-center fixed pin-b pin-x h-36 pb-20", onClick removeMsg ] [ text messageText ]

                Nothing ->
                    div [] []

        puzzleFooter =
            case selectedPuzzle.isCompleted of
                True ->
                    div [ class "pin-b pin-x fixed text-center text-white font-semibold bg-secondary-light" ]
                        [ div [ class "p-4" ] [ text "You've finished this puzzle - great work! The solution will be revealed when the theme ends." ] ]

                False ->
                    div [ class "pin-b pin-x shadow fixed h-16 bg-secondary-light px-4" ]
                        [ div [ class "flex justify-center" ]
                            [ div [ class "inline-flex m-2 w-full md:w-1/2" ]
                                [ input
                                    [ class "rounded-l-full w-full px-4 py-3 border-b-2 bg-grey-lighter focus:bg-grey-lightest "
                                    , type_ "text"
                                    , placeholder "Your submission here."
                                    , onInput onChangeSubmissionEvent
                                    ]
                                    []
                                , button [ class "bg-grey px-3 text-white rounded-r-full hover:bg-grey-dark", onClick onSubmitEvent ] [ text "Submit" ]
                                ]
                            ]
                        ]
    in
    div []
        [ detailPuzzle selectedPuzzle.puzzle onDeselectEvent headerColour
        , messageDiv
        , puzzleFooter
        ]


detailPuzzleWithSolution puzzle onDeselectEvent =
    div [ class "mb-8" ]
        [ detailPuzzle puzzle onDeselectEvent "bg-secondary-light"
        , div [ class "content shadow rounded-lg p-6 bg-white mb-8" ]
            [ div [ class "font-light font-sans text-4xl pb-3 " ] [ text "Solution" ]
            , div [ class "p-3 text-center " ] [ text "The answer is ", span [ class "font-bold" ] [ text puzzle.answer ], text "." ]
            , div [ class "markdown pb-12" ] <| Markdown.toHtml Nothing puzzle.explanation
            ]
        ]
