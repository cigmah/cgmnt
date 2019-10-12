module Views.Leaderboard exposing (view)

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


view : Meta -> LeaderboardState -> ( String, Html Msg )
view meta leaderboardState =
    let
        title =
            "Leaderboard - CIGMAH"
    in
    case leaderboardState of
        ByTotal leaderTotalDataWebData ->
            let
                body =
                    case leaderTotalDataWebData of
                        Success data ->
                            leaderboardByTotal data

                        Loading ->
                            loadingPage

                        Failure e ->
                            case e of
                                BadStatus metadata ->
                                    errorPage metadata.body

                                NetworkError ->
                                    errorPage "There's something wrong with your network or with accessing the backend - check your internet connection first and check the console for any network errors."

                                _ ->
                                    errorPage "Unfortunately, we don't yet know what this error is. :(  "

                        _ ->
                            notFoundPage
            in
            ( title, body )

        ByPuzzleNotChosen isSelectActive miniPuzzleDataListWebData ->
            let
                body =
                    case miniPuzzleDataListWebData of
                        Success data ->
                            leaderboardByPuzzle data isSelectActive Nothing Nothing

                        Loading ->
                            loadingPage

                        Failure e ->
                            case e of
                                BadStatus metadata ->
                                    errorPage metadata.body

                                NetworkError ->
                                    errorPage "There's something wrong with your network or with accessing the backend - check your internet connection first and check the console for any network errors."

                                _ ->
                                    errorPage "Unfortunately, we don't yet know what this error is. :(  "

                        NotAsked ->
                            errorPage "The request didn't go through - try refreshing!"
            in
            ( title, body )

        ByPuzzleChosen isSelectActive miniPuzzleDataList miniPuzzleData leaderPuzzleDataWebData ->
            let
                body =
                    case leaderPuzzleDataWebData of
                        Success data ->
                            leaderboardByPuzzle miniPuzzleDataList isSelectActive (Just miniPuzzleData) (Just data)

                        Loading ->
                            loadingPage

                        Failure e ->
                            case e of
                                BadStatus metadata ->
                                    errorPage metadata.body

                                NetworkError ->
                                    errorPage "There's something wrong with your network or with accessing the backend - check your internet connection first and check the console for any network errors."

                                _ ->
                                    errorPage "Unfortunately, we don't yet know what this error is. :(  "

                        NotAsked ->
                            errorPage "The request didn't go through - try refreshing!"
            in
            ( title, body )

        BySetNotChosen isSelectActive ->
            let
                body =
                    leaderboardBySet isSelectActive Nothing Nothing
            in
            ( title, body )

        BySetChosen isSelectActive puzzleSet webData ->
            let
                body =
                    case webData of
                        Success data ->
                            leaderboardBySet isSelectActive (Just puzzleSet) (Just data)

                        Loading ->
                            loadingPage

                        Failure e ->
                            case e of
                                BadStatus metadata ->
                                    errorPage metadata.body

                                NetworkError ->
                                    errorPage "There's something wrong with your network or with accessing the backend - check your internet connection first and check the console for any network errors."

                                _ ->
                                    errorPage "Unfortunately, we don't yet know what this error is. :(  "

                        NotAsked ->
                            errorPage "The request didn't go through - try refreshing!"
            in
            ( title, body )


puzzleOptionDiv : MiniPuzzleData -> Html Msg
puzzleOptionDiv puzzleOption =
    div
        [ class "block" ]
        [ div
            [ class "bg-grey-lightest px-6 py-2 hover:bg-grey-light cursor-pointer text-grey-darker"
            , onClick (LeaderboardClickedPuzzle puzzleOption)
            ]
            [ text <| String.concat [ "№ ", String.fromInt puzzleOption.id, " ", puzzleOption.title ] ]
        ]


setOptionDiv : PuzzleSet -> Html Msg
setOptionDiv puzzleSet =
    div
        [ class "block" ]
        [ div
            [ class "bg-grey-lightest px-6 py-2 hover:bg-grey-light cursor-pointer text-grey-darker"
            , onClick (LeaderboardClickedSet puzzleSet)
            ]
            [ text <| Handlers.puzzleSetString puzzleSet ]
        ]


tableMakerPuzzle headerList unitList =
    let
        rankList =
            List.range 1 (List.length unitList)
    in
    div
        [ id "table-block", class "block py-2" ]
        [ table
            [ class "w-full" ]
          <|
            [ tableRow ThinTable True headerList ]
                ++ List.map2 (\x y -> tableRow ThinTable False [ String.fromInt y, x.username, Handlers.posixToString x.submissionDatetime ]) unitList rankList
        ]


tableMakerTotal headerList unitList =
    let
        rankList =
            List.range 1 (List.length unitList)
    in
    div
        [ id "table-block", class "block py-2" ]
        [ table
            [ class "w-full" ]
          <|
            tableRow ThinTable True headerList
                :: List.map2 (\x y -> tableRow ThinTable False [ String.fromInt y, x.username, String.fromInt x.total ]) unitList rankList
        ]


