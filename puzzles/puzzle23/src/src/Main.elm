module Main exposing (Data, Model, Msg(..), State(..), init, main, subscriptions, update, view)

import Array exposing (Array)
import Browser
import Browser.Events
import D exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Decode as Decode exposing (Decoder)
import Random
import Random.List
import Time exposing (Posix)



---- MODEL ----


type State
    = Start
    | Randomising
    | Playing Data
    | Success Data
    | Failure FailureReason Data


type FailureReason
    = Timeout
    | Incorrect


type YearLevel
    = Y1
    | Y2
    | Y3
    | Y4


type alias Data =
    { secondsLeft : Int
    , question : Question
    , remainingQuestions : List Question
    , yearLevel : YearLevel
    }


type alias Model =
    { state : State
    , muted : Bool
    }


init : ( Model, Cmd Msg )
init =
    ( { state = Start, muted = False }, Cmd.none )


initialData : YearLevel -> Question -> List Question -> Data
initialData yearLevel h t =
    { secondsLeft = 60
    , question = h
    , remainingQuestions = t
    , yearLevel = yearLevel
    }



---- UPDATE ----


type Msg
    = NoOp
    | ClickedStart YearLevel
    | GotRandomisedQuestions YearLevel (List Question)
    | ToggledMute
    | ClickedAnswer Bool
    | ClickedRestart
    | Tick Posix


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        ignore =
            ( model, Cmd.none )
    in
    case msg of
        NoOp ->
            ignore

        ClickedStart yearLevel ->
            case model.state of
                Start ->
                    let
                        data =
                            case yearLevel of
                                Y1 ->
                                    D.da

                                Y2 ->
                                    D.db

                                Y3 ->
                                    D.dc

                                Y4 ->
                                    D.dd
                    in
                    ( { model | state = Randomising }
                    , Random.generate (GotRandomisedQuestions yearLevel) (Random.List.shuffle data)
                    )

                _ ->
                    ignore

        GotRandomisedQuestions yearLevel randomisedQuestions ->
            case randomisedQuestions of
                h :: rest ->
                    ( { model | state = Playing (initialData yearLevel h rest) }, Cmd.none )

                _ ->
                    ignore

        ToggledMute ->
            ( { model | muted = not model.muted }, Cmd.none )

        ClickedAnswer response ->
            case model.state of
                Playing data ->
                    if data.question.a == response then
                        case data.remainingQuestions of
                            next :: tail ->
                                ( { model | state = Playing { data | question = next, remainingQuestions = tail } }, Cmd.none )

                            [] ->
                                ( { model | state = Success data }, Cmd.none )

                    else
                        ( { model | state = Failure Incorrect data }, Cmd.none )

                _ ->
                    ignore

        ClickedRestart ->
            case model.state of
                Success _ ->
                    ( { model | state = Start }, Cmd.none )

                Failure _ _ ->
                    ( { model | state = Start }, Cmd.none )

                _ ->
                    ignore

        Tick _ ->
            case model.state of
                Playing data ->
                    let
                        newSecondsLeft =
                            data.secondsLeft - 1
                    in
                    if newSecondsLeft < 1 then
                        ( { model | state = Failure Timeout data }, Cmd.none )

                    else
                        ( { model | state = Playing { data | secondsLeft = newSecondsLeft } }, Cmd.none )

                _ ->
                    ignore



---- VIEW ----


view : Model -> Html Msg
view model =
    case model.state of
        Start ->
            viewStart

        Randomising ->
            viewRandomising

        Playing data ->
            viewPlaying data

        Success data ->
            viewSuccess data

        Failure reason data ->
            viewFailure reason data


tailwind : List String -> Attribute msg
tailwind stringList =
    class <| String.join " " stringList


buttonTailwind =
    tailwind
        [ "h-full"
        , "w-full"
        , "border-blue-400"
        , "border-2"
        , "mb-2"
        , "p-2"
        , "rounded-lg"
        , "text-xl"
        , "text-blue-400"
        , "font-bold"
        , "bg-gray-100"
        , "hover:bg-blue-400"
        , "hover:text-gray-100"
        ]


