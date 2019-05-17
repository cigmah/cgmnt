port module Handlers exposing (changedRoute, changedUrl, clickedLink, credsToUser, fromUrl, init, intDeltaString, login, logout, monthToString, parser, portChangedRoute, posixToMonth, posixToString, puzzleSetString, replaceUrl, routeInit, routeToString, safeOnSubmit, storeCache, themeLight, timeDelta, timeStringWithDefault)

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


port portChangedRoute : () -> Cmd msg


port themeLight : Bool -> Cmd msg



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
        aedt =
            11 * 60

        aest =
            { start = 25909380, offset = 10 * 60 }

        zone =
            Time.customZone aedt [ aest ]

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
                    [ "home" ]

                ContactRoute ->
                    [ "contact" ]

                PrizesRoute ->
                    [ "prizes" ]

                PuzzleRoute puzzleId ->
                    [ "puzzles", String.fromInt puzzleId ]

                LeaderboardRoute ->
                    [ "leaderboard" ]

                UserRoute username ->
                    [ "stats", username ]

                LoginRoute ->
                    [ "login" ]

                LogoutRoute ->
                    [ "logout" ]

                InfoRoute ->
                    [ "info" ]

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
        , Parser.map ContactRoute <| Parser.s "contact"
        , Parser.map PrizesRoute <| Parser.s "prizes"
        , Parser.map PuzzleRoute <| Parser.s "puzzles" </> Parser.int
        , Parser.map UserRoute <| Parser.s "stats" </> Parser.string
        , Parser.map LeaderboardRoute <| Parser.s "leaderboard"
        , Parser.map LogoutRoute <| Parser.s "logout"
        , Parser.map InfoRoute <| Parser.s "info"
        , Parser.map RegisterRoute <| Parser.s "register"
        , Parser.map LoginRoute <| Parser.s "login"
        ]


replaceUrl : Navigation.Key -> Route -> Cmd msg
replaceUrl key route =
    Navigation.replaceUrl key (routeToString route)


fromUrl : Url.Url -> Maybe Route
fromUrl url =
    { url | path = Maybe.withDefault "" url.fragment, fragment = Nothing } |> Parser.parse parser


credsToUser : Credentials -> FullUser
credsToUser c =
    { username = c.username, email = c.email, firstName = c.firstName, lastName = c.lastName }



-- Init


routeInit : Maybe Credentials -> Route -> Navigation.Key -> ColourTheme -> ( Model, Cmd Msg )
routeInit credentialsMaybe route key colourTheme =
    let
        model =
            defaultModel key credentialsMaybe colourTheme

        makeModel newModal =
            { model | modal = Just newModal }
    in
    case ( credentialsMaybe, route ) of
        ( Nothing, HomeRoute ) ->
            ( model, Requests.getHomeDataPublic )

        ( Nothing, PuzzleRoute puzzleId ) ->
            ( makeModel <| Puzzle puzzleId (PublicPuzzle Loading), Requests.getPuzzlePublic puzzleId )

        ( Nothing, RegisterRoute ) ->
            ( makeModel <| Register defaultRegister NotAsked, Cmd.none )

        ( Nothing, LoginRoute ) ->
            ( makeModel <| Login (InputEmail "" NotAsked), Cmd.none )

        ( Nothing, LogoutRoute ) ->
            ( model, Navigation.replaceUrl model.key <| routeToString HomeRoute )

        ( Nothing, UserRoute username ) ->
            ( makeModel <| UserInfo username Loading, Requests.getStatsPublic username )

        ( Just credentials, HomeRoute ) ->
            ( model, Requests.getHomeDataUser credentials.authToken )

        ( Just credentials, PuzzleRoute puzzleId ) ->
            ( makeModel <| Puzzle puzzleId (UserUnsolvedPuzzle Loading "" NotAsked), Requests.getPuzzleUser puzzleId credentials.authToken )

        ( Just credentials, UserRoute username ) ->
            ( makeModel <| UserInfo username Loading, Requests.getStatsUser username credentials.authToken )

        ( Just credentials, RegisterRoute ) ->
            ( makeModel <| NotFound, Cmd.none )

        ( Just credentials, LoginRoute ) ->
            ( makeModel <| NotFound, Cmd.none )

        ( Just credentials, LogoutRoute ) ->
            ( { model | auth = Public, modal = Just Logout }, logout )

        ( _, InfoRoute ) ->
            ( makeModel <| Info, Cmd.none )

        ( _, PrizesRoute ) ->
            ( makeModel <| Prizes Loading, Requests.getPrizeList )

        ( _, LeaderboardRoute ) ->
            ( makeModel <| Leaderboard Loading, Requests.getLeaderboard )

        ( _, ContactRoute ) ->
            ( makeModel <| Contact defaultContactData NotAsked, Cmd.none )

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

        ( model, cmd ) =
            routeInit credentialsMaybe route key Light
    in
    ( model, Cmd.batch [ cmd, portChangedRoute () ] )



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
            ( model, Cmd.batch [ Navigation.load href, portChangedRoute () ] )


changedUrl : Model -> Url.Url -> ( Model, Cmd Msg )
changedUrl model url =
    let
        maybeCredentials =
            case model.auth of
                User credentials ->
                    Just credentials

                Public ->
                    Nothing

        ( newModel, cmd ) =
            routeInit maybeCredentials (Maybe.withDefault NotFoundRoute <| fromUrl url) model.key model.colourTheme
    in
    ( newModel, Cmd.batch [ cmd, portChangedRoute () ] )


changedRoute : Model -> Route -> ( Model, Cmd Msg )
changedRoute model route =
    let
        maybeCredentials =
            case model.auth of
                User credentials ->
                    Just credentials

                Public ->
                    Nothing

        ( newModel, cmd ) =
            routeInit maybeCredentials route model.key model.colourTheme
    in
    ( newModel, Cmd.batch [ cmd, Navigation.pushUrl model.key <| routeToString route, portChangedRoute () ] )
