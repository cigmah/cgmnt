module Main exposing (main)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Markdown


type Model
    = Start
    | Level LevelData
    | Success LevelData
    | Failure LevelData


type Value
    = Negative
    | Positive


type ThreeValue
    = Low
    | Normal
    | High



{- Unfortunately, Elm doesn't allow dynamic record updates, so we define
   a union type here to pattern match a Msg in the update function
-}


type Field
    = Leukocytes
    | Nitrite
    | Urobilinogen
    | Protein
    | Blood
    | Ketone
    | Bilirubin
    | Glucose


type ThreeField
    = Ph
    | Gravity


type alias Dipstick =
    { leukocytes : Value
    , nitrite : Value
    , urobilinogen : Value
    , protein : Value
    , pH : ThreeValue
    , blood : Value
    , specificGravity : ThreeValue
    , ketone : Value
    , bilirubin : Value
    , glucose : Value
    }


defaultDipstick =
    { leukocytes = Negative
    , nitrite = Negative
    , urobilinogen = Negative
    , protein = Negative
    , pH = Normal
    , blood = Negative
    , specificGravity = Normal
    , ketone = Negative
    , bilirubin = Negative
    , glucose = Negative
    }


type alias LevelData =
    { levelNumber : Int
    , stem : String
    , explanation : String
    , dipstick : Dipstick
    , allowedMoves : Int
    , numMoves : Int
    , checker : Dipstick -> Bool
    , solved : Bool
    }


