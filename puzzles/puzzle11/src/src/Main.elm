module Main exposing (Model, Msg(..), init, main, update, view)

import Browser
import Color
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Decode as Decode
import Levels exposing (levelParams)
import List.Extra
import Logic exposing (..)
import Random
import Svg
import Svg.Events
import Time exposing (every)
import TypedSvg exposing (circle, polyline, rect, svg)
import TypedSvg.Attributes exposing (cx, cy, fill, height, points, r, stroke, strokeWidth, viewBox, width, x, y)
import TypedSvg.Core exposing (Svg)
import TypedSvg.Events as Events
import TypedSvg.Types exposing (..)
import Types exposing (..)



---- MODEL ----


type alias Model =
    Screen


init : ( Model, Cmd Msg )
init =
    ( Start, Cmd.none )


initState : Seconds -> LevelId -> Board -> Solution -> State
initState timeRemaining level board solution =
    Playing
        { board = board
        , boardParams = levelParams level
        , solution = solution
        , timeRemaining = timeRemaining
        , mouse = Nothing
        }



---- UPDATE ----


type Msg
    = NoOp
    | ClickedStart
    | NewBoard
    | GeneratedBoard Seconds LevelId ( Board, Solution )
    | MovedMouse Int Int
    | ClickedMouse Int Int
    | ClickedNext Seconds
    | Restart
    | TickClock


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( msg, model ) of
        ( ClickedStart, Start ) ->
            ( Loading, Random.generate (GeneratedBoard 300 (LevelId 1)) <| randomBoard <| levelParams (LevelId 1) )

        ( GeneratedBoard timeRemaining level ( board, solution ), Loading ) ->
            if List.all ((==) False) solution || List.all ((==) True) solution then
                ( Loading, Random.generate (GeneratedBoard timeRemaining level) <| randomBoard <| levelParams level )

            else
                ( Level level <| initState timeRemaining level board solution, Cmd.none )

        ( MovedMouse x y, Level level (Playing state) ) ->
            ( Level level <| Playing { state | mouse = Just <| Coord x y }, Cmd.none )

        ( ClickedMouse x y, Level level (Playing state) ) ->
            handleClick x y level state

        ( Restart, _ ) ->
            ( Start, Cmd.none )

        ( ClickedNext seconds, Level (LevelId level) (Correct state) ) ->
            let
                nextLevel =
                    LevelId (level + 1)
            in
            ( Loading, Random.generate (GeneratedBoard seconds nextLevel) <| randomBoard <| levelParams nextLevel )

        ( TickClock, Level level (Playing ({ timeRemaining } as state)) ) ->
            let
                newTimeRemaining =
                    timeRemaining - 1
            in
            if newTimeRemaining < 1 then
                ( Timeout, Cmd.none )

            else
                ( Level level (Playing { state | timeRemaining = newTimeRemaining }), Cmd.none )

        _ ->
            ( model, Cmd.none )


handleClick : Int -> Int -> LevelId -> StateData -> ( Model, Cmd Msg )
handleClick x y level state =
    let
        xpos =
            viewToSvgPos x state.boardParams.size viewWidth

        ypos =
            viewToSvgPos y state.boardParams.size viewHeight

        proposed =
            Block (Coord xpos ypos) state.boardParams.blockDims
                |> (\block -> solutionPath block state.board)

        correct =
            state.solution == proposed
    in
    if correct then
        case level of
            LevelId 10 ->
                ( Success state, Cmd.none )

            _ ->
                ( Level level <| Correct state, Cmd.none )

    else
        ( Failure level state proposed, Cmd.none )



---- EVENTS ----


mouseDecoder : (Int -> Int -> Msg) -> Decode.Decoder Msg
mouseDecoder msg =
    Decode.map2 msg
        (Decode.field "offsetX" Decode.int)
        (Decode.field "offsetY" Decode.int)


onMouseMoveAttribute : Svg.Attribute Msg
onMouseMoveAttribute =
    Svg.Events.on "mousemove" <| mouseDecoder MovedMouse


onMouseClickAttribute : Svg.Attribute Msg
onMouseClickAttribute =
    Svg.Events.on "click" <| mouseDecoder ClickedMouse


viewToSvgPos : Int -> Int -> Int -> Int
viewToSvgPos mousePos svgSize viewSize =
    mousePos * svgSize // viewSize



---- VIEW ----


viewHeight =
    300


viewWidth =
    300