tableMakerSet headerList unitList =
    let
        rankList =
            List.range 1 (List.length unitList)
    in
    div
        [ id "table-block", class "block py-2" ]
        [ table
            [ class "w-full" ]
          <|
            tableRow ThinTable True headerList
                :: List.map2 (\x y -> tableRow ThinTable False [ String.fromInt y, Handlers.puzzleSetString x.puzzleSet, x.username, String.fromInt x.total ]) unitList rankList
        ]


makeOption : Msg -> String -> List (Html Msg)
makeOption clickEvent option =
    [ span [ class "option", onClick clickEvent ] [ text option ], br [] [] ]


makeTotalRow : Int -> LeaderTotalUnit -> Html Msg
makeTotalRow rank data =
    tr []
        [ td [ class "lessen" ] [ text <| String.fromInt rank ]
        , td [ class "strengthen" ] [ text data.username ]
        , td [ class "lessen" ] [ text "[", text <| String.fromInt data.total, text "]" ]
        ]


leaderboardByTotal data =
    div [ class "main" ]
        [ div [ class "container" ]
            [ span [ class "lessen" ]
                [ text "?- top10("
                , span [ class "toggler", onClick LeaderboardClickedByPuzzle ] [ text "total" ]
                , text ")"
                ]
            , div
                [ class "leaderboard" ]
                [ table [] <| List.map2 makeTotalRow (List.range 1 10) data ]
            ]
        ]


titleCondense title =
    String.replace " " "" title


makePuzzleRow rank unit =
    tr []
        [ td [ class "lessen" ] [ text <| String.fromInt rank ]
        , td [ class "strengthen" ] [ text unit.username ]
        , td [ class "lessen" ] [ text "[", text <| Handlers.posixToString unit.submissionDatetime, text "]" ]
        ]


makePuzzleOption puzzle =
    makeOption (LeaderboardClickedPuzzle puzzle) puzzle.title


leaderboardByPuzzle puzzleOptions isOptionsVisible maybeSelectedPuzzle maybeLeaderPuzzleUnits =
    let
        optionsDiv =
            if isOptionsVisible then
                div [ class "options" ] <|
                    List.concat (List.map makePuzzleOption puzzleOptions)

            else
                span [] []

        puzzleSelection =
            case maybeSelectedPuzzle of
                Nothing ->
                    "<SELECT>"

                Just puzzle ->
                    titleCondense puzzle.title

        leaderboard =
            case maybeLeaderPuzzleUnits of
                Just units ->
                    div [ class "leaderboard" ]
                        [ table [] <| List.map2 makePuzzleRow (List.range 1 10) units ]

                Nothing ->
                    span [] []
    in
    div [ class "main" ]
        [ div [ class "container no-overflow" ]
            [ span [ class "lessen" ]
                [ text "?- top10("
                , span [ class "toggler", onClick LeaderboardClickedBySet ] [ text "puzzle" ]
                , span [ class "toggler", onClick LeaderboardTogglePuzzleOptions ] [ text puzzleSelection ]
                , text ")"
                ]
            , optionsDiv
            , leaderboard
            ]
        ]


makeSetRow rank unit =
    tr []
        [ td [ class "lessen" ] [ text <| String.fromInt rank ]
        , td [ class "strengthen" ] [ text unit.username ]
        , td [ class "lessen" ] [ text "[", text <| String.fromInt unit.total, text "]" ]
        ]


makeSetOption setOption =
    makeOption (LeaderboardClickedSet setOption) (Handlers.puzzleSetString setOption)


leaderboardBySet : Bool -> Maybe PuzzleSet -> Maybe LeaderSetData -> Html Msg
leaderboardBySet isOptionsVisible maybeSelectedSet maybeLeaderSetUnits =
    let
        setOptions =
            [ AbstractPuzzle, BeginnerPuzzle, ChallengePuzzle ]

        optionsDiv =
            if isOptionsVisible then
                div [ class "options" ] <|
                    List.concat (List.map makeSetOption setOptions)

            else
                span [] []

        setSelection =
            case maybeSelectedSet of
                Nothing ->
                    "<SELECT>"

                Just set ->
                    titleCondense <| Handlers.puzzleSetString set

        leaderboard =
            case maybeLeaderSetUnits of
                Just units ->
                    div [ class "leaderboard" ]
                        [ table [] <| List.map2 makeSetRow (List.range 1 10) units ]

                Nothing ->
                    span [] []
    in
    div [ class "main" ]
        [ div [ class "container no-overflow" ]
            [ span [ class "lessen" ]
                [ text "?- top10("
                , span [ class "toggler", onClick LeaderboardClickedByTotal ] [ text "set" ]
                , span [ class "toggler", onClick LeaderboardToggleSetOptions ] [ text setSelection ]
                , text ")"
                ]
            , optionsDiv
            , leaderboard
            ]
        ]
