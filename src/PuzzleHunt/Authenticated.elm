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

        loadingBarOn =
            case model.huntDashboardInformation of
                Just info ->
                    case info.isLoading of
                        True ->
                            "is-active"

                        False ->
                            case model.currentTime of
                                Nothing ->
                                    "is-active"

                                _ ->
                                    ""

                Nothing ->
                    ""
    in
    [ navBar model
    , loadingModal loadingBarOn
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


loadingModal activeClass =
    div [ class <| "modal " ++ activeClass ]
        [ div [ class "modal-background" ] []
        , div [ class "modal-content" ]
            [ div [ class "card" ]
                [ div [ class "card-content has-background-dark" ]
                    [ h1 [ class "title has-text-white has-text-centered" ] [ text "Loading..." ]
                    , span [ class "button is-large is-dark is-loading is-fullwidth" ] []
                    ]
                ]
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
                    modBy 24 <| d // (60 * 60 * 1000)

                days d =
                    d // (24 * 60 * 60 * 1000)

                phrase d f qualifier =
                    String.fromInt (f d) ++ " " ++ qualifier

                timeString d =
                    phrase d days "day(s)" ++ ", " ++ phrase d hours "hour(s)" ++ ", " ++ phrase d minutes "minute(s)" ++ " and " ++ phrase d seconds "second(s)"
            in
            tr []
                [ td [] [ text themeData.theme ]
                , td [] [ text themeData.tagline ]
                , td [] [ text <| timeString (posixToMillis t - posixToMillis themeData.openDatetime) ]
                , td [] [ text <| timeString (posixToMillis themeData.closeDatetime - posixToMillis t) ]
                ]

        Nothing ->
            tr [] []
