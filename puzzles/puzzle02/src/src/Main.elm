module Main exposing (Model, Msg(..), init, main, subscriptions, update, view)

import Browser
import Browser.Events exposing (onAnimationFrame)
import Canvas exposing (..)
import Color
import Ease
import Html exposing (Html, button, div)
import Html.Attributes exposing (class, classList)
import Html.Events exposing (onClick)
import Html.Lazy
import List
import Random
import Task
import Time



---- MODEL ----


type alias Frame =
    Int


type alias Model =
    { frame : Frame
    , runState : RunState
    , state : State
    , baseSpeed : Float
    , cMicronList : List CMicronData
    , liver : LiverData
    , lProteinList : List LProteinData
    , cMicronTakerList : Maybe (List Taker)
    , lProteinTakerList : Maybe (List Taker)
    , inertTakerList : List InertTaker
    , lipase : List Lipase
    , random : Float
    }


zeroViewport =
    { scene = { width = 0, height = 0 }, viewport = { x = 0, y = 0, width = 1, height = 1 } }


init : ( Model, Cmd Msg )
init =
    ( { frame = 0
      , runState = Stopped
      , state = Normal
      , baseSpeed = baseSpeed
      , cMicronList = []
      , liver = liverInit
      , lProteinList = []
      , cMicronTakerList = Nothing
      , lProteinTakerList = Nothing
      , inertTakerList = inertTakerListInit
      , lipase = lipaseInit
      , random = 0
      }
    , Cmd.none
    )


type State
    = Normal
    | Pathological


type RunState
    = Running
    | Stopped


type alias CMicronData =
    { cx : Float
    , cy : Float
    , pulse : Maybe Pulse
    , triglycerideSize : Float
    , startFrame : Int
    }


type alias Pulse =
    { startFrame : Int
    , currentRadius : Float
    , color : Color.Color
    }


type alias LiverData =
    { cx : Float
    , cy : Float
    , pulse : Maybe Pulse
    }


type alias LProteinData =
    { cx : Float
    , cy : Float
    , pulse : Maybe Pulse
    , triglycerideSize : Float
    , startFrame : Int
    , radiansPerFrame : Float
    }


type alias Taker =
    { startFrame : Int
    , takeX : Float
    , takeY : Float
    , proportion : Float
    }


type alias InertTaker =
    { startFrame : Int
    , angleRadians : Float
    , proportion : Float
    }


type alias Lipase =
    { positionRadians : Float
    }


cMicronInit startFrame =
    { cx = 400
    , cy = 200
    , pulse = Nothing
    , triglycerideSize = cMicronLongevity / cMicronSizeModifier
    , startFrame = startFrame
    }


liverInit : LiverData
liverInit =
    { cx = liverX, cy = liverY, pulse = Nothing }


lProteinInit : Int -> LProteinData
lProteinInit startFrame =
    { cx = liverX, cy = liverY, pulse = Nothing, triglycerideSize = maxLProteinSize, radiansPerFrame = lProteinRadiansPerFrame, startFrame = startFrame }


lipaseInit : List Lipase
lipaseInit =
    List.map Lipase <| List.map (\x -> toFloat x * (2 * pi / numLipase)) (List.range 0 numLipase)


inertTakerListInit : List InertTaker
inertTakerListInit =
    let
        startFrames =
            List.map (\x -> round (toFloat x / (inertTakerLongevity / numInertTaker))) <| List.range (0 - numInertTaker) 0

        ( angleRadians, _ ) =
            Random.step (Random.list numInertTaker randFloat) initialSeed

        proportions =
            List.map (\x -> makeInertTakerProportion (0 - x)) startFrames
    in
    List.map3 InertTaker startFrames angleRadians proportions



---- UTILITIES ----
-- CONSTANTS


initialSeed =
    Random.initialSeed 0


baseSpeed =
    1


maxX =
    300


maxY =
    300


circuitRadius =
    200


circuitCx =
    0


circuitCy =
    0


