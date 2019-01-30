module Decoders exposing (decoderArchiveData, decoderLeaderTotal, decoderLeaderTotalUnit, decoderPuzzleData, decoderPuzzleSet, decoderThemeData, decoderThemeSet)

import Iso8601
import Json.Decode as Decode exposing (..)
import Json.Decode.Pipeline exposing (optional, required)
import Types exposing (..)
import Viewer


decoderArchiveData : Decoder (List FullPuzzleData)
decoderArchiveData =
    list decoderPuzzleData


decoderPuzzleData : Decoder FullPuzzleData
decoderPuzzleData =
    succeed FullPuzzleData
        |> required "id" int
        |> required "theme" decoderThemeData
        |> required "puzzle_set" decoderPuzzleSet
        |> required "image_link" string
        |> required "title" string
        |> required "body" string
        |> required "example" string
        |> required "statement" string
        |> required "references" string
        |> optional "input" (maybe string) Nothing
        |> required "answer" string
        |> required "explanation" string


unwrapStringInt : Maybe Int -> Int
unwrapStringInt x =
    case x of
        Just i ->
            i

        Nothing ->
            0


decoderPuzzleSet : Decoder PuzzleSet
decoderPuzzleSet =
    string
        |> andThen
            (\str ->
                case str of
                    "A" ->
                        succeed A

                    "B" ->
                        succeed B

                    "C" ->
                        succeed C

                    "M" ->
                        succeed M

                    _ ->
                        fail "Failure"
            )


decoderThemeSet : Decoder ThemeSet
decoderThemeSet =
    string
        |> andThen
            (\string ->
                case string of
                    "R" ->
                        succeed RTheme

                    "M" ->
                        succeed MTheme

                    "S" ->
                        succeed STheme

                    _ ->
                        fail "Invalid ThemeSet"
            )


decoderThemeData : Decoder ThemeData
decoderThemeData =
    map7 ThemeData
        (field "id" int)
        (field "year" int)
        (field "theme" string)
        (field "theme_set" decoderThemeSet)
        (field "tagline" string)
        (field "open_datetime" Iso8601.decoder)
        (field "close_datetime" Iso8601.decoder)


decoderLeaderTotalUnit : Decoder LeaderTotalUnit
decoderLeaderTotalUnit =
    Decode.map2 LeaderTotalUnit
        (Decode.field "username" Decode.string)
        (Decode.field "total" <|
            Decode.oneOf
                [ Decode.int
                , Decode.map (\str -> unwrapStringInt <| String.toInt str) Decode.string
                ]
        )


decoderLeaderTotal : Decoder LeaderTotalData
decoderLeaderTotal =
    Decode.list decoderLeaderTotalUnit
