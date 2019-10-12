port module Main exposing (main)

import Browser
import Color
import Html exposing (..)
import Html.Attributes
import Html.Events
import Images
import List
import List.Extra
import Random exposing (Generator)
import Random.Extra
import Set
import Time
import TypedSvg exposing (..)
import TypedSvg.Attributes exposing (..)
import TypedSvg.Core exposing (Svg)
import TypedSvg.Events exposing (..)
import TypedSvg.Types exposing (..)



-- ports


type SoundMessage
    = PlayBgm
    | MuteAll
    | PlayCorrect
    | PlayIncorrect
    | PlayTap
    | PlayFinish
    | StopBgm


soundMessageToString : SoundMessage -> String
soundMessageToString soundMessage =
    case soundMessage of
        PlayBgm ->
            "playBgm"

        MuteAll ->
            "muteAll"

        PlayCorrect ->
            "playCorrect"

        PlayIncorrect ->
            "playIncorrect"

        PlayTap ->
            "playTap"

        PlayFinish ->
            "playFinish"

        StopBgm ->
            "stopBgm"


port sound : String -> Cmd msg



-- Types


type Screen
    = Start
    | Loading
    | Playing Board
    | Interim Board Grid Board
    | Failure Board
    | Success Board


type alias Points =
    Int


type alias SecondsLeft =
    Int


type alias LevelNumber =
    Int


type alias Board =
    { grid : Grid
    , secondsLeft : SecondsLeft
    , levelNumber : LevelNumber
    , points : Points
    , isSolved : Bool
    , gridParams : GridParams
    }


type alias GridParams =
    -- Width in terms of number of cells
    { width : Int }


type alias Cell =
    { x : Int
    , y : Int
    , contents : Contents
    }


type alias Grid =
    List Cell


type Contents
    = Bug BugName
    | Drug DrugName


type BugName
    = Chlamydia
    | Gonorrhoea
    | Candida
    | Treponema
    | Trichomonas
    | Haemophilus
    | Klebsiella
    | Hsv
    | Mycoplasma
    | Missingno


type DrugName
    = Azithromycin
    | Ceftriaxone
    | Metronidazole
    | Benzathine
    | Doxycycline
    | Valacyclovir
    | Moxifloxacin
    | Clotrimazole


type alias RowSpec =
    { bugXMin : Int
    , drugX : Int
    , bugXMax : Int
    }



-- Bug and Drug Data


bugList =
    [ Chlamydia, Gonorrhoea, Candida, Treponema, Trichomonas, Haemophilus, Klebsiella, Hsv, Mycoplasma, Missingno ]


drugList =
    [ Azithromycin, Ceftriaxone, Metronidazole, Benzathine, Doxycycline, Valacyclovir, Moxifloxacin, Clotrimazole ]


bugToString : BugName -> String
bugToString bugName =
    case bugName of
        Chlamydia ->
            "Chlamydia trachomatis, serovars D-F"

        Gonorrhoea ->
            "Neisseria gonorrhoea"

        Candida ->
            "Candida spp."

        Treponema ->
            "Treponema pallidum"

        Trichomonas ->
            "Trichomonas vaginalis"

        Haemophilus ->
            "Haemophilus ducreyi"

        Klebsiella ->
            "Klebsiella granulomatis"

        Hsv ->
            "Herpes simplex virus 2"

        Mycoplasma ->
            "Mycoplasma genitalium"

        Missingno ->
            "Missingno"


drugToString : DrugName -> String
drugToString drugName =
    case drugName of
        Azithromycin ->
            "Azithromycin"

        Ceftriaxone ->
            "Ceftriaxone"

        Metronidazole ->
            "Metronidazole"

        Benzathine ->
            "Benzathine benzylpenicillin (G)"

        Doxycycline ->
            "Doxycyline"

        Valacyclovir ->
            "Valacyclovir"

        Moxifloxacin ->
            "Moxifloxacin"

        Clotrimazole ->
            "Clotrimazole"



-- Every drug must react with SOMETHING!


