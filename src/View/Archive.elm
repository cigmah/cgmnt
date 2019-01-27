module View.Archive exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Html.Lazy exposing (..)
import Msg.Msg exposing (..)
import RemoteData exposing (RemoteData(..), WebData)
import Types.Types exposing (..)
import View.LoadingModal exposing (loadingModal)
import View.NavBar exposing (navBar)


view meta data =
    { title = "Puzzle Archive"
    , body = body meta data
    }


body meta data =
    let
        isLoading =
            case data of
                Loading ->
                    True

                _ ->
                    False
    in
    [ lazy2 navBar meta.authToken meta.navBarMenuActive
    , banner meta
    , lazy loadingModal isLoading
    , mainContainer data
    ]


banner meta =
    section [ class "hero is-primary" ]
        [ div [ class "hero-body" ]
            [ div [ class "container" ]
                [ h1 [ class "title" ]
                    [ text "Puzzle Archive" ]
                , h2 [ class "subtitle" ]
                    [ text "Closed puzzles from this year's Puzzle Hunt." ]
                ]
            ]
        ]


puzzleCard : PuzzleData -> Html Msg
puzzleCard puzzle =
    div [ class "column is-one-third" ]
        [ div [ class "card" ]
            [ div [ class "card-image" ]
                [ figure [ class "image is-16by9" ]
                    [ img [ src "https://bulma.io/images/placeholders/1280x960.png", alt "Placeholder" ] []
                    ]
                ]
            , div [ class "card-content" ]
                [ div [ class "card-header" ]
                    [ p [ class "card-header-title" ] [ text puzzle.title ] ]
                ]
            ]
        ]


mainContainer model =
    div [ class "columns is-multiline is-mobile" ] []
