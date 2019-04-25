module Views.PuzzleList exposing (view)

import Browser
import Handlers
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Html.Lazy exposing (..)
import RemoteData exposing (RemoteData(..), WebData)
import Types exposing (..)
import Views.Shared exposing (..)


view : Meta -> PuzzleListState -> ( String, Html Msg )
view meta puzzleListState =
    let
        title =
            "Puzzles - CIGMAH"

        body =
            case ( meta.auth, puzzleListState ) of
                ( Public, ListPublic webData ) ->
                    case webData of
                        Loading ->
                            loadingPage

                        Success puzzlePageData ->
                            if List.length puzzlePageData.puzzles < 25 then
                                let
                                    numRepeats =
                                        25 - List.length puzzlePageData.puzzles
                                in
                                puzzleListPage False Nothing { puzzlePageData | puzzles = puzzlePageData.puzzles ++ List.repeat numRepeats defaultPuzzleData } PuzzleListClickedPuzzle

                            else
                                puzzleListPage False Nothing puzzlePageData PuzzleListClickedPuzzle

                        Failure e ->
                            errorPage ""

                        NotAsked ->
                            errorPage "Hmm. It seems the request didn't go through. Try refreshing!"

                ( User credentials, ListUser webData ) ->
                    case webData of
                        Loading ->
                            loadingPage

                        Success puzzlePageData ->
                            if List.length puzzlePageData.puzzles < 25 then
                                let
                                    numRepeats =
                                        25 - List.length puzzlePageData.puzzles
                                in
                                puzzleListPage False Nothing { puzzlePageData | puzzles = puzzlePageData.puzzles ++ List.repeat numRepeats defaultPuzzleData } PuzzleListClickedPuzzle

                            else
                                puzzleListPage False Nothing puzzlePageData PuzzleListClickedPuzzle

                        Failure e ->
                            errorPage ""

                        NotAsked ->
                            errorPage "Hmm. It seems the request didn't go through. Try refreshing!"

                ( _, _ ) ->
                    notFoundPage
    in
    ( title, body )


defaultPuzzleData =
    { id = 0
    , themeTitle = "Lorem ipsum"
    , puzzleSet = AbstractPuzzle
    , imageLink = ""
    , title = String.slice 0 20 loremIpsum
    , isSolved = Nothing
    }


overlayDiv textString bgClass hasHover =
    div [ class "relative w-full" ]
        [ div [ class "absolute w-full pt-1", classList [ ( "group-hover:pt-0", hasHover ) ] ]
            [ div [ class "flex justify-center align-center items-center w-full " ]
                [ div [ class <| "px-3 py-2 text-bold text-white rounded-t-lg text-center w-full " ++ bgClass ] [ text textString ] ]
            ]
        ]


