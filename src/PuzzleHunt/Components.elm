module PuzzleHunt.Components exposing (viewPuzzleHuntInfo)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Markdown
import PuzzleHunt.Content as Content
import Shared.Components exposing (navBar)


viewPuzzleHuntInfo model =
    { title = "CIGMAH PuzzleHunt"
    , body = bodyPuzzleHuntInfo model
    }


bodyPuzzleHuntInfo model =
    [ navBar model
    , section [ class "hero is-dark is-fullheight-with-navbar" ]
        [ div [ class "hero-body" ]
            [ div [ class "container" ]
                [ h1 [ class "title" ]
                    [ text "CIGMAH Puzzle Hunt 2019" ]
                , h2 [ class "subtitle" ]
                    [ text "Testing Phase" ]
                , div [ class "buttons has-addons" ]
                    [ span [ class "button is-large is-dark is-inverted is-outlined" ] [ text "Register" ]
                    , span [ class "button is-large is-dark is-inverted is-outlined" ] [ text "Login" ]
                    ]
                ]
            ]
        ]
    , section [ class "hero" ]
        [ div [ class "hero-body" ]
            [ div [ class "container" ]
                [ div []
                    [ div [ class "content" ] <| Markdown.toHtml Nothing Content.puzzleHuntIntroText ]
                ]
            ]
        ]
    , section [ class "hero" ]
        [ div [ class "hero-body" ]
            [ div [ class "message container is-danger" ]
                [ div [ class "message-header" ]
                    [ h2 [] [ text "Never coded before?" ] ]
                , div [ class "message-body" ] [ div [ class "content" ] <| Markdown.toHtml Nothing Content.neverCodedText ]
                ]
            ]
        ]
    ]
