module Main exposing (main)

import Browser
import Browser.Events exposing (onAnimationFrameDelta)
import Canvas exposing (Renderable, Shape)
import Color
import Html exposing (Html, a, br, button, div, h1, i, img, li, ol, p, span, text)
import Html.Attributes exposing (class, classList, height, href, src, style, width)
import Html.Events exposing (onClick)
import Html.Events.Extra.Pointer as Pointer
import Html.Lazy
import Json.Decode exposing (Value)
import List.Extra exposing (interweave, last)
import Math.Matrix4 as Mat4 exposing (Mat4)
import Math.Vector3 as Vec3 exposing (Vec3, vec3)
import Math.Vector4 as Vec4 exposing (Vec4, vec4)
import Random exposing (Seed)
import WebGL exposing (Mesh, Shader)



-- Constants


{-| The number of cells per hemisphere circumference
-}
cellsPerHemisphereValue =
    11


{-| The radius of the sphere.
-}
radiusValue =
    1


{-| Time per generation in milliseconds
-}
timePerGeneration =
    75


{-| Number of generations until the pump node depolarises
-}
gensPerNodeOn =
    20



-- Model


type alias Model =
    { cells : List Cell
    , rotationLat : Float
    , rotationLong : Float
    , yTrans : Float
    , randomSeed : Seed
    , timeSinceLastGeneration : Float
    , generation : Generation
    , frame : Int
    , playing : Bool
    , genome : Genome
    , trace : Float
    , traceHistory : List Float
    , showHelp : Bool
    , pointerPrev : Maybe ( Float, Float )
    }


{-| Each generation is an integer.
-}
type alias Generation =
    Int


{-| The genom consits of four codons.
-}
type alias Genome =
    { c1 : Codon
    , c2 : Codon
    , c3 : Codon
    , c4 : Codon
    }


{-| Each codon consists of three bases.
-}
type alias Codon =
    { b1 : Base, b2 : Base, b3 : Base }


{-| The bases can come from a two-letter alphabet.
-}
type Base
    = M
    | P


{-| The initial genome is very unlikely to terminate.t
-}
initialGenome =
    { c1 = Codon M M M
    , c2 = Codon M M P
    , c3 = Codon P M P
    , c4 = Codon P P M
    }


init : Model
init =
    let
        initialSeed =
            Random.initialSeed 0
    in
    { cells = makeCells initialSeed
    , yTrans = 0
    , rotationLat = pi
    , rotationLong = -pi / 2
    , randomSeed = initialSeed
    , timeSinceLastGeneration = 0
    , generation = 0
    , frame = 0
    , playing = False
    , genome = initialGenome
    , trace = 0
    , traceHistory = List.repeat 60 0
    , showHelp = True
    , pointerPrev = Nothing
    }



-- Update


type Msg
    = OnNextFrame Float
    | ToggledPlaying
    | Rotate RotateDirection
    | ToggledBase CodonNum BaseNum
    | ToggledModal
    | ClickedRandomise
    | PointerHeld Pointer.Event
    | PointerMoved Pointer.Event
    | PointerUnheld Pointer.Event


type RotateDirection
    = RotateLat
    | RotateLong


type CodonNum
    = C1
    | C2
    | C3
    | C4


type BaseNum
    = B1
    | B2
    | B3


