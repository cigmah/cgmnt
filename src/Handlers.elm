port module Handlers exposing (changedRoute, changedUrl, clickedLink, credsToUser, fromUrl, init, intDeltaString, login, logout, monthToString, parser, posixToMonth, posixToString, puzzleSetString, replaceUrl, routeInit, routeToString, safeOnSubmit, storeCache, timeDelta, timeStringWithDefault)

import Browser
import Browser.Navigation as Navigation
import Html.Attributes as Attr
import Html.Events exposing (custom)
import Http
import Iso8601
import Json.Decode as Decode
import Json.Encode as Encode
import RemoteData exposing (RemoteData(..), WebData)
import Requests
import Time exposing (Month(..), Posix, millisToPosix, posixToMillis)
import Types exposing (..)
import Url
import Url.Parser as Parser exposing ((</>), Parser)



-- Ports


port storeCache : Maybe Decode.Value -> Cmd msg


login : Credentials -> Cmd Msg
login credentials =
    storeCache <| Just (Requests.encodeCredentials credentials)


logout : Cmd Msg
logout =
    storeCache Nothing



-- Utilities


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
        AbstractPuzzle ->
            "Abstract"

        BeginnerPuzzle ->
            "Beginner"

        ChallengePuzzle ->
            "Challenge"

        MetaPuzzle ->
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


posixToMonth : Posix -> String
posixToMonth time =
    let
        zone =
            Time.customZone (11 * 60) []

        month =
            Time.toMonth zone time
    in
    monthToString month


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



-- Routing


routeToString : Route -> String
routeToString route =
    let
        pieces =
            case route of
                HomeRoute ->
                    []

                FormatRoute ->
                    [ "resources" ]

                PrizesRoute ->
                    [ "prizes" ]

                PuzzleListRoute ->
                    [ "puzzles" ]

                PuzzleDetailRoute puzzleId ->
                    [ "puzzles", String.fromInt puzzleId ]

                LeaderboardRoute ->
                    [ "leaderboard" ]

                LoginRoute ->
                    [ "login" ]

                LogoutRoute ->
                    [ "logout" ]

                RegisterRoute ->
                    [ "register" ]

                _ ->
                    []
    in
    "#/" ++ String.join "/" pieces


parser : Parser (Route -> a) a
parser =
    Parser.oneOf
        [ Parser.map HomeRoute Parser.top
        , Parser.map FormatRoute <| Parser.s "resources"
        , Parser.map PrizesRoute <| Parser.s "prizes"
        , Parser.map PuzzleListRoute <| Parser.s "puzzles"
        , Parser.map PuzzleDetailRoute <| Parser.s "puzzles" </> Parser.int
        , Parser.map LeaderboardRoute <| Parser.s "leaderboard"
        , Parser.map LogoutRoute <| Parser.s "logout"
        , Parser.map RegisterRoute <| Parser.s "register"
        , Parser.map LoginRoute <| Parser.s "login"
        ]


replaceUrl : Navigation.Key -> Route -> Cmd msg
replaceUrl key route =
    Navigation.replaceUrl key (routeToString route)


fromUrl : Url.Url -> Maybe Route
fromUrl url =
    { url | path = Maybe.withDefault "" url.fragment, fragment = Nothing } |> Parser.parse parser


credsToUser : Credentials -> UserData
credsToUser c =
    { username = c.username, email = c.email, firstName = c.firstName, lastName = c.lastName }



-- Init


