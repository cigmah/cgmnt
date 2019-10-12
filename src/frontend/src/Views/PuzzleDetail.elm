module Views.PuzzleDetail exposing (view)

import Browser
import Handlers
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Html.Lazy exposing (..)
import Http exposing (Error(..))
import Markdown
import RemoteData exposing (RemoteData(..), WebData)
import Time
import Types exposing (..)
import Views.Shared exposing (..)


type SubmitOrComment
    = PuzzleSubmit Submission (WebData SubmissionResponse)
    | PuzzleComment String (WebData CommentResponse)


view : Model -> PuzzleId -> PuzzleDetailState -> Html Msg
view model puzzleId puzzleDetailState =
    case puzzleDetailState of
        UserSolvedPuzzle puzzleDetailWebData comment commentResponseWebData ->
            webDataWrapper puzzleDetailWebData (puzzleView <| Just <| PuzzleComment comment commentResponseWebData)

        UserUnsolvedPuzzle puzzleDetailWebData submission submissionResponseWebData ->
            case ( puzzleDetailWebData, submissionResponseWebData ) of
                ( Success puzzleDetail, Success (OkSubmit data) ) ->
                    if data.isResponseCorrect then
                        justSolvedPuzzleView puzzleId puzzleDetail data

                    else
                        webDataWrapper puzzleDetailWebData (puzzleView <| Just <| PuzzleSubmit submission submissionResponseWebData)

                _ ->
                    webDataWrapper puzzleDetailWebData (puzzleView <| Just <| PuzzleSubmit submission submissionResponseWebData)

        PublicPuzzle puzzleDetailWebData ->
            webDataWrapper puzzleDetailWebData (puzzleView Nothing)


submissionBox : PuzzleId -> Submission -> Bool -> Html Msg
submissionBox puzzleId submission isSubmissionLoading =
    div [ class "submission-container" ]
        [ div [ class "submission-controls" ]
            [ Html.form [ class "submission", onSubmit (PuzzleMsg (ClickedSubmit puzzleId)) ]
                [ input [ type_ "text", placeholder "Submission", value submission, onInput (PuzzleMsg << ChangedSubmission), disabled isSubmissionLoading ] []
                , button [ disabled isSubmissionLoading ] [ text "Submit" ]
                ]
            ]
        ]


panelDiv : PuzzleSet -> Bool -> Html Msg
panelDiv puzzleSet on =
    if on then
        div [ class <| "panel on " ++ Handlers.puzzleSetString puzzleSet ] []

    else
        div [ class <| "panel off " ++ Handlers.puzzleSetString puzzleSet ] []


miniTableRow : PuzzleLeaderboardUnit -> Html Msg
miniTableRow puzzleLeaderboardUnit =
    tr []
        [ td [] [ a [ routeHref <| UserRoute puzzleLeaderboardUnit.username ] [ text puzzleLeaderboardUnit.username ] ]
        , td [] [ span [ class "timestamp" ] [ text <| Handlers.posixToString puzzleLeaderboardUnit.submissionDatetime ] ]
        ]


puzzleStatsView : PuzzleSet -> PuzzleStats -> Html Msg
puzzleStatsView puzzleSet { correct, incorrect, leaderboard } =
    let
        proportion =
            if incorrect == 0 then
                0

            else
                floor <| 10 * toFloat incorrect / toFloat (correct + incorrect)

        panel =
            List.map (panelDiv puzzleSet) <| List.repeat proportion True ++ List.repeat (10 - proportion) False

        tableText =
            if List.length leaderboard > 0 then
                "First five solvers: "

            else
                "No solvers yet."

        firstfive =
            table [ class "side-table" ] <|
                List.map miniTableRow leaderboard
    in
    div [ class "footnote" ]
        [ div [ class "puzzle-stats-container" ]
            [ div [ class "difficulty" ] [ text "Participant difficulty:" ]
            , div [ class "panel-container" ] panel
            , div [ class "text" ] [ text <| String.fromInt incorrect, text " incorrect and ", text <| String.fromInt correct, text " correct total submissions." ]
            , br [] []
            , text tableText
            , firstfive
            ]
        ]


calculateRemainingPoints : PuzzleDetail -> Int
calculateRemainingPoints puzzle =
    let
        base =
            case puzzle.theme.themeSet of
                SampleTheme ->
                    0

                _ ->
                    100

        remaining =
            Basics.max 0 (base - puzzle.stats.correct)

        multiplier =
            case puzzle.puzzleSet of
                ChallengePuzzle ->
                    2

                MetaPuzzle ->
                    4

                _ ->
                    1
    in
    remaining * multiplier


justSolvedPuzzleView : PuzzleId -> PuzzleDetail -> OkSubmitData -> Html Msg
justSolvedPuzzleView puzzleId puzzleDetail okSubmitData =
    div []
        [ h1 [] [ text "Congratulations." ]
        , p []
            [ text "You've just solved Puzzle No. "
            , text <| String.fromInt puzzleDetail.id
            , text " "
            , text <| puzzleDetail.title
            , text ", and earned "
            , text <| String.fromInt okSubmitData.points
            , text " points."
            ]
        , a [ routeHref HomeRoute ] [ text "Head back to the homepage." ]
        ]


