module Types exposing (ArchiveData(..), PuzzleData, PuzzleSet(..), ThemeData)

import Time exposing (Posix)


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


type PuzzleSet
    = A
    | B
    | C
    | M
    | S


type ArchiveData
    = ArchiveFull (List PuzzleData)
    | ArchiveDetail (List PuzzleData) PuzzleData