update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
    case msg of
        OnNextFrame dt ->
            let
                cumulativeTime =
                    model.timeSinceLastGeneration + dt
            in
            if cumulativeTime > timePerGeneration then
                let
                    newGeneration =
                        model.generation + 1

                    newFrame =
                        model.frame + 1

                    trace =
                        List.sum <| List.map cellToTrace model.cells
                in
                ( { model
                    | timeSinceLastGeneration = 0
                    , cells = updateCells model.cells newGeneration model.genome
                    , generation = newGeneration
                    , rotationLat = model.rotationLat + (pi / 500)
                    , frame = newFrame
                    , yTrans = sin <| toFloat newFrame / 30
                    , trace = trace
                    , traceHistory = List.drop 1 model.traceHistory ++ [ trace ]
                  }
                , Cmd.none
                )

            else
                let
                    newFrame =
                        model.frame + 1
                in
                ( { model
                    | timeSinceLastGeneration = cumulativeTime
                    , rotationLat = model.rotationLat + (pi / 500)
                    , frame = newFrame
                    , yTrans = sin <| toFloat newFrame / 30
                  }
                , Cmd.none
                )

        ToggledPlaying ->
            ( { model | playing = not model.playing }, Cmd.none )

        Rotate RotateLat ->
            ( { model | rotationLat = model.rotationLat + (pi / 10) }, Cmd.none )

        Rotate RotateLong ->
            ( { model | rotationLong = model.rotationLong + (pi / 10) }, Cmd.none )

        ToggledBase codonNum baseNum ->
            ( { model | genome = updateGenome model.genome codonNum baseNum }, Cmd.none )

        ToggledModal ->
            ( { model | showHelp = not model.showHelp }, Cmd.none )

        ClickedRandomise ->
            let
                ( randomFloat, _ ) =
                    Random.step (Random.float 0 1) model.randomSeed

                newSeed =
                    Random.initialSeed (round <| randomFloat * 10000)
            in
            ( { model | cells = makeCells newSeed, randomSeed = newSeed }, Cmd.none )

        PointerHeld event ->
            ( { model | pointerPrev = Just <| relativePos event }, Cmd.none )

        PointerMoved event ->
            let
                newPos =
                    relativePos event
            in
            case model.pointerPrev of
                Just prevPos ->
                    ( { model
                        | pointerPrev = Just <| newPos
                        , rotationLat = model.rotationLat + ((Tuple.first newPos - Tuple.first prevPos) / 100)
                        , rotationLong = model.rotationLong - ((Tuple.second newPos - Tuple.second prevPos) / 100)
                      }
                    , Cmd.none
                    )

                Nothing ->
                    ( model, Cmd.none )

        PointerUnheld event ->
            ( { model | pointerPrev = Nothing }, Cmd.none )


relativePos : Pointer.Event -> ( Float, Float )
relativePos event =
    event.pointer.offsetPos


{-| Converts the phase to a modifier for the trace.
-}
phaseToTraceModifier : Phase -> Float
phaseToTraceModifier phase =
    case phase of
        Phase0 ->
            0

        Phase1 ->
            3

        Phase2 ->
            -0.5

        Phase3 ->
            -0.2

        Phase4 ->
            -1


cellToTrace : Cell -> Float
cellToTrace cell =
    let
        thetaUnit =
            cell.polarDiscrete.thetaUnit

        theta =
            pi / 2 + toFloat thetaUnit * (pi / cellsPerHemisphereValue)

        trace =
            (cos theta * -1) * phaseToTraceModifier cell.phase
    in
    trace


{-| Toggles the base in the specified base number.
-}
updateCodon : Codon -> BaseNum -> Codon
updateCodon codon baseNum =
    case baseNum of
        B1 ->
            { codon | b1 = toggleBase codon.b1 }

        B2 ->
            { codon | b2 = toggleBase codon.b2 }

        B3 ->
            { codon | b3 = toggleBase codon.b3 }


{-| Updates the genome with the specified base in the specified position.

Because the alphabet only has two letters, this is a simple toggle.

-}
updateGenome : Genome -> CodonNum -> BaseNum -> Genome
updateGenome genome codonNum baseNum =
    case codonNum of
        C1 ->
            { genome | c1 = updateCodon genome.c1 baseNum }

        C2 ->
            { genome | c2 = updateCodon genome.c2 baseNum }

        C3 ->
            { genome | c3 = updateCodon genome.c3 baseNum }

        C4 ->
            { genome | c4 = updateCodon genome.c4 baseNum }


{-| Toggles between the two types of bases.
-}
toggleBase : Base -> Base
toggleBase base =
    case base of
        M ->
            P

        P ->
            M