react : DrugName -> BugName -> Bool
react drug bug =
    case ( drug, bug ) of
        ( Ceftriaxone, Gonorrhoea ) ->
            True

        ( Doxycycline, Chlamydia ) ->
            True

        ( Benzathine, Treponema ) ->
            True

        ( Metronidazole, Trichomonas ) ->
            True

        ( Clotrimazole, Candida ) ->
            True

        ( Azithromycin, Haemophilus ) ->
            True

        ( Valacyclovir, Hsv ) ->
            True

        ( Moxifloxacin, Mycoplasma ) ->
            True

        ( _, _ ) ->
            False



-- Level Data


levelToParams : LevelNumber -> GridParams
levelToParams levelNum =
    case levelNum of
        1 ->
            GridParams 2

        2 ->
            GridParams 3

        3 ->
            GridParams 4

        4 ->
            GridParams 5

        5 ->
            GridParams 6

        6 ->
            GridParams 6

        _ ->
            GridParams 3



-- Generation


makeHeight : Int -> Int
makeHeight width =
    (5 * width) // 2


listToRowSpec : List Int -> RowSpec
listToRowSpec list =
    case list of
        [ a, b, c ] ->
            RowSpec a b c

        -- Will not occur, only because of convenience of sorting the list..
        _ ->
            RowSpec 0 0 0


randomDrug : Generator DrugName
randomDrug =
    Random.Extra.sample drugList
        |> Random.map (Maybe.withDefault Azithromycin)


randomGrid : GridParams -> Generator Grid
randomGrid params =
    let
        width =
            params.width

        height =
            makeHeight width

        ys =
            List.repeat (height - 1) 0 |> Random.constant

        --List.range 0 height
        --    |> List.map (Random.int 0)
        --     |> Random.Extra.combine
        rows =
            Random.int 0 (width - 1)
                |> Random.list 3
                |> Random.map (listToRowSpec << List.sort)
                |> Random.list height

        drugs : Generator (List DrugName)
        drugs =
            Random.list height randomDrug
    in
    Random.map3 combineGenerated ys rows drugs


combineGenerated : List Int -> List RowSpec -> List DrugName -> Grid
combineGenerated ys rows drugs =
    List.Extra.zip3 ys rows drugs
        |> List.foldl combineRow []


raiseCell : Int -> Int -> Int -> Cell -> Cell
raiseCell y xmin xmax cell =
    if cell.y >= y && cell.x >= xmin && cell.x <= xmax then
        { cell | y = cell.y + 1 }

    else
        cell


newCells : Int -> RowSpec -> DrugName -> Grid
newCells y row drug =
    let
        bug =
            bugList |> List.filter (react drug) |> List.head |> Maybe.withDefault Missingno

        bugRow =
            List.map (\x -> Cell x y (Bug bug))

        drugLeft =
            if row.bugXMin == row.drugX then
                []

            else
                List.range row.bugXMin (row.drugX - 1)
                    |> bugRow

        drugRight =
            if row.bugXMax == row.drugX then
                []

            else
                List.range (row.drugX + 1) row.bugXMax
                    |> bugRow
    in
    drugLeft ++ [ Cell row.drugX y (Drug drug) ] ++ drugRight


combineRow : ( Int, RowSpec, DrugName ) -> Grid -> Grid
combineRow ( y, row, drug ) grid =
    grid
        |> List.map (raiseCell y row.bugXMin row.bugXMax)
        |> (++) (newCells y row drug)



-- Model


type alias Model =
    { screen : Screen
    , muted : Bool
    }


initialModel : ( Model, Cmd Msg )
initialModel =
    ( { screen = Start
      , muted = False
      }
    , Cmd.none
    )


makeBoard : Grid -> SecondsLeft -> LevelNumber -> Points -> GridParams -> Board
makeBoard grid secondsLeft levelNumber points gridParams =
    { grid = grid
    , secondsLeft = secondsLeft
    , levelNumber = levelNumber
    , points = points
    , isSolved = False
    , gridParams = gridParams
    }



-- Msg


type Msg
    = NoOp
    | ClickedStart
    | ClickedDrug DrugName Cell
    | GotGrid Board GridParams Grid
    | ClickedNext
    | Mute
    | Tick
    | ClickedRestart



