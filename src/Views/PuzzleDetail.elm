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


view : Meta -> PuzzleShow -> PuzzleDetailState -> ( String, Html Msg )
view meta puzzleShow puzzleDetailState =
    let
        title =
            "Puzzles - CIGMAH"

        body =
            case ( meta.auth, puzzleDetailState ) of
                ( Public, PublicPuzzle puzzleId webData ) ->
                    case webData of
                        Loading ->
                            puzzleLoadingPage

                        Success puzzle ->
                            detailPuzzlePage puzzleShow puzzle (Just "Login to submit your answer.") False

                        Failure e ->
                            case e of
                                BadStatus metadata ->
                                    errorPage metadata.body

                                NetworkError ->
                                    errorPage "There's something wrong with your network or with accessing the backend - check your internet connection first and check the console for any network errors."

                                _ ->
                                    errorPage "Unfortunately, we don't yet know what this error is. :(  "

                        NotAsked ->
                            errorPage "Hmm. It seems the request didn't go through. Try refreshing!"

                ( User credentials, UserPuzzle puzzleId webData ) ->
                    case webData of
                        Loading ->
                            puzzleLoadingPage

                        Success puzzle ->
                            detailPuzzlePage puzzleShow puzzle Nothing False

                        Failure e ->
                            case e of
                                BadStatus metadata ->
                                    errorPage metadata.body

                                NetworkError ->
                                    errorPage "There's something wrong with your network or with accessing the backend - check your internet connection first and check the console for any network errors."

                                _ ->
                                    errorPage "Unfortunately, we don't yet know what this error is. :(  "

                        NotAsked ->
                            errorPage "Hmm. It seems the request didn't go through. Try refreshing!"

                ( User credentials, UnsolvedPuzzleLoaded puzzleId data submission webData ) ->
                    case webData of
                        NotAsked ->
                            detailPuzzlePage puzzleShow data Nothing False

                        Loading ->
                            detailPuzzlePage puzzleShow data Nothing True

                        Failure e ->
                            detailPuzzlePage puzzleShow data (Just "Hm. It seems there was an error. Let us know!") False

                        Success submissionResponse ->
                            case submissionResponse of
                                OkSubmit okSubmitData ->
                                    case okSubmitData.isResponseCorrect of
                                        True ->
                                            successScreen data okSubmitData

                                        False ->
                                            detailPuzzlePage puzzleShow data (Just "Unfortunately, that answer was incorrect. Have a break and try again :)") False

                                TooSoonSubmit tooSoonSubmitData ->
                                    let
                                        messageString =
                                            String.concat
                                                [ "You submitted your last submission (at "
                                                , Handlers.posixToString tooSoonSubmitData.last
                                                , ", attempt no. "
                                                , String.fromInt tooSoonSubmitData.attempts
                                                , ") too recently. You can next submit at "
                                                , Handlers.posixToString tooSoonSubmitData.next
                                                , "."
                                                ]
                                    in
                                    detailPuzzlePage puzzleShow data (Just messageString) False

                ( _, _ ) ->
                    notFoundPage
    in
    ( title, body )


type alias Message =
    String


type PaddingSize
    = WithSubmissionBox
    | WithoutSubmissionBox


messageBox : Message -> Html Msg
messageBox message =
    div
        [ class "message"
        , onClick ToggledMessage
        ]
        [ text message ]


submissionInput : PuzzleId -> Bool -> Html Msg
submissionInput puzzleId isLoading =
    let
        submitText =
            case isLoading of
                True ->
                    "Loading..."

                False ->
                    "Submit"
    in
    div [ class "submission-container" ]
        [ input
            [ type_ "text"
            , placeholder "Submission"
            , onSubmit (PuzzleDetailClickedSubmit puzzleId)
            , onInput PuzzleDetailChangedSubmission
            , disabled isLoading
            ]
            []
        , button [ type_ "submit", onClick (PuzzleDetailClickedSubmit puzzleId), disabled isLoading ] [ text "Submit" ]
        ]


