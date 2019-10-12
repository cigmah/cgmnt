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


view : Meta -> HomeState -> ( String, Html Msg )
view meta homeState =
    let
        title =
            "Home - CIGMAH"

        body =
            case ( meta.auth, homeState ) of
                ( User credentials, HomeUser userData Loading ) ->
                    loadingPage

                ( User credentials, HomeUser userData (Failure e) ) ->
                    case e of
                        BadStatus metadata ->
                            errorPage metadata.body

                        NetworkError ->
                            errorPage "There's something wrong with your network or with accessing the backend - check your internet connection first and check the console for any network errors."

                        _ ->
                            errorPage "Unfortunately, we don't yet know what this error is. :(  "

                ( User credentials, HomeUser userData (Success profileData) ) ->
                    dashboardPage
                        False
                        credentials.username
                        profileData

                ( Public, HomePublic ) ->
                    landingPage

                ( _, _ ) ->
                    notFoundPage
    in
    ( title, body )


landingPage =
    div
        [ class "main" ]
        [ div [ class "container" ]
            [ p []
                [ span [ class "lessen" ] [ text "?- about(puzzlehunt)" ]
                , br [] []
                , text "Free coding puzzles about medicine."
                , br [] []
                , br [] []
                , span [ class "lessen" ] [ text "?- duration(puzzlehunt)" ]
                , br [] []
                , text "March 9th - September 30th."
                , br [] []
                , br [] []
                , span [ class "lessen" ] [ text "?- size(puzzlehunt)" ]
                , br [] []
                , text "25 puzzles, 3 per month."
                , br [] []
                , br [] []
                , span [ class "lessen" ] [ text "?- contact(puzzlehunt)" ]
                , br [] []
                , text "cigmah.contact at gmail dot com"
                ]
            ]
        ]


submissionToRow : SubmissionData -> Html Msg
submissionToRow data =
    let
        ( trClass, symbol ) =
            if data.isResponseCorrect then
                ( "strengthen", "✓" )

            else
                ( "lessen", "✕" )
    in
    tr [ class trClass ]
        [ td [] [ text data.puzzle.title ]
        , td [] [ text <| "(" ++ Handlers.posixToString data.submissionDatetime ++ ")" ]
        , td [] [ text <| data.submission ]
        , td [] [ text symbol ]
        ]


dashboardPage : Bool -> String -> ProfileData -> Html Msg
dashboardPage isLoading username profileData =
    let
        numSolved =
            String.fromInt profileData.numSolved

        points =
            String.fromInt profileData.points

        submissions =
            profileData.submissions
    in
    div
        [ class "main" ]
        [ div
            [ class "container" ]
            [ p []
                [ span
                    [ class "lessen" ]
                    [ text "?- greeting(user)" ]
                , br [] []
                , text "Welcome, "
                , b [] [ text username ]
                , text "."
                , br [] []
                , br [] []
                , span [ class "lessen" ] [ text "?- numsolved(user)" ]
                , br [] []
                , b [] [ text numSolved ]
                , text " puzzles solved."
                , br [] []
                , br [] []
                , span [ class "lessen" ] [ text "?- numpoints(user)" ]
                , br [] []
                , b [] [ text points ]
                , text " points."
                , br [] []
                , br [] []
                , span [ class "lessen" ] [ text "?- tenrecent(user)" ]
                , br [] []
                , table [] <|
                    List.map submissionToRow profileData.submissions
                ]
            ]
        ]
