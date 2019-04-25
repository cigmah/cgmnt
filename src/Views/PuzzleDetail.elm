module Views.PuzzleDetail exposing (view)

import Browser
import Handlers
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Html.Lazy exposing (..)
import Markdown
import RemoteData exposing (RemoteData(..), WebData)
import Time
import Types exposing (..)
import Views.Shared exposing (..)


view : Meta -> PuzzleDetailState -> ( String, Html Msg )
view meta puzzleDetailState =
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
                            detailPuzzlePage puzzle (Just "Login to submit.") False

                        Failure e ->
                            errorPage ""

                        NotAsked ->
                            errorPage "Hmm. It seems the request didn't go through. Try refreshing!"

                ( User credentials, UserPuzzle puzzleId webData ) ->
                    case webData of
                        Loading ->
                            puzzleLoadingPage

                        Success puzzle ->
                            detailPuzzlePage puzzle Nothing False

                        Failure e ->
                            errorPage ""

                        NotAsked ->
                            errorPage "Hmm. It seems the request didn't go through. Try refreshing!"

                ( User credentials, UnsolvedPuzzleLoaded puzzleId data submission webData ) ->
                    case webData of
                        NotAsked ->
                            detailPuzzlePage data Nothing False

                        Loading ->
                            detailPuzzlePage data Nothing True

                        Failure e ->
                            detailPuzzlePage data (Just "Hm. It seems there was an error. Let us know!") False

                        Success submissionResponse ->
                            case submissionResponse of
                                OkSubmit okSubmitData ->
                                    case okSubmitData.isResponseCorrect of
                                        True ->
                                            successScreen data okSubmitData

                                        False ->
                                            detailPuzzlePage data (Just "Unfortunately, that answer was incorrect. Have a break and try again :)") False

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
                                    detailPuzzlePage data (Just messageString) False

                ( _, _ ) ->
                    notFoundPage
    in
    ( title, body )


defaultPuzzleData : Maybe Bool -> DetailPuzzleData
defaultPuzzleData isSolved =
    { id = 0
    , puzzleSet = AbstractPuzzle
    , theme = { id = 0, theme = "Lorem Ipsum", themeSet = RegularTheme, tagline = "", openDatetime = Time.millisToPosix 0 }
    , title = "Lorem Ipsum"
    , imageLink = ""
    , body = String.slice 0 100 loremIpsum
    , example = String.slice 0 100 loremIpsum
    , statement = String.slice 0 30 loremIpsum
    , references = String.slice 0 30 loremIpsum
    , input = String.slice 0 30 loremIpsum
    , isSolved = isSolved
    , answer = Nothing
    , explanation = Nothing
    }


type alias Message =
    String


borderBox : Html Msg -> String -> Html Msg
borderBox content colour =
    div
        [ id "puzzle-input"
        , class "m-4 p-4 pt-2 border-l-4 text-grey-darkest rounded-lg rounded-l-none"
        , classList [ ( " bg-" ++ colour ++ "-lightest border-" ++ colour, True ) ]
        ]
        [ content ]


type alias CardBodyData =
    { iconSpan : Html Msg
    , colour : String
    , titleSpan : Html Msg
    , content : Html Msg
    }


cardBody : CardBodyData -> Html Msg
cardBody data =
    div [ class "md:pb-4 mt-8" ]
        [ div
            [ class "flex mb-2" ]
            [ div
                [ class "flex items-center justify-center h-12 w-12 px-3 py-3 rounded-l font-black text-white border-b-4"
                , classList [ ( " bg-" ++ data.colour ++ " border-" ++ data.colour ++ "-dark ", True ) ]
                ]
                [ data.iconSpan
                ]
            , div
                [ class "flex items-center h-12 w-full p-3 px-4 rounded-r bg-grey-lighter uppercase text-xl font-bold text-grey-darker border-grey-light border-b-4" ]
                [ data.titleSpan ]
            ]
        , div
            [ class "bg-white rounded-lg p-2 md:p-8 mb-12 md:mb-16 border-b-4 border-grey-lighter" ]
            [ data.content
            ]
        ]


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


