module Main exposing (main)

import Browser
import Browser.Events exposing (onAnimationFrameDelta, onKeyDown)
import Color
import Html exposing (..)
import Html.Attributes as Attr
import Html.Events exposing (..)
import Json.Decode as Decode
import List.Extra
import Maybe.Extra exposing (isNothing)
import Random exposing (Generator)
import Random.Extra
import Random.List
import Svg exposing (Svg)
import Time exposing (Posix)
import TypedSvg exposing (..)
import TypedSvg.Attributes exposing (..)
import TypedSvg.Core
import TypedSvg.Types exposing (..)



-- Cards


type Card
    = SepticShock
    | Metformin
    | Alcohol
    | Isoniazid
    | ThiamineDeficiency
    | Ketoacidosis
    | Acetazolamide
    | Diarrhoea
    | Methanol
    | RenalFailure
    | Vomiting
    | Frusemide
    | Thiazide
    | PrimaryHyperaldosteronism
    | PyloricStenosis
    | Antacid
    | Licorice
    | Copd
    | OpioidOverdose
    | GuillainBarre
    | PickwickianSyndrome
    | Hyperventilation
    | PulmonaryEmbolism
    | HighAltitude


cardList =
    [ SepticShock
    , Metformin
    , Alcohol
    , Isoniazid
    , ThiamineDeficiency
    , Ketoacidosis
    , Acetazolamide
    , Diarrhoea
    , Methanol
    , RenalFailure
    , Vomiting
    , Frusemide
    , Thiazide
    , PrimaryHyperaldosteronism
    , PyloricStenosis
    , Antacid
    , Licorice
    , Copd
    , OpioidOverdose
    , GuillainBarre
    , PickwickianSyndrome
    , Hyperventilation
    , PulmonaryEmbolism
    , HighAltitude
    ]


cardToAngle : Card -> Angle
cardToAngle card =
    case card of
        SepticShock ->
            Left

        Metformin ->
            Left

        Alcohol ->
            Left

        Isoniazid ->
            Left

        ThiamineDeficiency ->
            Left

        Ketoacidosis ->
            Left

        Acetazolamide ->
            Left

        Diarrhoea ->
            Left

        Methanol ->
            Left

        RenalFailure ->
            Left

        Vomiting ->
            Right

        Frusemide ->
            Right

        Thiazide ->
            Right

        PrimaryHyperaldosteronism ->
            Right

        PyloricStenosis ->
            Right

        Antacid ->
            Right

        Licorice ->
            Right

        Copd ->
            Left

        OpioidOverdose ->
            Left

        GuillainBarre ->
            Left

        PickwickianSyndrome ->
            Left

        Hyperventilation ->
            Right

        PulmonaryEmbolism ->
            Right

        HighAltitude ->
            Right


cardRandom : Generator Card
cardRandom =
    Random.Extra.sample cardList
        |> Random.map (Maybe.withDefault SepticShock)


