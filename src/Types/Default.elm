module Types.Default exposing (email, meta, model, register, selectedPuzzle, token)

import Browser.Navigation as Nav
import Time exposing (Posix, millisToPosix)
import Types.Types exposing (..)


model : Nav.Key -> Route -> Model
model key route =
    { meta = meta key
    , route = route
    }


meta : Nav.Key -> Meta
meta key =
    { currentTime = Nothing
    , navActive = False
    , key = key
    }


selectedPuzzle : PuzzleData -> SelectedPuzzleInfo
selectedPuzzle puzzle =
    { puzzle = puzzle, input = "" }


register : RegisterInfo
register =
    { username = ""
    , email = ""
    , firstName = ""
    , lastName = ""
    }


email : Email
email =
    ""


token : Token
token =
    ""
