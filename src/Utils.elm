module Utils exposing (intDeltaString, monthToString, posixToString, puzzleSetString, safeOnSubmit, timeDelta, timeStringWithDefault)

import Html.Events exposing (custom)
import Http
import Iso8601
import Json.Decode as Decode
import RemoteData exposing (RemoteData(..), WebData)
import Time exposing (..)
import Types exposing (..)


timeDelta : Posix -> Posix -> Maybe Int
timeDelta tEarly tLater =
    let
        result =
            posixToMillis tLater - posixToMillis tEarly
    in
    if result > 0 then
        Just result

    else
        Nothing


intDeltaString : Int -> String
intDeltaString diff =
    let
        seconds =
            modBy 60 <| diff // 1000

        minutes =
            modBy 60 <| diff // (60 * 1000)

        hours =
            modBy 24 <| diff // (60 * 60 * 1000)

        days =
            diff // (60 * 60 * 1000 * 24)
    in
    String.fromInt days
        ++ " days, "
        ++ String.padLeft 2 '0' (String.fromInt hours)
        ++ "h:"
        ++ String.padLeft 2 '0' (String.fromInt minutes)
        ++ "m:"
        ++ String.padLeft 2 '0' (String.fromInt seconds)
        ++ "s"


timeStringWithDefault : Posix -> Posix -> String -> String -> String
timeStringWithDefault tEarly tLater default base =
    let
        delta =
            timeDelta tEarly tLater
    in
    case delta of
        Just time ->
            base ++ intDeltaString time

        Nothing ->
            default


puzzleSetString : PuzzleSet -> String
puzzleSetString set =
    case set of
        A ->
            "Abstract"

        B ->
            "Beginner"

        C ->
            "Challenge"

        M ->
            "Meta"


posixToString : Posix -> String
posixToString time =
    let
        zone =
            Time.customZone (11 * 60) []

        year =
            Time.toYear zone time

        month =
            Time.toMonth zone time

        day =
            String.padLeft 2 '0' <| String.fromInt <| Time.toDay zone time

        hour =
            String.padLeft 2 '0' <| String.fromInt <| Time.toHour zone time

        minute =
            String.padLeft 2 '0' <| String.fromInt <| Time.toMinute zone time
    in
    monthToString month ++ " " ++ day ++ " " ++ hour ++ ":" ++ minute


monthToString : Month -> String
monthToString month =
    case month of
        Jan ->
            "Jan"

        Feb ->
            "Feb"

        Mar ->
            "Mar"

        Apr ->
            "Apr"

        May ->
            "May"

        Jun ->
            "Jun"

        Jul ->
            "Jul"

        Aug ->
            "Aug"

        Sep ->
            "Sep"

        Oct ->
            "Oct"

        Nov ->
            "Nov"

        Dec ->
            "Dec"


safeOnSubmit message =
    custom "submit" (Decode.succeed { message = message, stopPropagation = True, preventDefault = True })