cardToStrings : Card -> ( String, String )
cardToStrings card =
    case card of
        SepticShock ->
            ( "Septic Shock", "Sepsis is associated with Type A (hypoxic) lactic acidosis, likely from decreased tissue perfusion (though the precise mechanism appears unclear)." )

        Metformin ->
            ( "Side Effect of Metformin", "Metformin is associated with Type B (non-hypoxic) lactic acidosis, particularly in those with reduced renal function." )

        Alcohol ->
            ( "Alcohol Abuse", "Alcohol is most often associated with metabolic acidosis due to lactate and ketones, particularly in chronically malnourished patients. Often, mixed disturbances may be present (e.g. from vomiting)." )

        Isoniazid ->
            ( "Isoniazid", "Isoniazid toxicity is associated with seizures, metabolic acidosis, coma and death." )

        ThiamineDeficiency ->
            ( "Thiamine Deficiency", "Thiamine deficiency is associated with Type B (non-hypoxic) lactic acidosis. Thiamine is a co-factor for pyruvate dehydrogenase in the process of glycolysis; without thiamine, pyruvate instead is directed towards the lactic acid pathway." )

        Ketoacidosis ->
            ( "Diabetic Ketoacidosis", "Diabetic ketoacidosis is associated with acidosis, as the name suggests. Insulin deficiency directs the body towards metabolising fatty acids for energy, producing ketones in the process." )

        Acetazolamide ->
            ( "Side Effect of Acetazolamide", "Acetazolamide is a carbonic anhydrase inhibitor and reduces the reabsorption of bicarbonate in the proximal renal tubules, where most bicarbonate is reabsorbed. It is associated with metabolic acidosis." )

        Diarrhoea ->
            ( "Severe Diarrhoea", "Severe diarrhoea can cause significant losses to gastrointestinal bicarbonate, and is often associated with metabolic acidosis (though mixed disturbances may occur)." )

        Methanol ->
            ( "Methanol Poisoning", "Methanol is a toxin associated with high-anion gap metabolic acidosis (HAGMA)." )

        RenalFailure ->
            ( "Renal Failure", "Renal failure is often associated with metabolic acidosis due to a reduction in the kidneys' ability to excrete acid." )

        Vomiting ->
            ( "Profuse Vomiting", "Vomiting is associated with metabolic alkalosis due to a loss of acidic gastric juice." )

        Frusemide ->
            ( "Side Effect of Frusemide", "Frusemide is associated with hypochloraemic metabolic alkalosis due to inhibition of the Na-Cl-K transporter in the ascending loop of Henle leading to disproportionate excretion of chloride compared to bicarbonate, particularly in volume-depleted patients." )

        Thiazide ->
            ( "Side Effect of Thiazide Diuretics", "Thiazide diuretics are associated with hypochloraemic metabolic alkalosis due to inhibition of the Na-Cl transporter in the distal convoluted tubules leading to disproportionate excretion of chloride compared to bicarbonate, particularly in volume-depleted patients." )

        PrimaryHyperaldosteronism ->
            ( "Primary Hyperaldosteronism", "Primary hyperaldosteronism is associated with metabolic alkalosis due to increased activity of the Na-H transporter, leading to sodium retention and hydrogen ion loss." )

        PyloricStenosis ->
            ( "Pyloric Stenosis", "Pyloric stenosis leads to profuse vomiting, resulting in loss of acidic gastric juice and metabolic alkalosis." )

        Antacid ->
            ( "Antacid Overdose", "Antacid overdose causes metabolic alkalosis due to exogenous bicarbonate ingestion." )

        Licorice ->
            ( "Licorice", "Licorice ingestion (in large amounts) is associated with metabolic alkalosis due to the presence of glycyrrhizin, which can cause pseudohyperaldosteronism resulting in sodium retention and hydrogen ion loss." )

        Copd ->
            ( "COPD", "COPD is associated with chronic respiratory acidosis due to CO2 retention and hypoventilation" )

        OpioidOverdose ->
            ( "Opioid Overdose", "Opioid overdose can reduce central respiratory drive, leading to hypoventilation and CO2 retention." )

        GuillainBarre ->
            ( "Guillain Barre Syndrome", "Guillain Barre syndrome and other neuromuscular disorders can lead to neuromuscular restrictions in respiration, leading to hypoventilation and CO2 retention." )

        PickwickianSyndrome ->
            ( "Pickwickian Syndrome", "Pickwickian syndrome, also known as obesity hypoventilation syndrome, is characterised by hypoventilation and hypercapnia with high BMI, and is often associated with sleep apnoea." )

        Hyperventilation ->
            ( "Hyperventilation", "Hyperventilation causes increased loss of CO2, leading to respiratory alkalosis." )

        PulmonaryEmbolism ->
            ( "Pulmonary Embolism", "Pulmonary embolism is sometimes associated with hypocapnia and respiratory alkalosis, possibly due to hypoxia-induced hyperventilation." )

        HighAltitude ->
            ( "High Altitude", "At high altitude, hypoxia induces hyperventilation and loss of CO2, and is sometimes associated with respiratory alkalosis." )


cardRandomList : Generator (List Card)
cardRandomList =
    cardRandom
        |> Random.list 6



-- Types


