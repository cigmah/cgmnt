module Types.Init exposing (email, model, register, selectedPuzzle, token)

import Browser.Navigation as Nav
import Time exposing (Posix, millisToPosix)
import Types.Types exposing (..)


model : Nav.Key -> Route -> Maybe AuthToken -> Model
model key route authToken =
    { key = key
    , route = route
    , meta = meta authToken
    }


meta authToken =
    { currentTime = Nothing
    , authToken = authToken
    , navBarMenuActive = False
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