liverX =
    0 - circuitRadius


liverY =
    0



-- frames per second


framerate =
    20


quarterFramerate =
    framerate // 4


doubleFramerate =
    framerate * 2


halfFramerate =
    framerate // 2


secondsPerCircuit =
    16


degreesPerFrame =
    360 / (secondsPerCircuit * framerate)


baseRadiansPerFrame =
    degrees degreesPerFrame


cMicronRadiansPerFrame =
    baseRadiansPerFrame


lProteinRadiansPerFrame =
    baseRadiansPerFrame



-- for straight movement, roughly the same as circuit speed


pxPerFrame =
    2 * pi * circuitRadius / (secondsPerCircuit * framerate)



-- longevity in seconds


cMicronLongevity =
    20



-- in pixels


maxCMicronSize =
    16



-- The pixel amount of how much a cMicron must reduce in one second to disappear  by end of longevity


cMicronSizeModifier =
    cMicronLongevity / maxCMicronSize



-- Reduction in size per second, WITH modifier


cMicronReductionRate =
    1 / cMicronSizeModifier


cMicronPulseColor =
    Color.lightGrey



-- Half width of circuit track in px


trackHalfWidth =
    32



-- Pulse increase in size per frame in pixels


pulseUnit =
    1.2


pulseRadius =
    trackHalfWidth



-- Liver radius in pixels


liverRadius =
    32



-- Threshold size at which LDL particles no longer change


ldlThreshold =
    5



-- Delay in frames to make lProtein non-harmonic and appear to accumulate


lProteinDelay =
    2


lProteinLongevity =
    1 * secondsPerCircuit



-- In pathological state, the max time for lipoproteins to stay on screen in seconds


lProteinMaxTime =
    60



-- Delay in seconds until the first lProtein appears


lProteinAppearDelay =
    0


lProteinPulseColor =
    Color.lightGrey



-- in pixels


maxLProteinSize =
    12


lProteinSizeModifier =
    lProteinLongevity / (maxLProteinSize - ldlThreshold + 0.47)



-- Reduction in size per second, WITH modifier


lProteinReductionRate =
    1 / lProteinSizeModifier



-- Reduction rate as proportion


takerDuration =
    framerate


numLipase =
    48


lipaseRadiansPerFrame =
    baseRadiansPerFrame


numInertTaker =
    10


inertTakerLongevity =
    framerate


inertTakerRadius =
    48


makeInertTakerProportion age =
    ((inertTakerLongevity / 2) ^ 2 - (toFloat age - (inertTakerLongevity / 2)) ^ 2) / 100


randFloat : Random.Generator Float
randFloat =
    Random.float 0 1


inCircuit : Float -> Float -> Bool
inCircuit x y =
    -- This is okay while the circuit center is kept at the origin.
    if
        (x ^ 2 + y ^ 2 > ((circuitRadius - 0.005) ^ 2))
            && (x ^ 2 + y ^ 2 < ((circuitRadius + 0.005) ^ 2))
    then
        True

    else
        False


makeNextXY : ( Float, Float ) -> Float -> ( Float, Float )
makeNextXY ( prevX, prevY ) radiansPerFrame =
    let
        currentAngle =
            let
                baseAngle =
                    acos (prevX / circuitRadius)
            in
            case ( prevX < 0, prevY < 0 ) of
                ( True, True ) ->
                    pi + (pi - baseAngle)

                ( False, True ) ->
                    (2 * pi) - baseAngle

                ( _, _ ) ->
                    baseAngle

        nextAngle =
            currentAngle + radiansPerFrame

        baseX =
            circuitRadius * cos nextAngle

        baseY =
            circuitRadius * sin nextAngle

        ( cx, cy ) =
            ( baseX, baseY )
    in
    ( cx, cy )


