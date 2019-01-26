module Functions.Functions exposing (fromUrl, getDashData, handleLinkClicked, handleUrlChanged, routeParser)

import Browser exposing (UrlRequest)
import Browser.Navigation as Nav
import Functions.ApiBase exposing (apiBase)
import Functions.Decoders exposing (..)
import Http
import Iso8601
import Maybe
import Msg.Msg exposing (..)
import Types.Init as Init
import Types.Types exposing (..)
import Url exposing (Url)
import Url.Parser exposing ((</>), Parser, map, oneOf, parse, s, string, top)


fromUrl : Url -> Route
fromUrl url =
    Maybe.withDefault NotFound (parse routeParser url)


routeParser : Parser (Route -> a) a
routeParser =
    oneOf
        [ map Home top
        , map About (s "about")
        , map Contact (s "contact")
        , map Resources (s "resources")
        , map (Archive Init.archive) <| s "archive"
        , map (Leader Init.leader) <| s "leaderboard"
        , map (Dash Init.dash Nothing) <| s "puzzle-hunt"
        , map (Completed Init.completed) <| s "my-completed-puzzles"
        , map (Submissions Init.submissions) <| s "my-submissions"
        ]


handleLinkClicked : Model -> UrlRequest -> ( Model, Cmd Msg )
handleLinkClicked model urlRequest =
    case urlRequest of
        Browser.Internal url ->
            ( { model | navBarMenuActive = False }, Nav.pushUrl model.key (Url.toString url) )

        Browser.External href ->
            ( model, Nav.load href )


handleUrlChanged : Model -> Url -> ( Model, Cmd Msg )
handleUrlChanged model url =
    let
        route =
            fromUrl url
    in
    case route of
        Dash _ _ ->
            case model.authToken of
                _ ->
                    ( { model | route = fromUrl url }, Cmd.none )

        _ ->
            ( { model | route = fromUrl url }, Cmd.none )


getDashData : String -> Cmd Msg
getDashData token =
    Http.request
        { method = "GET"
        , headers = [ Http.header "Authorization" <| "Token " ++ token ]
        , url = apiBase ++ "themes/"
        , body = Http.emptyBody
        , expect = Http.expectJson (DashMsg << ReceivedDashData) decodeDashData
        , timeout = Nothing
        , tracker = Nothing
        }