nextLevel : Maybe LevelData -> Maybe LevelData
nextLevel maybeLevel =
    case maybeLevel of
        -- Very first level
        Nothing ->
            { levelNumber = 1
            , stem = "A long-distance runner has an abnormal urine dipstick at an appointment he attends after a 10km run. A repeat urinalysis after 2 days was negative for this abnormality and the GP, after careful clinical evaluation, reassured him that this was a benign condition. He is not dehydrated. "
            , explanation = "This scenario describes **exercise-induced haematuria**, a benign, transient haematuria sometimes seen after physical exertion. The urine dipstick should return to normal after 48-72 hours. Exercise-induced haematuria is a diagnosis of exclusion and is separate from other post-exercise haematurias such as rhabdomyolysis-induced myoglobinuria, or march haematuria. "
            , dipstick = defaultDipstick
            , allowedMoves = 1
            , numMoves = 0
            , checker = \dipstick -> dipstick.blood == Positive
            , solved = False
            }
                |> Just

        Just level ->
            let
                nextLevelNumber =
                    level.levelNumber + 1
            in
            case level.levelNumber of
                1 ->
                    { levelNumber = nextLevelNumber
                    , stem = "A 13 year old girl is admitted to the ED with nausea, vomiting and abdominal pain. She has a history of recurrent infections and asthma, and has just recently had had a respiratory infection. On examination, she is markedly dehydrated, lethargic, and breathing deep and laboured breaths."
                    , explanation = "This patient with nausea, vomiting, abdominal pain, dehydration, lethargy and Kussmaul respirations has **diabetic ketoacidosis** and undiagnosed Type 1 diabetes, most likely precipitated by her recent respiratory infection. While a urine dipstick is most certainly not your highest priority in this situation, if you did happen to do one, you would most certainly expect ketones and glucose to be positive. Other indicators (e.g. specific gravity, urinary pH) tend to be more variable. "
                    , dipstick = defaultDipstick
                    , allowedMoves = 2
                    , numMoves = 0
                    , checker = \dipstick -> dipstick.glucose == Positive && dipstick.ketone == Positive
                    , solved = False
                    }
                        |> Just

                2 ->
                    { levelNumber = nextLevelNumber
                    , stem = "A 37 year old G0P0 woman in her 36th week of pregnancy is found to have an elevated blood pressure at her scheduled antenatal visit, consistent between multiple readings taken twenty minutes apart. She has a severe headache and some mild upper abdominal pain. An abnormal urine dipstick result prompts a 24 hour urine collection."
                    , explanation = "This patient most likely has **preeclampsia**, a combination of hypertension and proteinuria occuring after 20 weeks pregnancy. Nulliparity and an increase maternal age are risk factors for preeclampsia, and while women may be asymptomatic, some women may experience symptoms such as visual disturbance, a severe headache or abdominal pain (as we see in this patient). "
                    , dipstick = defaultDipstick
                    , allowedMoves = 1
                    , numMoves = 0
                    , checker = \dipstick -> dipstick.protein == Positive
                    , solved = False
                    }
                        |> Just

                3 ->
                    { levelNumber = nextLevelNumber
                    , stem = "A 67 year old woman with a long-term catheter presents with a burning pain when passing urine. "
                    , explanation = "This patient most likely has a **urinary tract infection**, suggested by dysuria and her risk factors (elderly, female and long-term catheter use). The most likely findings in a UTI on a urine dipstick are the presence of nitrites (due to the bacteria reducing nitrates in the urine) and pyuria. Some urease-producing organisms, such as *Proteus spp.*, are also sometimes associated with alkaline urine (high urinary pH). "
                    , dipstick = defaultDipstick
                    , allowedMoves = 2
                    , numMoves = 0
                    , checker = \dipstick -> dipstick.nitrite == Positive && dipstick.leukocytes == Positive
                    , solved = False
                    }
                        |> Just

                4 ->
                    { levelNumber = nextLevelNumber
                    , stem = "A 52 year old man presents to the GP with progressive jaundice, dark urine, pale stools, fatigue and unintentional weight loss of 8kg over the past two months. Examination reveals a palpable gall bladder. Murphy's sign is negative."
                    , explanation = "This patient with a progressive history of obstructive, painless jaundice and systemic features most likely has **carcinoma of the head of the pancreas**. A urine dipstick may show bilirubin (normally negative) due to conjugated bilirubinaemia. In addition, urobilinogen in the urine will be absent due to the obstruction as bilirubin is not metabolised in the intestine (normally excreted in urine small amounts, though we have not made this distinction in this puzzle). "
                    , dipstick = defaultDipstick
                    , allowedMoves = 1
                    , numMoves = 0
                    , checker = \dipstick -> dipstick.bilirubin == Positive
                    , solved = False
                    }
                        |> Just

                5 ->
                    { levelNumber = nextLevelNumber
                    , stem = "An 6 year old boy presents with periorbital oedema and abdominal swelling. There are no systemic symptoms. Blood tests show hypoalbuminaemia and hyperlipidaemia. "
                    , explanation = "This patient displays the classic symptoms of **nephrotic syndrome** (oedema, hypoalbuminaemia, hyperlipidaemia and, for you to click, gross proteinuria) which, in this demographic and in the absence of systemic symptoms, is likely to be due to **minimal change disease.** In some cases, nephrotic syndrome may also display (typically microscopic) haematuria."
                    , dipstick = defaultDipstick
                    , allowedMoves = 1
                    , numMoves = 0
                    , checker = \dipstick -> dipstick.protein == Positive
                    , solved = False
                    }
                        |> Just

                6 ->
                    { levelNumber = nextLevelNumber
                    , stem = "A 19 year old man develops sudden sudden jaundice, dark urine and shortness of breath a day after a fava bean festival. A blood smear shows bite cells and Heinz bodies. "
                    , explanation = "This patient has **G6PD deficiency**, an X-linked genetic disease characterised by haemolytic crises after oxidative stress. This particular response to eating fava beans is pathognomonic (*favism*). Haemolysis is associated with increased urobilinogen (which is produced in the gut), which is sometimes reflected in the urine. In G6PD, the damaged RBCs are typically metabolised by the spleen; in contrast, causes of *intravascular haemolysis* (e.g. TTP) may directly release haemoglobin that is filtered by the kidneys and can appear as the presence of 'blood' on a urine dipstick (without erythrocytes)."
                    , dipstick = defaultDipstick
                    , allowedMoves = 1
                    , numMoves = 0
                    , checker = \dipstick -> dipstick.urobilinogen == Positive
                    , solved = False
                    }
                        |> Just

                7 ->
                    { levelNumber = nextLevelNumber
                    , stem = "A 35 year old woman on chronic lithium therapy for bipolar disorder experiences polyuria, polydipsia and nocturia. A fasting blood glucose level is normal. "
                    , explanation = "This patient has **nephrogenic diabetes insipidus**, a known adverse effect of chronic lithium therapy. Lithium can impair the kidneys' ability to concentrate urine, leading to dilute urine and polyuria. "
                    , dipstick = defaultDipstick
                    , allowedMoves = 1
                    , numMoves = 0
                    , checker = \dipstick -> dipstick.specificGravity == Low
                    , solved = False
                    }
                        |> Just

                _ ->
                    Nothing


