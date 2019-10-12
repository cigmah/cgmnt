module Views.Home exposing (view)

import Handlers
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Html.Lazy exposing (..)
import Http exposing (Error(..))
import RemoteData exposing (RemoteData(..), WebData)
import Time
import Types exposing (..)
import Views.Shared exposing (..)


view : Model -> HomeData -> Html Msg
view model homeData =
    let
        differs =
            case model.auth of
                User credentials ->
                    { welcome = "Welcome to CIGMAH, " ++ credentials.username ++ "."
                    , nav =
                        p []
                            [ a [ routeHref <| UserRoute credentials.username ] [ text "Check your stats" ]
                            , text ", or view the "
                            , a [ routeHref LeaderboardRoute ] [ text "leaderboard" ]
                            , text " or the log of "
                            , a [ routeHref PrizesRoute ] [ text "prizes" ]
                            , text "; or "
                            , a [ routeHref ContactRoute ] [ text "review the FAQ or ask a question" ]
                            , text " or "
                            , a [ routeHref LogoutRoute ] [ text "logout" ]
                            , text "."
                            ]
                    }

                Public ->
                    { welcome = "Welcome to the CIGMAH Puzzle Hunt."
                    , nav =
                        p []
                            [ text "Read the "
                            , a [ routeHref ContactRoute ] [ text "FAQ or get in touch" ]
                            , text ", "
                            , a [ routeHref RegisterRoute ] [ text "register" ]
                            , text " or "
                            , a [ routeHref LoginRoute ] [ text "login" ]
                            , text ", or view the "
                            , a [ routeHref LeaderboardRoute ] [ text "leaderboard" ]
                            , text " or the log of "
                            , a [ routeHref PrizesRoute ] [ text "prizes" ]
                            , text "."
                            ]
                    }

        noOverflow =
            case model.modal of
                Just _ ->
                    True

                Nothing ->
                    False
    in
    article [ class "container", classList [ ( "no-overflow", noOverflow ) ] ]
        [ h1 [] [ text differs.welcome ]
        , div [ class "footnote" ] [ text "Don't like the look? ", br [] [], button [ onClick ToggledTheme ] [ text "Cycle the theme." ] ]
        , p []
            [ text <|
                String.join " "
                    [ "There are"
                    , String.fromInt homeData.numRegistrations
                    , "registered participants."
                    , String.fromInt homeData.numSubmissions
                    , "submissions have been received in total so far."
                    ]
            ]
        , p []
            [ text <| "The next theme is "
            , span [ class "theme" ] [ text homeData.next.themeTitle ]
            , text <| " and opens "
            , span [ class "timestamp" ] [ text <| Handlers.posixToString homeData.next.openDatetime ]
            , text "."
            , div [ class "footnote" ]
                [ text homeData.next.tagline ]
            ]
        , differs.nav
        , hr [] []
        , puzzlesList homeData.puzzles
        ]


puzzlesList : List PuzzleMini -> Html Msg
puzzlesList puzzles =
    let
        isMeta set =
            case set of
                MetaPuzzle ->
                    True

                _ ->
                    False

        itemisePuzzle : PuzzleMini -> Html Msg
        itemisePuzzle puzzle =
            a [ routeHref <| PuzzleRoute puzzle.id ]
                [ li [ class <| "puzzle-list-item " ++ Handlers.puzzleSetString puzzle.puzzleSet, classList [ ( "solved-item", Maybe.withDefault False puzzle.isSolved ) ] ]
                    [ span
                        [ class "puzzle-list-marker"
                        , classList [ ( "solved", Maybe.withDefault False puzzle.isSolved ), ( "primary", isMeta puzzle.puzzleSet ) ]
                        ]
                        [ div
                            [ class "puzzle-list-marker-contents" ]
                            [ text <| String.fromInt puzzle.id
                            , text <| Handlers.puzzleSetSymbol puzzle.puzzleSet
                            ]
                        ]
                    , span [ class "timestamp" ] [ text <| Handlers.posixToMonth puzzle.themeData.openDatetime ]
                    , span [ class "puzzle-title" ] [ text puzzle.title ]
                    ]
                ]
    in
    ul [ class "puzzle-list" ] <| List.map itemisePuzzle puzzles
