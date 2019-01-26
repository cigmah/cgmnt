module Types.Types exposing (AccountModal(..), ArchiveInfo, CompletedInfo, DashData, DashInfo, LeaderInfo(..), LeaderPuzzle, LeaderPuzzleData, LeaderTotal, LeaderTotalData, LoginInfo, Model, OkSubmitData, PuzzleData, PuzzleSet(..), RegisterInfo, Route(..), SubmissionResponse(..), SubmissionsInfo, ThemeData, TooSoonSubmitData, UserSubmission)

import Browser.Navigation as Nav
import Time exposing (Posix)


type alias Model =
    { key : Nav.Key
    , route : Route
    , currentTime : Maybe Posix
    , authToken : Maybe String
    , navBarMenuActive : Bool
    }


type Route
    = Home
    | About
    | Contact
    | Resources
    | Archive ArchiveInfo
    | Leader LeaderInfo
    | Dash DashInfo (Maybe AccountModal)
    | Completed CompletedInfo
    | Submissions SubmissionsInfo
    | NotFound


type alias ArchiveInfo =
    { isLoading : Bool
    , data : Maybe (List PuzzleData)
    , selectedPuzzle : Maybe PuzzleData
    , message : Maybe String
    }


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
    , input : String
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


type LeaderInfo
    = ByTotal LeaderTotal
    | ByPuzzle LeaderPuzzle


type alias LeaderTotal =
    { isLoading : Bool
    , data : Maybe (List LeaderTotalData)
    , message : Maybe String
    }


type alias LeaderTotalData =
    { username : String
    , total : Int
    }


type alias LeaderPuzzle =
    { isLoading : Bool
    , data : Maybe (List LeaderPuzzleData)
    , message : Maybe String
    }


type alias LeaderPuzzleData =
    { username : String
    , puzzleTitle : String
    , submissionDatetime : Posix
    , points : Int
    }


type alias DashInfo =
    { isLoadingDash : Bool
    , dashData : Maybe DashData
    , dashMessage : Maybe String
    , currentPuzzle : Maybe PuzzleData
    , currentInput : Maybe String
    , isLoadingSendPuzzle : Bool
    , submissionData : Maybe SubmissionResponse
    , puzzleMessage : Maybe String
    }


type alias DashData =
    { active : Maybe (List PuzzleData)
    , next : Maybe ThemeData
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


type AccountModal
    = Register RegisterInfo
    | Login LoginInfo


type alias RegisterInfo =
    { username : String
    , email : String
    , firstName : String
    , lastName : String
    , isLoading : Bool
    , response : Maybe String
    , message : Maybe String
    }


type alias LoginInfo =
    { email : String
    , token : String
    , isLoadingSendToken : Bool
    , sendTokenResponse : Maybe String
    , isLoadingLogin : Bool
    , message : Maybe String
    }


type alias CompletedInfo =
    { isLoading : Bool
    , data : Maybe (List PuzzleData)
    , selectedPuzzle : Maybe PuzzleData
    , message : Maybe String
    }


type alias SubmissionsInfo =
    { isLoading : Bool
    , data : Maybe (List UserSubmission)
    , message : Maybe String
    }


type alias UserSubmission =
    { username : String
    , puzzleTitle : String
    , submissionDatetime : Posix
    , submission : String
    , isCorrect : Bool
    , points : Int
    }