viewStart : Html Msg
viewStart =
    section
        [ tailwind [ "h-screen", "w-screen", "bg-gray-200", "overflow-none", "flex-col", "flex", "justify-center", "items-center", "p-2" ] ]
        [ div [ tailwind [ "max-w-lg" ] ]
            [ div
                [ tailwind [ "rounded-b", "shadow-md", "p-4", "border-blue-400", "border-t-4", "bg-gray-100" ] ]
                [ h1 [ tailwind [ "uppercase", "mb-4" ] ] [ text "Run!" ]
                , p [ tailwind [ "mb-4" ] ]
                    [ text "You're being chased! You have "
                    , strong [] [ text " 60 seconds " ]
                    , text "to escape by answering"
                    , strong [] [ text " 40 True or False medical questions " ]
                    , text "correctly in a row. If you make a mistake, you'll stumble and be caught - so be careful. Good luck!"
                    ]
                ]
            , div
                [ tailwind [ "mt-4", "fadein" ] ]
                [ button
                    [ onClick <| ClickedStart Y1
                    , buttonTailwind
                    ]
                    [ text "Year 1 (Puzzle 23A)" ]
                , button
                    [ onClick <| ClickedStart Y2
                    , buttonTailwind
                    ]
                    [ text "Year 2 (Puzzle 23A)" ]
                , button
                    [ onClick <| ClickedStart Y3
                    , buttonTailwind
                    ]
                    [ text "Year 3 (Puzzle 24B)" ]
                , button
                    [ onClick <| ClickedStart Y4
                    , buttonTailwind
                    ]
                    [ text "Year 4 (Puzzle 24B)" ]
                ]
            ]
        ]


viewRandomising : Html Msg
viewRandomising =
    section
        [ tailwind [ "h-screen", "w-screen", "flex", "justify-center", "items-center", "p-4", "bg-gray-200" ] ]
        [ text "Loading..." ]


viewPlaying : Data -> Html Msg
viewPlaying data =
    section
        [ tailwind [ "h-screen", "w-screen", "overflow-hidden", "flex", "flex-col", "sm:p-4", "bg-gray-200" ] ]
        [ article [] [ viewProgress data ]
        , article [ tailwind [ "flex-grow", "p-2", "sm:p-4" ] ] [ viewQuestion data ]
        , article [] [ viewControls data ]
        ]


viewProgress : Data -> Html Msg
viewProgress data =
    let
        percent =
            round <| 100 * toFloat data.secondsLeft / 60

        color =
            if percent < 10 then
                "bg-red-400"

            else if percent < 25 then
                "bg-orange-400"

            else
                "bg-blue-400"
    in
    div
        [ tailwind [ "sm:p-2", "w-full" ] ]
        [ div [ tailwind [ color, "h-8", "sm:rounded", "full" ], style "width" (String.fromInt percent ++ "%") ] [] ]


encouragements : Array String
encouragements =
    Array.fromList
        [ "You can do it!"
        , "Awesome!"
        , "Super good!"
        , "I believe in you!"
        , "Great stuff!"
        , "Brilliant!"
        , "What a legend!"
        , "Good job!"
        , "Just a bit more!"
        , "Fantastic!"
        , "Amazing!"
        , "Keep at it!"
        ]


viewQuestion : Data -> Html Msg
viewQuestion data =
    let
        encouragement =
            Array.get (modBy 10 <| List.length data.remainingQuestions) encouragements
                |> Maybe.withDefault "Wonderful!"
    in
    article
        [ tailwind [ "h-full", "rounded-lg", "sm:shadow-lg", "shadow", "bg-white", "p-2", "sm:p-8", "overflow-auto", "flex", "flex-col" ] ]
        [ p [ tailwind [ "text-gray-600", "flex", "justify-between", "sm:text-2xl", "sm:mb-16", "mb-8" ] ]
            [ div [] [ text <| (String.fromInt <| 1 + List.length data.remainingQuestions) ++ " questions left." ], div [] [ text encouragement ] ]
        , p [ tailwind [ "sm:text-4xl", "text-2xl", "text-blue-500", "font-semibold", "flex-grow", "sm:p-8", "max-w-6xl", "m-auto" ] ] [ text data.question.q ]
        ]


viewControls : Data -> Html Msg
viewControls data =
    div
        [ tailwind [ "flex" ] ]
        [ button [ buttonTailwind, tailwind [ "m-2" ], onClick <| ClickedAnswer False ]
            [ div [ tailwind [ "sm:text-2xl", "uppercase" ] ] [ text "False" ], div [ tailwind [ "text-sm" ] ] [ text "(Left Arrow Key)" ] ]
        , button [ buttonTailwind, tailwind [ "m-2" ], onClick <| ClickedAnswer True ]
            [ div [ tailwind [ "sm:text-2xl", "uppercase" ] ] [ text "True" ], div [ tailwind [ "text-sm" ] ] [ text "(Right Arrow Key)" ] ]
        ]


swish : String -> String
swish s =
    s
        |> String.words
        |> List.sort
        |> List.reverse
        |> List.drop 5
        |> List.head
        |> Maybe.withDefault "hm."
        |> String.toUpper
        |> String.reverse


proc : Int -> List Question -> String
proc i d =
    Array.get i (Array.fromList d)
        |> Maybe.map .e
        |> Maybe.withDefault "hm."
        |> swish


a1 : String
a1 =
    proc 37 db ++ proc 17 da


a2 : String
a2 =
    proc 19 dc ++ proc 4 db


