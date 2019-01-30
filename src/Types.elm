module Types exposing (ArchiveData(..), FullPuzzleData, LimitedPuzzleData, PuzzleSet(..), ThemeData, ThemeSet(..))

import Time exposing (Posix)


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
    , answer : Maybe String
    , explanation : Maybe String
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