view : Model -> Html Msg
view model =
    let
        inner =
            case model of
                Start ->
                    div [ class "start" ]
                        [ div [ class "title" ] [ text "NEUROLOGIC" ]
                        , div [ class "subtitle" ] [ text "LOCALISE 10 LESIONS." ]
                        , button [ onClick ClickedStart ] [ text "PLAY" ]
                        ]

                Loading ->
                    div [] [ text "Loading" ]

                Level (LevelId level) (Playing state) ->
                    viewLevel level state state.solution False False

                Level (LevelId level) (Correct state) ->
                    viewLevel level state state.solution True True

                Failure (LevelId level) state proposed ->
                    viewLevel level state proposed True False

                Timeout ->
                    div [ class "start" ]
                        [ div [ class "title" ] [ text "FAILURE" ]
                        , div [ class "subtitle" ] [ text "Your time ran out." ]
                        , button [ onClick Restart ] [ text "REPLAY" ]
                        ]

                Success state ->
                    viewSuccess state
    in
    div [ class "document" ]
        [ div [ class "container" ] [ inner ]
        ]


viewLevel : Int -> StateData -> Solution -> Bool -> Bool -> Html Msg
viewLevel level state solution completed solved =
    let
        nextButton =
            case ( completed, solved ) of
                ( False, _ ) ->
                    [ button [ class "next hidden" ] [ text "UNSOLVED" ] ]

                ( True, False ) ->
                    [ button [ class "next", onClick Restart ] [ text "REPLAY" ] ]

                ( True, True ) ->
                    [ button [ class "next", onClick <| ClickedNext state.timeRemaining ] [ text "NEXT" ] ]

        extraTimeStyle =
            if state.timeRemaining < 10 then
                [ style "color" "red" ]

            else
                []

        feedbackDiv =
            case ( completed, solved ) of
                ( False, _ ) ->
                    div [] []

                ( True, False ) ->
                    div [ class "failure-feedback" ] []

                ( True, True ) ->
                    div [ class "success-feedback" ] []
    in
    div [ class "level" ]
        [ div [ class "text" ]
            [ div [ class "level" ] [ level |> String.fromInt |> text ]
            , text "|"
            , div (extraTimeStyle ++ [ class "time" ]) [ state.timeRemaining |> String.fromInt |> String.padLeft 3 '0' |> text ]
            ]
        , div [ class "board", classList [ ( "hide-cursor", not completed ) ] ]
            [ viewBoard state solution completed
            , div [ class "failure", classList [ ( "hidden", not completed || solved ) ] ] [ text "FAILURE" ]
            , feedbackDiv
            ]
        , div [ class "menu" ]
            [ div [ class "goal" ] (viewResult state.solution)
            , div [ class "next" ] nextButton
            ]
        ]


hues : List a -> List Float
hues list =
    let
        numElem =
            List.length list
    in
    List.map (\a -> toFloat a / toFloat numElem) <| List.range 0 (numElem - 1)


colorise : Float -> Color.Color
colorise hue =
    Color.hsl hue 0.5 0.5


viewBoard : StateData -> Solution -> Bool -> Html Msg
viewBoard state solution solved =
    svg
        [ width (px viewWidth)
        , height (px viewHeight)
        , viewBox 0 0 (toFloat state.boardParams.size) (toFloat state.boardParams.size)
        , onMouseMoveAttribute
        , onMouseClickAttribute
        ]
    <|
        List.map3 (viewPath solved) (hues solution) state.board solution
            ++ viewGhost state.mouse state.boardParams.size state.boardParams.blockDims solved


viewGhost : Maybe Coord -> Size -> Dims -> Bool -> List (Svg Msg)
viewGhost coordMaybe size dims solved =
    let
        ( fillcolor, strokecolor ) =
            if solved then
                ( Fill Color.black, Color.black )

            else
                ( FillNone, Color.lightGrey )
    in
    case coordMaybe of
        Just coord ->
            [ rect
                [ fill fillcolor
                , stroke strokecolor
                , strokeWidth <| px 0.2
                , TypedSvg.Attributes.strokeLinejoin StrokeLinejoinRound
                , width <| px <| toFloat dims.width
                , height <| px <| toFloat dims.height
                , x <| px <| (toFloat <| viewToSvgPos coord.x size viewWidth) - (toFloat dims.width / 2)
                , y <| px <| (toFloat <| viewToSvgPos coord.y size viewHeight) - (toFloat dims.height / 2)
                ]
                []
            ]

        Nothing ->
            []


