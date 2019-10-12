module Views.Leaderboard exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Types exposing (..)
import Views.Shared exposing (..)


tableRow : Int -> UserAggregate -> Html Msg
tableRow rank userAggregate =
    tr []
        [ td [] [ text <| String.fromInt rank ]
        , td [] [ a [ routeHref <| UserRoute userAggregate.username ] [ text userAggregate.username ] ]
        , td [] [ text <| String.fromInt userAggregate.totalAbstract ]
        , td [] [ text <| String.fromInt userAggregate.totalBeginner ]
        , td [] [ text <| String.fromInt userAggregate.totalChallenge ]
        , td [] [ text <| String.fromInt userAggregate.totalMeta ]
        , td [] [ text <| String.fromInt userAggregate.totalGrand ]
        ]


view : Model -> List UserAggregate -> Html Msg
view model userAggregateList =
    div []
        [ h1 [] [ text "Leaderboard" ]
        , div [ class "footnote" ]
            [ text "The leaderboard shows the first 10 participants ordered by number of total points."
            ]
        , table [] <|
            tr []
                [ th [] [ text "Rank" ]
                , th [] [ text "Username" ]
                , th [] [ text "Abstract" ]
                , th [] [ text "Beginner" ]
                , th [] [ text "Challenge" ]
                , th [] [ text "Meta" ]
                , th [] [ text "Total" ]
                ]
                :: List.map2 tableRow (List.range 1 <| List.length userAggregateList) userAggregateList
        ]
