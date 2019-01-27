module View.LoadingModal exposing (loadingModal)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


loadingModal isActive =
    let
        modalClass =
            case isActive of
                True ->
                    "modal is-active"

                False ->
                    "modal "
    in
    div [ class modalClass ]
        [ div [ class "modal-background" ] []
        , div [ class "modal-content" ]
            [ div [ class "card" ]
                [ div [ class "card-content has-background-dark" ]
                    [ h1 [ class "subtitle has-text-white has-text-centered" ] [ text "Loading..." ]
                    , span [ class "button is-large is-dark is-loading is-fullwidth" ] []
                    ]
                ]
            ]
        ]
