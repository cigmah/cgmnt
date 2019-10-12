module Views.Stats exposing (view)

import Handlers exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Svg
import Svg.Attributes as Attributes
import Types exposing (..)


subRow : SubmissionData -> Html Msg
subRow data =
    tr []
        [ td [] [ text data.puzzle.title ]
        , td [] [ span [ class "timestamp" ] [ text <| Handlers.posixToString data.submissionDatetime ] ]
        , td [] [ text data.submission ]
        , td []
            [ text <|
                if data.isResponseCorrect then
                    "O"

                else
                    "X"
            ]
        , td [] [ text <| String.fromInt data.points ]
        ]


bigRank : UserStats -> Html Msg
bigRank userStats =
    div [ class "ranksquare" ]
        [ div [ class "rankbig" ] [ text "#", text <| String.fromInt userStats.rank ]
        , div [ class "rankpoints" ] [ text <| String.fromInt userStats.points, text " points." ]
        ]


barChart : UserStats -> Html Msg
barChart userStats =
    Svg.svg
        [ Attributes.width "400"
        , Attributes.height "100"
        , Attributes.viewBox "40 -40 840 290"
        , Attributes.class "ranksvg"
        ]
        [ Svg.rect
            [ Attributes.width <| String.fromInt <| userStats.numSubmit * 20
            , Attributes.height "50"
            , Attributes.x "0"
            , Attributes.y "0"
            ]
            []
        , Svg.text_ [ Attributes.x "0", Attributes.y "-10" ] [ Svg.text <| String.fromInt userStats.numSubmit ++ " submissions." ]
        , Svg.rect
            [ Attributes.width <| String.fromInt <| userStats.numSolved * 20
            , Attributes.height "50"
            , Attributes.x "0"
            , Attributes.y "100"
            ]
            []
        , Svg.text_ [ Attributes.x "0", Attributes.y "90" ] [ Svg.text <| String.fromInt userStats.numSolved ++ " solved." ]
        , Svg.rect
            [ Attributes.width <| String.fromInt <| userStats.numPrizes * 20
            , Attributes.height "50"
            , Attributes.x "0"
            , Attributes.y "200"
            ]
            []
        , Svg.text_ [ Attributes.x "0", Attributes.y "190" ] [ Svg.text <| String.fromInt userStats.numPrizes ++ " prizes." ]
        ]


view : Model -> Username -> UserStats -> Html Msg
view model username userStats =
    let
        prizesMessage =
            if userStats.numPrizes == 0 then
                ""

            else
                "They have also received " ++ String.fromInt userStats.numPrizes ++ " prize(s) throughout the Puzzle Hunt so far."

        submissions =
            case model.auth of
                User credentials ->
                    case ( userStats.submissions, credentials.username == username ) of
                        ( Just submissionsList, True ) ->
                            div []
                                [ h2 [] [ text "Your Recent Submissions" ]
                                , div [ class "footnote" ] [ text "This is you, so you get to see your most recent past submissions." ]
                                , table [] <|
                                    [ tr []
                                        [ th [] [ text "Puzzle" ]
                                        , th [] [ text "Timestamps" ]
                                        , th [] [ text "Attempt" ]
                                        , th [] [ text "Correct" ]
                                        , th [] [ text "Points" ]
                                        ]
                                    ]
                                        ++ List.map subRow submissionsList
                                ]

                        _ ->
                            div [] []

                _ ->
                    div [] []
    in
    div []
        [ h1 [] [ text <| "Participant: " ++ username ]
        , bigRank userStats
        , barChart userStats
        , submissions
        ]
