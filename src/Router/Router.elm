module Router.Router exposing (StartRoute(..), routeParser, startRouteToCmd, urlChanged, urlInit, urlToStartRoute)

import Browser.Navigation as Nav
import Maybe
import RemoteData exposing (RemoteData(..), WebData)
import Types.Default as Default
import Types.Msg exposing (..)
import Types.Types exposing (..)
import Url exposing (Url)
import Url.Parser exposing ((</>), Parser, map, oneOf, parse, s, string, top)


type RouteInputType
    = InitialRoute (Maybe AuthToken)
    | ContinueFromRoute Route


routeParser : RouteInputType -> Parser (Route -> a) a
routeParser routeInputType =
    case routeInputType of
        InitialRoute authTokenMaybe ->
            case authTokenMaybe of
                Just token ->
                    parserWithAuth NotAsked

                Nothing ->
                    parserNoAuth

        ContinueFromRoute prevRoute ->
            case prevRoute of
                RouteWithAuth userWebData _ ->
                    parserWithAuth userWebData

                RouteNoAuth _ ->
                    parserNoAuth


parserWithAuth userWebData =
    let
        routify : PageWithAuth -> Route
        routify page =
            RouteWithAuth NotAsked page
    in
    oneOf
        [ map (routify MyHome) top

        --, map MyAbout <| s "about"
        --, map Contact <| s "contact"
        , map (routify MyResources) <| s "resources"

        --, map (MyArchive NotAsked) <| s "archive"
        , map (routify <| MyLeader NotAsked) <| s "leaderboard"
        , map (routify <| MyLeaderFull NotAsked) <| s "leaderboard-detailed"
        , map (routify <| MyLogin) <| s "login"
        , map (routify <| MyPuzzles NotAsked) <| s "my-puzzles"
        , map (routify <| MyCompleted NotAsked) <| s "my-completed"
        , map (routify <| MySubmissions NotAsked) <| s "my-submissions"
        ]


parserNoAuth =
    let
        routify : PageNoAuth -> Route
        routify page =
            RouteNoAuth page
    in
    oneOf
        [ map (routify <| Home Default.register NotAsked) top
        , map (routify About) <| s "about"
        , map (routify Contact) <| s "contact"
        , map (routify Resources) <| s "resources"
        , map (routify <| Archive NotAsked) <| s "archive"
        , map (routify <| LeaderTotal NotAsked) <| s "leaderboard"
        , map (routify <| Login <| InputEmail Default.email NotAsked) <| s "login"
        ]


type StartRoute
    = RouteWithoutToken
    | RouteWithToken AuthToken


urlToStartRoute : Maybe AuthToken -> Url -> ( StartRoute, Route )
urlToStartRoute authTokenMaybe url =
    let
        newRoute =
            Maybe.withDefault (RouteNoAuth NotFound) <| parse (routeParser (InitialRoute authTokenMaybe)) url
    in
    case newRoute of
        RouteWithAuth _ _ ->
            case authTokenMaybe of
                Just token ->
                    ( RouteWithToken token, newRoute )

                Nothing ->
                    ( RouteWithoutToken, newRoute )

        RouteNoAuth _ ->
            ( RouteWithoutToken, newRoute )


startRouteToCmd : StartRoute -> Cmd Msg
startRouteToCmd startRoute =
    case startRoute of
        RouteWithToken authToken ->
            Cmd.none

        _ ->
            Cmd.none


authToCmd : AuthToken -> Cmd Msg
authToCmd authToken =
    Cmd.none


continueRouteToCmd : Route -> Cmd Msg
continueRouteToCmd route =
    case route of
        RouteNoAuth pageNoAuth ->
            Cmd.none

        RouteWithAuth userWebData pageWithAuth ->
            case userWebData of
                Success user ->
                    Cmd.none

                _ ->
                    Cmd.none


urlToRouteCmd : Route -> Url -> ( Route, Cmd Msg )
urlToRouteCmd prevRoute url =
    let
        newRoute =
            Maybe.withDefault (RouteNoAuth NotFound) <| parse (routeParser (ContinueFromRoute prevRoute)) url

        newCmd =
            continueRouteToCmd newRoute
    in
    ( newRoute, newCmd )


urlInit : Maybe AuthToken -> Url -> Nav.Key -> ( Model, Cmd Msg )
urlInit authTokenMaybe url key =
    let
        ( startRoute, route ) =
            urlToStartRoute authTokenMaybe url

        startCmd =
            startRouteToCmd startRoute

        initModel =
            Default.model key route
    in
    ( initModel, startCmd )


urlChanged : Model -> Url -> ( Model, Cmd Msg )
urlChanged model url =
    let
        meta =
            model.meta

        ( newRoute, newCmd ) =
            urlToRouteCmd model.route url
    in
    ( { model | meta = { meta | navActive = False }, route = newRoute }, newCmd )
