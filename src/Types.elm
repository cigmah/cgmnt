module Types exposing (ArchiveData(..), FullPuzzleData, LeaderTotalData, LeaderTotalUnit, LimitedPuzzleData, OkSubmitData, PuzzleData, PuzzleSet(..), SelectedPuzzleInfo, SubmissionResponse(..), ThemeData, ThemeSet(..), TooSoonSubmitData)

import Time exposing (Posix)


type alias PuzzleData a =
    { a
        | id : Int
        , theme : ThemeData
        , set : PuzzleSet
        , imagePath : String
        , title : String
    }


type alias FullPuzzleData =
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
    , answer : String
    , explanation : String
    }


type alias LimitedPuzzleData =
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
    }


type ThemeSet
    = RTheme
    | MTheme
    | STheme


type alias ThemeData =
    { id : Int
    , year : Int
    , theme : String
    , themeSet : ThemeSet
    , tagline : String
    , openDatetime : Posix
    , closeDatetime : Posix
    }


type PuzzleSet
    = A
    | B
    | C
    | M


type ArchiveData
    = ArchiveFull (List FullPuzzleData)
    | ArchiveDetail (List FullPuzzleData) FullPuzzleData


type alias LeaderTotalData =
    List LeaderTotalUnit


type alias LeaderTotalUnit =
    { username : String
    , total : Int
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


type alias SelectedPuzzleInfo =
    { puzzle : LimitedPuzzleData
    , input : String
    , isCompleted : Bool
    }


type alias TooSoonSubmitData =
    { message : String
    , attempts : Int
    , last : Posix
    , wait : Int
    , next : Posix
    }