initialModel : Model
initialModel =
    Start


type Msg
    = NoOp
    | ClickedStart
    | ClickedField Field Value
    | ClickedThreeField ThreeField ThreeValue
    | ClickedNext
    | ClickedRestart


toggle : Value -> Value
toggle value =
    case value of
        Negative ->
            Positive

        Positive ->
            Negative


update : Msg -> Model -> Model
update msg model =
    case model of
        Start ->
            case msg of
                ClickedStart ->
                    case nextLevel Nothing of
                        Just level ->
                            Level level

                        Nothing ->
                            model

                _ ->
                    model

        Level level ->
            case level.solved of
                True ->
                    case msg of
                        ClickedNext ->
                            let
                                maybeNextLevel =
                                    nextLevel (Just level)
                            in
                            case maybeNextLevel of
                                Just newLevel ->
                                    Level newLevel

                                {- The player solved the game -}
                                Nothing ->
                                    Success level

                        _ ->
                            model

                False ->
                    case msg of
                        ClickedField field value ->
                            let
                                dipstick =
                                    level.dipstick

                                newDipstick =
                                    case field of
                                        {- Without dynamic record updates, this must be enumerated manually -}
                                        Leukocytes ->
                                            { dipstick | leukocytes = value }

                                        Nitrite ->
                                            { dipstick | nitrite = value }

                                        Urobilinogen ->
                                            { dipstick | urobilinogen = value }

                                        Protein ->
                                            { dipstick | protein = value }

                                        Blood ->
                                            { dipstick | blood = value }

                                        Ketone ->
                                            { dipstick | ketone = value }

                                        Bilirubin ->
                                            { dipstick | bilirubin = value }

                                        Glucose ->
                                            { dipstick | glucose = value }

                                newLevel =
                                    { level | dipstick = newDipstick, numMoves = level.numMoves + 1 }
                            in
                            if newLevel.numMoves >= newLevel.allowedMoves then
                                case level.checker newDipstick of
                                    True ->
                                        Level { newLevel | solved = True }

                                    False ->
                                        Failure newLevel

                            else
                                Level newLevel

                        ClickedThreeField field value ->
                            let
                                dipstick =
                                    level.dipstick

                                newDipstick =
                                    case field of
                                        Ph ->
                                            { dipstick | pH = value }

                                        Gravity ->
                                            { dipstick | specificGravity = value }

                                newLevel =
                                    { level | dipstick = newDipstick, numMoves = level.numMoves + 1 }
                            in
                            if newLevel.numMoves >= newLevel.allowedMoves then
                                case level.checker newDipstick of
                                    True ->
                                        Level { newLevel | solved = True }

                                    False ->
                                        Failure newLevel

                            else
                                Level newLevel

                        _ ->
                            model

        Failure level ->
            case msg of
                ClickedRestart ->
                    Start

                _ ->
                    model

        Success level ->
            case msg of
                ClickedRestart ->
                    Start

                _ ->
                    model


view : Model -> Html Msg
view model =
    case model of
        Start ->
            viewStart

        Level level ->
            viewLevel level

        Success level ->
            viewSuccess level

        Failure level ->
            viewFailure level


tailwind : List String -> Html.Attribute Msg
tailwind =
    class << String.join " "


viewStart : Html Msg
viewStart =
    main_
        [ tailwind
            [ "flex"
            , "justify-center"
            , "items-center"
            , "bg-gray-200"
            , "h-screen"
            , "w-screen"
            ]
        ]
        [ article
            [ tailwind
                [ "max-w-4xl"
                , "p-4"
                , "bg-white"
                , "rounded"
                , "fadein"
                , "shadow-lg"
                ]
            ]
            [ h1 [ tailwind [ "text-left", "font-bold", "text-lg", "mb-4" ] ] [ text "What Dipstick?" ]
            , p [ tailwind [ "my-8", "text-left", "max-w-lg" ] ]
                (Markdown.toHtml
                    Nothing
                    "Click the **most** likely urine dipstick abnormality/ies in each of the 10 scenarios. You can change the dipstick tiles by clicking on the tiles *outside* the dipstick. You've only got a limited number of clicks, so be confident of your answers or you'll have to start again!"
                )
            , p
                [ tailwind
                    [ "my-8"
                    , "text-left"
                    , "text-sm"
                    , "font-gray-700"
                    , "max-w-lg"
                    ]
                ]
                [ text "Please note: this puzzle is designed for desktop computers. Mobile displays will not size the graphics appropriately." ]
            , button
                [ tailwind
                    [ "p-2"
                    , "w-full"
                    , "bg-white"
                    , "text-blue-500"
                    , "border-2"
                    , "rounded"
                    , "border-blue-500"
                    , "hover:bg-blue-500"
                    , "hover:text-white"
                    , "cursor-pointer"
                    ]
                , onClick ClickedStart
                ]
                [ text "Start" ]
            ]
        ]