viewPath : Bool -> Float -> Path -> Bool -> Svg Msg
viewPath solved hue path off =
    let
        color =
            case ( solved, off ) of
                ( True, True ) ->
                    Color.black

                _ ->
                    colorise hue

        ( cxstart, cystart ) =
            coordToTuple <| Maybe.withDefault (Coord 0 0) <| List.head path

        ( cxend, cyend ) =
            coordToTuple <| Maybe.withDefault (Coord 0 0) <| List.Extra.last path
    in
    TypedSvg.g
        [ TypedSvg.Attributes.class [ "neurogroup" ] ]
        [ rect
            [ fill <| Fill color
            , strokeWidth (px 0)
            , TypedSvg.Attributes.class [ "neuroend" ]
            , x <| px <| cxend - 0.5
            , y <| px <| cyend - 0.5
            , height <| px 1
            , width <| px 1
            ]
            []
        , polyline
            [ stroke color
            , points (List.map coordToTuple path)
            , fill FillNone
            , strokeWidth (px 0.25)
            , TypedSvg.Attributes.class [ "neuroline" ]
            , TypedSvg.Attributes.strokeLinejoin StrokeLinejoinRound
            ]
            []
        , circle
            [ fill (Fill (Color.rgb 0.098 0.098 0.109))
            , r (px 0.5)
            , stroke Color.white
            , strokeWidth (px 0.1)
            , cx (px cxstart)
            , cy (px cystart)
            , TypedSvg.Attributes.class [ "neurostart" ]
            ]
            []
        ]


viewResult : Solution -> List (Html Msg)
viewResult solution =
    [ div [ class "result-container" ]
        (List.map2 viewSquare (hues solution) solution)
    ]


viewSquare : Float -> Bool -> Html Msg
viewSquare hue off =
    let
        color =
            Color.toCssString <| colorise hue

        extraStyle =
            if off then
                [ style "background-color" "black" ]

            else
                [ style "background-color" color ]
    in
    div
        (extraStyle
            ++ [ class "result-square"
               , classList [ ( "off", off ) ]
               ]
        )
        []


viewSuccess : StateData -> Html Msg
viewSuccess state =
    div [ class "level" ]
        [ div [ class "text" ]
            [ div [ class "level" ] [ 10 |> String.fromInt |> text ]
            , text "|"
            , div [ class "time" ] [ state.timeRemaining |> String.fromInt |> String.padLeft 3 '0' |> text ]
            ]
        , div [ class "board" ] [ viewBoard state state.solution True, div [ class "success" ] [ text "CONGRATS." ] ]
        , div [ class "end" ]
            [ div [] [ end ]
            , button [ class "next", onClick Restart ] [ text "REPLAY" ]
            ]
        ]


quickRect : ( Float, Float ) -> ( Float, Float ) -> Svg Msg
quickRect ( xstart, ystart ) ( xend, yend ) =
    rect
        [ fill <| Fill Color.white
        , strokeWidth (px 0)
        , TypedSvg.Attributes.class [ "rectend" ]
        , x <| px <| xstart
        , y <| px <| ystart
        , width <| px <| xend - xstart + 1
        , height <| px <| yend - ystart + 1
        ]
        []


end : Html Msg
end =
    svg
        [ width (px viewWidth)
        , height (px <| viewHeight / 6)
        , viewBox -1 -1 25 7
        ]
    <|
        List.map (\( c1, c2 ) -> quickRect c1 c2)
            [ ( ( 0, 0 ), ( 4, 0 ) )
            , ( ( 0, 0 ), ( 0, 2 ) )
            , ( ( 0, 2 ), ( 4, 2 ) )
            , ( ( 4, 2 ), ( 4, 4 ) )
            , ( ( 0, 4 ), ( 4, 4 ) )
            , ( ( 6, 0 ), ( 10, 0 ) )
            , ( ( 6, 0 ), ( 6, 4 ) )
            , ( ( 6, 4 ), ( 10, 4 ) )
            , ( ( 10, 0 ), ( 10, 4 ) )
            , ( ( 12, 0 ), ( 16, 0 ) )
            , ( ( 12, 0 ), ( 12, 4 ) )
            , ( ( 14, 0 ), ( 14, 4 ) )
            , ( ( 16, 0 ), ( 16, 4 ) )
            , ( ( 18, 0 ), ( 22, 0 ) )
            , ( ( 18, 0 ), ( 18, 4 ) )
            , ( ( 22, 0 ), ( 22, 4 ) )
            , ( ( 18, 2 ), ( 22, 2 ) )
            ]


coordToTuple : Coord -> ( Float, Float )
coordToTuple c =
    ( toFloat c.x, toFloat c.y )



---- SUBSCRIPTIONS ----


subscriptions : Model -> Sub Msg
subscriptions model =
    case model of
        Level _ (Playing _) ->
            every 1000 (\x -> TickClock)

        _ ->
            Sub.none



---- PROGRAM ----


main : Program () Model Msg
main =
    Browser.element
        { view = view
        , init = \_ -> init
        , update = update
        , subscriptions = subscriptions
        }
