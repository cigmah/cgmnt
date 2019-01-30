module Decoders exposing (decodeArchiveData, decodePuzzleData, decodePuzzleSet, decodeSendEmail, decodeThemeData, decodeThemeSet)

import Iso8601
import Json.Decode as Decode exposing (..)
import Json.Decode.Pipeline exposing (optional, required)
import Types exposing (..)
import Viewer


decodeArchiveData : Decoder ArchiveData
decodeArchiveData =
    map ArchiveFull <| list decodePuzzleData


decodePuzzleData : Decoder FullPuzzleData
decodePuzzleData =
    succeed FullPuzzleData
        |> required "id" int
        |> required "theme" decodeThemeData
        |> required "puzzle_set" decodePuzzleSet
        |> required "image_link" string
        |> required "title" string
        |> required "body" string
        |> required "example" string
        |> required "statement" string
        |> required "references" string
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
                        fail "Failure"
            )


decodeThemeSet : Decoder ThemeSet
decodeThemeSet =
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


decodeThemeData : Decoder ThemeData
decodeThemeData =
    map7 ThemeData
        (field "id" int)
        (field "year" int)
        (field "theme" string)
        (field "theme_set" decodeThemeSet)
        (field "tagline" string)
        (field "open_datetime" Iso8601.decoder)
        (field "close_datetime" Iso8601.decoder)



--
--decodeActiveData : Decoder ActiveData
--decodeActiveData =
--    map2 ActiveData
--        (field "active" (list decodePuzzleData))
--        (field "next" (maybe decodeThemeData))
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
--decodeLeaderTotal : Decoder LeaderTotalData
--decodeLeaderTotal =
--    list decodeLeaderTotalUser
--
--
--
---- decodeLeaderTotalUser : Decoder LeaderTotalUser
---- decodeLeaderTotalUser =
----     map2 LeaderTotalUser
----         (field "username" string)
----         (field "total" int)
--
--
--decodeLeaderTotalUser : Decoder LeaderTotalUser
--decodeLeaderTotalUser =
--    map2 LeaderTotalUser
--        (field "username" string)
--        (field "total" <| oneOf [ int, map (\str -> unwrapStringInt <| String.toInt str) string ])
--
--
--unwrapStringInt : Maybe Int -> Int
--unwrapStringInt x =
--    case x of
--        Just i ->
--            i
--
--        Nothing ->
--            0
--
--
--decodeUserSubmissions : Decoder UserSubmission
--decodeUserSubmissions =
--    map8 UserSubmission
--        (field "user" <| field "username" string)
--        (field "puzzle" <| field "title" string)
--        (field "puzzle" <| field "theme" <| field "theme" string)
--        (field "puzzle" <| field "puzzle_set" decodePuzzleSet)
--        (field "submission_datetime" Iso8601.decoder)
--        (field "submission" string)
--        (field "is_response_correct" bool)
--        (field "points" int)
--
--
--decodeSubmissionsData : Decoder SubmissionsData
--decodeSubmissionsData =
--    list decodeUserSubmissions