type alias Data =
    { position : Float
    , velocity : Float
    , acceleration : Float
    , globalTimeMillis : Float
    , levelTimeMillis : Float
    , angle : Angle
    , cardShow : Maybe Card
    , cardList : List Card
    , curtain : Bool
    , showExplanation : Bool
    , level : Int
    }


type Screen
    = Start
    | Loading
    | Playing Data
    | Success Data
    | Failure Data


type alias Model =
    Screen


type Angle
    = Left
    | Even
    | Right


angleToAccel : Angle -> Float
angleToAccel angle =
    case angle of
        Left ->
            -1 / 250000

        Even ->
            0

        Right ->
            1 / 250000


angleMoveLeft : Angle -> Angle
angleMoveLeft angle =
    case angle of
        Left ->
            Left

        Even ->
            Left

        Right ->
            Even


angleMoveRight : Angle -> Angle
angleMoveRight angle =
    case angle of
        Left ->
            Even

        Even ->
            Right

        Right ->
            Right



-- Msg


type Msg
    = NoOp
    | ClickedStart
    | Tick Float
    | GotRandomCardList (List Card)
    | ClickedLeft
    | ClickedRight
    | Restart



-- Init


init : () -> ( Model, Cmd Msg )
init _ =
    ( Start, Cmd.none )


initData : List Card -> Data
initData randomCardList =
    { position = 0
    , velocity = 0
    , acceleration = 0
    , globalTimeMillis = 0
    , levelTimeMillis = 0
    , angle = Even
    , cardList = randomCardList
    , cardShow = Nothing
    , showExplanation = False
    , curtain = False
    , level = 0
    }



-- Update


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        ignore =
            ( model, Cmd.none )
    in
    case model of
        Start ->
            case msg of
                ClickedStart ->
                    ( Loading, Random.generate GotRandomCardList cardRandomList )

                _ ->
                    ignore

        Loading ->
            case msg of
                GotRandomCardList randomCardList ->
                    ( Playing <| initData randomCardList, Cmd.none )

                _ ->
                    ignore

        Playing data ->
            case msg of
                ClickedLeft ->
                    ( Playing { data | angle = angleMoveLeft data.angle }, Cmd.none )

                ClickedRight ->
                    ( Playing { data | angle = angleMoveRight data.angle }, Cmd.none )

                Tick dt ->
                    let
                        accel : Float
                        accel =
                            angleToAccel data.angle

                        friction : Float
                        friction =
                            data.velocity
                                |> Basics.max -0.1
                                |> Basics.min 0.1
                                |> (*) 0.05

                        newVelocity : Float
                        newVelocity =
                            data.velocity + accel * dt - friction

                        newPosition : Float
                        newPosition =
                            data.position + newVelocity * dt

                        newData =
                            { data
                                | position = newPosition
                                , velocity = newVelocity
                                , globalTimeMillis = data.globalTimeMillis + dt
                                , levelTimeMillis = data.levelTimeMillis + dt
                            }
                    in
                    if newData.position < -1 || newData.position > 1 then
                        ( Failure newData, Cmd.none )

                    else if newData.levelTimeMillis > 2000 && isNothing newData.cardShow then
                        let
                            cardToShow =
                                List.Extra.getAt data.level data.cardList
                                    |> Maybe.withDefault SepticShock

                            -- Shouldn't happen
                            newAngle =
                                cardToAngle cardToShow
                        in
                        ( Playing
                            { newData
                                | cardShow = Just cardToShow
                                , angle = newAngle
                                , velocity = newData.velocity + (angleToAccel newAngle / 2) -- Make it harder so you can't just toggle between the two directions quickly forever}
                            }
                        , Cmd.none
                        )

                    else if newData.levelTimeMillis > 10000 then
                        if newData.level == 5 then
                            ( Success newData, Cmd.none )

                        else if newData.level == 1 then
                            ( Playing
                                { newData
                                    | curtain = True
                                    , level = data.level + 1
                                    , levelTimeMillis = 0
                                    , cardShow = Nothing
                                    , showExplanation = False
                                }
                            , Cmd.none
                            )

                        else
                            ( Playing
                                { newData
                                    | level = data.level + 1
                                    , levelTimeMillis = 0
                                    , cardShow = Nothing
                                    , showExplanation = False
                                }
                            , Cmd.none
                            )

                    else if newData.levelTimeMillis > 4500 then
                        ( Playing
                            { newData
                                | showExplanation = True
                            }
                        , Cmd.none
                        )

                    else
                        ( Playing newData, Cmd.none )

                _ ->
                    ignore

        Success _ ->
            case msg of
                Restart ->
                    ( Start, Cmd.none )

                _ ->
                    ignore

        Failure _ ->
            case msg of
                Restart ->
                    ( Start, Cmd.none )

                _ ->
                    ignore