makeComment : Comment -> Html Msg
makeComment comment =
    div [ class "comment-item" ]
        [ div [ class "comment-header" ] [ a [ routeHref (UserRoute comment.username) ] [ text comment.username ], text " wrote on ", text <| Handlers.posixToString comment.timestamp, text ":" ]
        , div [ class "comment-body" ] <| Markdown.toHtml Nothing comment.text
        ]


commentBox : String -> WebData CommentResponse -> Html Msg
commentBox comment webData =
    let
        isLoading =
            case webData of
                Loading ->
                    True

                _ ->
                    False
    in
    case webData of
        Success _ ->
            div [ class "comment-success" ] [ p [] [ text "Your comment was successfully added." ] ]

        _ ->
            div [ class "comment-container" ]
                [ Html.form [ class "comment-input-container", onSubmit (PuzzleMsg ClickedComment) ]
                    [ textarea
                        [ class "comment"
                        , value comment
                        , rows 8
                        , placeholder "Your comment in here, formattable with **markdown**."
                        , disabled isLoading
                        , onInput (PuzzleMsg << ChangedComment)
                        ]
                        []
                    , button [ class "comment-button", disabled isLoading ] [ text "Post Comment" ]
                    ]
                , div [ class "comment-preview-container" ]
                    [ br [] []
                    , div [] [ text "Your comment will be posted under your username. A preview of your comment's contents is below." ]
                    , div [ class "comment preview" ] <| Markdown.toHtml Nothing comment
                    ]
                ]


wrapSummary : String -> Html Msg -> Html Msg
wrapSummary summaryString msgHtml =
    details [ class "puzzle-details" ]
        [ summary [ class "puzzle-summary" ] [ text summaryString ]
        , msgHtml
        ]


puzzleView : Maybe SubmitOrComment -> PuzzleDetail -> Html Msg
puzzleView submitOrCommentMaybe puzzle =
    let
        numRemainingPoints =
            calculateRemainingPoints puzzle

        puzzleBody =
            let
                base =
                    div []
                        [ div [ class "main" ] <| Markdown.toHtml Nothing puzzle.body
                        , div [ class <| "input " ++ Handlers.puzzleSetString puzzle.puzzleSet ] <| Markdown.toHtml Nothing puzzle.input
                        , div [ class "footnote" ] [ text "Punctuation, whitespace and capitalisation do not matter and are not checked. You can include punctuation or whitespace if it makes typing easier." ]
                        , div [ class "statement" ] <| Markdown.toHtml Nothing puzzle.statement
                        ]
            in
            case submitOrCommentMaybe of
                Just (PuzzleComment _ _) ->
                    wrapSummary "Click to show the puzzle." base

                _ ->
                    base

        extraContent =
            case submitOrCommentMaybe of
                Just submitOrComment ->
                    case submitOrComment of
                        PuzzleSubmit submission response ->
                            case response of
                                Loading ->
                                    submissionBox puzzle.id submission True

                                Success responseData ->
                                    submissionBox puzzle.id submission False

                                _ ->
                                    submissionBox puzzle.id submission False

                        PuzzleComment comment response ->
                            case ( puzzle.answer, puzzle.explanation, puzzle.comments ) of
                                ( Just answer, Just explanation, Just comments ) ->
                                    div [ class "solution-body" ]
                                        [ wrapSummary "Click to show the answer." (div [ class "puzzle-answer" ] [ text "The answer is ", span [ class "answer" ] [ text answer ], text "." ])
                                        , wrapSummary "Click to show the map hint and writer's notes." <| div [ class "puzzle-explanation" ] <| Markdown.toHtml Nothing explanation
                                        , wrapSummary "Click to show the comments." <|
                                            div [ class "puzzle-comments" ] <|
                                                case List.length comments of
                                                    0 ->
                                                        [ text "No comments yet." ]

                                                    _ ->
                                                        List.map makeComment comments
                                        , hr [] []
                                        , h3 [] [ text "Post a new comment." ]
                                        , commentBox comment response
                                        ]

                                _ ->
                                    div [] []

                Nothing ->
                    div [ style "text-align" "right" ] [ text "Login to submit a response." ]
    in
    div [ class "puzzle" ]
        [ puzzleStatsView puzzle.puzzleSet puzzle.stats
        , h1 [ class <| "main-header " ++ Handlers.puzzleSetString puzzle.puzzleSet ]
            [ text "№"
            , text <| String.fromInt puzzle.id
            , text " "
            , text puzzle.title
            ]
        , div [ class "footnote" ]
            [ text "This puzzle is the "
            , span [ class "puzzle-set" ] [ text <| Handlers.puzzleSetString puzzle.puzzleSet ]
            , text " puzzle from the theme "
            , span [ class "theme" ] [ text puzzle.theme.themeTitle ]
            , text ". It was released on "
            , span [ class "timestamp" ] [ text <| Handlers.posixToString puzzle.theme.openDatetime ]
            , text " and is worth "
            , text <| String.fromInt numRemainingPoints
            , text " points for the next solver."
            , div [ class "references" ] <| Markdown.toHtml Nothing puzzle.references
            ]
        , puzzleBody
        , extraContent
        ]
