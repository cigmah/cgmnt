module PuzzleHunt.Authenticated exposing (bodyPuzzleHunt)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Iso8601
import List
import Markdown
import Maybe exposing (withDefault)
import PuzzleHunt.Content as Content
import Shared.Components exposing (navBar)
import Shared.Types exposing (Msg(..))
import String
import Time exposing (millisToPosix, posixToMillis)


bodyPuzzleHunt model token =
    let
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

        nextPuzzle =
            case model.huntDashboardInformation of
                Just info ->
                    case model.currentTime of
                        Just currentTime ->
                            case info.data of
                                Just data ->
                                    case data.next of
                                        Just next ->
                                            "The next theme is ''" ++ next.theme ++ "'' and opens in " ++ getTimeString (posixToMillis next.openDatetime - posixToMillis currentTime)

                                        Nothing ->
                                            "The next theme has not been announced yet."

                                Nothing ->
                                    ""

                        Nothing ->
                            ""

                Nothing ->
                    ""

        openCards =
            case model.huntDashboardInformation of
                Just info ->
                    case info.data of
                        Just data ->
                            case model.currentTime of
                                Just currentTime ->
                                    List.map (\x -> makeOpenCard x <| posixToMillis x.closeDatetime - posixToMillis currentTime) data.current

                                Nothing ->
                                    [ div [] [] ]

                        Nothing ->
                            [ div [] [] ]

                Nothing ->
                    [ div [] [] ]
    in
    [ navBar model
    , loadingModal loadingBarOn
    , section [ class "hero is-dark" ]
        [ div [ class "hero-body" ]
            [ div [ class "container" ]
                [ h1 [ class "title" ] [ text "Puzzle Hunt 2019 Portal" ]
                , h2 [ class "subtitle" ] [ text nextPuzzle ]
                ]
            ]
        ]
    , section [ class "hero" ]
        [ div [ class "hero-body" ]
            [ div [ class "container" ]
                [ div [ class "tile is-ancestor" ]
                    openCards
                ]
            ]
        ]
    ]


makeOpenCard themeData timeDelta =
    let
        timeString =
            getTimeString timeDelta
    in
    div [ class "tile is-parent" ]
        [ div [ class "tile is-child box" ]
            [ h1 [ class "subtitle" ] [ text themeData.theme ]
            , div [ class "field is-grouped is-grouped-multiline" ]
                [ div [ class "control" ]
                    [ div
                        [ class "tag has-addons" ]
                        [ span [ class "tag is-danger" ]
                            [ text "Closes" ]
                        , span [ class "tag" ] [ text <| getTimeString timeDelta ]
                        ]
                    ]
                ]
            , div [ class "content" ]
                [ text themeData.tagline ]
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


getTimeString timeDelta =
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
            String.fromInt (f d) ++ qualifier

        timeString d =
            phrase d days "d" ++ ":" ++ phrase d hours "h" ++ ":" ++ phrase d minutes "m" ++ ":" ++ phrase d seconds "s"
    in
    timeString timeDelta