puzzleCard : Bool -> (PuzzleId -> Msg) -> MiniPuzzleData -> Html Msg
puzzleCard loadState onClickPuzzle puzzle =
    let
        isLoading =
            case loadState of
                True ->
                    True

                False ->
                    case puzzle.themeTitle of
                        "Lorem ipsum" ->
                            -- bit of a hack to differentiate non-open puzzles...
                            True

                        _ ->
                            False

        colour =
            case isLoading of
                True ->
                    "grey"

                _ ->
                    puzzleColour puzzle.puzzleSet

        onClickPuzzleAttrs =
            case isLoading of
                True ->
                    []

                False ->
                    [ onClick (onClickPuzzle puzzle.id) ]

        overlay =
            case mapSolvedToBool puzzle.isSolved of
                True ->
                    overlayDiv "COMPLETED!" "bg-black" True

                False ->
                    case ( isLoading, loadState ) of
                        ( True, False ) ->
                            overlayDiv "UNRELEASED" "bg-grey" False

                        _ ->
                            div [] []

        opacityClass =
            case mapSolvedToBool puzzle.isSolved of
                True ->
                    " opacity-25 "

                False ->
                    " opacity-100 "

        bottomText =
            case isLoading of
                True ->
                    ""

                False ->
                    "№ " ++ String.fromInt puzzle.id ++ " " ++ puzzle.title
    in
    div
        [ class "block w-full  h-full w-1/2 sm:w-1/3 md:w-1/4 lg:w-1/4 xl:w-1/5 p-1" ]
        [ div
            ([ class <| "group w-full rounded active:border-b-0 ", classList [ ( "cursor-pointer", not isLoading ) ] ] ++ onClickPuzzleAttrs)
            [ overlay
            , div
                [ class "block w-full h-full rounded-b-lg border-b-4 pt-1 "
                , classList
                    [ ( "border-" ++ colour ++ "-dark", not isLoading )
                    , ( "active:border-t-4 active:border-b-0 active:border-white group-hover:pt-0 group-hover:border-b-8", not isLoading )
                    , ( "border-grey", isLoading )
                    ]
                ]
                [ div
                    [ class "flex h-full flex-col items-center align-center justify-center rounded-t-lg", classList [ ( "bg-" ++ colour, not isLoading ), ( "bg-grey-light", isLoading ) ] ]
                    [ div [ class "w-full h-32 overflow-hidden rounded-t-lg" ]
                        [ div [ class "w-full flex align-center items-center justify-center" ]
                            [ img
                                [ class "h-32", src puzzle.imageLink ]
                                []
                            ]
                        ]
                    , div
                        [ class "w-full flex-grow items-center justify-center flex px-1 h-8 text-sm text-center"
                        , classList [ ( "text-white bg-" ++ colour, not isLoading ), ( "bg-grey text-grey rounded", isLoading ) ]
                        ]
                        [ text bottomText ]
                    ]
                ]
            ]
        ]


mapSolvedToBool : Maybe Bool -> Bool
mapSolvedToBool boolMaybe =
    case boolMaybe of
        Just bool ->
            case bool of
                True ->
                    True

                False ->
                    False

        Nothing ->
            False


puzzleListPage : Bool -> Maybe String -> PuzzlePageData -> (PuzzleId -> Msg) -> Html Msg
puzzleListPage isLoading errorMsg puzzlePageData onClickPuzzle =
    let
        puzzles =
            puzzlePageData.puzzles

        pageTitle =
            "Puzzles"

        introText =
            div [] [ text "Click on a puzzle to view it." ]

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

        puzzlesDiv =
            case List.length puzzles of
                0 ->
                    div [] [ text "There aren't any open puzzles yet...but stay tuned :)" ]

                _ ->
                    div [ class "block" ]
                        [ div [ class "py-2" ]
                            [ div [ class "pb-2" ] [ textWithLoad isLoading "Here's the colour coding for the puzzles:" ]
                            , div [ class "py-1" ]
                                [ puzzleSetSpan isLoading MetaPuzzle
                                , textWithLoad isLoading " - The puzzle about all the puzzles!"
                                ]
                            , div [ class "py-1" ]
                                [ puzzleSetSpan isLoading AbstractPuzzle
                                , textWithLoad isLoading " - Puzzles which don't require any explicit coding, but do require a logical mindset and some medical knowledge."
                                ]
                            , div [ class "py-1" ]
                                [ puzzleSetSpan isLoading BeginnerPuzzle
                                , textWithLoad isLoading " - Puzzles for coding beginners with fill-in-the-blank Python tutorials included."
                                ]
                            , div [ class "py-1" ]
                                [ puzzleSetSpan isLoading ChallengePuzzle
                                , textWithLoad isLoading " - Puzzles for experienced coders and not the faint of heart!"
                                ]
                            ]
                        , div [ class "flex flex-wrap" ] <| List.map (puzzleCard isLoading onClickPuzzle) puzzles
                        ]
    in
    pageBase
        { iconSpan = span [ class "fas fa-book-reader" ] []
        , isCentered = False
        , colour = "yellow"
        , titleSpan = text "Puzzles"
        , bodyContent = puzzlesDiv
        , outsideMain = div [] []
        }
