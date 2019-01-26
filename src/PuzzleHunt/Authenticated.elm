module PuzzleHunt.Authenticated exposing (bodyPuzzleHunt)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Iso8601
import List
import Markdown
import PuzzleHunt.Content as Content
import Shared.Components exposing (navBar)
import Shared.Types exposing (Msg(..))
import String
import Time exposing (posixToMillis)


bodyPuzzleHunt model token =
    let
        themeTable =
            case model.huntDashboardInformation of
                Just info ->
                    case info.data of
                        Just data ->
                            div [ class "hero-body" ]
                                [ div [ class "container" ]
                                    [ table [ class "table is-fullwidth" ]
                                        [ thead []
                                            [ tr []
                                                [ th [] [ text "Theme" ]
                                                , th [] [ text "Tagline" ]
                                                , th [] [ text "Opened For" ]
                                                , th [] [ text "Closes In" ]
                                                ]
                                            ]
                                        , tbody [] <|
                                            List.map
                                                (\x ->
                                                    themeRow
                                                        model
                                                        x
                                                )
                                                data.current
                                        ]
                                    ]
                                ]

                        Nothing ->
                            div [] []

                Nothing ->
                    div [] []
    in
    [ navBar model
    , section [ class "hero is-success" ]
        [ div [ class "hero-body" ]
            [ div [ class "container" ]
                [ h1 [ class "title" ] [ text "Puzzle Hunt 2019 Portal" ]
                , h2 [ class "subtitle" ] [ text "The next set is ___ and opens at ___" ]
                ]
            ]
        , themeTable
        ]
    ]


themeRow model themeData =
    case model.currentTime of
        Just t ->
            let
                seconds d =
                    modBy 60 <| d // 1000

                minutes d =
                    modBy 60 <| d // (60 * 1000)

                hours d =
                    modBy 24 <| d // (24 * 60 * 1000)

                days d =
                    d // (24 * 60 * 1000)

                phrase d f qualifier =
                    String.fromInt (f d) ++ " " ++ qualifier

                timeString d =
                    phrase d days "days" ++ phrase d hours "hours" ++ phrase d minutes "minutes" ++ phrase d seconds "seconds"
            in
            tr []
                [ td [] [ text themeData.theme ]
                , td [] [ text themeData.tagline ]
                , td [] [ text <| timeString (posixToMillis t - posixToMillis themeData.openDatetime) ]
                , td [] [ text <| timeString (posixToMillis themeData.closeDatetime - posixToMillis t) ]
                ]

        Nothing ->
            tr [] []
