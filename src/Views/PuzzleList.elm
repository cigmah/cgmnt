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
                            puzzleListPage True Nothing (List.repeat 5 defaultPuzzleData) (\x -> Ignored)

                        Success puzzles ->
                            puzzleListPage False Nothing puzzles PuzzleListClickedPuzzle

                        Failure e ->
                            errorPage ""

                        NotAsked ->
                            errorPage "Hmm. It seems the request didn't go through. Try refreshing!"

                ( User credentials, ListUser webData ) ->
                    case webData of
                        Loading ->
                            puzzleListPage True Nothing (List.repeat 5 defaultPuzzleData) (\x -> Ignored)

                        Success puzzles ->
                            puzzleListPage False Nothing puzzles PuzzleListClickedPuzzle

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


puzzleCard : Bool -> (PuzzleId -> Msg) -> MiniPuzzleData -> Html Msg
puzzleCard isLoading onClickPuzzle puzzle =
    let
        colour =
            puzzleColour puzzle.puzzleSet

        onClickPuzzleAttrs =
            case isLoading of
                True ->
                    []

                False ->
                    [ onClick (onClickPuzzle puzzle.id) ]

        completedOverlay =
            case mapSolvedToBool puzzle.isSolved of
                True ->
                    div [ class "relative w-full" ]
                        [ div [ class "absolute w-full pt-1 group-hover:pt-0" ]
                            [ div [ class "flex justify-center align-center items-center w-full " ]
                                [ div [ class "px-3 py-2 bg-black text-bold text-white rounded-t-lg text-center w-full" ] [ text "COMPLETE!" ] ]
                            ]
                        ]

                False ->
                    div [] []

        opacityClass =
            case mapSolvedToBool puzzle.isSolved of
                True ->
                    " opacity-25 "

                False ->
                    " opacity-100 "
    in
    div
        [ class "block w-full h-full w-1/2 sm:w-1/3 md:w-1/4 lg:w-1/4 xl:w-1/5 p-1" ]
        [ div
            ([ class <| "group w-full rounded cursor-pointer active:border-b-0 " ] ++ onClickPuzzleAttrs)
            [ completedOverlay
            , div
                [ class "block w-full h-full rounded-b-lg border-b-4 pt-1 active:border-t-4 active:border-b-0 active:border-white group-hover:pt-0 group-hover:border-b-8"
                , classList [ ( "border-" ++ colour ++ "-dark", not isLoading ), ( "border-grey-light", isLoading ) ]
                ]
                [ div
                    [ class "flex h-full flex-col items-center align-center justify-center rounded-t-lg", classList [ ( "bg-" ++ colour, not isLoading ), ( "bg-grey-light", isLoading ) ] ]
                    [ div [ class "w-full h-32 overflow-hidden rounded-t-lg" ]
                        [ img
                            [ class "w-full", src puzzle.imageLink ]
                            []
                        ]
                    , div
                        [ class "w-full h-full flex-grow p-3 text-sm text-center"
                        , classList [ ( "text-white bg-" ++ colour, not isLoading ), ( "bg-grey-lighter text-grey rounded", not isLoading ) ]
                        ]
                        [ textWithLoad isLoading <| "№ " ++ String.fromInt puzzle.id ++ " " ++ puzzle.title ]
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


puzzleListPage : Bool -> Maybe String -> List MiniPuzzleData -> (PuzzleId -> Msg) -> Html Msg
puzzleListPage isLoading errorMsg puzzles onClickPuzzle =
    let
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
            div [ class "flex flex-wrap" ] <| List.map (puzzleCard isLoading onClickPuzzle) puzzles
    in
    pageBase
        { iconSpan = span [ class "fas fa-book-reader" ] []
        , isCentered = False
        , colour = "yellow"
        , titleSpan = text "Puzzles"
        , bodyContent = puzzlesDiv
        , outsideMain = div [] []
        }
