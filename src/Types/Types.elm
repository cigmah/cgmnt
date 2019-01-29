module Types.Types exposing (ActiveData, ArchiveData(..), AuthToken, Email, LeaderFullData, LeaderPuzzleData, LeaderPuzzleUser, LeaderTotalData, LeaderTotalUser, LeaderUnit, LoginState(..), Message, Meta, Model, OkSubmitData, PageNoAuth(..), PageWithAuth(..), PuzzleData, PuzzleSet(..), PuzzlesData(..), RegisterInfo, Route(..), SelectedPuzzleInfo, SubmissionResponse(..), SubmissionsData, ThemeData, Token, TooSoonSubmitData, User, UserSubmission)

import Browser.Navigation as Nav
import RemoteData exposing (RemoteData(..), WebData)
import Time exposing (Posix)


type alias Model =
    { route : Route
    , meta : Meta
    }


type alias AuthToken =
    String


type alias Meta =
    { currentTime : Maybe Posix
    , navActive : Bool
    , key : Nav.Key
    }


type alias User =
    { username : String
    , email : String
    , firstName : Maybe String
    , lastName : Maybe String
    , authToken : AuthToken
    }


type Route
    = RouteNoAuth PageNoAuth
    | RouteWithAuth (WebData User) PageWithAuth


type PageNoAuth
    = Home RegisterInfo (WebData Message)
    | About
    | Contact
    | Resources
    | Archive (WebData ArchiveData)
    | LeaderTotal (WebData LeaderTotalData)
    | Login LoginState
    | NotFound


type PageWithAuth
    = MyHome
    | MyResources
    | MyLogin
    | MyLeader (WebData LeaderTotalData)
    | MyLeaderFull (WebData LeaderFullData)
    | MyPuzzles (WebData PuzzlesData)
    | MyCompleted (WebData ArchiveData)
    | MySubmissions (WebData SubmissionsData)
    | MyNotFound


type alias Message =
    String


type alias RegisterInfo =
    { username : String
    , email : String
    , firstName : String
    , lastName : String
    }


type ArchiveData
    = ArchiveFull (List PuzzleData)
    | ArchiveDetail (List PuzzleData) PuzzleData


type PuzzleSet
    = A
    | B
    | C
    | M
    | S


type alias PuzzleData =
    { id : Int
    , theme : ThemeData
    , set : PuzzleSet
    , imagePath : String
    , title : String
    , body : String
    , example : String
    , statement : String
    , references : String
    , input : Maybe String
    , answer : Maybe String
    , explanation : Maybe String
    }


type alias ThemeData =
    { id : Int
    , year : Int
    , theme : String
    , tagline : String
    , openDatetime : Posix
    , closeDatetime : Posix
    }


type alias LeaderTotalData =
    List LeaderTotalUser


type alias LeaderTotalUser =
    { username : String
    , total : Int
    }


type alias LeaderPuzzleData =
    List LeaderPuzzleUser


type alias LeaderPuzzleUser =
    { username : String
    , puzzleTitle : String
    , submissionDatetime : Posix
    , points : Int
    }


type alias LeaderFullData =
    List LeaderUnit


type alias LeaderUnit =
    { username : String
    , puzzleTitle : String
    , submissionDatetime : Posix
    , themeTitle : String
    , puzzleSet : PuzzleSet
    , points : Int
    }


type alias Email =
    String


type alias Token =
    String


type LoginState
    = InputEmail Email (WebData Message)
    | InputToken Email (WebData Message) Token (WebData Message)


type PuzzlesData
    = PuzzlesAll ActiveData
    | PuzzlesDetail ActiveData SelectedPuzzleInfo (WebData SubmissionResponse)


type alias ActiveData =
    { active : List PuzzleData
    , next : Maybe ThemeData
    }


type alias SelectedPuzzleInfo =
    { puzzle : PuzzleData
    , input : String
    }


type SubmissionResponse
    = OkSubmit OkSubmitData
    | TooSoonSubmit TooSoonSubmitData


type alias OkSubmitData =
    { id : Int
    , submission : String
    , isCorrect : Bool
    , points : Int
    }


type alias TooSoonSubmitData =
    { message : String
    , attempts : Int
    , last : Posix
    , wait : Int
    , next : Posix
    }


type alias SubmissionsData =
    List UserSubmission


type alias UserSubmission =
    { username : String
    , puzzleTitle : String
    , theme : String
    , set : PuzzleSet
    , submissionDatetime : Posix
    , submission : String
    , isCorrect : Bool
    , points : Int
    }
