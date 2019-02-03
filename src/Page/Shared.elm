module Page.Shared exposing (DetailPuzzleType(..), PuzzlePageType(..), detailPuzzlePage, fullPuzzlePage, loadingState, loremIpsum, puzzleCard, safeOnSubmit, tableCell, tableRow, textWithLoad, viewDetailPuzzle)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Html.Lazy exposing (..)
import Json.Decode as Decode
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
                    "red"

                B ->
                    "yellow"

                C ->
                    "green"

                M ->
                    "pink"

        onClickPuzzleAttrs =
            case onClickPuzzle of
                Nothing ->
                    []

                Just event ->
                    [ onClick (event puzzle) ]
    in
    div
        [ class "block w-full sm:w-1/2 md:w-1/3 lg:w-1/4 xl:w-1/4 p-3" ]
        [ div
            ([ class "group w-full rounded cursor-pointer active:border-b-0 " ] ++ onClickPuzzleAttrs)
            [ div
                [ class "block w-full h-full rounded-b-lg border-b-4 active:border-t-4 active:border-b-0 active:border-white"
                , classList [ ( "border-" ++ colour ++ "-dark", not isLoading ), ( "border-grey-light", isLoading ) ]
                ]
                [ div
                    [ class "flex flex-col group-hover:opacity-75 items-center align-center justify-center rounded-t-lg", classList [ ( "bg-" ++ colour, not isLoading ), ( "bg-grey-lighter", isLoading ) ] ]
                    [ div [ class "w-full h-32 overflow-hidden rounded-t-lg" ]
                        [ img
                            [ class "w-full", src puzzle.imagePath ]
                            []
                        ]
                    , div
                        [ class "w-full p-3"
                        , classList [ ( "text-white bg-" ++ colour, not isLoading ), ( "bg-grey-light text-grey-light", not isLoading ) ]
                        ]
                        [ textWithLoad isLoading <| "№ " ++ String.fromInt puzzle.id ++ " " ++ puzzle.title ]
                    , div
                        [ class "w-full p-1 px-3 text-xs font-semibold"
                        , classList [ ( "bg-" ++ colour ++ " text-" ++ colour ++ "-lighter", not isLoading ), ( "bg-grey-light text-grey-light", not isLoading ) ]
                        ]
                        [ textWithLoad isLoading <| String.concat [ Utils.posixToString puzzle.theme.openDatetime, " - ", Utils.posixToString puzzle.theme.closeDatetime ]
                        ]
                    ]
                ]
            ]
        ]


