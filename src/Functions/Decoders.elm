module Functions.Decoders exposing (decodeArchiveData, decodeAuthToken, decodePuzzleData, decodePuzzleSet, decodeRegisterResponse, decodeThemeData)

import Iso8601
import Json.Decode as Decode exposing (..)
import Json.Decode.Pipeline exposing (optional, required)
import Types.Types exposing (..)


decodeAuthToken : Decoder AuthToken
decodeAuthToken =
    field "token" string


decodeArchiveData : Decoder ArchiveData
decodeArchiveData =
    map ArchiveFull <| list decodePuzzleData


decodePuzzleData : Decoder PuzzleData
decodePuzzleData =
    succeed PuzzleData
        |> required "id" int
        |> required "theme" decodeThemeData
        |> required "puzzle_set" decodePuzzleSet
        |> required "title" string
        |> required "body" string
        |> required "example" string
        |> required "statement" string
        |> optional "input" (maybe string) Nothing
        |> optional "answer" (maybe string) Nothing
        |> optional "explanation" (maybe string) Nothing


decodePuzzleSet : Decoder PuzzleSet
decodePuzzleSet =
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
                        succeed S
            )


decodeThemeData : Decoder ThemeData
decodeThemeData =
    map6 ThemeData
        (field "id" int)
        (field "year" int)
        (field "theme" string)
        (field "tagline" string)
        (field "open_datetime" Iso8601.decoder)
        (field "close_datetime" Iso8601.decoder)


decodeRegisterResponse : Decoder String
decodeRegisterResponse =
    succeed "Success! You can now login with your email."