{-| Checks if two cells are adjacent.

There are a number of edge cases to consider because of
how the cells were initiated.

Because the cells may have a radius of 1 or -1,
we have to specifically check the edge cases there.

`cellCheck` is the "cell to be checked" and is
the one for which phase is checked.

-}
isAdjacentOn : Cell -> Cell -> Bool
isAdjacentOn cellRef cellCheck =
    let
        phaseCheck =
            cellCheck.phase

        satisfies =
            case phaseCheck of
                Phase1 ->
                    let
                        polarRef =
                            cellRef.polarDiscrete

                        thetaRef =
                            polarRef.thetaUnit

                        phiRef =
                            polarRef.phiUnit

                        rRef =
                            polarRef.r

                        polarCheck =
                            cellCheck.polarDiscrete

                        thetaCheck =
                            polarCheck.thetaUnit

                        phiCheck =
                            polarCheck.phiUnit

                        rCheck =
                            polarCheck.r

                        thetaComp =
                            abs <| thetaCheck - thetaRef

                        phiComp =
                            abs <| phiCheck - phiRef

                        immediate =
                            (thetaComp == 1 && phiComp == 0)
                                || (phiComp == 1 && thetaComp == 0)
                                || (thetaComp == 1 && phiComp == 1)

                        edgeCase =
                            if (phiComp == ((cellsPerHemisphereValue * 2) - 1)) && (thetaComp == 1 || thetaComp == 0) then
                                True

                            else
                                False
                    in
                    immediate || edgeCase

                _ ->
                    False
    in
    satisfies


{-| Translate the codon into a number of adjacent Phase1 cells to count.

We are basing it on binary numbers to make it more solvable (rather
than having participants resort to guessing.)

-}
codonToInt : Codon -> Int
codonToInt codon =
    case ( codon.b1, codon.b2, codon.b3 ) of
        ( M, M, M ) ->
            1

        ( M, M, P ) ->
            2

        ( M, P, M ) ->
            3

        ( M, P, P ) ->
            2

        ( P, M, M ) ->
            1

        ( P, M, P ) ->
            0

        ( P, P, M ) ->
            1

        ( P, P, P ) ->
            2


{-| Convert the genome into a set of adjacent Phase1 cells to count.

If the number of adjacent Phase1 cells falls into this set,
then the center cell will enter Phase0 in the next generation.

Originally this was a list, but this was too easy to solve.

    genomeToNum : Genome -> Int
    genomeToNum genome =
        let
            maybeMin =
                List.minimum <| List.map codonToInt [ genome.c1, genome.c2, genome.c3, genome.c4 ]
        in
        case maybeMin of
            Just min ->
                min

            Nothing ->
                0

-}
genomeToList : Genome -> List Int
genomeToList genome =
    List.map codonToInt [ genome.c1, genome.c2, genome.c3, genome.c4 ]


updateCells : List Cell -> Generation -> Genome -> List Cell
updateCells cells generation genome =
    let
        nextPhase cell =
            let
                polar =
                    cell.polarDiscrete

                phase =
                    cell.phase
            in
            case ( polar.thetaUnit, phase ) of
                ( 0, Phase0 ) ->
                    case modBy gensPerNodeOn generation of
                        0 ->
                            Phase1

                        _ ->
                            Phase0

                ( thetaValue, _ ) ->
                    if thetaValue == cellsPerHemisphereValue then
                        Phase0

                    else
                        case phase of
                            Phase0 ->
                                let
                                    adjacents =
                                        List.filter (isAdjacentOn cell) cells

                                    numAdjacents =
                                        List.length adjacents

                                    numNeededToDepolarise =
                                        genomeToList genome
                                in
                                if List.member numAdjacents numNeededToDepolarise then
                                    Phase1

                                else
                                    Phase0

                            Phase1 ->
                                Phase2

                            Phase2 ->
                                Phase3

                            Phase3 ->
                                Phase4

                            Phase4 ->
                                Phase0

        nextCell cell =
            { cell | phase = nextPhase cell }
    in
    List.map nextCell cells



