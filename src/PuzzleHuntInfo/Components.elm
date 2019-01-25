module PuzzleHuntInfo.Components exposing (viewPuzzleHuntInfo)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Markdown
import PuzzleHuntInfo.Content as Content
import Shared.Components exposing (navBar)


viewPuzzleHuntInfo model =
    { title = "CIGMAH PuzzleHunt"
    , body = bodyPuzzleHuntInfo model
    }


bodyPuzzleHuntInfo model =
    [ navBar model
    , section [ class "hero is-dark" ]
        [ div [ class "hero-body" ]
            [ div [ class "container" ]
                [ h1 [ class "title" ]
                    [ text "CIGMAH Puzzle Hunt 2019" ]
                , h2 [ class "subtitle" ]
                    [ text "Coming Soon" ]
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
