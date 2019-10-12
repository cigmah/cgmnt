module Levels exposing (levelParams)

import Types exposing (..)



-- Odd block dims are best.


levelParams : LevelId -> BoardParams
levelParams (LevelId level) =
    case level of
        1 ->
            { size = 20
            , blockDims = { height = 1, width = 3 }
            , baseNumPaths = 3
            , baseNumPoints = 3
            , sourceCoord = { x = 10, y = 1 }
            }

        2 ->
            { size = 28
            , blockDims = { height = 3, width = 1 }
            , baseNumPaths = 4
            , baseNumPoints = 3
            , sourceCoord = { x = 14, y = 1 }
            }

        3 ->
            { size = 32
            , blockDims = { height = 1, width = 5 }
            , baseNumPaths = 5
            , baseNumPoints = 4
            , sourceCoord = { x = 1, y = 1 }
            }

        4 ->
            { size = 36
            , blockDims = { height = 5, width = 3 }
            , baseNumPaths = 6
            , baseNumPoints = 4
            , sourceCoord = { x = 18, y = 1 }
            }

        5 ->
            { size = 36
            , blockDims = { height = 1, width = 5 }
            , baseNumPaths = 7
            , baseNumPoints = 5
            , sourceCoord = { x = 18, y = 17 }
            }

        6 ->
            { size = 36
            , blockDims = { height = 5, width = 1 }
            , baseNumPaths = 7
            , baseNumPoints = 5
            , sourceCoord = { x = 20, y = 1 }
            }

        7 ->
            { size = 40
            , blockDims = { height = 1, width = 7 }
            , baseNumPaths = 8
            , baseNumPoints = 4
            , sourceCoord = { x = 20, y = 1 }
            }

        8 ->
            { size = 40
            , blockDims = { height = 7, width = 1 }
            , baseNumPaths = 8
            , baseNumPoints = 4
            , sourceCoord = { x = 20, y = 1 }
            }

        9 ->
            { size = 42
            , blockDims = { height = 9, width = 3 }
            , baseNumPaths = 9
            , baseNumPoints = 4
            , sourceCoord = { x = 20, y = 1 }
            }

        10 ->
            { size = 44
            , blockDims = { height = 1, width = 9 }
            , baseNumPaths = 9
            , baseNumPoints = 5
            , sourceCoord = { x = 24, y = 23 }
            }

        -- Default instead of Nothing because I am too lazy to unwrap a Maybe
        _ ->
            { size = 20
            , blockDims = { height = 2, width = 2 }
            , baseNumPaths = 3
            , baseNumPoints = 3
            , sourceCoord = { x = 10, y = 1 }
            }
