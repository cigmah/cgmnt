module Types.Init exposing (archive, completed, dash, leader, login, model, register, submissions)

import Browser.Navigation as Nav
import Time exposing (Posix)
import Types.Types exposing (..)


model : Nav.Key -> Route -> Model
model key route =
    { key = key
    , route = route
    , currentTime = Nothing
    , authToken = Nothing
    , navBarMenuActive = False
    }


archive : ArchiveInfo
archive =
    { isLoading = False
    , data = Nothing
    , selectedPuzzle = Nothing
    , message = Nothing
    }


leader : LeaderInfo
leader =
    ByTotal { isLoading = False, data = Nothing, message = Nothing }


dash : DashInfo
dash =
    { isLoadingDash = False
    , dashData = Nothing
    , dashMessage = Nothing
    , currentPuzzle = Nothing
    , currentInput = Nothing
    , isLoadingSendPuzzle = False
    , submissionData = Nothing
    , puzzleMessage = Nothing
    }


register : RegisterInfo
register =
    { username = ""
    , email = ""
    , firstName = ""
    , lastName = ""
    , isLoading = False
    , message = Nothing
    , response = Nothing
    }


login : LoginInfo
login =
    { email = ""
    , token = ""
    , isLoadingSendToken = False
    , sendTokenResponse = Nothing
    , isLoadingLogin = False
    , message = Nothing
    }


completed : CompletedInfo
completed =
    { isLoading = False
    , data = Nothing
    , selectedPuzzle = Nothing
    , message = Nothing
    }


submissions : SubmissionsInfo
submissions =
    { isLoading = False
    , data = Nothing
    , message = Nothing
    }