makeNextCMicron : Frame -> CMicronData -> CMicronData
makeNextCMicron f data =
    let
        currentlyInCircuit =
            inCircuit data.cx data.cy

        ( nextCx, nextCy ) =
            if currentlyInCircuit then
                makeNextXY ( data.cx, data.cy ) cMicronRadiansPerFrame

            else
                ( data.cx - pxPerFrame, data.cy )

        triglycerideSize =
            case ( currentlyInCircuit, modBy framerate f ) of
                ( True, 0 ) ->
                    data.triglycerideSize - cMicronReductionRate

                _ ->
                    data.triglycerideSize

        pulse =
            case ( currentlyInCircuit, data.pulse ) of
                ( True, Just pulseData ) ->
                    if pulseData.currentRadius > (trackHalfWidth - 0.01) then
                        Nothing

                    else
                        Just { pulseData | currentRadius = (*) trackHalfWidth <| Ease.outExpo <| toFloat (f - pulseData.startFrame) / framerate }

                ( True, Nothing ) ->
                    case modBy framerate f of
                        0 ->
                            Just <| Pulse f data.triglycerideSize cMicronPulseColor

                        _ ->
                            Nothing

                ( False, _ ) ->
                    Nothing
    in
    { data
        | cx = nextCx
        , cy = nextCy
        , triglycerideSize = triglycerideSize
        , pulse = pulse
    }


makeNextLProtein : Frame -> State -> LProteinData -> LProteinData
makeNextLProtein f state data =
    let
        ( nextCx, nextCy ) =
            case state of
                Normal ->
                    makeNextXY ( data.cx, data.cy ) data.radiansPerFrame

                Pathological ->
                    let
                        radiansModifier =
                            toFloat ((lProteinMaxTime * framerate) - (f - data.startFrame)) / (lProteinMaxTime * framerate)
                    in
                    if (f - data.startFrame) >= (lProteinLongevity * framerate) then
                        makeNextXY ( data.cx, data.cy ) (data.radiansPerFrame * radiansModifier)

                    else
                        makeNextXY ( data.cx, data.cy ) data.radiansPerFrame

        triglycerideSize =
            case state of
                Normal ->
                    if modBy framerate f == halfFramerate then
                        data.triglycerideSize - lProteinReductionRate

                    else
                        data.triglycerideSize

                Pathological ->
                    if (f - data.startFrame) >= (lProteinLongevity * framerate) then
                        data.triglycerideSize

                    else if modBy framerate f == halfFramerate then
                        data.triglycerideSize - lProteinReductionRate

                    else
                        data.triglycerideSize

        pulse =
            case ( state, data.pulse ) of
                ( _, Just pulseData ) ->
                    if pulseData.currentRadius > (trackHalfWidth - 0.01) then
                        Nothing

                    else
                        Just { pulseData | currentRadius = (*) trackHalfWidth <| Ease.outExpo <| toFloat (f - pulseData.startFrame) / framerate }

                ( Normal, Nothing ) ->
                    if modBy framerate f == halfFramerate then
                        -- Do not pulse with the chylomicrons
                        Just <| Pulse f data.triglycerideSize lProteinPulseColor

                    else
                        Nothing

                ( Pathological, Nothing ) ->
                    if (modBy framerate f == halfFramerate) && (f - data.startFrame) <= (lProteinLongevity * framerate) then
                        -- Do not pulse with the chylomicrons
                        Just <| Pulse f data.triglycerideSize lProteinPulseColor

                    else
                        Nothing
    in
    { data
        | cx = nextCx
        , cy = nextCy
        , triglycerideSize = triglycerideSize
        , pulse = pulse
    }


makeTaker frame prevTakers removalList =
    let
        filtered =
            case prevTakers of
                Just takers ->
                    List.filter (\t -> t.proportion > 0) takers

                Nothing ->
                    []

        proportioned =
            List.map (\t -> { t | proportion = Ease.outCirc (1 - (toFloat (frame - t.startFrame) / takerDuration)) }) filtered
    in
    case ( prevTakers, removalList ) of
        ( Just takers, [] ) ->
            Just proportioned

        ( Just takers, rs ) ->
            Just <| proportioned ++ List.map (\r -> Taker frame r.cx r.cy 1.0) rs

        ( Nothing, [] ) ->
            Nothing

        ( Nothing, rs ) ->
            Just <| List.map (\r -> Taker frame r.cx r.cy 1.0) rs



