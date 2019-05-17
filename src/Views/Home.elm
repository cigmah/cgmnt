module Views.Home exposing (view)

import Browser
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


view : Model -> ( String, Html Msg )
view model =
    let
        title =
            "CIGMAH Puzzle Hunt"

        body =
            makeBody model
    in
    ( title, body )


makeBody : Model -> Html Msg
makeBody =
    case model.webDataHome of
        NotAsked ->
            notAskedPage

        Loading ->
            loadingPage

        Failure ->
            failurePage

        Success homeData ->
            homePage model.auth homeData


notAskedPage : Html Msg
notAskedPage =
    div [ class "container" ]
        [ h1 [] [ text "Welcome to the CIGMAH Puzzle Hunt" ]
        , p [] [ text "Reload?" ]
        ]


failurePage : Html Msg
failurePage =
    div [ class "container" ]
        [ h1 [] [ text "Something went wrong." ] ]


homePage : Auth -> HomeData -> Html Msg
homePage auth homeData =
    let
        welcomeMessage =
            case auth of
                User credentials ->
                    "Welcome, " ++ credentials.username

                Public ->
                    "Welome to the CIGMAH Puzzle Hunt"
    in
    div [ class "container" ]
        [ h1 [] [ text welcomeMessage ] ]
