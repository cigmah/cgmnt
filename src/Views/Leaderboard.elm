module Views.Leaderboard exposing (view)

import Browser
import Handlers
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Html.Lazy exposing (..)
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
                            leaderboardLoading

                        Failure e ->
                            errorPage ""

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
                            leaderboardLoading

                        _ ->
                            errorPage ""
            in
            ( title, body )

        ByPuzzleChosen isSelectActive miniPuzzleDataList miniPuzzleData leaderPuzzleDataWebData ->
            let
                body =
                    case leaderPuzzleDataWebData of
                        Success data ->
                            leaderboardByPuzzle miniPuzzleDataList isSelectActive (Just miniPuzzleData) (Just data)

                        Loading ->
                            leaderboardLoading

                        _ ->
                            errorPage ""
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


leaderboardTemplate isLoading optionsToShow tableToShow =
    div
        [ class "px-2 md:px-8 bg-grey-lightest" ]
        [ div
            [ class "mb-4 flex flex-wrap content-center justify-center items-center pt-16" ]
            [ div
                [ class "block md:w-5/6 lg:w-4/5 xl:w-3/4" ]
                [ div
                    [ class "inline-flex flex justify-center w-full" ]
                    [ div
                        [ class "flex items-center  sm:text-xl justify-center  px-5 py-3 rounded-l-lg font-black bg-green text-grey-lighter border-b-2 border-green-dark"
                        , classList [ ( "text-green", isLoading ), ( "text-white", not isLoading ) ]
                        ]
                        [ span
                            [ class "fas fa-table" ]
                            []
                        ]
                    , div
                        [ class "flex items-center  w-full p-3 px-5 rounded-r-lg text-grey-darkest sm:text-lg font-bold uppercase bg-grey-lighter border-b-2 border-grey" ]
                        [ textWithLoad isLoading "Leaderboard" ]
                    ]
                , div
                    [ class "block w-full my-3 bg-white rounded-lg p-6 w-full text-base border-b-2 border-grey-light" ]
                    [ p
                        []
                        [ textWithLoad isLoading "You can choose to view the total leaderboard, or a per-puzzle leaderboard." ]
                    , br
                        []
                        []
                    , div
                        [ id "leader-options", class "block my-1 w-full" ]
                        [ div
                            [ class "inline-flex flex:wrap w-full justify-center items-center" ]
                            [ div
                                [ id "leader-button", class "block p-1 w-1/2" ]
                                [ button
                                    [ class "rounded-lg px-3 py-2 bg-green border-b-2 border-green-dark focus:outline-none outline-none hover:bg-green-dark active:border-b-0 w-full"
                                    , classList [ ( "text-white", not isLoading ), ( "text-green hover:text-green-dark", isLoading ) ]
                                    , onClick LeaderboardClickedByTotal
                                    ]
                                    [ text "Total" ]
                                ]
                            , div
                                [ class "block p-1 w-1/2" ]
                                [ button
                                    [ class "rounded-lg px-3 py-2 bg-green border-b-2 border-green-dark focus:outline-none outline-none hover:bg-green-dark active:border-b-0 w-full"
                                    , classList [ ( "text-white", not isLoading ), ( "text-green hover:text-green-dark", isLoading ) ]
                                    , onClick LeaderboardClickedByPuzzle
                                    ]
                                    [ text "By Puzzle" ]
                                ]
                            ]
                        ]
                    , optionsToShow
                    , tableToShow
                    ]
                ]
            ]
        ]


leaderboardLoading =
    leaderboardTemplate True (div [] []) (div [ class "block my-2 bg-grey-lightest rounded-lg h-64" ] [])


leaderboardByTotal leaderUnits =
    leaderboardTemplate False (div [] []) (tableMakerTotal [ "Rank", "Username", "Points" ] leaderUnits)


leaderboardByPuzzle puzzleOptions isOptionsVisible maybeSelectedPuzzle maybeLeaderPuzzleUnits =
    let
        puzzleOptionSelector =
            let
                selectorText =
                    case maybeSelectedPuzzle of
                        Nothing ->
                            "Select a puzzle..."

                        Just puzzle ->
                            String.concat [ "№ ", String.fromInt puzzle.id, " ", puzzle.title ]
            in
            div
                [ class "flex-col w-full mb-3 mt-2" ]
                [ div
                    [ class "flex justify-between px-6 py-2 rounded-t-lg border-grey border-b-2 bg-grey-light text-grey-darker hover:bg-grey-light cursor-pointer active:border-b-0"
                    , onClick LeaderboardTogglePuzzleOptions
                    ]
                    [ div
                        []
                        [ text selectorText ]
                    , div
                        []
                        [ span
                            [ class "fas fa-caret-down text-grey-dark text-right" ]
                            []
                        ]
                    ]
                , div [ classList [ ( "hidden", not isOptionsVisible ) ] ] <| List.map (\x -> puzzleOptionDiv x) puzzleOptions
                ]

        leaderTable =
            case maybeLeaderPuzzleUnits of
                Just units ->
                    tableMakerPuzzle [ "Rank", "Username", "Correct Submission" ] units

                Nothing ->
                    div [] []
    in
    leaderboardTemplate False puzzleOptionSelector leaderTable