-- Mesh


{-| 3D vector with elements in order r, theta and phi.

  - `r` is the radius.
  - `theta` corresponds to the inclination from the z-axis.
  - `phi` corresponds to the angle from the x-axis towards the positive y-axis.

-}
type alias PolarCoordinate =
    Vec3


type alias PolarDiscrete =
    { r : Float
    , thetaUnit : Int
    , phiUnit : Int
    }


{-| Abstract this away in case it changes.
-}
makePolar : Float -> Int -> Int -> PolarDiscrete
makePolar r thetaUnit phiUnit =
    { r = r, thetaUnit = thetaUnit, phiUnit = phiUnit }


{-| Cells on the polar grid.
-}
type alias Cell =
    { polarDiscrete : PolarDiscrete
    , phase : Phase
    }


{-| Cells cane be in one of five phases, loosely corresponding to phases of the cardiac AP.

  - Phase 0 = resting, can be excited
  - Phase 1 = depolarising, is excited
  - Phase 2 = depolarised, cannot be excited more
  - Phase 3 = refractory, cannot be excited
  - Phase 4 = refractory, cannot be excited (for our purposes)

-}
type Phase
    = Phase0
    | Phase1
    | Phase2
    | Phase3
    | Phase4


{-| Actual vertices for WebGL
-}
type alias Vertex =
    { color : Vec3
    , position : Vec3
    }


{-| Simply flips the sign of the radius.
-}
reflectPolar : PolarDiscrete -> PolarDiscrete
reflectPolar coord =
    let
        r =
            coord.r

        theta =
            coord.thetaUnit

        phi =
            coord.phiUnit
    in
    makePolar r theta -phi


intToPhase : Int -> Phase
intToPhase int =
    case int of
        1 ->
            Phase1

        2 ->
            Phase2

        3 ->
            Phase3

        4 ->
            Phase4

        _ ->
            Phase0


makeCells : Seed -> List Cell
makeCells seed =
    let
        r =
            radiusValue

        cellsPerHemisphere =
            cellsPerHemisphereValue

        spacing =
            pi / toFloat cellsPerHemisphere

        unitList =
            List.range 0 cellsPerHemisphere

        unitListOpposite =
            List.map ((-) 0) <| List.range 1 (cellsPerHemisphere - 1)

        hemisphere : List (Phase -> Cell)
        hemisphere =
            unitList
                |> List.map (\thetaUnit -> List.map (\phiUnit -> Cell (makePolar r thetaUnit phiUnit)) unitList)
                |> List.concat

        numCells =
            List.length hemisphere

        ( ints, s1 ) =
            Random.step (Random.list numCells (Random.int 0 5)) seed

        ( intsOpposite, _ ) =
            Random.step (Random.list numCells (Random.int 0 5)) s1

        phases =
            List.map intToPhase ints

        phasesOpposite =
            List.map intToPhase intsOpposite

        --List.map intToPhase intsOpposite
        hemisphereWithPhases : List Cell
        hemisphereWithPhases =
            List.map2 (\f phase -> f phase) hemisphere phases

        hemisphereOpposite =
            unitList
                |> List.map (\thetaUnit -> List.map (\phiUnit -> Cell (makePolar r thetaUnit phiUnit)) unitListOpposite)
                |> List.concat
                |> List.map2 (\phase f -> f phase) phasesOpposite

        sphere =
            interweave hemisphereWithPhases hemisphereOpposite
    in
    sphere


{-| Turns a (r, theta, phi) vector into an (x, y, z) vector.
-}
polarToCartesian : PolarCoordinate -> Vec3
polarToCartesian polar =
    let
        r =
            Vec3.getX polar

        theta =
            Vec3.getY polar

        phi =
            Vec3.getZ polar

        x =
            r * sin theta * cos phi

        y =
            r * sin theta * sin phi

        z =
            r * cos theta
    in
    vec3 x y z