-- Decoders


keyDecoder : Decode.Decoder Msg
keyDecoder =
    Decode.field "key" Decode.string
        |> Decode.map keyToMsg


keyToMsg : String -> Msg
keyToMsg key =
    case key of
        "ArrowLeft" ->
            ClickedLeft

        "ArrowRight" ->
            ClickedRight

        _ ->
            NoOp



-- View


view : Model -> Html Msg
view model =
    let
        content =
            case model of
                Start ->
                    viewStart

                Loading ->
                    viewLoading

                Playing data ->
                    viewPlaying data

                Failure data ->
                    viewFailure data

                Success data ->
                    viewSuccess data
    in
    div [ Attr.class "container" ]
        [ content ]


viewStart : Html Msg
viewStart =
    div [ Attr.class "intro-container" ]
        [ div [ Attr.class "intro" ]
            [ h1 [] [ text "Base In Balance" ]
            , p [] [ text "Keep the ball on the bar for 1 minute!" ]
            ]
        , button [ onClick ClickedStart ]
            [ text "Start" ]
        ]


viewLoading : Html Msg
viewLoading =
    div [] [ text "Loading" ]


viewPlaying : Data -> Html Msg
viewPlaying data =
    let
        cardData =
            case data.cardShow of
                Just card ->
                    Just <| cardToStrings card

                Nothing ->
                    Nothing

        indicatorClass =
            if data.position < -0.7 || data.position > 0.7 then
                "red"

            else if data.position < -0.4 || data.position > 0.4 then
                "amber"

            else
                "green"

        timerString =
            String.fromInt <| floor <| data.globalTimeMillis / 1000

        maybeExplanation =
            let
                content =
                    case cardData of
                        Just ( cardName, explanation ) ->
                            if data.showExplanation then
                                [ h1 [] [ text cardName ]
                                , div [ Attr.class "detail" ] [ text explanation ]
                                ]

                            else
                                [ h1 [] [ text cardName ] ]

                        Nothing ->
                            [ h1 [] [ text "Ready?" ] ]
            in
            div [ Attr.class "explanation" ]
                [ div [ Attr.class "helpers" ]
                    [ div [ Attr.class "timer" ] [ text timerString ]
                    , div
                        [ Attr.class "indicator"
                        , Attr.classList [ ( indicatorClass, True ) ]
                        ]
                        []
                    ]
                , div [ Attr.class "explanation-text" ] content
                ]
    in
    div [ Attr.class "playing" ]
        [ div [ Attr.class "above" ] [ viewBalance data ]
        , div [ Attr.class "below" ]
            [ maybeExplanation
            , div [ Attr.class "buttons" ]
                [ div [ Attr.class "button-div", Attr.classList [ ( "hold", isLeft data.angle ) ] ] [ button [ onClick ClickedLeft ] [ text "Left", span [ Attr.class "small" ] [ text "(Left Arrow Key)" ] ] ]
                , div [ Attr.class "button-div", Attr.classList [ ( "hold", isRight data.angle ) ] ] [ button [ onClick ClickedRight ] [ text "Right", span [ Attr.class "small" ] [ text "(Right Arrow Key)" ] ] ]
                ]
            ]
        ]


isLeft : Angle -> Bool
isLeft angle =
    case angle of
        Left ->
            True

        _ ->
            False


isRight : Angle -> Bool
isRight angle =
    case angle of
        Right ->
            True

        _ ->
            False


barWidth =
    300


barHeight =
    60


