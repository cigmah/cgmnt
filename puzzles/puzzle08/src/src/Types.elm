module Types exposing (Board, BoardState(..), BoardTime, Cell, Contents, Grid, HighlightType(..), Movement(..), Points, Screen(..), SolutionComparison(..), Tarsal(..))

import Random exposing (Seed)

type Screen
    = Start Seed
    | Playing Float Board
    | Failure Board
    | Success Board


type alias Board =
    { grid : Grid
    , boardState : BoardState
    , nextTarsal : Tarsal
    , remainingTarsals : List Tarsal
    , timeLeft : BoardTime
    , points : Points
    , muted : Bool
    , randomSeed : Seed
    }


type alias Grid =
    List Cell


type alias Cell =
    { x : Int
    , y : Int
    , contents : Contents
    }


type alias Contents =
    Int


type BoardState
    = Falling Grid Grid
    | Highlighting HighlightType


type HighlightType
    = Cleared (List Int)
    | Correct Grid
    | Incorrect Grid


type SolutionComparison
    = NotIntersecting
    | CorrectIntersect
    | IncorrectIntersect


type Tarsal
    = DistalPhalanx
    | Hallux
    | MiddlePhalanx
    | ProximalPhalanx
    | Metatarsal
    | Cuneiform
    | Navicular
    | Cuboid
    | Talus
    | Calcaneus


{-| Time in seconds
-}
type alias BoardTime =
    Float


type alias Points =
    Int


type Movement
    = Left
    | Right
    | Down
