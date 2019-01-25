module Shared.Router exposing (fromUrl, routeParser)

import Maybe
import Shared.Types exposing (Route(..))
import Url exposing (Url)
import Url.Parser exposing ((</>), Parser, map, oneOf, parse, s, string, top)


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