viewLevel : LevelData -> Html Msg
viewLevel level =
    main_
        [ tailwind
            [ "flex"
            , "justify-center"
            , "h-screen"
            , "overflow-hidden"
            , "w-screen"
            , "p-2"
            , "items-center"
            , "bg-gray-200"
            ]
        ]
        [ div []
            [ viewDipstick level.solved level.dipstick
            , section
                [ tailwind
                    [ "lg:h-64"
                    , "mt-32"
                    , "md:h-48"
                    , "overflow-auto"
                    , "rounded-lg"
                    , "shadow-lg"
                    , "text-gray-800"
                    , "max-w-4xl"
                    , "p-4"
                    , "bg-white"
                    , "mx-auto"
                    ]
                ]
                [ viewText level ]
            ]
        ]


levelNumber : LevelData -> Html Msg
levelNumber data =
    div [ tailwind [ "my-4", "uppercase", "font-bold", "text-sm", "text-gray-600", "transition" ] ]
        [ text ("Level " ++ String.fromInt data.levelNumber) ]


stem : LevelData -> Html Msg
stem data =
    div
        [ tailwind
            [ "text-left"
            , "my-4"
            , "transition"
            , "pl-4"
            , "border-l-4"
            , "border-gray-300"
            ]
        ]
        (Markdown.toHtml Nothing data.stem)


movesInfo : LevelData -> Html Msg
movesInfo data =
    p [ tailwind [ "transition", "mb-2" ] ]
        [ text "You have used "
        , strong [] [ text (String.fromInt data.numMoves) ]
        , text " of your "
        , strong [] [ text (String.fromInt data.allowedMoves) ]
        , text " allowed clicks."
        ]


viewText : LevelData -> Html Msg
viewText data =
    let
        explanation =
            div
                [ tailwind
                    [ "fadein"
                    , "text-left"
                    ]
                ]
                (Markdown.toHtml Nothing data.explanation)
    in
    if data.solved then
        article []
            [ div
                [ tailwind
                    [ "flex"
                    , "justify-between"
                    , "w-full"
                    , "items-center"
                    , "fadein"
                    , "mb-4"
                    ]
                ]
                [ p
                    [ tailwind
                        [ "text-green-500"
                        , "font-bold"
                        , "uppercase"
                        , "mr-2"
                        ]
                    ]
                    [ text "Correct - well done!" ]
                , button
                    [ tailwind
                        [ "ml-2"
                        , "border-green-500"
                        , "text-green-500"
                        , "border-2"
                        , "font-bold"
                        , "px-2"
                        , "py-1"
                        , "rounded"
                        , "hover:bg-green-500"
                        , "hover:text-white"
                        , "cursor-pointer"
                        ]
                    , onClick ClickedNext
                    ]
                    [ text "NEXT" ]
                ]
            , explanation
            ]

    else
        article []
            [ levelNumber data
            , stem data
            , p [ tailwind [ "my-2" ] ]
                [ text "Click on the "
                , strong [] [ text (String.fromInt data.allowedMoves) ]
                , text " most likely urine dipstick abnormality/ies in this scenario."
                ]
            , movesInfo data
            ]


tileTailwind : Html.Attribute Msg
tileTailwind =
    tailwind
        [ "h-6"
        , "w-6"
        , "mr-1"
        , "md:h-12"
        , "md:w-12"
        , "md:mr-3"
        , "rounded"
        ]


threeToString : ThreeField -> ThreeValue -> String
threeToString field value =
    let
        fieldString =
            case field of
                Ph ->
                    "pH"

                Gravity ->
                    "Specific Gravity"

        valueString =
            case value of
                Low ->
                    "Low"

                Normal ->
                    "Normal"

                High ->
                    "High"
    in
    fieldString ++ ": " ++ valueString


