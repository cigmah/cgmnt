module Functions.Decoders exposing (decodeActiveData, decodeArchiveData, decodeAuthToken, decodeLogin, decodeOkSubmit, decodePuzzleData, decodePuzzleSet, decodePuzzlesData, decodeRegisterResponse, decodeSendEmail, decodeSubmissionResponse, decodeThemeData, decodeTooSoonSubmit)

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


decodeActiveData : Decoder ActiveData
decodeActiveData =
    map2 ActiveData
        (field "active" (list decodePuzzleData))
        (field "next" (maybe decodeThemeData))


decodePuzzlesData : Decoder PuzzlesData
decodePuzzlesData =
    map PuzzlesAll decodeActiveData


decodeRegisterResponse : Decoder String
decodeRegisterResponse =
    succeed "Success! You can now login with your email."


decodeSendEmail =
    succeed "A login token was sent to your email!"


decodeLogin =
    succeed "Login was successful!"


decodeOkSubmit : Decoder OkSubmitData
decodeOkSubmit =
    map4 OkSubmitData
        (field "id" int)
        (field "submission" string)
        (field "is_response_correct" bool)
        (field "points" int)


decodeTooSoonSubmit : Decoder TooSoonSubmitData
decodeTooSoonSubmit =
    map5 TooSoonSubmitData
        (field "message" string)
        (field "num_attempts" int)
        (field "last_submission" Iso8601.decoder)
        (field "wait_time_seconds" int)
        (field "next_allowed" Iso8601.decoder)


decodeSubmissionResponse : Decoder SubmissionResponse
decodeSubmissionResponse =
    map OkSubmit decodeOkSubmit
