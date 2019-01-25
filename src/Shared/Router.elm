module Shared.Router exposing (Route(..), fromUrl, routeParser)

import Maybe
import Url exposing (Url)
import Url.Parser exposing ((</>), Parser, map, oneOf, parse, s, string, top)


type Route
    = Home
    | About
    | PuzzleHunt
    | Contact
    | NotFound


routeParser : Parser (Route -> a) a
routeParser =
    oneOf
        [ map Home top
        , map About (s "about")
        , map PuzzleHunt (s "puzzle-hunt")
        , map Contact (s "contact")
        ]


fromUrl : Url -> Route
fromUrl url =
    Maybe.withDefault NotFound (parse routeParser url)
