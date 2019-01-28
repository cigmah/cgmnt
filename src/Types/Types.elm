module Types.Types exposing (ActiveData, ArchiveData(..), AuthToken, Email, LeaderPuzzleData, LeaderPuzzleUser, LeaderState(..), LeaderTotalData, LeaderTotalUser, LoginState(..), Message, Model, OkSubmitData, PuzzleData, PuzzleSet(..), PuzzlesData(..), RegisterInfo, Route(..), SelectedPuzzleInfo, SubmissionResponse(..), SubmissionsData, ThemeData, Token, TooSoonSubmitData, UserSubmission)

import Browser.Navigation as Nav
import RemoteData exposing (RemoteData(..), WebData)
import Time exposing (Posix)


type alias Model =
    { key : Nav.Key
    , route : Route
    , meta : Meta
    }


type alias AuthToken =
    String


type alias Meta =
    { currentTime : Maybe Posix
    , authToken : Maybe String
    , navBarMenuActive : Bool
    }


type Route
    = Home RegisterInfo (WebData Message)
    | About
    | Contact
    | Resources
    | Archive (WebData ArchiveData)
    | Leader LeaderState
    | Login LoginState
    | HomeAuth AuthToken
    | LoginAuth AuthToken
    | PuzzlesAuth AuthToken (WebData PuzzlesData)
    | CompletedAuth AuthToken (WebData ArchiveData)
    | SubmissionsAuth AuthToken (WebData SubmissionsData)
    | NotFound


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
    , title : String
    , body : String
    , example : String
    , statement : String
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


type LeaderState
    = ByTotal (WebData (List LeaderTotalData))
    | ByPuzzle (WebData (List LeaderPuzzleData))


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
    , next : ThemeData
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
    , wait : Posix
    , next : Posix
    }


type alias SubmissionsData =
    List UserSubmission


type alias UserSubmission =
    { username : String
    , puzzleTitle : String
    , submissionDatetime : Posix
    , submission : String
    , isCorrect : Bool
    , points : Int
    }
