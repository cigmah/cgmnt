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
                            detailPuzzlePage (defaultPuzzleData Nothing) Nothing True False

                        Success puzzle ->
                            detailPuzzlePage puzzle (Just "Login to submit your answer and reveal the solution!") False False

                        Failure e ->
                            errorPage ""

                        NotAsked ->
                            errorPage "Hmm. It seems the request didn't go through. Try refreshing!"

                ( User credentials, UserPuzzle puzzleId webData ) ->
                    case webData of
                        Loading ->
                            detailPuzzlePage (defaultPuzzleData Nothing) Nothing True False

                        Success puzzle ->
                            detailPuzzlePage puzzle (Just "Well done! You've solved this puzzle.") False False

                        Failure e ->
                            errorPage ""

                        NotAsked ->
                            errorPage "Hmm. It seems the request didn't go through. Try refreshing!"

                ( User credentials, UnsolvedPuzzleLoaded puzzleId data submission webData ) ->
                    case webData of
                        NotAsked ->
                            detailPuzzlePage data Nothing False False

                        Loading ->
                            detailPuzzlePage data Nothing False True

                        Failure e ->
                            detailPuzzlePage data (Just "Hm. It seems there was an error. Let us know!") False False

                        Success submissionResponse ->
                            case submissionResponse of
                                OkSubmit okSubmitData ->
                                    case okSubmitData.isResponseCorrect of
                                        True ->
                                            successScreen data okSubmitData

                                        False ->
                                            detailPuzzlePage data (Just "Unfortunately, that answer was incorrect. Have a break and try again :)") False False

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
                                    detailPuzzlePage data (Just messageString) False False

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


messageBox : PaddingSize -> Message -> Html Msg
messageBox bottomPadding message =
    let
        bottomPaddingClass =
            case bottomPadding of
                WithSubmissionBox ->
                    "pb-20"

                WithoutSubmissionBox ->
                    "pb-4"
    in
    div
        [ id "message-box"
        , class <| "flex pin-b pin-x h-auto px-4 pt-4 md:px-2 fixed bg-grey-light text-grey-darkest justify-center text " ++ bottomPaddingClass
        , onClick ToggledMessage
        ]
        [ span
            [ class "text-center md:w-3/4 " ]
            [ text message ]
        ]


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
    div
        [ class "flex h-16 fixed pin-b pin-x justify-center bg-grey-lighter w-full" ]
        [ div
            [ class "flex items-center justify-center w-full md:w-1/2 xl:w-1/3"
            , onSubmit (PuzzleDetailClickedSubmit puzzleId)
            , onInput PuzzleDetailChangedSubmission
            ]
            [ input
                [ class "px-4 py-2 rounded-l-full outline-none text-grey-dark focus:bg-white focus:text-grey-darker"
                , placeholder "Your submission here."
                , disabled isLoading
                , classList [ ( "bg-grey", isLoading ), ( "bg-grey-light", not isLoading ) ]
                ]
                []
            , div [ class "border-t-2 border-grey-lighter hover:border-t-0 active:border-t-4" ]
                [ button
                    [ class "px-4 py-2 rounded-r-full bg-grey outline-none border-b-2 border-grey-dark focus:outline-none hover:border-b-4 active:border-grey-darker text-grey-darker  active:border-b-0"
                    , onClick (PuzzleDetailClickedSubmit puzzleId)
                    , type_ "submit"
                    ]
                    [ text submitText ]
                ]
            ]
        ]