detailPuzzlePage : PuzzleShow -> DetailPuzzleData -> Maybe Message -> Bool -> Html Msg
detailPuzzlePage puzzleShow puzzle maybeMessage isInputLoading =
    let
        ( solutionBody, puzzleBottom ) =
            case ( puzzle.isSolved, puzzle.answer, puzzle.explanation ) of
                ( Just True, Just answer, Just explanation ) ->
                    ( div [ class "puzzle-solution" ]
                        [ div [ class "puzzle-answer" ] [ text answer ]
                        , div [ class "puzzle-explanation" ] <| Markdown.toHtml Nothing explanation
                        ]
                    , div [] []
                    )

                ( _, _, _ ) ->
                    ( div [] []
                    , div [ class "puzzle-bottom" ]
                        [ messageBody
                        , submissionBox
                        ]
                    )

        paddingSize =
            case puzzle.isSolved of
                Just False ->
                    WithSubmissionBox

                _ ->
                    WithoutSubmissionBox

        messageBody =
            case maybeMessage of
                Just message ->
                    messageBox message

                Nothing ->
                    div [] []

        submissionBox =
            case paddingSize of
                WithSubmissionBox ->
                    submissionInput puzzle.id isInputLoading

                WithoutSubmissionBox ->
                    div [] []

        ( puzzleBody, toggleText ) =
            case puzzleShow of
                Video ->
                    let
                        videoDiv =
                            case puzzle.videoLink of
                                Just videoLink ->
                                    div [ class "puzzle-video" ] [ iframe [ width 384, height 216, src videoLink ] [] ]

                                Nothing ->
                                    div [ class "puzzle-video-placeholder" ] [ text "We're still making the video for this puzzle while we're transitioning the site design. Please use the text-only version in the meantime." ]
                    in
                    ( [ div [ class "puzzle-video-version" ]
                            [ videoDiv
                            , div [ class "puzzle-input" ] <| Markdown.toHtml Nothing puzzle.input
                            , div [ class "puzzle-statement" ] <| Markdown.toHtml Nothing puzzle.statement
                            , div [ class "puzzle-references" ] <| Markdown.toHtml Nothing puzzle.references
                            , solutionBody
                            ]
                      ]
                    , "TEXT-ONLY VERSION"
                    )

                Text ->
                    ( [ div [ class "puzzle-text-version" ]
                            [ div [ class "puzzle-body-text" ] <| Markdown.toHtml Nothing puzzle.body
                            , div [ class "puzzle-input" ] <| Markdown.toHtml Nothing puzzle.input
                            , div [ class "puzzle-statement" ] <| Markdown.toHtml Nothing puzzle.statement
                            , div [ class "puzzle-example" ] <| Markdown.toHtml Nothing puzzle.example
                            , div [ class "puzzle-references" ] <| Markdown.toHtml Nothing puzzle.references
                            , solutionBody
                            ]
                      ]
                    , "VIDEO VERSION"
                    )
    in
    div
        [ class "main" ]
        [ div [ class "puzzle-container" ]
            [ div [ class "puzzle" ]
                [ div [ class "puzzle-top" ]
                    [ div [ class "puzzle-header" ]
                        [ div [ class "title" ]
                            [ b [] [ text puzzle.title ]
                            ]
                        , div [ class "right" ]
                            [ button [ style "margin-right" "1em", onClick PuzzleDetailTogglePuzzleShow ] [ text toggleText ]
                            , div [ class "button-container", onClick (ChangedRoute PuzzleListRoute) ]
                                [ button []
                                    [ b [] [ text "✕" ]
                                    ]
                                ]
                            ]
                        ]
                    , div [ class "puzzle-tags" ]
                        [ span [ class "puzzle-tag" ] [ text puzzle.theme.theme ]
                        , span [ class "puzzle-tag" ] [ text "|" ]
                        , span [ class "puzzle-tag" ] [ text <| Handlers.puzzleSetString puzzle.puzzleSet ]
                        , span [ class "puzzle-tag" ] [ text "|" ]
                        , span [ class "puzzle-tag" ] [ text (Handlers.posixToString puzzle.theme.openDatetime) ]
                        ]
                    ]
                , div [ class "puzzle-body" ]
                    [ div [ class "puzzle-padder" ] puzzleBody
                    ]
                , puzzleBottom
                ]
            ]
        ]


successScreen : DetailPuzzleData -> OkSubmitData -> Html Msg
successScreen puzzle okSubmitData =
    let
        message =
            case okSubmitData.points of
                0 ->
                    [ text "Kudos." ]

                _ ->
                    [ text "Congrats. "
                    , b [] [ text <| String.fromInt okSubmitData.points ]
                    , text " points awarded."
                    ]
    in
    div
        [ class "main" ]
        [ div [ class "container" ]
            [ div [ class "success-container" ]
                [ div [ class "success-image" ] [ img [ src puzzle.imageLink ] [] ]
                , div [ class "success-message" ] message
                , button [ class "success-button", onClick (ChangedRoute PuzzleListRoute) ] [ text "Return" ]
                ]
            ]
        ]
