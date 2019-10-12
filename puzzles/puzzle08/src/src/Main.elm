port module Main exposing (main)

import Browser
import Browser.Events exposing (onAnimationFrameDelta, onKeyDown)
import Canvas exposing (Renderable)
import Color
import Html exposing (Html, a, br, button, div, p, span, text)
import Html.Attributes exposing (attribute, class, href, id, style, target)
import Html.Events exposing (onClick)
import Html.Lazy
import Json.Decode as Decode
import List.Extra
import Random exposing (Seed)
import Random.List
import Set exposing (Set)
import Task
import Time exposing (Posix)
import Types exposing (..)



-- DATA


type alias TarsalData =
    List (List Int)


distalPhalanx =
    [ [ 1 ] ]


hallux =
    [ [ 0, 1 ]
    , [ 1, 1 ]
    , [ 1, 1 ]
    ]


middlePhalanx =
    [ [ 1, 1 ]
    , [ 1, 1 ]
    ]


proximalPhalanx =
    [ [ 1, 1 ]
    , [ 1, 1 ]
    , [ 1, 1 ]
    , [ 1, 1 ]
    ]


metatarsal =
    [ [ 1, 1 ]
    , [ 1, 1 ]
    , [ 1, 1 ]
    , [ 1, 1 ]
    , [ 1, 1 ]
    , [ 1, 1 ]
    , [ 1, 1 ]
    ]


cuneiform =
    [ [ 1, 1, 1 ]
    , [ 1, 1, 1 ]
    , [ 1, 1, 1 ]
    ]


navicular =
    [ [ 1, 1, 1, 1, 1, 1, 1, 1, 1 ]
    , [ 1, 1, 1, 1, 1, 1, 1, 1, 1 ]
    , [ 1, 1, 1, 1, 1, 1, 1, 1, 1 ]
    ]


cuboid =
    [ [ 0, 0, 1, 1, 1 ]
    , [ 0, 0, 1, 1, 1 ]
    , [ 1, 1, 1, 1, 1 ]
    , [ 1, 1, 1, 1, 1 ]
    , [ 1, 1, 1, 1, 1 ]
    , [ 1, 1, 1, 1, 1 ]
    ]


talus =
    [ [ 0, 0, 1, 1, 1, 1, 1, 1, 1, 1 ]
    , [ 0, 0, 1, 1, 1, 1, 1, 1, 1, 1 ]
    , [ 0, 0, 1, 2, 1, 2, 2, 2, 2, 1 ]
    , [ 0, 0, 1, 2, 1, 2, 1, 1, 2, 1 ]
    , [ 0, 0, 1, 2, 1, 2, 1, 1, 2, 1 ]
    , [ 2, 2, 1, 2, 1, 2, 2, 2, 2, 1 ]
    , [ 1, 1, 1, 2, 1, 2, 1, 1, 2, 1 ]
    , [ 1, 1, 1, 2, 1, 2, 1, 1, 2, 1 ]
    , [ 2, 2, 1, 2, 1, 2, 2, 2, 2, 1 ]
    , [ 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 ]
    ]


calcaneus =
    [ [ 1, 1, 1, 1, 1, 1, 0, 0, 0 ]
    , [ 1, 1, 1, 1, 1, 1, 0, 0, 0 ]
    , [ 1, 1, 2, 2, 2, 2, 0, 0, 0 ]
    , [ 1, 1, 2, 1, 1, 1, 0, 0, 0 ]
    , [ 1, 1, 2, 1, 1, 1, 0, 0, 0 ]
    , [ 1, 1, 2, 2, 0, 0, 0, 0, 0 ]
    , [ 1, 1, 2, 1, 0, 0, 0, 0, 0 ]
    , [ 1, 1, 2, 1, 0, 0, 0, 0, 0 ]
    , [ 1, 1, 2, 2, 0, 0, 0, 0, 0 ]
    , [ 1, 1, 1, 1, 0, 0, 0, 0, 0 ]
    , [ 1, 1, 1, 1, 1, 1, 1, 1, 0 ]
    , [ 1, 1, 1, 1, 1, 1, 1, 1, 0 ]
    , [ 1, 1, 1, 1, 1, 1, 1, 1, 0 ]
    , [ 1, 1, 1, 1, 1, 1, 1, 1, 0 ]
    , [ 1, 1, 1, 1, 1, 1, 1, 1, 0 ]
    , [ 1, 1, 1, 1, 1, 1, 1, 1, 0 ]
    , [ 1, 1, 1, 1, 1, 1, 1, 1, 0 ]
    , [ 1, 1, 1, 1, 1, 1, 1, 1, 0 ]
    , [ 1, 1, 1, 1, 1, 1, 1, 1, 0 ]
    ]



-- SOLUTION GRID


