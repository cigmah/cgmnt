module Decoders exposing (decodeSendEmail, decoderArchiveData, decoderPuzzleData, decoderPuzzleSet, decoderThemeData, decoderThemeSet)

import Iso8601
import Json.Decode as Decode exposing (..)
import Json.Decode.Pipeline exposing (optional, required)
import Types exposing (..)
import Viewer


decoderArchiveData : Decoder ArchiveData
decoderArchiveData =
    map ArchiveFull <| list decoderPuzzleData


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
        |> optional "answer" (maybe string) Nothing
        |> optional "explanation" (maybe string) Nothing


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



--
--decodeActiveData : Decoder ActiveData
--decodeActiveData =
--    map2 ActiveData
--        (field "active" (list decoderPuzzleData))
--        (field "next" (maybe decoderThemeData))
--
--
--decodePuzzlesData : Decoder PuzzlesData
--decodePuzzlesData =
--    map PuzzlesAll decodeActiveData
--
--
--decodeRegisterResponse : Decoder String
--decodeRegisterResponse =
--    succeed "Success! You can now login with your email."
--
--


decodeSendEmail =
    succeed "A login token was sent to your email!"



--
--
--
--
--
--
--
--
--
-- decodeLeaderTotalUser : Decoder LeaderTotalUser
---- decodeLeaderTotalUser =
----     map2 LeaderTotalUser
----         (field "username" string)
----         (field "total" int)
--
--
--
--
--
--
--decodeUserSubmissions : Decoder UserSubmission
--decodeUserSubmissions =
--    map8 UserSubmission
--        (field "user" <| field "username" string)
--        (field "puzzle" <| field "title" string)
--        (field "puzzle" <| field "theme" <| field "theme" string)
--        (field "puzzle" <| field "puzzle_set" decoderPuzzleSet)
--        (field "submission_datetime" Iso8601.decoder)
--        (field "submission" string)
--        (field "is_response_correct" bool)
--        (field "points" int)
--
--
--decodeSubmissionsData : Decoder SubmissionsData
--decodeSubmissionsData =
--    list decodeUserSubmissions