fullPuzzlePage isLoading errorMsg puzzlePageType onClickPuzzle maybeOnClickPuzzleComplete =
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
                        ]

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
                    div []
                        [ span
                            [ class "text-xl" ]
                            [ p
                                []
                                [ textWithLoad isLoading "These puzzles are currently open." ]
                            ]
                        , br
                            []
                            []
                        , p
                            []
                            [ textWithLoad isLoading "Click on a puzzle to view it. When the puzzle closes, submissions will be locked and the puzzle (and it solution) will be moved to the archive." ]
                        , br
                            []
                            []
                        , p
                            []
                            [ textWithLoad isLoading "Puzzles you haven't solved yet:" ]
                        , br
                            []
                            []
                        ]

        unsolvedPuzzles =
            case puzzlePageType of
                ArchivePublic puzzles ->
                    case puzzles of
                        [] ->
                            div [ class "flex flex-inline justify-center w-full m-3 text-sm p-3" ] [ text "There aren't any puzzles in the archive yet." ]

                        _ ->
                            div [ class "flex flex-wrap" ] <| List.map (puzzleCard isLoading onClickPuzzle) puzzles

                ArchiveUser puzzles _ ->
                    case puzzles of
                        [] ->
                            div [ class "flex flex-inline justify-center w-full m-3 text-sm p-3" ] [ text "Wow! You've solved every puzzle in the arcive at the moment. Great job!" ]

                        _ ->
                            div [ class "flex flex-wrap" ] <| List.map (puzzleCard isLoading onClickPuzzle) puzzles

                Open puzzles _ ->
                    case puzzles of
                        [] ->
                            div [ class "flex flex-inline justify-center w-full m-3 text-sm p-3" ] [ text "Fantastic! You've solved every open puzzle at the moment. Amazing stuff!" ]

                        _ ->
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
                    div
                        [ class "pt-3 pb-2" ]
                        [ p
                            []
                            [ textWithLoad isLoading "Open puzzles which you've already solved:" ]
                        ]

        onClickPuzzleComplete =
            case maybeOnClickPuzzleComplete of
                Nothing ->
                    onClickPuzzle

                Just event ->
                    Just event

        solvedPuzzles =
            case puzzlePageType of
                ArchivePublic _ ->
                    div [] []

                ArchiveUser _ puzzles ->
                    case puzzles of
                        [] ->
                            div [ class "flex flex-inline justify-center w-full m-3 text-sm p-3" ] [ text "You haven't solved any of the closed puzzles." ]

                        _ ->
                            div [ class "flex flex-wrap" ] <| List.map (puzzleCard isLoading onClickPuzzleComplete) puzzles

                Open _ puzzles ->
                    case puzzles of
                        [] ->
                            div [ class "flex flex-inline justify-center w-full m-3 text-sm p-3" ] [ text "You haven't solved any puzzles this month yet." ]

                        _ ->
                            div [ class "flex flex-wrap" ] <| List.map (puzzleCard isLoading onClickPuzzleComplete) puzzles

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
                        [ class "flex items-center  sm:text-xl justify-center px-5 py-3 rounded-l-lg font-black bg-yellow  border-b-2 border-yellow-dark"
                        , classList [ ( "text-white", not isLoading ), ( "text-yellow", isLoading ) ]
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


type DetailPuzzleType
    = Closed FullPuzzleData
    | OpenSolved LimitedPuzzleData
    | OpenUnsolved LimitedPuzzleData (WebData SubmissionResponse)


viewDetailPuzzle detailPuzzleType onDeselectPuzzle onInputMaybe onSubmitMaybe toggleMsg =
    case detailPuzzleType of
        Closed data ->
            detailPuzzlePage data onDeselectPuzzle True Nothing False Nothing Nothing False toggleMsg

        OpenSolved data ->
            detailPuzzlePage data onDeselectPuzzle False (Just "Well done! You've already solved this puzzle.") False Nothing Nothing False toggleMsg

        OpenUnsolved data webResponse ->
            case webResponse of
                NotAsked ->
                    detailPuzzlePage data onDeselectPuzzle False Nothing True onSubmitMaybe onInputMaybe False toggleMsg

                Loading ->
                    detailPuzzlePage data onDeselectPuzzle False Nothing True Nothing Nothing True toggleMsg

                Success (OkSubmit okSubmitData) ->
                    case okSubmitData.isCorrect of
                        False ->
                            detailPuzzlePage data onDeselectPuzzle False (Just "We're sorry, that answer was incorrect. Have a break and try again later :) ") True onSubmitMaybe onInputMaybe False toggleMsg

                        _ ->
                            div [] []

                Success (TooSoonSubmit tooSoonData) ->
                    detailPuzzlePage
                        data
                        onDeselectPuzzle
                        False
                        (Just <| String.concat [ "Your last attempt (", Utils.posixToString tooSoonData.last, ", attempt number ", String.fromInt tooSoonData.attempts, ") was too recent. You can next submit at ", Utils.posixToString tooSoonData.next, "." ])
                        True
                        onSubmitMaybe
                        onInputMaybe
                        False
                        toggleMsg

                Failure e ->
                    detailPuzzlePage data onDeselectPuzzle False (Just "We're sorry, there was an error. Please contact us!") True onSubmitMaybe onInputMaybe False toggleMsg


safeOnSubmit message =
    custom "submit" (Decode.succeed { message = message, stopPropagation = True, preventDefault = True })


detailPuzzlePage puzzle onDeselectPuzzle withSolution messageMaybe withSubmissionBox onSubmitMaybe onInputMaybe isLoading toggleMessage =
    let
        setSymbol =
            case puzzle.set of
                A ->
                    "A"

                B ->
                    "B"

                C ->
                    "C"

                M ->
                    "M"

        colour =
            case puzzle.set of
                A ->
                    "red"

                B ->
                    "yellow"

                C ->
                    "green"

                M ->
                    "pink"

        inputDiv =
            case puzzle.input of
                Just inputString ->
                    div
                        [ id "puzzle-input"
                        , class "m-4 p-4  border-l-4 text-grey-darkest  rounded-lg rounded-l-none"
                        , classList [ ( " bg-" ++ colour ++ "-lightest border-" ++ colour, True ) ]
                        ]
                    <|
                        Markdown.toHtml Nothing inputString

                Nothing ->
                    div [] []

        solutionBody =
            case withSolution of
                True ->
                    div [ class "pb-4 mt-8" ]
                        [ div
                            []
                            [ div
                                [ class "flex mb-2" ]
                                [ div
                                    [ class "flex items-center justify-center h-12 w-12 px-3 py-3 rounded-l font-black text-white border-b-4"
                                    , classList [ ( " bg-" ++ colour ++ " border-" ++ colour ++ "-dark ", True ) ]
                                    ]
                                    [ span
                                        [ class "fas fa-lightbulb fa-lg" ]
                                        []
                                    ]
                                , div
                                    [ class "flex items-center h-12 w-full p-3 px-4 rounded-r bg-grey-lighter uppercase text-xl font-bold text-grey-darker border-grey-light border-b-4" ]
                                    [ text "Solution" ]
                                ]
                            ]
                        , div
                            [ id "solution-card", class "bg-white rounded-lg p-2 md:p-8 mb-16 border-b-4 border-grey-lighter" ]
                            [ div
                                [ id "puzzle-solution"
                                , class "mt-2 mx-4 mb-4 md:mb-8 p-2 md:p-4 border-l-4 text-grey-darkest text-sm md:text-base rounded-lg rounded-l-none"
                                , classList [ ( " bg-" ++ colour ++ "-lightest border-" ++ colour, True ) ]
                                ]
                                [ p
                                    []
                                    [ text "The solution is ..." ]
                                ]
                            , p []
                                [ text
                                    "This is some solution text."
                                ]
                            ]
                        ]

                False ->
                    div [] []

        messageBody =
            case messageMaybe of
                Just message ->
                    div
                        [ id "message-box"
                        , class "flex pin-b pin-x h-auto px-4 pt-2 md:px-2 fixed bg-grey-light text-grey-darkest justify-center text"
                        , classList [ ( "pb-20", withSubmissionBox ), ( "pb-4", not withSubmissionBox ) ]
                        , onClick toggleMessage
                        ]
                        [ span
                            [ class "text-center md:w-3/4 " ]
                            [ text message ]
                        ]

                Nothing ->
                    div [] []

        submissionBox =
            case withSubmissionBox of
                True ->
                    let
                        onSubmitEvent =
                            case onSubmitMaybe of
                                Just event ->
                                    if isLoading then
                                        []

                                    else
                                        [ safeOnSubmit event ]

                                Nothing ->
                                    []

                        onClickEvent =
                            case onSubmitMaybe of
                                Just event ->
                                    if isLoading then
                                        []

                                    else
                                        [ onClick event ]

                                Nothing ->
                                    []

                        onInputEvent =
                            case onInputMaybe of
                                Just event ->
                                    [ onInput event ]

                                Nothing ->
                                    []

                        submitText =
                            if isLoading then
                                "Loading"

                            else
                                "Submit"

                        buttonType =
                            if isLoading then
                                []

                            else
                                [ type_ "submit" ]
                    in
                    div
                        [ class "flex h-16 fixed pin-b pin-x justify-center bg-grey-lighter w-full" ]
                        [ div
                            ([ class "flex items-center justify-center w-full md:w-1/2 xl:w-1/3" ] ++ onSubmitEvent ++ onInputEvent)
                            [ input
                                [ class "px-4 py-2 rounded-l-full outline-none text-grey-dark focus:bg-white focus:text-grey-darker"
                                , placeholder "Your submission here."
                                , disabled isLoading
                                , classList [ ( "bg-grey", isLoading ), ( "bg-grey-light", not isLoading ) ]
                                ]
                                []
                            , button
                                ([ class "px-4 py-2 rounded-r-full bg-grey outline-none border-b-2 border-grey-dark focus:outline-none hover:bg-grey-dark active:bg-grey-darker active:border-grey-darker text-grey-darker hover:text-grey-light active:border-b-0" ]
                                    ++ buttonType
                                    ++ onClickEvent
                                )
                                [ text submitText ]
                            ]
                        ]

                False ->
                    div [] []
    in
    div
        [ class "bg-grey-lightest h-full " ]
        [ div
            [ class "flex fixed pin-t pin-x bg-grey-lightest border-b-2 border-grey-lighter" ]
            [ div
                [ class "flex h-12 hover:bg-grey-light" ]
                [ button
                    [ class "h-full uppercase px-3 text-sm text-grey-dark outline-none focus:outline-none"
                    , onClick onDeselectPuzzle
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
                        [ class "flex items-center text-xl justify-center h-12 w-12 px-3 py-3 rounded-l font-black text-grey-lighter border-b-4"
                        , classList [ ( " bg-" ++ colour ++ " border-" ++ colour ++ "-dark ", True ) ]
                        ]
                        [ text setSymbol ]
                    , div
                        [ class "flex items-center h-12 w-full p-3 px-4 rounded-r bg-grey-lighter uppercase text-xl font-bold text-grey-darker border-grey-light border-b-4" ]
                        [ text puzzle.title ]
                    ]
                , div
                    [ class "my-3 md:flex flex-wrap " ]
                    [ span
                        [ class "inline-flex m-1 px-3 py-2 rounded-full bg-grey-lighter text-sm text-grey" ]
                        [ text puzzle.theme.theme ]
                    , span
                        [ class "inline-flex m-1 px-3 py-2 rounded-full bg-grey-lighter text-sm text-grey" ]
                        [ text <| String.concat [ Utils.posixToString puzzle.theme.openDatetime, " - ", Utils.posixToString puzzle.theme.closeDatetime ] ]
                    ]
                , div [ classList [ ( "pb-32", withSubmissionBox ), ( "pb-24", not withSubmissionBox ) ] ]
                    [ div
                        [ id "puzzle-card", class "markdown bg-white rounded-lg p-2 md:p-8 pb-4 md-24 border-b-4 border-grey-lighter md:text-base lg:text-lg" ]
                        [ div
                            [ id "puzzle-body" ]
                          <|
                            Markdown.toHtml Nothing puzzle.body
                        , div
                            [ id "puzzle-example", class "overflow-auto markdown m-1 mt-3 md:m-4  p-2  md:p-4 border-grey-light border-l-4 text-grey-darkest bg-grey-lightest rounded-lg rounded-l-none md:text-base" ]
                          <|
                            Markdown.toHtml Nothing puzzle.example
                        , inputDiv
                        , div
                            [ id "puzzle-statement", class "markdown m-4 mt-8 text-center pb-8 font-semibold" ]
                          <|
                            Markdown.toHtml Nothing puzzle.statement
                        , div
                            [ class "flex justify-end" ]
                            [ div
                                [ id "puzzle-references", class "markdown text-right text-grey-dark text-sm md:text-base md:w-1/2" ]
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


tableCell widthStr str isHeader =
    if isHeader then
        th
            [ class <| "p-1 py-2" ++ widthStr ]
            [ text str ]

    else
        td
            [ class <| "p-1 py-2" ++ widthStr ]
            [ text str ]


tableRow isHeader strList =
    let
        classes =
            if isHeader then
                "w-full bg-grey-light text-sm text-grey-darker"

            else
                "w-full bg-grey-lightest text-center hover:bg-grey-lighter text-grey-darkest"
    in
    tr [ class classes ] <| List.map2 (\x y -> tableCell x y isHeader) [ "w-1/5", "w-2/5", "w-1/5" ] strList