toString : Field -> Value -> String
toString field value =
    let
        fieldString =
            case field of
                Leukocytes ->
                    "Leukocytes"

                Nitrite ->
                    "Nitrites"

                Urobilinogen ->
                    "Urobilinogen"

                Protein ->
                    "Protein"

                Blood ->
                    "Blood"

                Ketone ->
                    "Ketones"

                Bilirubin ->
                    "Bilirubin"

                Glucose ->
                    "Glucose"

        valueString =
            case value of
                Negative ->
                    "(-) or normal"

                Positive ->
                    "(++) or raised"
    in
    fieldString ++ ": " ++ valueString


transformY translateString =
    style "transform" ("translateY(" ++ translateString ++ ")")


container transformYValue contents =
    div
        [ tailwind
            [ "relative"
            , "h-6"
            , "w-6"
            , "md:mr-1"
            , "md:h-12"
            , "md:w-12"
            , "md:mr-3"
            , "transition"
            ]
        , transformY transformYValue
        ]
        [ div [ tailwind [ "absolute", "h-6", "md:h-12" ] ] contents ]


viewTile : Bool -> ( Field, Value ) -> Html Msg
viewTile isSolved ( field, value ) =
    let
        negativeTile =
            let
                color =
                    case field of
                        Leukocytes ->
                            "#fcfceb"

                        Nitrite ->
                            "#fffdf5"

                        Urobilinogen ->
                            "#ffe0d6"

                        Protein ->
                            "#f5f593"

                        Blood ->
                            "#eddfa6"

                        Ketone ->
                            "#f5c3b0"

                        Bilirubin ->
                            "#ffeaba"

                        Glucose ->
                            "#c1e6e0"
            in
            div
                [ if value == Positive then
                    onClick (ClickedField field Negative)

                  else
                    onClick NoOp
                , tileTailwind
                , class "tile"
                , attribute "data-tooltip" (toString field Negative)
                , style "background" color
                , tailwind [ "hover-grow" ]
                , classList
                    [ ( "cursor-pointer", value == Positive )
                    , ( "no-scale", value == Negative )
                    ]
                ]
                []

        positiveTile =
            let
                color =
                    case field of
                        Leukocytes ->
                            "#a78cbd"

                        Nitrite ->
                            "#f5c9e2"

                        Urobilinogen ->
                            "#eb91a0"

                        Protein ->
                            "#7bc7be"

                        Blood ->
                            "#709e99"

                        Ketone ->
                            "#a3557d"

                        Bilirubin ->
                            "#d4a38a"

                        Glucose ->
                            "#bd885b"
            in
            div
                [ if value == Negative then
                    onClick (ClickedField field Positive)

                  else
                    onClick NoOp
                , tileTailwind
                , class "tile"
                , attribute "data-tooltip" (toString field Positive)
                , style "background" color
                , tailwind [ "hover-grow" ]
                , classList
                    [ ( "cursor-pointer", value == Negative )
                    , ( "no-scale", value == Positive )
                    ]
                ]
                []
    in
    case value of
        Negative ->
            if isSolved then
                container "-100%"
                    [ div [ tailwind [ "opacity-0", "pointer-events-none" ] ] [ positiveTile ]
                    , div [ tailwind [ "opacity-100" ] ] [ negativeTile ]
                    ]

            else
                container "-100%"
                    [ div [ tailwind [ "opacity-25", "hover-opacity-100" ] ] [ positiveTile ]
                    , div [ tailwind [ "opacity-100" ] ] [ negativeTile ]
                    ]

        Positive ->
            if isSolved then
                container "0%"
                    [ div [ tailwind [ "opacity-100" ] ] [ positiveTile ]
                    , div [ tailwind [ "opacity-0", "pointer-events-none" ] ] [ negativeTile ]
                    ]

            else
                container "0%"
                    [ div [ tailwind [ "opacity-100" ] ] [ positiveTile ]
                    , div [ tailwind [ "opacity-25", "hover-opacity-100" ] ] [ negativeTile ]
                    ]