---- UPDATE ----


type Msg
    = NoOp
    | TickFrame Time.Posix
    | ToggleState
    | ToggleRunState
    | IncreaseSpeed
    | DecreaseSpeed
    | GotRandomFloat Float


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        TickFrame _ ->
            ( updateFrame model.frame model, Random.generate GotRandomFloat randFloat )

        ToggleState ->
            case model.state of
                Normal ->
                    ( { model | state = Pathological }, Cmd.none )

                Pathological ->
                    ( { model | state = Normal }, Cmd.none )

        ToggleRunState ->
            case model.runState of
                Running ->
                    ( { model | runState = Stopped }, Cmd.none )

                Stopped ->
                    ( { model | runState = Running }, Cmd.none )

        IncreaseSpeed ->
            if model.baseSpeed < 2 then
                ( { model | baseSpeed = model.baseSpeed * 2 }, Cmd.none )

            else
                ( model, Cmd.none )

        DecreaseSpeed ->
            if model.baseSpeed > 0.5 then
                ( { model | baseSpeed = model.baseSpeed / 2 }, Cmd.none )

            else
                ( model, Cmd.none )

        GotRandomFloat float ->
            ( { model | random = float }, Cmd.none )

        NoOp ->
            ( model, Cmd.none )


updateFrame : Frame -> Model -> Model
updateFrame frame model =
    let
        nextCMicronList =
            case modBy (round (framerate * 6 / 5)) frame of
                0 ->
                    cMicronInit frame :: List.map (makeNextCMicron frame) model.cMicronList

                _ ->
                    List.map (makeNextCMicron frame) model.cMicronList

        nextLProteinList =
            let
                phase =
                    modBy (round (framerate * 6 / 5)) frame
            in
            if phase == framerate && frame > (lProteinAppearDelay * framerate) then
                lProteinInit frame :: List.map (makeNextLProtein frame model.state) model.lProteinList

            else
                List.map (makeNextLProtein frame model.state) model.lProteinList

        nextValidCMicronList =
            List.filter (\cm -> cm.triglycerideSize > 0) nextCMicronList

        nextValidLProteinList =
            case model.state of
                Normal ->
                    List.filter (\lp -> lp.triglycerideSize > ldlThreshold) nextLProteinList

                Pathological ->
                    List.filter (\lp -> frame - lp.startFrame <= (framerate * lProteinMaxTime)) nextLProteinList

        removeCMicron =
            List.filter (\cm -> cm.triglycerideSize <= 0) nextCMicronList

        removeLProtein =
            case model.state of
                Normal ->
                    List.filter (\lp -> lp.triglycerideSize <= ldlThreshold) nextLProteinList

                Pathological ->
                    []

        cMicronTakerList =
            makeTaker frame model.cMicronTakerList removeCMicron

        lProteinTakerList =
            case model.state of
                Normal ->
                    makeTaker frame model.lProteinTakerList removeLProtein

                Pathological ->
                    Nothing

        inertTakerList =
            let
                additional =
                    case modBy (framerate // numInertTaker) frame of
                        0 ->
                            [ InertTaker frame (2 * pi * model.random) 0 ]

                        _ ->
                            []

                modified =
                    List.map (\x -> { x | proportion = makeInertTakerProportion (frame - x.startFrame) }) model.inertTakerList
            in
            additional ++ List.filter (\x -> (frame - x.startFrame) <= inertTakerLongevity) modified

        lipase =
            List.map (\x -> Lipase <| x.positionRadians - lipaseRadiansPerFrame) model.lipase
    in
    { model
        | frame = model.frame + 1
        , cMicronList = nextValidCMicronList
        , lProteinList = nextValidLProteinList
        , liver = model.liver
        , cMicronTakerList = cMicronTakerList
        , lProteinTakerList = lProteinTakerList
        , inertTakerList = inertTakerList
        , lipase = lipase
    }



---- SUBSCRIPTIONS ----


subscriptions : Model -> Sub Msg
subscriptions model =
    case model.runState of
        Running ->
            --Time.every (1000 / (framerate * model.baseSpeed)) TickFrame
            onAnimationFrame TickFrame

        Stopped ->
            Sub.none



---- VIEW ----


view : Model -> Html Msg
view model =
    let
        ( buttonTextValue, isNormalValue ) =
            case model.state of
                Normal ->
                    ( "State: Normal", True )

                Pathological ->
                    ( "State: Pathological", False )

        runButtonTextValue =
            case model.runState of
                Running ->
                    "STOP"

                Stopped ->
                    "START"

        isSlowDisabledValue =
            model.baseSpeed <= 0.05

        isFastDisabledValue =
            model.baseSpeed >= 2

        ( random2, _ ) =
            Random.step (Random.float 0 1) (Random.initialSeed <| round (model.random * 100))

        bottomButtonClass =
            "bg-black small-text border-grey-darkest rounded border py-1 px-2 text-grey-lightest hover:bg-grey-darkest"

        disabledButtonClass =
            "bg-black small-text rounded border-grey-darkest border py-1 px-2 text-grey cursor-not-allowed mr-2"

        centerInfo isSlowDisabled isFastDisabled buttonText runButtonText isNormal =
            div [ class "h-screen flex-col flex items-center align-center justify-center absolute w-full" ]
                [ div [ class "w-16 md:w-32" ]
                    [ div [ class "hidden md:block w-full p-1 mb-2 text-grey" ]
                        [ Html.span [ class " font-hairline small-text" ] [ Html.text "CIGMAH CGMNT" ]
                        , Html.br [ class "" ] []
                        , Html.span [ class " font-sans small-text" ] [ Html.text "Metabolic Mayhem" ]
                        , Html.br [] []
                        ]
                    , button
                        [ class "w-full p-1 pb-2 bg-black border rounded hover:bg-grey-darkest   "
                        , classList
                            [ ( "text-grey border-grey-darkest ", isNormalValue )
                            , ( "text-red-light border-red-light "
                              , not isNormalValue
                              )
                            ]
                        , onClick ToggleState
                        ]
                        [ Html.span [ class "small-text" ] [ Html.text buttonText ]
                        , Html.br [] []
                        , Html.span [ class "text-xs smaller-text" ] [ Html.text "(Click to Toggle)" ]
                        ]
                    , div [ class "mt-2 w-full" ]
                        [ --button [ classList [ ( disabledButtonClass, isSlowDisabled ), ( bottomButtonClass ++ " mr-2 ", not isSlowDisabled ) ], Html.Attributes.disabled isSlowDisabled, onClick DecreaseSpeed ] [ Html.text "<<" ]
                          button [ class (bottomButtonClass ++ " w-full "), onClick ToggleRunState ] [ Html.text runButtonText ]

                        --, button [ classList [ ( disabledButtonClass, isFastDisabled ), ( bottomButtonClass ++ " ml-2 ", not isFastDisabled ) ], Html.Attributes.disabled isFastDisabled, onClick IncreaseSpeed ] [ Html.text ">>" ]
                        ]
                    ]
                ]

        ( canvasWidth, canvasHeight ) =
            ( 600, 600 )
    in
    div []
        [ div [ class "h-screen absolute w-full flex items-center align-center justify-center bg-black" ]
            [ Canvas.toHtml ( canvasWidth, canvasHeight ) [] <| animationCanvas model canvasWidth canvasHeight
            , Html.Lazy.lazy5 centerInfo isSlowDisabledValue isFastDisabledValue buttonTextValue runButtonTextValue isNormalValue
            ]
        ]


animationCanvas : Model -> Int -> Int -> List Renderable
animationCanvas model canvasWidth canvasHeight =
    let
        translator =
            { x = toFloat canvasWidth / 2, y = toFloat canvasHeight / 2 }
    in
    List.concat <|
        [ [ shapes [ transform [ translate translator.x translator.y ], fill <| Color.rgb255 34 41 47 ] [ rect ( toFloat <| 0 - canvasWidth // 2, toFloat <| 0 - canvasHeight // 2 ) (toFloat canvasWidth) (toFloat canvasHeight) ] ]
        , pulseView translator cMicronPulseColor model.frame model.cMicronList
        , pulseView translator lProteinPulseColor model.frame model.lProteinList
        , List.concat <| List.map (cMicronView translator model.frame) model.cMicronList
        , List.concat <| List.map (lProteinView translator model.random model.frame) model.lProteinList
        , liverView translator model.random model.liver
        , List.map (takerView translator) <| Maybe.withDefault [] model.lProteinTakerList
        , List.map (inertTakerView translator model.state) model.inertTakerList
        , [ shapes [ fill <| Color.gray ] <| List.concat <| List.map (lipaseView translator) model.lipase ]
        ]


type alias Translator =
    { x : Float, y : Float }


pulseView : Translator -> Color.Color -> Frame -> List { b | cx : Float, cy : Float, pulse : Maybe Pulse } -> List Renderable
pulseView t pulseColor frame data =
    let
        pulseRender object =
            case object.pulse of
                Just pulseData ->
                    let
                        alphaValue =
                            Ease.inQuad <| 1 - (toFloat (frame - pulseData.startFrame) / (framerate * 1))
                    in
                    shapes [ transform [ translate t.x t.y ], stroke pulseColor, alpha alphaValue, fill <| Color.hsla 0 0 0 0 ] [ circle ( object.cx, object.cy ) pulseData.currentRadius ]

                Nothing ->
                    shapes [] [ circle ( object.cx, object.cy ) 0 ]
    in
    List.map pulseRender data


cMicronView : Translator -> Frame -> CMicronData -> List Renderable
cMicronView t frame data =
    let
        phase : Float -> Float
        phase modifier =
            Ease.inOutSine <| toFloat (modBy framerate <| (frame + round (modifier * framerate)) - data.startFrame) / (*) framerate 2

        cMicronCircle widthTransform rotation =
            shapes
                [ stroke Color.darkGray
                , fill <| Color.hsla 0 0 0 0
                , transform [ translate (t.x + data.cx) (t.y + data.cy), rotate rotation, scale widthTransform 1 ]
                ]
                [ circle ( 0, 0 ) data.triglycerideSize ]

        cMicronCircles =
            let
                widthTransforms =
                    List.map (\x -> (phase (toFloat x / 3) * 2) - 1) (List.range 0 4)
            in
            List.map (\x -> cMicronCircle x 0) widthTransforms ++ List.map (\x -> cMicronCircle x (degrees 70)) widthTransforms
    in
    cMicronCircles


liverView : Translator -> Float -> LiverData -> List Renderable
liverView t random data =
    let
        ( noise, s2 ) =
            Random.step (Random.list 5 (Random.float 0 1)) (Random.initialSeed (round (random * 1000)))

        ( rotationValue, s3 ) =
            Random.step (Random.float 0 pi) s2

        ( coreModifier, _ ) =
            Random.step (Random.float 0.75 1.25) s3

        liverCircle rotation widthTransform =
            shapes
                [ stroke Color.grey
                , lineWidth 10
                , fill <| Color.hsla 0 0 0 0
                , transform [ translate (t.x + data.cx) (t.y + data.cy), rotate rotation, scale widthTransform 1 ]
                ]
                [ circle ( 0, 0 ) liverRadius ]

        liverCore =
            shapes [ stroke Color.grey, fill <| Color.grey ] [ circle ( t.x + data.cx, t.y + data.cy ) <| toFloat liverRadius / 3 * coreModifier ]
    in
    liverCore :: List.concat [ List.map (liverCircle 0) noise, List.map (liverCircle rotationValue) noise ]


lProteinView : Translator -> Float -> Frame -> LProteinData -> List Renderable
lProteinView t random frame data =
    let
        phase : Float -> Float
        phase modifier =
            Ease.inOutSine <| toFloat (modBy framerate <| (frame + round (modifier * framerate)) - data.startFrame) / (*) framerate 2

        lProteinCircle widthTransform rotation =
            shapes
                [ stroke <| Color.hsla 0 0 0.8 0.8
                , fill <| Color.hsla 0 0 0 0
                , transform [ translate (t.x + data.cx) (t.y + data.cy), rotate rotation, scale widthTransform 1 ]
                ]
                [ circle ( 0, 0 ) data.triglycerideSize ]

        ( cholesterolSizeModifier, _ ) =
            Random.step (Random.float 0.75 1.25) (Random.initialSeed <| round (random * 1000))

        cholesterolCircle =
            shapes [ fill <| Color.red ] [ circle ( t.x + data.cx, t.y + data.cy ) (toFloat (ldlThreshold - 2) * cholesterolSizeModifier) ]

        lProteinCircles =
            let
                widthTransforms =
                    List.map (\x -> (phase (toFloat x / 2) * 2) - 1) (List.range 0 3)
            in
            List.map (\x -> lProteinCircle x 0) widthTransforms ++ List.map (\x -> lProteinCircle x 90) widthTransforms
    in
    cholesterolCircle :: lProteinCircles


makeTakerLine t endX endY =
    path ( t.x + liverX, t.y + liverY ) <| [ lineTo ( endX, endY ) ]


makeTakerCircle endX endY =
    circle ( endX, endY ) 4


takerView : Translator -> Taker -> Renderable
takerView t data =
    let
        endX =
            t.x + liverX + (data.proportion * (data.takeX - liverX))

        endY =
            t.y + liverY + (data.proportion * (data.takeY - liverY))

        takerLine =
            makeTakerLine t endX endY

        takerCircle =
            makeTakerCircle endX endY
    in
    shapes [ stroke Color.grey, lineWidth 2, fill Color.red ] [ takerLine, takerCircle ]


inertTakerView : Translator -> State -> InertTaker -> Renderable
inertTakerView t state data =
    let
        endX =
            (+) t.x <| (+) liverX <| (*) (cos data.angleRadians) (inertTakerRadius * data.proportion)

        endY =
            (+) t.y <| (+) liverY <| (*) (sin data.angleRadians) (inertTakerRadius * data.proportion)

        takerLine =
            makeTakerLine t endX endY

        takerCircle =
            makeTakerCircle endX endY
    in
    case state of
        Normal ->
            shapes [ stroke Color.grey, lineWidth 2, fill <| Color.hsla 0 0 0 0 ] [ takerLine, takerCircle ]

        Pathological ->
            shapes [ stroke Color.grey, lineWidth 2, fill <| Color.hsla 0 0 0 0 ] [ takerLine ]


makeLipase t x y =
    circle ( t.x + x, t.y + y ) 1


lipaseView : Translator -> Lipase -> List Shape
lipaseView t data =
    let
        xInner =
            (*) (cos data.positionRadians) (circuitRadius - trackHalfWidth)

        xOuter =
            (*) (cos data.positionRadians) (circuitRadius + trackHalfWidth)

        yInner =
            (*) (sin data.positionRadians) (circuitRadius - trackHalfWidth)

        yOuter =
            (*) (sin data.positionRadians) (circuitRadius + trackHalfWidth)

        lipaseInner =
            makeLipase t xInner yInner

        lipaseOuter =
            makeLipase t xOuter yOuter
    in
    [ lipaseInner, lipaseOuter ]



---- PROGRAM ----


main : Program () Model Msg
main =
    Browser.element
        { view = view
        , init = \_ -> init
        , update = update
        , subscriptions = subscriptions
        }
