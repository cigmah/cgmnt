module View.Table exposing (makeTableHeadings)

import Html exposing (..)
import Html.Attributes exposing (..)
import List
import Msg.Msg exposing (..)


makeTableHeadings : List String -> Html Msg
makeTableHeadings headingList =
    let
        makeRow heading =
            th [ class "has-background-info has-text-white" ] [ text heading ]
    in
    thead []
        [ tr [] <| List.map makeRow headingList ]
