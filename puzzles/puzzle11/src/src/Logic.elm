module Logic exposing (collides, interleave, lineIntersectBlock, middle, modifyCoord, randomBoard, randomPath, randomPoints, randomSolution, solutionPath)

import List
import List.Extra exposing (scanl, scanl1)
import Random exposing (Generator, Seed)
import Random.Extra exposing (traverse)
import Tuple
import Types exposing (..)


middle : Size -> Int -> List Coord
middle size numpoints =
    let
        minpoint =
            size // 2 - numpoints // 2

        maxpoint =
            minpoint + numpoints - 1
    in
    List.range minpoint maxpoint
        |> List.map (\x -> Coord x (size - 1))


randomBoard : BoardParams -> Generator ( Board, Solution )
randomBoard ({ size, blockDims, baseNumPaths, baseNumPoints, sourceCoord } as params) =
    Random.int (baseNumPaths - 1) (baseNumPaths + 1)
        |> Random.andThen (\n -> Random.constant <| middle size n)
        |> Random.andThen (traverse (\end -> randomPath { params | size = size - 3 } end))
        |> Random.andThen (randomSolution (size - 2) blockDims)


randomSolution : Size -> Dims -> Board -> Generator ( Board, Solution )
randomSolution size blockDims board =
    Random.pair (Random.int 1 size) (Random.int 1 size)
        |> Random.map (\( x, y ) -> Block (Coord x y) blockDims)
        |> Random.map (\block -> solutionPath block board)
        |> Random.map (\solution -> ( board, solution ))


solutionPath : Block -> Board -> Solution
solutionPath block board =
    List.map (collides block) board


collides : Block -> Path -> Bool
collides block path =
    List.drop 1 path
        |> List.map2 Tuple.pair path
        |> List.map (lineIntersectBlock block)
        |> List.member True


lineIntersectBlock : Block -> ( Coord, Coord ) -> Bool
lineIntersectBlock block ( c1, c2 ) =
    let
        ( blockxmin, blockxmax ) =
            ( block.coord.x - block.dims.width // 2
            , block.coord.x + block.dims.width // 2
            )

        ( blockymin, blockymax ) =
            ( block.coord.y - block.dims.height // 2
            , block.coord.y + block.dims.height // 2
            )

        ( linexmin, linexmax ) =
            ( min c1.x c2.x, max c1.x c2.x )

        ( lineymin, lineymax ) =
            ( min c1.y c2.y, max c1.y c2.y )

        check1 =
            (blockxmin <= linexmin)
                && (linexmin <= blockxmax)
                && (blockymax >= lineymin)
                && (blockymin <= lineymax)

        check2 =
            (blockymin <= lineymin)
                && (lineymin <= blockymax)
                && (blockxmax >= linexmin)
                && (blockxmin <= linexmax)
    in
    if check1 || check2 then
        True

    else
        False


randomPath : BoardParams -> Coord -> Generator Path
randomPath params end =
    Random.int (params.baseNumPoints - 1) (params.baseNumPoints + 1)
        |> Random.map ((*) 2)
        |> Random.andThen (randomPoints params.size end)
        |> Random.map (interleave params.sourceCoord)


randomPoints : Size -> Coord -> Int -> Generator (List Int)
randomPoints size end numPoints =
    Random.int 1 size
        |> Random.list numPoints
        |> Random.map (\l -> l ++ [ end.x, end.y ])


modifyCoord : ( Int, CoordType ) -> Coord -> Coord
modifyCoord ( value, coordType ) coord =
    case coordType of
        X ->
            { coord | x = value }

        Y ->
            { coord | y = value }


interleave : Coord -> List Int -> List Coord
interleave coord intList =
    let
        zipped =
            List.length intList
                |> (\s -> s // 2 + 1)
                |> (\s -> List.repeat s [ X, Y ])
                |> List.concat
                |> List.map2 Tuple.pair intList
    in
    scanl modifyCoord coord zipped