detailPuzzlePage : DetailPuzzleData -> Maybe Message -> Bool -> Bool -> Html Msg
detailPuzzlePage puzzle maybeMessage isLoading isInputLoading =
    let
        colour =
            case isLoading of
                True ->
                    "grey"

                False ->
                    puzzleColour puzzle.puzzleSet

        solutionBody =
            case ( puzzle.isSolved, puzzle.answer, puzzle.explanation ) of
                ( Just True, Just answer, Just explanation ) ->
                    cardBody
                        { iconSpan = text "..."
                        , colour = colour
                        , titleSpan = text "Solution"
                        , content =
                            div []
                                [ borderBox (div [ class "markdown" ] [text "The answer is ", span [class "font-bold"] [text answer], text "."] colour
                                , div [ class "markdown" ] <| Markdown.toHtml Nothing explanation
                                ]
                        }

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
                    messageBox paddingSize message

                Nothing ->
                    div [] []

        submissionBox =
            case paddingSize of
                WithSubmissionBox ->
                    submissionInput puzzle.id isInputLoading

                WithoutSubmissionBox ->
                    div [] []

        pagePadding =
            case paddingSize of
                WithSubmissionBox ->
                    "pb-32"

                WithoutSubmissionBox ->
                    "pb-32"

        borderBoxInput =
            case isLoading of
                True ->
                    [ textWithLoad True <| String.slice 0 30 loremIpsum ]

                False ->
                    Markdown.toHtml Nothing puzzle.input
    in
    div
        [ class "bg-grey-lightest h-full z-50" ]
        [ div
            [ class "flex fixed pin-t pin-x bg-grey-lightest border-b-2 border-grey-lighter" ]
            [ div
                [ class "flex h-12 hover:bg-grey-light" ]
                [ button
                    [ class "h-full uppercase px-3 text-sm text-grey-dark outline-none focus:outline-none"
                    , onClick (ChangedRoute PuzzleListRoute)
                    ]
                    [ text "Back to Puzzles" ]
                ]
            ]
        , div
            [ class "puzzle-detail h-full overflow-auto p-2 md:p-3 w-full flex fixed mt-12 mb-24 pb-24" ]
            [ div [ class "container w-full mx-auto pb-32" ]
                [ div
                    [ class "flex mb-4" ]
                    [ div
                        [ class "flex items-center text-xl justify-center h-12 w-12 rounded-l font-black text-grey-lighter border-b-4"
                        , classList [ ( " bg-" ++ colour ++ " border-" ++ colour ++ "-dark ", True ) ]
                        ]
                        [ img [ class "resize h-full w-full overflow-hidden", src puzzle.imageLink, classList [ ( "hidden", isLoading ) ] ] [] ]
                    , div
                        [ class "flex items-center h-12 w-full p-3 px-4 rounded-r bg-grey-lighter uppercase text-xl font-bold text-grey-darker border-grey-light border-b-4" ]
                        [ textWithLoad isLoading puzzle.title ]
                    ]
                , div
                    [ class "my-3 md:flex flex-wrap " ]
                    [ span
                        [ class "inline-flex m-1 px-3 py-2 rounded-full bg-grey-lighter text-sm text-grey" ]
                        [ textWithLoad isLoading puzzle.theme.theme ]
                    , span
                        [ class "inline-flex m-1 px-3 py-2 rounded-full bg-grey-lighter text-sm text-grey" ]
                        [ textWithLoad isLoading <| Handlers.posixToString puzzle.theme.openDatetime ]
                    ]
                , div [ class pagePadding ]
                    [ div
                        [ id "puzzle-card", class "markdown rounded-lg p-2 md:p-8 pb-4 md-24 border-b-4 border-grey-lighter bg-white md:text-base lg:text-lg" ]
                        [ div
                            [ id "puzzle-body", classList [ ( "rounded-lg bg-grey-light text-grey-light", isLoading ) ] ]
                          <|
                            Markdown.toHtml Nothing puzzle.body
                        , borderBox (div [ class "markdown" ] borderBoxInput) colour
                        , div
                            [ id "puzzle-statement", class "markdown m-4 mt-8 text-center pb-8 font-semibold", classList [ ( "bg-grey-lighter text-grey-lighter rounded-lg", isLoading ) ] ]
                          <|
                            Markdown.toHtml Nothing puzzle.statement
                        , div
                            [ id "puzzle-example"
                            , class "overflow-auto markdown m-1 mt-3 md:m-4 p-2 md:p-4 md:pt-2 border-grey-light border-l-4 rounded-lg rounded-l-none md:text-base"
                            , classList [ ( "bg-grey-lightest text-grey-lightest rounded-lg", isLoading ), ( "bg-grey-lightest text-grey-darkest ", not isLoading ) ]
                            ]
                          <|
                            Markdown.toHtml Nothing puzzle.example
                        , div
                            [ class "flex justify-end" ]
                            [ div
                                [ id "puzzle-references", class "markdown text-right text-grey-dark text-sm md:text-base md:w-1/2", classList [ ( "bg-grey-light rounded-full text-grey-light", isLoading ), ( "text-grey-dark", not isLoading ) ] ]
                              <|
                                Markdown.toHtml Nothing puzzle.references
                            ]
                        ]
                    , solutionBody
                    , div
                        []
                        [ messageBody
                        , submissionBox
                        ]
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