solutionRelativePositions =
    [ ( Calcaneus, 7, 0 )
    , ( Talus, 2, 10 )
    , ( Navicular, 2, 20 )
    , ( Cuboid, 10, 19 )
    , ( Cuneiform, 2, 23 )
    , ( Cuneiform, 5, 23 )
    , ( Cuneiform, 8, 23 )
    , ( Metatarsal, 1, 25 )
    , ( Metatarsal, 4, 25 )
    , ( Metatarsal, 7, 25 )
    , ( Metatarsal, 10, 25 )
    , ( Metatarsal, 13, 23 )
    , ( ProximalPhalanx, 2, 33 )
    , ( ProximalPhalanx, 5, 33 )
    , ( ProximalPhalanx, 8, 33 )
    , ( ProximalPhalanx, 11, 33 )
    , ( ProximalPhalanx, 14, 31 )
    , ( Hallux, 1, 36 )
    , ( MiddlePhalanx, 5, 37 )
    , ( MiddlePhalanx, 8, 37 )
    , ( MiddlePhalanx, 11, 37 )
    , ( MiddlePhalanx, 14, 35 )
    , ( DistalPhalanx, 5, 39 )
    , ( DistalPhalanx, 8, 39 )
    , ( DistalPhalanx, 11, 39 )
    , ( DistalPhalanx, 14, 37 )
    ]


solutionGrid =
    solutionRelativePositions
        |> List.map (\( t, x, y ) -> shift (tarsalToGrid t |> rotateGrid |> rotateGrid) ( x, y + 1 ))
        |> List.concat
        |> (\g -> shift g ( bufferWidth - 1, 0 ))


solutionSet =
    solutionGrid |> makeGridComparable |> Set.fromList


requiredInert : List ( Int, Int )
requiredInert =
    [ ( 2, 40 )
    , ( 5, 40 )
    , ( 8, 40 )
    , ( 11, 40 )
    , ( 13, 39 )
    , ( 13, 40 )
    , ( 14, 38 )
    , ( 14, 39 )
    , ( 14, 40 )
    ]



-- CONSTANTS


gridWidth =
    35


gridHeight =
    40


bufferWidth =
    20


scaleFactor =
    10


stepsPerSecond =
    2


numTarsals =
    10


millisPerStep =
    1000 / stepsPerSecond