-- Update


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        modelify screen =
            { model | screen = screen }
    in
    case ( msg, model.screen ) of
        ( ClickedStart, Start ) ->
            let
                initialParams =
                    levelToParams 1
            in
            ( modelify Loading
            , Cmd.batch
                [ Random.generate (GotGrid (makeBoard [] 300 0 0 initialParams) initialParams) <| randomGrid initialParams
                , sound (soundMessageToString PlayBgm)
                ]
            )

        ( Mute, _ ) ->
            ( { model | muted = not model.muted }, sound (soundMessageToString MuteAll) )

        ( GotGrid oldBoard gridParams grid, Loading ) ->
            ( modelify <|
                Playing <|
                    { oldBoard
                        | grid = grid
                        , gridParams = gridParams
                        , isSolved = False
                        , levelNumber = oldBoard.levelNumber + 1
                    }
            , Cmd.none
            )

        ( ClickedDrug drug cell, Playing board ) ->
            clickedDrug model drug cell board

        ( ClickedNext, Playing board ) ->
            if board.isSolved then
                if board.levelNumber == 6 then
                    ( modelify <| Success board, sound (soundMessageToString PlayFinish) )

                else
                    let
                        newParams =
                            levelToParams <| board.levelNumber + 1
                    in
                    ( modelify Loading, Random.generate (GotGrid board newParams) <| randomGrid newParams )

            else
                ( model, Cmd.none )

        ( Tick, Interim oldBoard cleared newBoard ) ->
            if List.length newBoard.grid == 0 then
                ( modelify <| Playing { newBoard | isSolved = True }, sound (soundMessageToString PlayCorrect) )

            else if List.length (List.filter isDrug newBoard.grid) == 0 then
                ( modelify <| Failure newBoard, sound (soundMessageToString PlayIncorrect) )

            else
                ( modelify <| Playing newBoard, Cmd.none )

        ( ClickedRestart, _ ) ->
            ( modelify Start, sound (soundMessageToString StopBgm) )

        ( _, _ ) ->
            ( model, Cmd.none )


safeReact : DrugName -> Cell -> Bool
safeReact drug cell =
    case cell.contents of
        Bug bugName ->
            react drug bugName

        Drug _ ->
            False


gravity : Int -> Int -> Int -> Cell -> Cell
gravity y xmin xmax cell =
    if cell.y > y && cell.x >= xmin && cell.x <= xmax then
        { cell | y = cell.y - 1 }

    else
        cell



-- Should be okay because there is only one item per coordinate.


makeGridComparable : Grid -> List ( Int, Int )
makeGridComparable grid =
    grid
        |> List.map (\c -> ( c.x, c.y ))


isDrug : Cell -> Bool
isDrug cell =
    case cell.contents of
        Bug _ ->
            False

        Drug _ ->
            True


clickedDrug : Model -> DrugName -> Cell -> Board -> ( Model, Cmd Msg )
clickedDrug model drug cell board =
    let
        modelify screen =
            { model | screen = screen }

        row =
            board.grid
                |> List.filter (\c -> (==) cell.y c.y)
                |> List.sortBy .x

        ( tryLeft, tryRight ) =
            row
                |> List.Extra.splitWhen (\c -> (==) cell.x c.x)
                |> Maybe.withDefault ( [], [] )

        clearedLeft =
            tryLeft
                |> List.Extra.takeWhileRight (safeReact drug)

        clearedRight =
            tryRight
                |> List.drop 1
                |> List.Extra.takeWhile (safeReact drug)

        clearedList =
            cell :: clearedLeft ++ clearedRight

        clearedSet =
            clearedList
                |> makeGridComparable
                |> Set.fromList

        xmin =
            clearedLeft
                |> List.map .x
                |> List.minimum
                |> Maybe.withDefault cell.x

        xmax =
            clearedRight
                |> List.map .x
                |> List.maximum
                |> Maybe.withDefault cell.x

        newGrid =
            board.grid
                |> List.filter (\c -> not <| Set.member ( c.x, c.y ) clearedSet)
                |> List.map (gravity cell.y xmin xmax)
    in
    ( modelify <| Interim board clearedList { board | grid = newGrid }, sound (soundMessageToString PlayTap) )



