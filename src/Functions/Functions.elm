module Functions.Functions exposing (fromUrl, intDeltaString, routeParser, timeDelta, timeStringWithDefault)

import Browser.Navigation as Nav
import Functions.ApiBase exposing (apiBase)
import Functions.Decoders exposing (..)
import Http
import Iso8601
import Maybe
import Msg.Msg exposing (..)
import RemoteData exposing (RemoteData(..), WebData)
import Time exposing (Posix, posixToMillis)
import Types.Init as Init
import Types.Types exposing (..)
import Url exposing (Url)
import Url.Parser exposing ((</>), Parser, map, oneOf, parse, s, string, top)


routeParser : Maybe AuthToken -> Parser (Route -> a) a
routeParser maybeAuth =
    case maybeAuth of
        Just token ->
            oneOf
                [ map (HomeAuth token) top
                , map About <| s "about"
                , map Contact <| s "contact"
                , map Resources <| s "resources"
                , map (Archive NotAsked) <| s "archive"
                , map (Leader <| ByTotal NotAsked) <| s "leaderboard"
                , map (LoginAuth token) <| s "login"
                , map (PuzzlesAuth token NotAsked) <| s "my-puzzles"
                , map (CompletedAuth token NotAsked) <| s "my-completed"
                , map (SubmissionsAuth token NotAsked) <| s "my-submissions"
                ]

        Nothing ->
            oneOf
                [ map (Home Init.register NotAsked) top
                , map About <| s "about"
                , map Contact <| s "contact"
                , map Resources <| s "resources"
                , map (Archive NotAsked) <| s "archive"
                , map (Leader <| ByTotal NotAsked) <| s "leaderboard"
                , map (Login <| InputEmail Init.email NotAsked) <| s "login"
                ]


fromUrl : Maybe AuthToken -> Url -> Route
fromUrl maybeAuth url =
    Maybe.withDefault NotFound (parse (routeParser maybeAuth) url)


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
        ++ "days, "
        ++ String.fromInt hours
        ++ "h:"
        ++ String.fromInt minutes
        ++ "m:"
        ++ String.fromInt seconds
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
