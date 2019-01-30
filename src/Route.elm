module Route exposing (Route(..), fromUrl, href, replaceUrl)

import Browser.Navigation as Nav
import Html exposing (Attribute)
import Html.Attributes as Attr
import Url exposing (Url)
import Url.Parser as Parser exposing ((</>), Parser, oneOf, s, string)


type Route
    = Home
    | Resources
    | Archive
    | Login
    | Dashboard
    | OpenPuzzles
    | ClosedPuzzles
    | Leaderboard
    | Submissions


parser : Parser (Route -> a) a
parser =
    oneOf
        [ Parser.map Home Parser.top
        , Parser.map Resources <| s "resources"
        , Parser.map Archive <| s "archive"
        , Parser.map Login <| s "login"
        , Parser.map Dashboard <| s "dashboard"
        , Parser.map OpenPuzzles <| s "open-puzzles"
        , Parser.map ClosedPuzzles <| s "closed-puzzles"
        , Parser.map Leaderboard <| s "leaderboard"
        , Parser.map Submissions <| s "submissions"
        ]


routeToString : Route -> String
routeToString page =
    let
        pieces =
            case page of
                Home ->
                    []

                Resources ->
                    [ "resources" ]

                Archive ->
                    [ "archive" ]

                Login ->
                    [ "login" ]

                Dashboard ->
                    [ "dashboard" ]

                OpenPuzzles ->
                    [ "open-puzzles" ]

                ClosedPuzzles ->
                    [ "closed-puzzles" ]

                Leaderboard ->
                    [ "leaderboard" ]

                Submissions ->
                    [ "submissions" ]
    in
    "#/" ++ String.join "/" pieces



-- HELPERS


href : Route -> Attribute msg
href targetRoute =
    Attr.href (routeToString targetRoute)


replaceUrl : Nav.Key -> Route -> Cmd msg
replaceUrl key route =
    Nav.replaceUrl key (routeToString route)


fromUrl : Url -> Maybe Route
fromUrl url =
    { url | path = Maybe.withDefault "" url.fragment, fragment = Nothing }
        |> Parser.parse parser