--  if List.length newGrid == 0 then
--      ( modelify <| Playing { board | grid = newGrid, isSolved = True }, Cmd.none )
--  else if List.length (List.filter isDrug newGrid) == 0 then
--      ( modelify <| Failure { board | grid = newGrid }, Cmd.none )
--  else
--      ( modelify <| Playing { board | grid = newGrid }, Cmd.none )
-- View


view : Model -> Html Msg
view model =
    let
        mainBody =
            case model.screen of
                Start ->
                    div [ Html.Attributes.class "start" ]
                        [ div [ Html.Attributes.class "title" ] [ text "Bugs 'n' Drugs" ]
                        , div [ Html.Attributes.class "subtitle" ] [ text "Click on drugs to clear bugs." ]
                        , div [ Html.Attributes.class "subtitle" ] [ text "Clear all the bugs from the board." ]
                        , div [ Html.Attributes.class "subtitle" ] [ text "Don't leave any behind." ]
                        , svg [] Images.klebsiella
                        , button [ Html.Events.onClick ClickedStart ]
                            [ text "Start" ]
                        ]

                Loading ->
                    div [] [ text "Loading" ]

                Playing board ->
                    viewBoard board Nothing

                Interim oldBoard clearedList _ ->
                    viewBoard oldBoard (Just clearedList)

                Success board ->
                    div []
                        [ viewBoard board Nothing
                        , div [ Html.Attributes.class "success overlay" ] [ text "SUCCESS", reveal, button [ onClick ClickedRestart ] [ text "Restart" ] ]
                        ]

                Failure board ->
                    div []
                        [ viewBoard board Nothing
                        , div [ Html.Attributes.class "failure overlay" ] [ text "FAILURE", button [ onClick ClickedRestart ] [ text "Restart" ] ]
                        ]
    in
    div [ Html.Attributes.class "container" ] [ mainBody ]


viewBoard : Board -> Maybe Grid -> Html Msg
viewBoard board clearedMaybe =
    let
        nextButton =
            if board.isSolved then
                [ button [ onClick ClickedNext ] [ text "Next Level" ] ]

            else
                []
    in
    div [ Html.Attributes.class "board-container" ]
        ([ viewGrid board.grid board.gridParams clearedMaybe ] ++ nextButton)


viewGrid : Grid -> GridParams -> Maybe Grid -> Html Msg
viewGrid grid gridParams clearedMaybe =
    let
        gridWidth =
            300

        gridHeight =
            toFloat <| makeHeight gridWidth

        cellWidth =
            gridWidth / toFloat gridParams.width

        cellHeight =
            gridHeight / toFloat (makeHeight gridParams.width)

        clearedCells =
            case clearedMaybe of
                Just cleared ->
                    List.map (viewCell cellWidth cellHeight gridParams.width True) cleared

                Nothing ->
                    []

        nonClearedCells =
            case clearedMaybe of
                Just cleared ->
                    let
                        clearedSet =
                            cleared |> makeGridComparable |> Set.fromList
                    in
                    grid |> List.filter (\cell -> not <| Set.member ( cell.x, cell.y ) clearedSet)

                Nothing ->
                    grid
    in
    svg
        [ viewBox 0 (gridWidth / 8) gridWidth gridHeight
        , height (px 750)
        , width (px 300)
        ]
        (List.map (viewCell cellWidth cellHeight gridParams.width False) nonClearedCells
            ++ clearedCells
        )


viewCell : Float -> Float -> Int -> Bool -> Cell -> Svg Msg
viewCell cellWidth cellHeight gridWidth isCleared cell =
    let
        xPos =
            toFloat cell.x * cellWidth

        yPos =
            -- SVG has corner at top left, so transform to bottom left.
            toFloat (makeHeight gridWidth - cell.y - 1) * cellWidth

        opacityValue =
            if isCleared then
                Opacity 0.3

            else
                Opacity 1

        posAttributes =
            [ x <| px <| xPos
            , y <| px <| yPos
            , cx <| px <| xPos + (cellWidth / 2)
            , cy <| px <| yPos + (cellWidth / 2)
            , r <| px <| cellWidth / 2
            , width <| px cellWidth
            , height <| px cellHeight
            , opacity opacityValue
            , transform [ Translate xPos yPos, Scale (cellWidth / 256) (cellHeight / 256) ]
            ]
    in
    viewContents posAttributes cell