viewSuccess : Data -> Html Msg
viewSuccess data =
    let
        puzzle =
            case data.yearLevel of
                Y1 ->
                    "23A"

                Y2 ->
                    "23A"

                Y3 ->
                    "24B"

                Y4 ->
                    "24B"

        a =
            case data.yearLevel of
                Y1 ->
                    a1

                Y2 ->
                    a1

                Y3 ->
                    a2

                Y4 ->
                    a2
    in
    div
        [ tailwind [ "h-screen", "w-screen", "overflow-auto", "flex", "flex-col", "sm:p-8", "sm:p-2", "bg-gray-200", "sm:justify-center", "sm:items-center" ] ]
        [ article
            []
            [ h1 [ tailwind [ "sm:text-4xl", "text-xl", "sm:text-green-400", "font-semibold", "sm:bg-transparent", "text-white", "bg-green-400", "p-2", "sm:p-0" ] ]
                [ text "Congratulations, you did it! :)" ]
            , article [ tailwind [ "max-w-4xl", "shadow", "sm:shadow-lg", "rounded", "bg-white", "p-2", "py-8", "sm:p-8", "mx-2", "sm:mx-0", "my-4", "text-lg" ] ]
                [ p [ tailwind [ "text-gray-600", "mb-4", "text-xl" ] ] [ text "Submit:" ]
                , p [ tailwind [ "text-4xl", "font-bold", "mb-4" ] ] [ text a ]
                , p [ tailwind [ "text-gray-600", "text-xl" ] ] [ text <| "as your answer to Puzzle " ++ puzzle ++ " :)" ]
                ]
            , div [ tailwind [ "sm:mt-8", "m-2", "sm:mx-0" ] ] [ button [ buttonTailwind, onClick ClickedRestart ] [ text "Restart" ] ]
            ]
        ]


viewFailure : FailureReason -> Data -> Html Msg
viewFailure reason data =
    case reason of
        Timeout ->
            div
                [ tailwind [ "h-screen", "w-screen", "overflow-auto", "flex", "flex-col", "sm:p-8", "sm:p-2", "bg-gray-200", "sm:justify-center", "sm:items-center" ]
                ]
                [ article
                    []
                    [ h1 [ tailwind [ "sm:text-4xl", "text-xl", "sm:text-red-400", "font-semibold", "sm:bg-transparent", "text-white", "bg-red-400", "p-2", "sm:p-0" ] ]
                        [ text "You ", span [ tailwind [ "italic" ] ] [ text "ran" ], text " out of time :O" ]
                    , div [ tailwind [ "mt-8", "sm:mx-0", "m-2" ] ] [ button [ buttonTailwind, onClick ClickedRestart ] [ text "Restart" ] ]
                    ]
                ]

        Incorrect ->
            let
                correctText =
                    if data.question.a then
                        "True"

                    else
                        "False"
            in
            div
                [ tailwind [ "h-screen", "w-screen", "overflow-auto", "flex", "flex-col", "sm:p-8", "sm:p-2", "bg-gray-200", "sm:justify-center", "sm:items-center" ] ]
                [ article
                    []
                    [ h1 [ tailwind [ "sm:text-4xl", "text-xl", "sm:text-red-400", "font-semibold", "sm:bg-transparent", "text-white", "bg-red-400", "p-2", "sm:p-0" ] ]
                        [ text "Unfortunately, that was incorrect :(" ]
                    , article [ tailwind [ "max-w-4xl", "shadow", "sm:shadow-lg", "rounded", "bg-white", "sm:p-8", "p-4", "py-8", "sm:mx-0", "mx-2", "my-4", "sm:text-lg" ] ]
                        [ p [ tailwind [ "text-gray-600", "font-semibold", "mb-4", "text-lg", "sm:text-2xl" ] ] [ text "\"", text data.question.q, text "\"" ]
                        , p [ tailwind [ "text-normal", "sm:text-xl", "mb-4" ] ] [ text "The correct answer is ", span [ tailwind [ "font-semibold" ] ] [ text correctText ], text "." ]
                        , p [ tailwind [ "sm:text-center", "text-left" ] ] [ text data.question.e ]
                        ]
                    , div [ tailwind [ "sm:mt-8", "m-2", "sm:mx-0" ] ] [ button [ buttonTailwind, onClick ClickedRestart ] [ text "Restart" ] ]
                    ]
                ]


decodeKey : Decoder Msg
decodeKey =
    Decode.field "key" Decode.string
        |> Decode.map toMsg


toMsg : String -> Msg
toMsg string =
    case string of
        "ArrowLeft" ->
            ClickedAnswer False

        "Left" ->
            ClickedAnswer False

        "ArrowRight" ->
            ClickedAnswer True

        "Right" ->
            ClickedAnswer True

        _ ->
            NoOp


subscriptions : Model -> Sub Msg
subscriptions model =
    case model.state of
        Playing _ ->
            Sub.batch
                [ Browser.Events.onKeyDown decodeKey
                , Time.every 1000 Tick
                ]

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
