module View.Puzzle exposing (detailPuzzle, puzzleCard, puzzleContainer, puzzleTags)

import Functions.Functions exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Html.Lazy exposing (..)
import Markdown
import Msg.Msg exposing (..)
import RemoteData exposing (RemoteData(..), WebData)
import Types.Types exposing (..)


puzzleCard : PuzzleData -> (PuzzleData -> Msg) -> Html Msg
puzzleCard puzzle onSelectEvent =
    div [ class "column is-one-third-desktop is-half-tablet" ]
        [ div [ class "card puzzle", onClick <| onSelectEvent puzzle ]
            [ div [ class "card-image" ]
                [ figure [ class "image is-2by1" ]
                    [ img [ src "https://bulma.io/images/placeholders/1280x960.png", alt "Placeholder" ] []
                    ]
                ]
            , div [ class "card-content" ]
                [ div [ class "media" ]
                    [ div [ class "media-content" ]
                        [ p [ class "subtitle" ] [ text puzzle.title ] ]
                    ]
                , puzzleTags puzzle
                ]
            ]
        ]


puzzleTags puzzle =
    div [ class "content" ]
        [ div [ class "field is-grouped is-grouped-multiline" ]
            [ div [ class "control" ]
                [ div [ class "tags has-addons" ]
                    --[ span [ class "tag is-primary" ] [ text "Theme" ]
                    [ span [ class "tag is-primary" ] [ text puzzle.theme.theme ]
                    ]
                ]
            , div [ class "control" ]
                [ div [ class "tags has-addons" ]
                    --[ span [ class "tag is-info" ] [ text "Set" ]
                    [ span [ class "tag is-info" ] [ text <| puzzleSetString puzzle.set ]
                    ]
                ]
            , div [ class "control" ]
                [ div [ class "tags has-addons" ]
                    [ span [ class "tag has-background-grey-lighter" ] [ text "Open" ]
                    , span [ class "tag" ] [ text <| posixToString puzzle.theme.openDatetime ]
                    ]
                ]
            , div [ class "control" ]
                [ div [ class "tags has-addons" ]
                    [ span [ class "tag has-background-grey-lighter" ] [ text "Close" ]
                    , span [ class "tag" ] [ text <| posixToString puzzle.theme.closeDatetime ]
                    ]
                ]
            ]
        ]


puzzleContainer puzzles onSelectEvent =
    div [ class "columns is-multiline" ] <| List.map (\x -> puzzleCard x onSelectEvent) puzzles


detailPuzzle puzzle currentInput maybeSubmissionData onDeselectEvent =
    let
        solutionSection =
            case puzzle.answer of
                Just answer ->
                    section [ class "content" ]
                        [ div [ class "container" ]
                            [ h1 [ class "title" ] [ text "Solution" ]
                            , div [ class "message is-danger" ]
                                [ div [ class "message-body" ] [ text <| "The answer is " ++ answer ++ "." ] ]
                            ]
                        ]

                Nothing ->
                    div [ class "content" ] [ text "When you've solved the puzzle, enter your solution in the box in the footer." ]

        explanationSection =
            case puzzle.explanation of
                Just explanation ->
                    div [ class "content" ]
                        [ p [] <| Markdown.toHtml Nothing explanation ]

                Nothing ->
                    case puzzle.answer of
                        Just _ ->
                            div [ class "content" ] [ text "Hm...it looks like there's no explanation here. Sorry about that!" ]

                        Nothing ->
                            div [] []

        submitField =
            div [ class "field is-grouped" ]
                [ div [ class "control" ]
                    [ div [ class "field has-addons" ]
                        [ div [ class "control is-expanded" ]
                            [ input [ class "input", type_ "text", placeholder "Your submission here.", onInput <| PuzzlesMsg << OnChangeInput ] [] ]
                        , div [ class "control" ]
                            [ button [ class "button is-info", onClick <| PuzzlesMsg OnPostSubmission ] [ text "Submit" ] ]
                        ]
                    ]
                ]

        footerSection =
            case puzzle.answer of
                Just answer ->
                    div [ class "content" ] [ text "This puzzle has closed." ]

                -- Note to self...better way to do this?!? :(
                Nothing ->
                    case maybeSubmissionData of
                        Just webData ->
                            case webData of
                                Success submitData ->
                                    case submitData of
                                        OkSubmit submission ->
                                            case submission.isCorrect of
                                                True ->
                                                    div [ class "field" ]
                                                        [ div [ class "control is-expanded" ]
                                                            [ button [ class "button has-background-success has-text-white is-static" ]
                                                                [ text <| "Congratulations! You scored " ++ String.fromInt submission.points ++ " points!" ]
                                                            ]
                                                        ]

                                                False ->
                                                    submitField

                                        _ ->
                                            submitField

                                _ ->
                                    submitField

                        _ ->
                            submitField

        baseHeaderMessage colour msg =
            header [ class <| "modal-card-head has-text-white has-background-" ++ colour ] [ p [ class "content" ] [ text msg ] ]

        headerMessage =
            case maybeSubmissionData of
                Just webData ->
                    case webData of
                        Success submitData ->
                            case submitData of
                                OkSubmit submission ->
                                    case submission.isCorrect of
                                        True ->
                                            div [] []

                                        False ->
                                            baseHeaderMessage "warning" "Your response was incorrect. Have a break and have another go later :) "

                                TooSoonSubmit submission ->
                                    baseHeaderMessage "danger" <| "Your last attempt (" ++ posixToString submission.last ++ ", attempt no. " ++ String.fromInt submission.attempts ++ ") was too recent. You can next submit at " ++ posixToString submission.next ++ "."

                        Failure _ ->
                            baseHeaderMessage "danger" "Hm. There was an error with submitting your submission...maybe a network issue? If not, get in contact with us - we'd like to know!"

                        _ ->
                            div [] []

                Nothing ->
                    div [] []
    in
    div [ class "modal is-active" ]
        [ div [ class "modal-background" ] []
        , div [ class "modal-card" ]
            [ header [ class "modal-card-head" ]
                [ p [ class "modal-card-title" ]
                    [ text puzzle.title ]
                , button [ class "delete is-medium", onClick onDeselectEvent ] []
                ]
            , headerMessage
            , div [ class "modal-card-body" ]
                [ puzzleTags puzzle
                , div [ class "container" ]
                    [ div [ class "content" ]
                        [ p [] <| Markdown.toHtml Nothing puzzle.body ]
                    , div [ class "message" ]
                        [ div [ class "message-body" ] <| Markdown.toHtml Nothing puzzle.example
                        ]
                    , div [ class "notification is-info" ] <| Markdown.toHtml Nothing puzzle.statement
                    , hr [] []
                    , solutionSection
                    , explanationSection
                    ]
                ]
            , footer [ class "modal-card-foot" ]
                [ footerSection ]
            ]
        ]