viewContents : List (TypedSvg.Core.Attribute Msg) -> Cell -> Svg Msg
viewContents posAttributes cell =
    case cell.contents of
        Bug bug ->
            viewBug posAttributes cell bug

        Drug drug ->
            viewDrug posAttributes cell drug


viewBug : List (TypedSvg.Core.Attribute Msg) -> Cell -> BugName -> Svg Msg
viewBug posAttributes cell bug =
    g
        ([ class [ "bug", "tile" ]
         ]
            ++ posAttributes
        )
        (bugSvgPath bug ++ [ TypedSvg.title [] [ text (bugToString bug) ] ])


bugSvgPath : BugName -> List (Svg Msg)
bugSvgPath bug =
    case bug of
        Chlamydia ->
            Images.chlamydia

        Gonorrhoea ->
            Images.gonorrhoea

        Candida ->
            Images.candida

        Treponema ->
            Images.treponema

        Trichomonas ->
            Images.trichomonas

        Haemophilus ->
            Images.haemophilus

        Klebsiella ->
            Images.klebsiella

        Hsv ->
            Images.hsv

        Mycoplasma ->
            Images.mycoplasma

        Missingno ->
            []


viewDrug : List (TypedSvg.Core.Attribute Msg) -> Cell -> DrugName -> Svg Msg
viewDrug posAttributes cell drug =
    g
        ([ class [ "drug", "tile" ]
         , TypedSvg.Events.onClick (ClickedDrug drug cell)
         ]
            ++ posAttributes
        )
        ([ rect [ fillOpacity (Opacity 0), width (px 256), height (px 256) ] []
         , TypedSvg.title [] [ text (drugToString drug) ]
         ]
            ++ drugSvgPath drug
        )


reveal : Html Msg
reveal =
    let
        baseHbar xc yc w =
            rect [ x (px <| xc * 10), y (px <| yc * 10), width (px (w * 10)), height (px 10), fill (Fill Color.white) ] []

        hbar xc yc =
            baseHbar xc yc 5

        vbar xc yc =
            rect [ x (px <| xc * 10), y (px <| yc * 10), width (px 10), height (px 60), fill (Fill Color.white) ] []
    in
    svg
        [ viewBox 30 0 300 60
        , height (px 50)
        , width (px 300)
        , class [ "reveal" ]
        ]
        [ hbar 1 0
        , hbar 1 3
        , vbar 1 0
        , vbar 5 0
        , baseHbar 7 0 5
        , baseHbar 11 5 5
        , vbar 11 0
        , hbar 17 0
        , hbar 17 5
        , vbar 17 0
        , vbar 22 0
        , vbar 24 0
        , hbar 24 5
        , hbar 30 0
        , hbar 30 2.5
        , hbar 30 5
        , vbar 30 0
        ]


drugSvgPath : DrugName -> List (Svg Msg)
drugSvgPath drug =
    case drug of
        Azithromycin ->
            Images.azithromycin

        Ceftriaxone ->
            Images.ceftriaxone

        Metronidazole ->
            Images.metronidazole

        Benzathine ->
            Images.benzathine

        Doxycycline ->
            Images.doxycycline

        Valacyclovir ->
            Images.valacyclovir

        Moxifloxacin ->
            Images.moxifloxacin

        Clotrimazole ->
            Images.clotrimazole


subscriptions : Model -> Sub Msg
subscriptions model =
    case model.screen of
        Interim _ _ _ ->
            Time.every 500 (\_ -> Tick)

        _ ->
            Sub.none



-- Main


main : Program () Model Msg
main =
    Browser.element
        { init = \_ -> initialModel
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