viewThreeTile : Bool -> ( ThreeField, ThreeValue ) -> Html Msg
viewThreeTile isSolved ( field, value ) =
    let
        lowTile =
            let
                color =
                    case field of
                        Ph ->
                            "#f08a41"

                        Gravity ->
                            "#284e54"
            in
            div
                [ if value == Low then
                    onClick NoOp

                  else
                    onClick (ClickedThreeField field Low)
                , tileTailwind
                , class "tile"
                , attribute "data-tooltip" (threeToString field Low)
                , style "background" color
                , classList
                    [ ( "cursor-pointer", not (value == Low) )
                    , ( "no-scale", value == Low )
                    ]
                ]
                []

        normalTile =
            let
                color =
                    case field of
                        Ph ->
                            "#ced19f"

                        Gravity ->
                            "#b6ba97"
            in
            div
                [ if value == Normal then
                    onClick NoOp

                  else
                    onClick (ClickedThreeField field Normal)
                , tileTailwind
                , class "tile"
                , attribute "data-tooltip" (threeToString field Normal)
                , style "background" color
                , classList
                    [ ( "cursor-pointer", not (value == Normal) )
                    , ( "no-scale", value == Normal )
                    ]
                ]
                []

        highTile =
            let
                color =
                    case field of
                        Ph ->
                            "#0b676e"

                        Gravity ->
                            "#f2a916"
            in
            div
                [ if value == High then
                    onClick NoOp

                  else
                    onClick (ClickedThreeField field High)
                , tileTailwind
                , class "tile"
                , attribute "data-tooltip" (threeToString field High)
                , style "background" color
                , classList
                    [ ( "cursor-pointer", not (value == High) )
                    , ( "no-scale", value == High )
                    ]
                ]
                []
    in
    case value of
        High ->
            if isSolved then
                container "0%"
                    [ div [ tailwind [ "opacity-100" ] ] [ highTile ]
                    , div [ tailwind [ "opacity-0", "pointer-events-none" ] ] [ normalTile ]
                    , div [ tailwind [ "opacity-0", "pointer-events-none" ] ] [ lowTile ]
                    ]

            else
                container "0%"
                    [ div [ tailwind [ "opacity-100" ] ] [ highTile ]
                    , div [ tailwind [ "opacity-25", "hover-opacity-100" ] ] [ normalTile ]
                    , div [ tailwind [ "opacity-25", "hover-opacity-100" ] ] [ lowTile ]
                    ]

        Normal ->
            if isSolved then
                container "-100%"
                    [ div [ tailwind [ "opacity-0", "pointer-events-none" ] ] [ highTile ]
                    , div [ tailwind [ "opacity-100" ] ] [ normalTile ]
                    , div [ tailwind [ "opacity-0", "pointer-events-none" ] ] [ lowTile ]
                    ]

            else
                container "-100%"
                    [ div [ tailwind [ "opacity-25", "hover-opacity-100" ] ] [ highTile ]
                    , div [ tailwind [ "opacity-100" ] ] [ normalTile ]
                    , div [ tailwind [ "opacity-25", "hover-opacity-100" ] ] [ lowTile ]
                    ]

        Low ->
            if isSolved then
                container "-200%"
                    [ div [ tailwind [ "opacity-0", "pointer-events-none" ] ] [ highTile ]
                    , div [ tailwind [ "opacity-0", "pointer-events-none" ] ] [ normalTile ]
                    , div [ tailwind [ "opacity-100" ] ] [ lowTile ]
                    ]

            else
                container "-200%"
                    [ div [ tailwind [ "opacity-25", "hover-opacity-100" ] ] [ highTile ]
                    , div [ tailwind [ "opacity-25", "hover-opacity-100" ] ] [ normalTile ]
                    , div [ tailwind [ "opacity-100" ] ] [ lowTile ]
                    ]


viewDipstick : Bool -> Dipstick -> Html Msg
viewDipstick isSolved dipstick =
    div [ tailwind [ "flex", "justify-center" ] ]
        [ article
            [ tailwind
                [ "flex"
                , "bg-white"
                , "rounded"
                , "shadow-lg"
                ]
            ]
            (List.map (viewTile isSolved)
                [ ( Leukocytes, dipstick.leukocytes )
                , ( Nitrite, dipstick.nitrite )
                , ( Urobilinogen, dipstick.urobilinogen )
                , ( Protein, dipstick.protein )
                ]
                ++ [ viewThreeTile isSolved ( Ph, dipstick.pH ) ]
                ++ [ viewTile isSolved ( Blood, dipstick.blood ) ]
                ++ [ viewThreeTile isSolved ( Gravity, dipstick.specificGravity ) ]
                ++ List.map (viewTile isSolved)
                    [ ( Ketone, dipstick.ketone )
                    , ( Bilirubin, dipstick.bilirubin )
                    , ( Glucose, dipstick.glucose )
                    ]
                ++ [ div [ tailwind [ "w-24", "md:w-48", "lg:w-56" ] ] [] ]
            )
        ]