{-| Changes discrete polar to polar coordinate.

Note the global `cellsPerHemisphereValue`.

-}
polarDiscreteToPolar : PolarDiscrete -> PolarCoordinate
polarDiscreteToPolar polarDiscrete =
    let
        spacing =
            pi / toFloat cellsPerHemisphereValue
    in
    vec3 polarDiscrete.r (toFloat polarDiscrete.thetaUnit * spacing) (toFloat polarDiscrete.phiUnit * spacing)


{-| This turns a phase into a modifier to the radius.

This is so vertices can appear "inset" depending on their phase.

-}
phaseToRadiusModifier : Phase -> Float
phaseToRadiusModifier phase =
    case phase of
        Phase0 ->
            1

        Phase1 ->
            0.8

        Phase2 ->
            0.9

        Phase3 ->
            0.95

        Phase4 ->
            0.975


{-| Converts phase to alpha modifier for color.
-}
phaseToColorModifier : Phase -> Float
phaseToColorModifier phase =
    case phase of
        Phase0 ->
            0.8

        Phase1 ->
            1

        Phase2 ->
            0.9

        Phase3 ->
            0.85

        Phase4 ->
            0.82


{-| Converts a polar discrete center to a mesh for that cell.
-}
polarToMesh : Vec3 -> PolarDiscrete -> Mesh Vertex
polarToMesh baseColor cellCoordDiscrete =
    let
        cellCoord =
            polarDiscreteToPolar cellCoordDiscrete

        cellsPerHemisphere =
            cellsPerHemisphereValue

        r =
            Vec3.getX cellCoord

        theta =
            Vec3.getY cellCoord

        phi =
            Vec3.getZ cellCoord

        halfSpace =
            pi / (2 * toFloat cellsPerHemisphere)

        topLeft =
            vec3 r (theta - halfSpace) (phi - halfSpace) |> polarToCartesian

        topRight =
            vec3 r (theta - halfSpace) (phi + halfSpace) |> polarToCartesian

        bottomLeft =
            vec3 r (theta + halfSpace) (phi - halfSpace) |> polarToCartesian

        bottomRight =
            vec3 r (theta + halfSpace) (phi + halfSpace) |> polarToCartesian

        triangleLeft =
            ( Vertex color topLeft, Vertex color topRight, Vertex color bottomLeft )

        triangleRight =
            ( Vertex color topRight, Vertex color bottomLeft, Vertex color bottomRight )

        origin =
            vec3 0 0 0

        color =
            case cellCoordDiscrete.thetaUnit of
                0 ->
                    vec3 0 0 0

                _ ->
                    vec3 (Vec3.getX baseColor) (Vec3.getY baseColor) (Vec3.getZ baseColor)

        sideTop =
            ( Vertex color origin, Vertex color topLeft, Vertex color topRight )

        sideLeft =
            ( Vertex color origin, Vertex color topLeft, Vertex color bottomLeft )

        sideRight =
            ( Vertex color origin, Vertex color topRight, Vertex color bottomRight )

        sideBottom =
            ( Vertex color origin, Vertex color bottomLeft, Vertex color bottomRight )
    in
    WebGL.triangles [ triangleLeft, triangleRight, sideTop, sideLeft, sideRight, sideBottom ]


