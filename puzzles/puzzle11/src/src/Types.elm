module Types exposing (Block, Board, BoardParams, Coord, CoordType(..), Dims, LevelId(..), Path, Screen(..), Seconds, Size, Solution, State(..), StateData)


type alias Coord =
    { x : Int, y : Int }


type CoordType
    = X
    | Y


type alias Path =
    List Coord


type alias Board =
    List Path


type alias Block =
    { coord : Coord, dims : Dims }


type alias Dims =
    { height : Int
    , width : Int
    }


type alias Size =
    Int


type alias Solution =
    List Bool


type Screen
    = Start
    | Loading
    | Level LevelId State
    | Failure LevelId StateData Solution
    | Timeout
    | Success StateData


type LevelId
    = LevelId Int


type alias Seconds =
    Int


type State
    = Playing StateData
    | Correct StateData


type alias BoardParams =
    { size : Size
    , blockDims : Dims
    , baseNumPaths : Int
    , baseNumPoints : Int
    , sourceCoord : Coord
    }


type alias StateData =
    { board : Board
    , boardParams : BoardParams
    , solution : Solution
    , timeRemaining : Seconds
    , mouse : Maybe Coord
    }