detailPuzzlePage : DetailPuzzleData -> Maybe Message -> Bool -> Html Msg
detailPuzzlePage puzzle maybeMessage isInputLoading =
    let
        solutionBody =
            case ( puzzle.isSolved, puzzle.answer, puzzle.explanation ) of
                ( Just True, Just answer, Just explanation ) ->
                    div [ class "puzzle-solution" ]
                        [ h1 [] [ text "Solution" ]
                        , div [ class "puzzle-answer" ] [ text answer ]
                        , div [ class "puzzle-explanation" ] <| Markdown.toHtml Nothing explanation
                        ]

                ( _, _, _ ) ->
                    div [] []

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
                            [ button [ style "margin-right" "1em" ] [ text "TEXT" ]
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
                    [ div [ class "puzzle-padder" ]
                        [ div [ class "puzzle-body-text" ] <| Markdown.toHtml Nothing puzzle.body
                        , div [ class "puzzle-input" ] <| Markdown.toHtml Nothing puzzle.input
                        , div [ class "puzzle-statement" ] <| Markdown.toHtml Nothing puzzle.statement
                        , div [ class "puzzle-example" ] <| Markdown.toHtml Nothing puzzle.example
                        , div [ class "puzzle-references" ] <| Markdown.toHtml Nothing puzzle.references
                        ]
                    ]
                , div [ class "puzzle-bottom" ]
                    [ messageBody
                    , submissionBox
                    ]
                ]
            ]
        ]


successScreen : DetailPuzzleData -> OkSubmitData -> Html Msg
successScreen puzzle okSubmitData =
    let
        message =
            case okSubmitData.points of
                0 ->
                    [ text "You completed "
                    , span [ class "italics" ] [ text puzzle.title ]
                    , text "! No points were awarded, but who needs points when you have skills ;)"
                    ]

                _ ->
                    [ text "You completed "
                    , span [ class "italic" ] [ text puzzle.title ]
                    , text " and earned "
                    , span [ class "text-bold" ] [ text <| String.fromInt okSubmitData.points ]
                    , text " points!"
                    ]
    in
    div
        [ class "px-8 bg-grey-lightest" ]
        [ div
            [ class "flex flex-wrap h-screen content-center justify-center items-center" ]
            [ div
                [ class "flex-col-reverse h-full items-center justify-center flex md:flex-col md:w-4/5 lg:w-3/4 xl:w-2/3" ]
                [ div [] [ img [ src puzzle.imageLink, class "resize rounded-lg h-64 w-64 bg-grey" ] [] ]
                , div [ class "mb-4 md:mt-4 md:mb-0" ]
                    [ div
                        [ class "inline-flex flex justify-center w-full" ]
                        [ div
                            [ class "flex items-center sm:text-xl justify-center sm:h-12 sm:w-10 px-5 py-3 rounded-l-lg font-black bg-green text-grey-lighter border-b-2 border-green-dark" ]
                            [ span
                                [ class "fas fa-glass-cheers" ]
                                []
                            ]
                        , div
                            [ class "flex items-center w-full p-3 px-5 sm:h-12 rounded-r-lg text-grey-darkest sm:text-lg font-bold uppercase bg-grey-lighter border-b-2 border-grey" ]
                            [ text "Congratulations!" ]
                        ]
                    , div
                        [ class "block w-full my-3 bg-white rounded-lg p-6 w-full text-base border-b-2 border-grey-light" ]
                        [ div
                            [ class "text-lg" ]
                            message
                        , br
                            []
                            []
                        , br [] []
                        , div
                            [ class "text-lg" ]
                            [ text "Great job!" ]
                        ]
                    , div
                        [ class "flex w-full justify-center" ]
                        [ button
                            [ class "px-3 py-2 bg-green rounded-lg border-b-2 border-green-dark w-full text-white active:border-0 outline-none focus:outline-none active:outline-none hover:border-b-4"
                            , onClick (ChangedRoute PuzzleListRoute)
                            ]
                            [ text "Go Back to Puzzles" ]
                        ]
                    ]
                ]
            ]
        ]