initialMesh : List (Mesh Vertex)
initialMesh =
    let
        cells =
            makeCells (Random.initialSeed 0)

        numCells =
            List.length cells

        colors =
            List.range (numCells // 2) (numCells + (numCells // 2))
                |> List.map (\x -> vec3 (toFloat x) 100 100)
                |> List.map (Vec3.scale (1 / toFloat (numCells + (numCells // 2))))
    in
    List.map2 (\color cell -> polarToMesh color cell.polarDiscrete) colors cells



-- Uniforms


type alias Uniforms =
    { rotation : Mat4
    , translation : Mat4
    , scale : Mat4
    , colorModifier : Float
    , perspective : Mat4
    , camera : Mat4
    , shade : Float
    }


uniforms : Float -> Float -> Float -> Phase -> Uniforms
uniforms latAngle longAngle yTrans phase =
    { rotation =
        Mat4.mul
            (Mat4.makeRotate latAngle (vec3 0 1 0))
            (Mat4.makeRotate longAngle (vec3 1 0 0))
    , translation =
        Mat4.makeTranslate (vec3 0 (yTrans / 8) 0)
    , scale =
        let
            scaler =
                phaseToRadiusModifier phase
        in
        Mat4.makeScale3 scaler scaler scaler
    , colorModifier = phaseToColorModifier phase
    , perspective = Mat4.makePerspective 45 1 0.01 100
    , camera = Mat4.makeLookAt (vec3 0 0 5) (vec3 0 0 0) (vec3 0 1 0)
    , shade = 1
    }



-- Shaders


vertexShader : Shader Vertex Uniforms { vcolor : Vec4 }
vertexShader =
    [glsl|
        attribute vec3 position;
        attribute vec3 color;
        uniform mat4 perspective;
        uniform mat4 camera;
        uniform mat4 rotation;
        uniform mat4 translation;
        uniform mat4 scale;
        uniform float colorModifier;
        varying vec4 vcolor;
        void main () {
            gl_Position = perspective * camera * translation * rotation * scale * vec4(position, 1.0);
            vcolor = vec4(color[0] * colorModifier, color[1], color[2], 1.0);
        }
    |]


fragmentShader : Shader {} Uniforms { vcolor : Vec4 }
fragmentShader =
    [glsl|
        precision mediump float;
        uniform float shade;
        varying vec4 vcolor;
        void main () {
            gl_FragColor = shade * vcolor;
        }
    |]



-- Subscriptions


subscriptions : Model -> Sub Msg
subscriptions model =
    case model.playing of
        True ->
            onAnimationFrameDelta OnNextFrame

        False ->
            Sub.none



-- View


baseToChar : Base -> String
baseToChar base =
    case base of
        M ->
            "M"

        P ->
            "P"


baseToColor : Base -> ( String, String )
baseToColor base =
    let
        white =
            "#ffffff"

        black =
            "#383838"
    in
    case base of
        M ->
            ( white, black )

        P ->
            ( black, white )


baseDiv : CodonNum -> BaseNum -> Base -> Html Msg
baseDiv codonNum baseNum base =
    let
        ( textColor, bgColor ) =
            baseToColor base
    in
    button
        [ class "base"
        , style "background" bgColor
        , style "color" textColor
        , onClick <| ToggledBase codonNum baseNum
        ]
        [ text <| baseToChar base ]


codonDiv : CodonNum -> Codon -> Html Msg
codonDiv codonNum codon =
    span [ class "codon" ] <|
        List.map2 (baseDiv codonNum) [ B1, B2, B3 ] [ codon.b1, codon.b2, codon.b3 ]


genomeDiv : Genome -> Html Msg
genomeDiv genome =
    div [ class "genome" ] <|
        List.map2 codonDiv [ C1, C2, C3, C4 ] [ genome.c1, genome.c2, genome.c3, genome.c4 ]


traceWidth =
    200


traceHeight =
    50


traceToCanvas : List Float -> List Renderable
traceToCanvas traceHistory =
    let
        ( first, tail ) =
            case traceHistory of
                x :: xs ->
                    ( x, xs )

                [] ->
                    ( 0, [] )

        path =
            Canvas.path ( 0, first ) <| List.map2 (\x y -> Canvas.lineTo ( toFloat x, y )) (List.range 1 60) tail
    in
    [ Canvas.shapes
        [ Canvas.stroke Color.red
        , Canvas.lineWidth 0.5
        , Canvas.lineCap Canvas.RoundCap
        , Canvas.lineJoin Canvas.RoundJoin
        , Canvas.transform [ Canvas.translate 0 (traceHeight / 2), Canvas.scale 4 0.8 ]
        ]
        [ path ]
    ]


view : Model -> Html Msg
view model =
    let
        modal showHelp =
            div [ class "modal", classList [ ( "modal-off", not showHelp ) ] ] [ modalContent ]

        bottom playing =
            div [ class "bottom" ]
                [ div [ class "control" ]
                    [ span [ class "play-buttons" ] <| playButtons model.playing
                    , button [ class "rotate", onClick <| Rotate RotateLong ] [ i [ class "fas fa-sync-alt" ] [] ]
                    , button [ class "randomise", onClick ClickedRandomise ] [ i [ class "fas fa-dice" ] [] ]
                    , button [ class "help", onClick ToggledModal ] [ i [ class "fas fa-question" ] [] ]
                    ]
                ]

        playButtons playing =
            case playing of
                True ->
                    [ button [ onClick ToggledPlaying, class "pause" ] [ i [ class "fas fa-pause" ] [] ] ]

                False ->
                    [ button [ class "step", onClick <| OnNextFrame (toFloat <| timePerGeneration + 1) ] [ i [ class "fas fa-step-forward" ] [] ]
                    , button [ onClick ToggledPlaying, class "play" ] [ i [ class "fas fa-play" ] [] ]
                    ]

        topDiv genome =
            div [ class "top" ]
                [ genomeDiv genome ]
    in
    div [ class "main" ]
        [ Html.Lazy.lazy (\_ -> div [ class "bar" ] [ img [ src "./icon_inverted.png", class "icon-image" ] [], text "PIGLET.exe" ]) 0
        , div [ class "container" ]
            [ Html.Lazy.lazy topDiv model.genome
            , div [ class "center" ]
                [ WebGL.toHtml
                    [ width 400
                    , height 400
                    , style "display" "block"
                    , class "webgl"
                    , Pointer.onDown PointerHeld
                    , Pointer.onMove PointerMoved
                    , Pointer.onUp PointerUnheld
                    ]
                  <|
                    List.map2
                        (\mesh cell ->
                            WebGL.entity vertexShader
                                fragmentShader
                                mesh
                                (uniforms model.rotationLat model.rotationLong model.yTrans cell.phase)
                        )
                        initialMesh
                        model.cells
                , Canvas.toHtml ( traceWidth * 2, traceHeight * 2 ) [ class "trace" ] <|
                    Canvas.shapes [ Canvas.fill Color.white ] [ Canvas.rect ( 0, 0 ) (traceWidth * 2) (traceHeight * 2) ]
                        :: traceToCanvas model.traceHistory
                ]
            , Html.Lazy.lazy bottom model.playing
            , Html.Lazy.lazy modal model.showHelp
            ]
        ]


modalContent : Html Msg
modalContent =
    div [ class "modal-content" ]
        [ h1 [] [ text "Out of Sync" ]
        , p [] [ text "The PUMP (Primitive Universal Miniature PUMP) is currently beating in a disorderly fashion." ]
        , p [] [ text "It's up to you to use PIGLET (The PUMP Interactive Gene Live Editing Terminal) to get it back to an orderly state (shown below)." ]
        , img [ src "./orderly_small.gif", class "gif" ] []
        , p [] [ text "Toggle the letters at the top between M and P to edit the genome. The letters come in triplets ('codons') - codons represent a certain parameter for the PUMP cells." ]
        , p []
            [ text "You've also been tasked with finding two special codons:"
            , br [] []
            , ol []
                [ li []
                    [ text "The "
                    , span [ style "font-weight" "bold" ] [ text "Havoc" ]
                    , text " codon, which never occurs in an orderly pump."
                    ]
                , li []
                    [ text "The "
                    , span [ style "font-weight" "bold" ] [ text "Order" ]
                    , text " codon, which must occur in an orderly pump."
                    ]
                ]
            ]
        , a [ href "https://cigmah.github.io/cgmnt/#/puzzles/5" ] [ text "The full puzzle details can be found here." ]
        , br [] []
        , button [ onClick ToggledModal, class "modal-button" ] [ text "Got it!" ]
        ]



-- Main


main : Program Value Model Msg
main =
    Browser.element
        { init = \_ -> ( init, Cmd.none )
        , view = view
        , subscriptions = subscriptions
        , update = update
        }