routeInit : Maybe Credentials -> Route -> Navigation.Key -> ( Model, Cmd Msg )
routeInit credentialsMaybe route key =
    let
        meta =
            defaultMeta key credentialsMaybe

        makeModel =
            Model meta
    in
    case ( credentialsMaybe, route ) of
        ( Nothing, HomeRoute ) ->
            ( makeModel <| Home (HomePublic defaultContactData NotAsked), Cmd.none )

        ( Nothing, PuzzleListRoute ) ->
            ( makeModel <| PuzzleList (ListPublic Loading), Requests.getPuzzleListPublic )

        ( Nothing, PuzzleDetailRoute puzzleId ) ->
            ( makeModel <| PuzzleDetail (PublicPuzzle puzzleId Loading), Requests.getPuzzleDetailPublic puzzleId )

        ( Nothing, LeaderboardRoute ) ->
            ( makeModel <| Leaderboard (ByTotal Loading), Requests.getLeaderboardByTotal )

        ( Nothing, RegisterRoute ) ->
            ( makeModel <| Register (NewUser defaultRegister NotAsked), Cmd.none )

        ( Nothing, LoginRoute ) ->
            ( makeModel <| Login (InputEmail "" NotAsked), Cmd.none )

        ( Nothing, LogoutRoute ) ->
            ( makeModel <| Home (HomePublic defaultContactData NotAsked), Navigation.replaceUrl meta.key <| routeToString HomeRoute )

        ( Just credentials, HomeRoute ) ->
            ( makeModel <| Home (HomeUser (credsToUser credentials) Loading), Requests.getProfile credentials.token )

        ( Just credentials, PuzzleListRoute ) ->
            ( makeModel <| PuzzleList (ListUser Loading), Requests.getPuzzleListUser credentials.token )

        ( Just credentials, PuzzleDetailRoute puzzleId ) ->
            ( makeModel <| PuzzleDetail (UserPuzzle puzzleId Loading), Requests.getPuzzleDetailUser puzzleId credentials.token )

        ( Just credentials, LeaderboardRoute ) ->
            ( makeModel <| Leaderboard (ByTotal Loading), Requests.getLeaderboardByTotal )

        ( Just credentials, RegisterRoute ) ->
            ( makeModel <| Register AlreadyUser, Cmd.none )

        ( Just credentials, LoginRoute ) ->
            ( makeModel <| Login AlreadyLoggedIn, Cmd.none )

        ( Just credentials, LogoutRoute ) ->
            ( { meta = { meta | auth = Public }, page = Logout }, logout )

        ( _, FormatRoute ) ->
            ( makeModel <| Format, Cmd.none )

        ( _, PrizesRoute ) ->
            ( makeModel <| Prizes Loading, Requests.getPrizeList )

        ( _, NotFoundRoute ) ->
            ( makeModel <| NotFound, Cmd.none )


init : Decode.Value -> Url.Url -> Navigation.Key -> ( Model, Cmd Msg )
init valueDecode url key =
    let
        route =
            Maybe.withDefault NotFoundRoute <| fromUrl url

        credentialsMaybe =
            valueDecode
                |> Decode.decodeValue Decode.string
                |> Result.andThen (Decode.decodeString Requests.decoderCredentials)
                |> Result.toMaybe
    in
    routeInit credentialsMaybe route key



-- Handlers


clickedLink model urlRequest =
    case urlRequest of
        Browser.Internal url ->
            case url.fragment of
                Nothing ->
                    ( model, Navigation.load <| Url.toString url )

                Just _ ->
                    ( model, Navigation.pushUrl model.meta.key <| Url.toString url )

        Browser.External href ->
            ( model, Navigation.load href )


changedUrl : Meta -> Url.Url -> ( Model, Cmd Msg )
changedUrl meta url =
    let
        maybeCredentials =
            case meta.auth of
                User credentials ->
                    Just credentials

                Public ->
                    Nothing
    in
    routeInit maybeCredentials (Maybe.withDefault NotFoundRoute <| fromUrl url) meta.key


changedRoute : Meta -> Route -> ( Model, Cmd Msg )
changedRoute meta route =
    let
        maybeCredentials =
            case meta.auth of
                User credentials ->
                    Just credentials

                Public ->
                    Nothing

        ( model, cmd ) =
            routeInit maybeCredentials route meta.key
    in
    ( model, Cmd.batch [ cmd, Navigation.pushUrl meta.key <| routeToString route ] )