manufacture : Int -> Int -> Int -> Int -> Int
manufacture a b c d =
    (a * 2 + b ^ 2 + c ^ 3) + d + 52


viewSuccess : LevelData -> Html Msg
viewSuccess level =
    main_
        [ tailwind
            [ "flex"
            , "justify-center"
            , "h-screen"
            , "overflow-hidden"
            , "w-screen"
            , "p-2"
            , "items-center"
            , "bg-gray-200"
            ]
        ]
        [ div []
            [ viewDipstick level.solved level.dipstick
            , section
                [ tailwind
                    [ "lg:h-64"
                    , "mt-32"
                    , "md:h-48"
                    , "overflow-auto"
                    , "rounded-lg"
                    , "shadow-lg"
                    , "text-gray-800"
                    , "p-4"
                    , "bg-white"
                    , "mx-auto"
                    , "fadein"
                    ]
                ]
                [ article [ tailwind [ "w-full", "h-full" ] ]
                    [ div
                        [ tailwind
                            [ "flex"
                            , "flex-col"
                            , "justify-between"
                            , "h-full"
                            , "w-full"
                            , "fadein"
                            ]
                        ]
                        [ p
                            [ tailwind
                                [ "text-blue-500"
                                , "font-bold"
                                , "my-2"
                                ]
                            ]
                            [ text "Congratulations!" ]
                        , p [ tailwind [ "my-2" ] ]
                            [ text "Your digit code is "
                            , strong []
                                [ text
                                    (String.fromInt <|
                                        manufacture level.levelNumber
                                            level.allowedMoves
                                            level.numMoves
                                            (String.length level.stem)
                                    )
                                ]
                            , text " - enter it as your submission :)"
                            ]
                        , button
                            [ tailwind
                                [ "border-blue-500"
                                , "text-blue-500"
                                , "border-2"
                                , "font-bold"
                                , "px-2"
                                , "py-2"
                                , "my-2"
                                , "rounded"
                                , "hover:bg-blue-500"
                                , "hover:text-white"
                                , "cursor-pointer"
                                ]
                            , onClick ClickedRestart
                            ]
                            [ text "RESTART" ]
                        ]
                    ]
                ]
            ]
        ]


viewFailure : LevelData -> Html Msg
viewFailure level =
    main_
        [ tailwind
            [ "flex"
            , "justify-center"
            , "h-screen"
            , "overflow-hidden"
            , "w-screen"
            , "p-2"
            , "items-center"
            , "bg-gray-200"
            ]
        ]
        [ div []
            [ viewDipstick level.solved level.dipstick
            , section
                [ tailwind
                    [ "lg:h-64"
                    , "mt-32"
                    , "md:h-48"
                    , "overflow-auto"
                    , "rounded-lg"
                    , "shadow-lg"
                    , "text-gray-800"
                    , "max-w-4xl"
                    , "p-4"
                    , "bg-white"
                    , "mx-auto"
                    ]
                ]
                [ article []
                    [ div
                        [ tailwind
                            [ "flex"
                            , "justify-between"
                            , "w-full"
                            , "items-center"
                            , "fadein"
                            , "mb-4"
                            ]
                        ]
                        [ p
                            [ tailwind
                                [ "text-red-500"
                                , "font-bold"
                                , "mr-2"
                                ]
                            ]
                            [ text "Unfortunately, that is not correct." ]
                        , button
                            [ tailwind
                                [ "ml-2"
                                , "border-red-500"
                                , "text-red-500"
                                , "border-2"
                                , "font-bold"
                                , "px-2"
                                , "py-1"
                                , "rounded"
                                , "hover:bg-red-500"
                                , "hover:text-white"
                                , "cursor-pointer"
                                ]
                            , onClick ClickedRestart
                            ]
                            [ text "RESTART" ]
                        ]
                    ]
                ]
            ]
        ]


main : Program () Model Msg
main =
    Browser.sandbox
        { init = initialModel
        , view = view
        , update = update
        }