startPoint : ( Int, Int )
startPoint =
    ( gridWidth // 2, 0 )


solutionTarsalList : List Tarsal
solutionTarsalList =
    solutionRelativePositions
        |> List.map (\( t, _, _ ) -> t)


coloursPerTarsal =
    3



-- MSG


type Msg
    = ClickedStart
    | SteppedFrameDelta Float
    | MovedLeft
    | MovedRight
    | MovedDown
    | Rotated
    | Dropped
    | GotTime Posix
    | NoOp



-- MODEL (TOTAL)


type alias Model =
    Screen



-- INITIALS


initialModel : Model
initialModel =
    Start initialSeed


initialSeed : Random.Seed
initialSeed =
    Random.initialSeed 0


initialGrid : Grid
initialGrid =
    {- Inert tiles required for the little toes -}
    requiredInert
        |> List.map (\( x, y ) -> Cell (x + bufferWidth) y 1)


initialBoard : Seed -> Board
initialBoard randomSeed =
    let
        ( initialTarsal, tarsalPool, newSeed ) =
            newNextTarsalList [] randomSeed

        ( nextTarsal, remainingTarsals, newerSeed ) =
            newNextTarsalList tarsalPool newSeed

        activeGrid =
            tarsalToGrid initialTarsal |> moveGridToStartPoint

        ghostGrid =
            makeGhost activeGrid initialGrid
    in
    { grid = initialGrid
    , boardState = Falling activeGrid ghostGrid
    , nextTarsal = nextTarsal
    , remainingTarsals = remainingTarsals
    , timeLeft = 120000
    , points = 0
    , muted = False
    , randomSeed = newerSeed
    }



-- PORTS


port playBgm : Bool -> Cmd msg


port playFx : String -> Cmd msg



-- UPDATE (TOTAL)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case model of
        Start seed ->
            updateStart msg seed

        Playing accumulator board ->
            updatePlaying msg accumulator board

        Failure board ->
            updateFailure msg board

        Success board ->
            updateSuccess msg board



-- UPDATE (SCREEN-SPECIFIC)


updateStart : Msg -> Seed -> ( Model, Cmd Msg )
updateStart msg seed =
    case msg of
        ClickedStart ->
            ( Playing 0 (initialBoard seed)
            , playBgm True
            )

        GotTime time ->
            ( Start <| Random.initialSeed <| Time.posixToMillis time
            , Cmd.none
            )

        _ ->
            ( Start seed, Cmd.none )


updateFailure : Msg -> Board -> ( Model, Cmd Msg )
updateFailure msg board =
    case msg of
        ClickedStart ->
            ( Start board.randomSeed, playBgm False )

        _ ->
            ( Failure board, Cmd.none )


updateSuccess : Msg -> Board -> ( Model, Cmd Msg )
updateSuccess msg board =
    case msg of
        ClickedStart ->
            ( Start board.randomSeed, playBgm False )

        _ ->
            ( Success board, Cmd.none )


updatePlaying : Msg -> Float -> Board -> ( Model, Cmd Msg )
updatePlaying msg accumulator board =
    case msg of
        SteppedFrameDelta timeDelta ->
            let
                newAccumulator =
                    accumulator + timeDelta
            in
            if newAccumulator > millisPerStep then
                let
                    overflow =
                        bufferOverflow board.grid

                    timeLeft =
                        board.timeLeft - millisPerStep

                    updatedBoard =
                        { board | timeLeft = timeLeft }
                in
                if overflow || timeLeft <= 0 then
                    ( Failure board, Cmd.batch [ playBgm False, playFx "failure" ] )

                else
                    let
                        isFullSolution =
                            checkFullSolution board.grid
                    in
                    if isFullSolution then
                        ( Success board, Cmd.batch [ playBgm False, playFx "success" ] )

                    else
                        let
                            ( newBoard, cmd ) =
                                stepBoard updatedBoard
                        in
                        ( Playing 0 newBoard, cmd )

            else
                ( Playing newAccumulator board, Cmd.none )

        MovedLeft ->
            ( Playing accumulator <| updateMove board Left, Cmd.none )

        MovedRight ->
            ( Playing accumulator <| updateMove board Right, Cmd.none )

        MovedDown ->
            ( Playing accumulator <| updateMove board Down, Cmd.none )

        Rotated ->
            ( Playing accumulator <| updateRotate board, Cmd.none )

        Dropped ->
            {- Have to add the overflow check here too since the accumulator resets... -}
            case board.boardState of
                Falling _ _ ->
                    let
                        overflow =
                            bufferOverflow board.grid
                    in
                    if overflow then
                        ( Failure board, Cmd.batch [ playBgm False, playFx "failure" ] )

                    else
                        let
                            ( newBoard, cmd ) =
                                updateDrop board
                        in
                        ( Playing 0 newBoard, cmd )

                _ ->
                    ( Playing accumulator board, Cmd.none )

        ClickedStart ->
            ( Start board.randomSeed, playBgm False )

        _ ->
            ( Playing accumulator board, Cmd.none )



-- UPDATE (HELPERS)


makeGhost : Grid -> Grid -> Grid
makeGhost activeGrid boardGrid =
    let
        ys =
            List.map (\c -> c.y) activeGrid

        minY =
            List.minimum ys |> Maybe.withDefault 0

        maxShift =
            gridHeight - minY + 1
    in
    testGhost activeGrid boardGrid 1 maxShift


checkFullSolution : Grid -> Bool
checkFullSolution grid =
    let
        gridSet =
            makeGridComparable grid |> Set.fromList

        intersection =
            Set.intersect gridSet solutionSet
    in
    Set.size intersection == Set.size solutionSet


testGhost activeGrid boardGrid yTest maxShift =
    let
        shifted =
            shift activeGrid ( 0, yTest )

        collision =
            collidesQuick shifted boardGrid
    in
    if yTest > maxShift then
        activeGrid

    else if collision then
        shift activeGrid ( 0, yTest - 1 )

    else
        testGhost activeGrid boardGrid (yTest + 1) maxShift


newNextTarsalList : List Tarsal -> Seed -> ( Tarsal, List Tarsal, Seed )
newNextTarsalList lastNextTarsalList seed =
    let
        ( nextTarsalList, newSeed ) =
            Random.step (Random.List.choose lastNextTarsalList) seed

        nextTarsalListWithDefault =
            case nextTarsalList of
                ( Just tarsal, [] ) ->
                    ( tarsal, solutionTarsalList, newSeed )

                ( Just tarsal, list ) ->
                    ( tarsal, list, newSeed )

                {- This shouldn't occur except on init. -}
                ( Nothing, _ ) ->
                    let
                        ( start, newerSeed ) =
                            Random.step (Random.List.choose solutionTarsalList) seed
                    in
                    case start of
                        ( Just startTarsal, newList ) ->
                            ( startTarsal, newList, newerSeed )

                        ( Nothing, _ ) ->
                            ( DistalPhalanx, solutionTarsalList, newerSeed )
    in
    nextTarsalListWithDefault


moveGridToStartPoint : Grid -> Grid
moveGridToStartPoint grid =
    let
        ( gridXs, gridYs ) =
            gridToXYLists grid

        gridMinX =
            List.minimum gridXs |> Maybe.withDefault 0

        gridMaxX =
            List.maximum gridXs |> Maybe.withDefault 0

        gridHalfX =
            (gridMaxX - gridMinX) // 2 + gridMinX

        gridMaxY =
            List.maximum gridYs |> Maybe.withDefault 0

        ( startX, startY ) =
            startPoint

        moveX cell =
            cell.x - gridHalfX + startX

        moveY cell =
            cell.y - gridMaxY + startY

        moveCell cell =
            { cell | x = moveX cell, y = moveY cell }
    in
    List.map moveCell grid


stepBoard : Board -> ( Board, Cmd Msg )
stepBoard board =
    case board.boardState of
        Falling activeGrid ghostGrid ->
            let
                proposedActive =
                    move activeGrid Down

                ( newProposed, collision ) =
                    ifCollidesThenPrevent activeGrid proposedActive board.grid
            in
            if collision then
                let
                    newGrid =
                        combineGrid newProposed board.grid

                    cleared =
                        clearRows newGrid

                    numCleared =
                        List.length cleared

                    clearedRows =
                        numCleared > 0

                    comparison =
                        compareWithSolution newProposed
                in
                case ( clearedRows, comparison ) of
                    ( True, NotIntersecting ) ->
                        ( { board
                            | grid = newGrid
                            , boardState = Highlighting (Cleared cleared)
                            , points = board.points + (50 * numCleared)
                            , timeLeft = board.timeLeft + (10000 * toFloat numCleared)
                          }
                        , playFx "rowClear"
                        )

                    ( _, CorrectIntersect ) ->
                        ( { board
                            | grid = newGrid
                            , boardState = Highlighting (Correct newProposed)
                            , timeLeft = board.timeLeft + 30000
                          }
                        , playFx "correct"
                        )

                    ( _, IncorrectIntersect ) ->
                        ( { board
                            | grid = board.grid
                            , boardState = Highlighting (Incorrect newProposed)
                            , timeLeft = board.timeLeft / 2
                            , points = board.points // 2
                          }
                        , playFx "incorrect"
                        )

                    ( False, NotIntersecting ) ->
                        ( newTarsalOnBoard { board | grid = newGrid }, playFx "drop" )

            else
                let
                    newGhost =
                        makeGhost newProposed board.grid
                in
                ( { board | boardState = Falling newProposed newGhost }, Cmd.none )

        Highlighting (Cleared _) ->
            let
                newGrid =
                    updateGridClearedRows board.grid

                newBoard =
                    { board | grid = newGrid }
            in
            ( newTarsalOnBoard newBoard, Cmd.none )

        Highlighting (Correct _) ->
            ( newTarsalOnBoard board, Cmd.none )

        Highlighting (Incorrect _) ->
            ( newTarsalOnBoard board, Cmd.none )


{-| Returns a list of rows (by index) which are cleared
-}
clearRows : Grid -> List Int
clearRows boardGrid =
    List.range 0 gridHeight
        |> List.filter (\row -> List.length (filterBufferByRow row boardGrid) == bufferWidth)


filterBufferByRow : Int -> Grid -> Grid
filterBufferByRow row boardGrid =
    List.filter (\c -> c.y == row && c.contents >= coloursPerTarsal && c.x < bufferWidth) boardGrid


clearRowFolder : Grid -> Grid -> Grid
clearRowFolder currentRow prevRow =
    if List.length currentRow == bufferWidth then
        List.map (\c -> { c | y = c.y + 1 }) prevRow

    else
        prevRow ++ currentRow


nonBufferBoard : Grid -> Grid
nonBufferBoard boardGrid =
    List.filter (\c -> c.x >= bufferWidth && c.contents > coloursPerTarsal) boardGrid


makeGridComparable : Grid -> List ( Int, Int, Int )
makeGridComparable grid =
    List.map (\c -> ( c.x, c.y, c.contents )) grid


compareWithSolution : Grid -> SolutionComparison
compareWithSolution activePieceGrid =
    let
        nonBuffer =
            nonBufferBoard activePieceGrid

        nonBufferSet =
            nonBuffer |> makeGridComparable |> Set.fromList

        difference =
            Set.diff nonBufferSet solutionSet
    in
    if List.length nonBuffer == 0 then
        NotIntersecting

    else if Set.size difference > 0 then
        IncorrectIntersect

    else
        CorrectIntersect


separateBufferByRow : Grid -> List Grid
separateBufferByRow boardGrid =
    List.range 0 gridHeight |> List.map (\row -> filterBufferByRow row boardGrid)


updateGridClearedRows : Grid -> Grid
updateGridClearedRows boardGrid =
    let
        nonBuffer =
            nonBufferBoard boardGrid

        inert =
            List.filter (\c -> c.contents == 1) boardGrid

        bufferSeparated =
            separateBufferByRow boardGrid
    in
    List.foldl clearRowFolder [] bufferSeparated ++ nonBuffer ++ inert


bufferOverflow : Grid -> Bool
bufferOverflow boardGrid =
    List.map (\c -> c.y) boardGrid
        |> List.minimum
        |> Maybe.withDefault 0
        |> (>) 1


newTarsalOnBoard : Board -> Board
newTarsalOnBoard board =
    let
        newActive =
            tarsalToGrid board.nextTarsal |> moveGridToStartPoint

        newGhost =
            makeGhost newActive board.grid

        {- TODO Check if row completed or in solution space -}
        newState =
            Falling newActive newGhost

        ( nextTarsal, remainingTarsals, newSeed ) =
            newNextTarsalList board.remainingTarsals board.randomSeed
    in
    { board
        | boardState = newState
        , nextTarsal = nextTarsal
        , remainingTarsals = remainingTarsals
        , randomSeed = newSeed
    }


combineGrid : Grid -> Grid -> Grid
combineGrid activeGrid baseGrid =
    baseGrid ++ activeGrid


updateRotate : Board -> Board
updateRotate board =
    case board.boardState of
        Falling activeGrid ghostGrid ->
            let
                proposedActive =
                    rotateGrid activeGrid

                newProposed =
                    ifCollidesThenTryShift activeGrid proposedActive board.grid

                newGhost =
                    makeGhost newProposed board.grid
            in
            { board | boardState = Falling newProposed newGhost }

        _ ->
            board


updateDrop : Board -> ( Board, Cmd Msg )
updateDrop board =
    case board.boardState of
        Falling activeGrid ghostGrid ->
            let
                droppedBoard =
                    { board | boardState = Falling ghostGrid ghostGrid }
            in
            stepBoard droppedBoard

        _ ->
            ( board, Cmd.none )


{-| Needs to be debugged - noticed tha calcaneus doesn't rotate sometimes when it should be able to? Or maybe not?
-}
rotateGrid : Grid -> Grid
rotateGrid grid =
    let
        ( xs, ys ) =
            gridToXYLists grid

        xMax =
            xs |> List.maximum |> Maybe.withDefault 0

        xMin =
            xs |> List.minimum |> Maybe.withDefault 0

        yMax =
            ys |> List.maximum |> Maybe.withDefault 0

        yMin =
            ys |> List.minimum |> Maybe.withDefault 0

        xCenter =
            toFloat xMin + toFloat (xMax - xMin) / 2

        yCenter =
            toFloat yMin + toFloat (yMax - yMin) / 2
    in
    List.map
        (\c ->
            { c
                | x = round (0 - (toFloat c.y - yCenter) + xCenter)
                , y = round (toFloat c.x - xCenter + yCenter)
            }
        )
        grid


updateMove : Board -> Movement -> Board
updateMove board movement =
    case board.boardState of
        Falling activeGrid ghostGrid ->
            moveSafely board activeGrid movement

        _ ->
            board


moveSafely : Board -> Grid -> Movement -> Board
moveSafely board activeGrid movement =
    let
        proposedActive =
            move activeGrid movement

        ( newProposed, _ ) =
            ifCollidesThenPrevent activeGrid proposedActive board.grid

        newGhost =
            makeGhost newProposed board.grid
    in
    { board | boardState = Falling newProposed newGhost }


move : Grid -> Movement -> Grid
move grid movement =
    let
        mover cell =
            case movement of
                Left ->
                    { cell | x = cell.x - 1 }

                Right ->
                    { cell | x = cell.x + 1 }

                Down ->
                    { cell | y = cell.y + 1 }
    in
    List.map mover grid


shift : Grid -> ( Int, Int ) -> Grid
shift grid ( x, y ) =
    List.map (\c -> { c | x = c.x + x, y = c.y + y }) grid


ifCollidesThenTryShift : Grid -> Grid -> Grid -> Grid
ifCollidesThenTryShift priorGrid proposedGrid baseGrid =
    let
        ( collision, shiftX, shiftY ) =
            collides proposedGrid baseGrid
    in
    if collision then
        let
            {- Try shifting, then if fail, don't change -}
            newProposed =
                shift proposedGrid ( 0 - Maybe.withDefault 0 shiftX, 0 - Maybe.withDefault 0 shiftY )

            ( newCollision, afterX, afterY ) =
                collides newProposed baseGrid
        in
        if newCollision then
            priorGrid

        else
            newProposed

    else
        proposedGrid


ifCollidesThenPrevent : Grid -> Grid -> Grid -> ( Grid, Bool )
ifCollidesThenPrevent priorGrid proposedGrid baseGrid =
    let
        collision =
            collidesQuick proposedGrid baseGrid
    in
    if collision then
        ( priorGrid, True )

    else
        ( proposedGrid, False )


collidesQuick : Grid -> Grid -> Bool
collidesQuick proposedGrid baseGrid =
    let
        proposedList =
            gridToCoords proposedGrid

        baseList =
            gridToCoords baseGrid

        proposedSet =
            Set.fromList proposedList

        baseSet =
            Set.fromList baseList

        intersection =
            Set.intersect proposedSet baseSet

        outOfBoundsProposed =
            outOfBoundsSet proposedList

        allCollisions =
            Set.union intersection outOfBoundsProposed
    in
    Set.size allCollisions > 0



{- Bool, overshootX, overshootY -}


collides : Grid -> Grid -> ( Bool, Maybe Int, Maybe Int )
collides proposedGrid baseGrid =
    let
        proposedList =
            gridToCoords proposedGrid

        baseList =
            gridToCoords baseGrid

        ( proposedXs, proposedYs ) =
            gridToXYLists proposedGrid

        proposedSet =
            Set.fromList proposedList

        baseSet =
            Set.fromList baseList

        intersection =
            Set.intersect proposedSet baseSet

        outOfBoundsProposed =
            outOfBoundsSet proposedList

        allCollisions =
            Set.union intersection outOfBoundsProposed

        collidesTruth =
            Set.size allCollisions > 0

        noCollisions =
            Set.diff proposedSet allCollisions

        getXs =
            List.map (\( x, _ ) -> x)

        getYs =
            List.map (\( _, y ) -> y)

        okayList =
            Set.toList noCollisions

        okayXs =
            getXs okayList

        okayXMin =
            okayXs |> List.minimum |> Maybe.withDefault 0

        okayXMax =
            okayXs |> List.maximum |> Maybe.withDefault 0

        okayYMax =
            getYs okayList |> List.maximum |> Maybe.withDefault 0

        collisionList =
            Set.toList allCollisions

        collisionXs =
            getXs collisionList

        collisionXMin =
            collisionXs |> List.minimum |> Maybe.withDefault 0

        collisionXMax =
            collisionXs |> List.maximum |> Maybe.withDefault 0

        collisionYMax =
            getYs collisionList |> List.maximum |> Maybe.withDefault 0

        shiftX =
            case collidesTruth of
                True ->
                    let
                        minOvershoot =
                            collisionXMin - okayXMin

                        maxOvershoot =
                            collisionXMax - okayXMax
                    in
                    if (minOvershoot < 0) && (maxOvershoot > 0) then
                        Nothing

                    else if minOvershoot < 0 then
                        Just minOvershoot

                    else if maxOvershoot > 0 then
                        Just maxOvershoot

                    else
                        Nothing

                False ->
                    Nothing

        shiftY =
            case collidesTruth of
                True ->
                    let
                        maxOvershoot =
                            collisionYMax - okayYMax
                    in
                    if maxOvershoot > 0 then
                        Just maxOvershoot

                    else
                        Nothing

                False ->
                    Nothing
    in
    ( collidesTruth, shiftX, shiftY )


outOfBounds : ( Int, Int ) -> Bool
outOfBounds ( x, y ) =
    if (x < 0) || (x > gridWidth) || (y > gridHeight) then
        True

    else
        False



{- Second and third value are overshoot X and Y -}


outOfBoundsSet : List ( Int, Int ) -> Set ( Int, Int )
outOfBoundsSet coords =
    coords
        |> List.filter outOfBounds
        |> Set.fromList



-- CONVERSIONS


cellToCoords : Cell -> ( Int, Int )
cellToCoords cell =
    ( cell.x, cell.y )


gridToCoords : Grid -> List ( Int, Int )
gridToCoords grid =
    List.map cellToCoords grid


gridToXYLists : Grid -> ( List Int, List Int )
gridToXYLists grid =
    let
        xs =
            List.map (\c -> c.x) grid

        ys =
            List.map (\c -> c.y) grid
    in
    ( xs, ys )


tarsalToDataOrder : Tarsal -> ( TarsalData, Contents )
tarsalToDataOrder tarsal =
    case tarsal of
        {- Zero is left just in case for empty squares or inert squares -}
        DistalPhalanx ->
            ( distalPhalanx, 1 )

        Hallux ->
            ( hallux, 2 )

        MiddlePhalanx ->
            ( middlePhalanx, 3 )

        ProximalPhalanx ->
            ( proximalPhalanx, 4 )

        Metatarsal ->
            ( metatarsal, 5 )

        Cuneiform ->
            ( cuneiform, 6 )

        Navicular ->
            ( navicular, 7 )

        Cuboid ->
            ( cuboid, 8 )

        Talus ->
            ( talus, 9 )

        Calcaneus ->
            ( calcaneus, 10 )


tarsalToGrid : Tarsal -> Grid
tarsalToGrid tarsal =
    {- Each tarsal is allowed a certain number of "colours." -}
    let
        ( data, order ) =
            tarsalToDataOrder tarsal

        numRows =
            List.length data

        {- Assume here that each list element is of the same length. -}
        numColumns =
            List.head data |> Maybe.withDefault [] |> List.length

        mapOuter : List Int -> Int -> List Cell
        mapOuter subList yValue =
            List.map2 (\x contents -> mapInner x yValue contents) (List.range 0 (numColumns - 1)) subList

        mapInner : Int -> Int -> Int -> Cell
        mapInner xValue yValue contents =
            Cell xValue yValue (contentsScale contents)

        contentsScale contents =
            if contents > 0 then
                (order * coloursPerTarsal) + contents

            else
                0
    in
    List.map2 mapOuter data (List.range 0 (numRows - 1))
        |> List.concat
        |> List.filter (\c -> c.contents /= 0)


keyToMsg : String -> Msg
keyToMsg keyString =
    case keyString of
        "ArrowUp" ->
            Rotated

        "ArrowDown" ->
            MovedDown

        "ArrowLeft" ->
            MovedLeft

        "ArrowRight" ->
            MovedRight

        " " ->
            Dropped

        _ ->
            NoOp


tarsalToString : Tarsal -> String
tarsalToString tarsal =
    case tarsal of
        DistalPhalanx ->
            "DISTAL PHALANX"

        Hallux ->
            "DISTAL PHALANX (HALLUX)"

        MiddlePhalanx ->
            "MIDDLE PHALANX"

        ProximalPhalanx ->
            "PROXIMAL PHALANX"

        Metatarsal ->
            "METATARSAL"

        Cuneiform ->
            "CUNEIFORM"

        Cuboid ->
            "CUBOID"

        Navicular ->
            "NAVICULAR"

        Talus ->
            "TALUS"

        Calcaneus ->
            "CALCANEUS"



-- SUBSCRIPTIONS (TOTAL)


subscriptions : Model -> Sub Msg
subscriptions model =
    case model of
        Playing _ _ ->
            Sub.batch
                [ onAnimationFrameDelta SteppedFrameDelta
                , onKeyDown (Decode.map keyToMsg (Decode.field "key" Decode.string))
                ]

        _ ->
            Sub.none



-- VIEW (TOTAL)


view : Model -> Html Msg
view model =
    case model of
        Start _ ->
            viewStart

        Playing _ board ->
            viewBoard board

        Failure board ->
            viewFailure board

        Success board ->
            viewSuccess board



-- VIEW (BY SCREEN)


viewStart : Html Msg
viewStart =
    viewContainer
        [ div [ class "flex flex-col items-center align-center justify-center text-center text-lg md:p-8" ]
            [ span [ class "text-3xl font-bold text-grey-darker" ]
                [ text
                    "WELCOME TO TARSAL TUMBLE"
                ]
            , br [] []
            , div [ class "text-left" ]
                [ p [ class "my-2" ] [ text "On the left side of the screen is a normal falling block game, but with tarsals instead of the shapes you're use to." ]
                , p [ class "my-2" ] [ text "On the right side of the screen is an area where you'll need to build the left foot out of tarsals." ]
                , p [ class "my-2" ] [ text "Watch the time - you don't have much! Clearing rows and getting tarsals right gets you extra time; getting tarsals wrong halves it." ]
                , p [ class "my-2" ] [ text "You'll also earn and lose points - the more points you have when you finish, the clearer the puzzle answer will be!" ]
                , p [ class "mt-4 text-center" ] [ a [ href "https://cigmah.github.io/cgmnt/#/puzzles/8", class "no-underline text-blue" ] [ text "View the full puzzle details here." ] ]
                ]
            , br [] []
            , startButton "PLAY"
            ]
        ]


viewBoard : Board -> Html Msg
viewBoard board =
    viewContainer
        [ div [ class "flex w-full h-full" ]
            [ canvas board
            , div [ class "flex flex-col" ]
                [ infoBox "NEXT PIECE" (tarsalToString board.nextTarsal)
                , infoBox "TIME LEFT" (String.fromInt <| round <| board.timeLeft / 1000)
                , infoBox "POINTS" (String.fromInt board.points)
                , controls
                ]
            ]
        ]


viewFailure : Board -> Html Msg
viewFailure board =
    viewContainer
        [ div [ class "md:p-8" ]
            [ div [ class "text-3xl font-bold text-grey-darker mb-4 md:w-full" ] [ text "FAILURE" ]
            , div [ class "text-center mb-4 " ] [ text "You either ran out of time, or the board overflowed.", br [] [], text "Better luck next time!" ]
            , Canvas.toHtml
                ( (gridWidth + 1) * scaleFactor, (gridHeight + 1) * scaleFactor )
                [ class "border-grey-lighter border-4 rounded mb-4 w-2/3" ]
                (renderBg :: (renderGrid board.grid ++ renderNonSolution))
            , div [ class "w-full" ] [ startButton "START OVER" ]
            , fbshare
            ]
        ]


viewSuccess : Board -> Html Msg
viewSuccess board =
    viewContainer
        [ div [ class "md:px-8 md:py-2" ]
            [ div [ class "text-3xl font-bold text-grey-darker mb-4 md:w-full" ] [ text "SUCCESS!" ]
            , div [ class "text-center mb-4 " ]
                [ text "Congratulations - you scored "
                , span [ class "font-bold" ] [ text <| String.fromInt board.points ]
                , text " points! Here's the digit code...hidden!"
                , br [] []
                , text "Depending on how many points you earned, it's either very visible or just faintly visible :)"
                ]
            , Canvas.toHtml
                ( (gridWidth + 1) * scaleFactor, (gridHeight + 1) * scaleFactor )
                [ class "border-grey-lighter border-4 rounded mb-4 w-2/3" ]
                (renderBg :: (renderGridSuccess board.grid board.points ++ renderNonSolution))
            , div [ class "w-full" ] [ startButton "PLAY AGAIN" ]
            , fbshare
            ]
        ]


viewContainer : List (Html Msg) -> Html Msg
viewContainer contents =
    div [ class "bg-grey-lighter w-full" ]
        [ div [ class "w-full md:h-screen text-center flex justify-center items-center align-center" ]
            [ div [ class "bg-white p-8 flex flex-col rounded-lg justify-center align-center items-center" ] contents ]
        ]


infoBox : String -> String -> Html Msg
infoBox title contents =
    div [ class "flex flex-col mx-2 mb-4 rounded-lg" ]
        [ div [ class "text-center font-bold text-sm bg-grey-light text-grey-darker py-1 rounded-t" ] [ text title ]
        , div [ class "rounded-b bg-grey-lightest text-center py-3 px-2 w-32 font-bold text-sm text-grey-darker flex contents-center align-center items-center justify-center" ] [ text contents ]
        ]


fbshare =
    div
        [ class "fb-share-button"
        , attribute "data-href" "https://cgmnt-tarsal-tumble-player.netlify.com"
        , attribute "data-layout" "button"
        , attribute "data-size" "large"
        ]
        [ a
            [ target "_blank"
            , href "https://www.facebook.com/sharer/sharer.php?u=https%3A%2F%2Fcgmnt-tarsal-tumble-player.netlify.com%2F&amp;src=sdkpreparse"
            , class "fb-xfbml-parse-ignore no-underline text-white text-xs font-bold bg-blue-dark py-1 px-2 rounded"
            ]
            [ text "Share" ]
        ]


controls =
    div
        [ class "flex flex-col w-full mx-2 justify-center items-center" ]
        [ div [ class "flex" ]
            [ div [ class "w-8 h-8 bg-white" ] []
            , controlButton "R" Rotated
            , div [ class "w-8 h-8 bg-white" ] []
            ]
        , div [ class "flex" ]
            [ controlButton "<" MovedLeft
            , controlButton "v" MovedDown
            , controlButton ">" MovedRight
            ]
        , div [ class "h-2 bg-white" ] []
        , div [ class "text-center text-xs font-bold bg-grey-lighter text-grey-dark py-1 px-4 cursor-pointer rounded", onClick Dropped ]
            [ text "DROP", br [] [], text "[SPACE]" ]
        , div [ class "mt-6" ]
            [ button [ class "bg-grey-lighter text-grey-dark font-semibold text-xs text-center px-2 py-1 rounded", onClick ClickedStart ]
                [ text "RESTART" ]
            ]
        ]


controlButton contents action =
    div
        [ class "bg-grey-lighter text-center text-sm font-bold text-grey-dark py-1 px-1 w-8 h-8 cursor-pointer rounded"
        , onClick action
        ]
        [ text contents ]



-- VIEW (CANVAS)


canvas : Board -> Html Msg
canvas board =
    let
        baseBoard =
            renderGrid board.grid

        activeGrid =
            renderActive board.boardState
    in
    Canvas.toHtml
        {- +1 to dims because the render is a box that goes down and to the right 1 px -} ( (gridWidth + 1) * scaleFactor, (gridHeight + 1) * scaleFactor )
        [ class "w-full border-b-4 border-grey-light" ]
        (renderBg :: (baseBoard ++ activeGrid ++ renderNonSolution))


renderBg : Renderable
renderBg =
    Canvas.shapes
        [ Canvas.fill Color.white ]
        [ Canvas.rect ( 0, 0 ) ((gridWidth + 1) * scaleFactor) ((gridHeight + 1) * scaleFactor) ]


renderCell : Cell -> Color.Color -> Renderable
renderCell cell color =
    Canvas.shapes
        [ Canvas.fill color
        , Canvas.stroke color
        , Canvas.lineWidth 0.000001
        , Canvas.transform [ Canvas.scale scaleFactor scaleFactor ]
        ]
        [ Canvas.rect ( toFloat cell.x, toFloat cell.y ) 1 1 ]


renderNonSolutionCell ( x, y ) =
    Canvas.shapes
        [ Canvas.fill (Color.rgba 0.855 0.882 0.906 0.5)

        {- Canvas.stroke Color.grey
           , Canvas.lineWidth 0.1
           , Canvas.lineDash [ 0.1, 0.2 ]
        -}
        , Canvas.transform [ Canvas.scale scaleFactor scaleFactor ]
        ]
        [ Canvas.rect ( toFloat x, toFloat y ) 1 1 ]


renderSuccessCell points cell =
    case cell.contents of
        1 ->
            {- Inert cell -}
            renderCell cell (Color.rgb 0.855 0.882 0.906)

        x ->
            let
                alpha =
                    case x of
                        29 ->
                            0.8 - toFloat points / 500

                        32 ->
                            0.8 - toFloat points / 500

                        _ ->
                            1
            in
            renderCell cell (Color.hsla (toFloat (cell.contents - 3) / (coloursPerTarsal * numTarsals)) 0.78 0.82 alpha)


renderNormalCell cell =
    case cell.contents of
        1 ->
            {- Inert cell -}
            renderCell cell (Color.rgb 0.855 0.882 0.906)

        _ ->
            renderCell cell (Color.hsla (toFloat ((cell.contents - coloursPerTarsal) // coloursPerTarsal) / numTarsals) 0.78 0.82 1)


renderGhostCell cell =
    renderCell cell (Color.rgb 0.945 0.961 0.973)


nonSolution =
    let
        nonBufferXFuncs =
            List.map (\x y -> ( x, y )) (List.range bufferWidth gridWidth)

        -- dummy cell contents
        ys =
            List.range 0 gridHeight

        nonBuffer =
            List.map (\f -> List.map f ys) nonBufferXFuncs |> List.concat

        nonSolutionCoords =
            nonBuffer |> Set.fromList

        solutionCoords =
            List.map (\c -> ( c.x, c.y )) solutionGrid |> Set.fromList

        difference =
            Set.diff nonSolutionCoords solutionCoords
    in
    difference


renderNonSolution =
    List.map renderNonSolutionCell <| Set.toList nonSolution


renderGrid : Grid -> List Renderable
renderGrid grid =
    List.map renderNormalCell grid


renderGridSuccess : Grid -> Int -> List Renderable
renderGridSuccess grid points =
    List.map (renderSuccessCell points) grid


renderGhost : Grid -> List Renderable
renderGhost grid =
    List.map renderGhostCell grid


renderHighlightRow : Int -> Renderable
renderHighlightRow row =
    Canvas.shapes
        [ Canvas.fill (Color.hsla 1 1 1 0.8)
        , Canvas.transform [ Canvas.scale scaleFactor scaleFactor ]
        ]
        [ Canvas.rect ( 0, toFloat row ) bufferWidth 1 ]


renderHighlightCorrect : Grid -> List Renderable
renderHighlightCorrect grid =
    List.map (\c -> renderCell c (Color.hsl 0.33 0.58 0.67)) grid


renderHighlightIncorrect : Grid -> List Renderable
renderHighlightIncorrect grid =
    List.map (\c -> renderCell c (Color.hsl 0 0.576 0.663)) grid


renderActive : BoardState -> List Renderable
renderActive boardState =
    case boardState of
        Falling activeGrid ghostGrid ->
            renderGhost ghostGrid ++ renderGrid activeGrid

        Highlighting (Cleared rows) ->
            List.map renderHighlightRow rows

        Highlighting (Correct grid) ->
            renderHighlightCorrect grid

        Highlighting (Incorrect grid) ->
            renderHighlightIncorrect grid



-- VIEW (COMPONENTS)


startButton : String -> Html Msg
startButton message =
    button
        [ class "px-5 py-2 my-2 bg-red font-bold text-white rounded-full text-xl hover:bg-red-dark active:bg-red-dark"
        , onClick ClickedStart
        ]
        [ text message ]



-- MAIN PROGRAM


main : Program () Model Msg
main =
    Browser.element
        { init = \() -> ( initialModel, Task.perform GotTime Time.now )
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