viewBalance : Data -> Html Msg
viewBalance data =
    if data.curtain then
        div [ Attr.class "curtain-container" ] [ div [ Attr.class "curtain" ] [ text "Someone put a curtain in front of your balance! Now you can't see it anymore...so trust yourself :)" ] ]

    else
        svg
            [ width <| px barWidth
            , height <| px barHeight
            , viewBox (-1 / 8 * barWidth) 0 (barWidth * 1.25) barHeight
            ]
            [ viewBar data ]


viewBar : Data -> Svg Msg
viewBar data =
    let
        makeText xPos string =
            text_
                [ x <| px <| xPos
                , y <| px <| 5 * barHeight / 6 - barHeight / 21
                , fontSize <| px <| barHeight / 7
                , textLength <| px <| barWidth / 16
                , fill <| Fill <| Color.white
                ]
                [ TypedSvg.Core.text string ]
    in
    g []
        [ g [ transform [ viewAngle data.angle ] ]
            [ rect
                [ x <| px 0
                , y <| px <| 2 * barHeight / 3
                , width <| px <| barWidth
                , height <| px <| barHeight / 6
                , fill <| Fill <| Color.rgb255 206 108 0
                , rx <| px 2
                , ry <| px 2
                ]
                []
            , circle
                [ cx <| px <| barWidth / 2 + barWidth / 2 * data.position
                , cy <| px <| 3 * barHeight / 6
                , r <| px <| barHeight / 6
                , fill <| Fill <| Color.rgb255 206 108 0
                ]
                []
            , makeText (barWidth / 2 - barWidth / 32) "7.40"
            , makeText (barWidth / 128) "7.35"
            , makeText (barWidth - barWidth / 14) "7.45"
            ]
        , polygon
            [ points [ ( barWidth / 2, barHeight * 5 / 6 ), ( barWidth / 2 - barWidth / 30, barHeight ), ( barWidth / 2 + barWidth / 30, barHeight ) ]
            , fill <| Fill <| Color.rgb255 206 108 0
            ]
            []
        , text_
            [ x <| px <| barWidth / 2 - barWidth / 64
            , y <| px <| barHeight * 47 / 48
            , fontSize <| px <| barHeight / 9
            , fill <| Fill <| Color.white
            , textLength <| px <| barWidth / 32
            ]
            [ TypedSvg.Core.text "pH" ]
        ]


viewAngle : Angle -> Transform
viewAngle angle =
    let
        ( centerX, centerY ) =
            ( barWidth / 2, 10 * barHeight / 12 )
    in
    case angle of
        Left ->
            Rotate -10 centerX centerY

        Even ->
            Rotate 0 0 0

        Right ->
            Rotate 10 centerX centerY


viewFailure : Data -> Html Msg
viewFailure data =
    div [ Attr.class "end failure" ]
        [ div [ Attr.class "end-text-container" ]
            [ text "Your ball fell off the pH bar :(" ]
        , button [ onClick Restart ] [ text "RESTART" ]
        ]


viewSuccess : Data -> Html Msg
viewSuccess data =
    div [ Attr.class "end success" ]
        [ div [ Attr.class "end-text-container" ]
            [ text "Well done. Submit:"
            , span [ Attr.class "end-text" ] [ text <| makeEnd "ACIDIC" ]
            , text " as your submission :)"
            ]
        , button [ onClick Restart ] [ text "RESTART" ]
        ]


makeEnd : String -> String
makeEnd string =
    let
        alphabet =
            "ABCDEFGHIJKLMNOPQRSTUVWXYZ" |> String.toList
    in
    string
        |> String.toList
        |> List.map ((\c -> List.Extra.findIndex ((==) c) alphabet) >> Maybe.withDefault 0)
        |> List.map2 (\a b -> a + b) [ 1, 6, 20, 23, 9, 25 ]
        |> List.map ((\i -> modBy 26 i) >> (\i -> List.Extra.getAt i alphabet) >> Maybe.withDefault 'a')
        |> String.fromList



-- Subscriptions


subscriptions : Model -> Sub Msg
subscriptions model =
    case model of
        Playing _ ->
            Sub.batch
                [ onAnimationFrameDelta Tick
                , onKeyDown keyDecoder
                ]

        _ ->
            Sub.none



-- Main


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }
