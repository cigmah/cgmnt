module Views.PuzzleList exposing (view)

import Browser
import Handlers
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Html.Lazy exposing (..)
import Http exposing (Error(..))
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
                            puzzleListPage puzzlePageData PuzzleListClickedPuzzle

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

                ( User credentials, ListUser webData ) ->
                    case webData of
                        Loading ->
                            loadingPage

                        Success puzzlePageData ->
                            puzzleListPage puzzlePageData PuzzleListClickedPuzzle

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

                ( _, _ ) ->
                    notFoundPage
    in
    ( title, body )


puzzleCard : MiniPuzzleData -> Html Msg
puzzleCard puzzle =
    div
        [ class "item"
        , title <| String.fromInt puzzle.id ++ ". " ++ puzzle.title
        , onClick <| PuzzleListClickedPuzzle puzzle.id
        ]
        [ img [ src puzzle.imageLink, classList [ ( "half-opacity", mapSolvedToBool puzzle.isSolved ) ] ] []
        ]


emptyPuzzle =
    div [ class "item" ] []


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


puzzleListPage : PuzzlePageData -> (PuzzleId -> Msg) -> Html Msg
puzzleListPage puzzlePageData onClickPuzzle =
    let
        puzzles =
            puzzlePageData.puzzles

        items =
            List.map puzzleCard puzzles

        extraItems =
            if List.length puzzles < 25 then
                List.repeat (25 - List.length puzzles) emptyPuzzle

            else
                []

        next =
            puzzlePageData.next

        nextString =
            [ b [] [ text next.theme ], text " releases ", text (Handlers.posixToString next.openDatetime), text " AEST (GMT+10)." ]

        pageTitle =
            "Puzzles"

        introText =
            div [] [ text "Click on a puzzle to view it." ]
    in
    div
        [ class "main" ]
        [ div [ class "container" ]
            [ div [ class "center" ]
                [ div [ class "grid" ] (items ++ extraItems)
                , div [ class "tagline" ]
                    (br [] [] :: nextString)
                ]
            ]
        ]
