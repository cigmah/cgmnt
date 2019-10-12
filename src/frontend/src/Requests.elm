module Requests exposing (authConfig, authHeader, buildUrl, decoderCredentials, decoderDetailPuzzleData, decoderLeaderboardByPuzzle, decoderLeaderboardBySet, decoderLeaderboardByTotal, decoderMiniPuzzleData, decoderPrizeData, decoderProfileData, decoderPuzzleList, decoderPuzzlePageData, decoderPuzzleSet, decoderRegisterResponse, decoderSendEmailResponse, decoderSubmissionData, decoderSubmissionResponse, decoderThemeData, decoderTooSoonSubmit, decoderUserData, encodeCredentials, encodeEmail, encodeRegister, encodeSubmission, encodeToken, getLeaderboardByPuzzle, getLeaderboardBySet, getLeaderboardByTotal, getNoAuth, getPrizeList, getProfile, getPuzzleDetailPublic, getPuzzleDetailUser, getPuzzleListPublic, getPuzzleListPublicforLeaderboard, getPuzzleListUser, getWithAuth, noAuthConfig, noInputString, postLogin, postNoAuth, postRegister, postSendEmail, postSubmit, postWithAuth)

import ApiBase exposing (apiBase)
import Http as ElmHttp exposing (header)
import Iso8601
import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline exposing (optional, required)
import Json.Encode as Encode
import RemoteData exposing (RemoteData(..), WebData)
import RemoteData.Http as Http exposing (Config)
import Types exposing (..)
import Url.Builder as Builder


authHeader token =
    header "Authorization" <| "Token " ++ token


noAuthConfig : Config
noAuthConfig =
    { headers = []
    , withCredentials = False
    , timeout = Nothing
    }


authConfig : AuthToken -> Config
authConfig token =
    { headers = [ authHeader token ]
    , withCredentials = False
    , timeout = Nothing
    }



-- Encoders


encodeSubmission : Submission -> Encode.Value
encodeSubmission v =
    Encode.object [ ( "submission", Encode.string v ) ]


encodeRegister : UserData -> Encode.Value
encodeRegister v =
    Encode.object
        [ ( "username", Encode.string v.username )
        , ( "email", Encode.string v.email )
        , ( "first_name", Encode.string v.firstName )
        , ( "last_name", Encode.string v.lastName )
        ]


encodeCredentials : Credentials -> Encode.Value
encodeCredentials v =
    Encode.object
        [ ( "username", Encode.string v.username )
        , ( "email", Encode.string v.email )
        , ( "first_name", Encode.string v.firstName )
        , ( "last_name", Encode.string v.lastName )
        , ( "token", Encode.string v.token )
        ]


encodeEmail : Email -> Encode.Value
encodeEmail v =
    Encode.object [ ( "email", Encode.string v ) ]


encodeToken : Token -> Encode.Value
encodeToken v =
    Encode.object [ ( "token", Encode.string v ) ]


decoderUserData : Decoder UserData
decoderUserData =
    Decode.map4 UserData
        (Decode.field "username" Decode.string)
        (Decode.field "email" Decode.string)
        (Decode.field "first_name" Decode.string)
        (Decode.field "last_name" Decode.string)


decoderCredentials : Decoder Credentials
decoderCredentials =
    Decode.map5 Credentials
        (Decode.field "username" Decode.string)
        (Decode.field "email" Decode.string)
        (Decode.field "first_name" Decode.string)
        (Decode.field "last_name" Decode.string)
        (Decode.field "token" Decode.string)


decoderPrizeData : Decoder PrizeData
decoderPrizeData =
    Decode.list
        (Decode.map4 Prize
            (Decode.field "username" Decode.string)
            (Decode.field "prize_type"
                (Decode.string
                    |> Decode.andThen
                        (\string ->
                            case string of
                                "A" ->
                                    Decode.succeed AbstractPrize

                                "B" ->
                                    Decode.succeed BeginnerPrize

                                "C" ->
                                    Decode.succeed ChallengePrize

                                "P" ->
                                    Decode.succeed PuzzlePrize

                                "G" ->
                                    Decode.succeed GrandPrize

                                _ ->
                                    Decode.fail "Invalid PrizeType"
                        )
                )
            )
            (Decode.field "awarded_datetime" Iso8601.decoder)
            (Decode.field "note" Decode.string)
        )


decoderPuzzleSet : Decoder PuzzleSet
decoderPuzzleSet =
    Decode.string
        |> Decode.andThen
            (\string ->
                case string of
                    "A" ->
                        Decode.succeed AbstractPuzzle

                    "B" ->
                        Decode.succeed BeginnerPuzzle

                    "C" ->
                        Decode.succeed ChallengePuzzle

                    "M" ->
                        Decode.succeed MetaPuzzle

                    _ ->
                        Decode.fail "Invalid PuzzleSet"
            )


decoderMiniPuzzleData : Decoder MiniPuzzleData
decoderMiniPuzzleData =
    Decode.map6 MiniPuzzleData
        (Decode.field "id" Decode.int)
        (Decode.field "theme" Decode.string)
        (Decode.field "puzzle_set" decoderPuzzleSet)
        (Decode.field "title" Decode.string)
        (Decode.field "image_link" Decode.string)
        (Decode.maybe (Decode.field "is_solved" Decode.bool))


decoderPuzzlePageData : Decoder PuzzlePageData
decoderPuzzlePageData =
    Decode.map2 PuzzlePageData
        (Decode.field "puzzles" (Decode.list decoderMiniPuzzleData))
        (Decode.field "next" decoderThemeData)


decoderPuzzleList : Decoder (List MiniPuzzleData)
decoderPuzzleList =
    Decode.field "puzzles" (Decode.list decoderMiniPuzzleData)


noInputString =
    "There aren't extra materials for this puzzle - you have everything you need!"


decoderVideoLink : Decoder (Maybe String)
decoderVideoLink =
    Decode.string
        |> Decode.andThen
            (\string ->
                case string of
                    "" ->
                        Decode.succeed Nothing

                    link ->
                        Decode.succeed (Just link)
            )


decoderDetailPuzzleData : Decoder DetailPuzzleData
decoderDetailPuzzleData =
    Decode.succeed DetailPuzzleData
        |> required "id" Decode.int
        |> required "puzzle_set" decoderPuzzleSet
        |> required "theme" decoderThemeData
        |> required "title" Decode.string
        |> required "video_link" decoderVideoLink
        |> required "image_link" Decode.string
        |> required "body" Decode.string
        |> required "example" Decode.string
        |> required "statement" Decode.string
        |> required "references" Decode.string
        |> optional "puzzle_input" Decode.string noInputString
        |> optional "is_solved" (Decode.maybe Decode.bool) Nothing
        |> optional "answer" (Decode.maybe Decode.string) Nothing
        |> optional "explanation" (Decode.maybe Decode.string) Nothing


decoderSubmissionData : Decoder SubmissionData
decoderSubmissionData =
    Decode.map7 SubmissionData
        (Decode.field "id" Decode.int)
        (Decode.at [ "user", "username" ] Decode.string)
        (Decode.field "puzzle" decoderMiniPuzzleData)
        (Decode.field "submission_datetime" Iso8601.decoder)
        (Decode.field "submission" Decode.string)
        (Decode.field "is_response_correct" Decode.bool)
        (Decode.field "points" Decode.int)


decoderThemeData : Decoder ThemeData
decoderThemeData =
    Decode.map5 ThemeData
        (Decode.field "id" Decode.int)
        (Decode.field "theme" Decode.string)
        (Decode.field "theme_set"
            (Decode.string
                |> Decode.andThen
                    (\string ->
                        case string of
                            "R" ->
                                Decode.succeed RegularTheme

                            "M" ->
                                Decode.succeed MetaTheme

                            "S" ->
                                Decode.succeed SampleTheme

                            _ ->
                                Decode.fail "Invalid ThemeSet"
                    )
            )
        )
        (Decode.field "tagline" Decode.string)
        (Decode.field "open_datetime" Iso8601.decoder)


decoderProfileData : Decoder ProfileData
decoderProfileData =
    Decode.map3 ProfileData
        (Decode.field "submissions" (Decode.list decoderSubmissionData))
        (Decode.field "num_solved" Decode.int)
        (Decode.field "points" Decode.int)


decoderSubmissionResponse : Decoder SubmissionResponseData
decoderSubmissionResponse =
    Decode.map OkSubmit <|
        Decode.map4
            OkSubmitData
            (Decode.field "id" Decode.int)
            (Decode.field "submission" Decode.string)
            (Decode.field "is_response_correct" Decode.bool)
            (Decode.field "points" Decode.int)


decoderTooSoonSubmit : Decoder TooSoonSubmitData
decoderTooSoonSubmit =
    Decode.map5 TooSoonSubmitData
        (Decode.field "message" Decode.string)
        (Decode.field "num_attempts" Decode.int)
        (Decode.field "last_submission" Iso8601.decoder)
        (Decode.field "wait_time_seconds" Decode.int)
        (Decode.field "next_allowed" Iso8601.decoder)


decoderLeaderboardByTotal : Decoder LeaderTotalData
decoderLeaderboardByTotal =
    Decode.list
        (Decode.map2 LeaderTotalUnit
            (Decode.field "username" Decode.string)
            (Decode.field "total" Decode.int)
        )


decoderLeaderboardByPuzzle : Decoder LeaderPuzzleData
decoderLeaderboardByPuzzle =
    Decode.list
        (Decode.map4 LeaderPuzzleUnit
            (Decode.field "username" Decode.string)
            (Decode.field "puzzle" Decode.string)
            (Decode.field "submission_datetime" Iso8601.decoder)
            (Decode.field "points" Decode.int)
        )


decoderLeaderboardBySet : Decoder LeaderSetData
decoderLeaderboardBySet =
    Decode.list
        (Decode.map3 LeaderSetUnit
            (Decode.field "puzzle_set" decoderPuzzleSet)
            (Decode.field "username" Decode.string)
            (Decode.field "total" Decode.int)
        )


decoderRegisterResponse : Decoder RegisterResponseData
decoderRegisterResponse =
    Decode.succeed "Thanks for registering for the 2019 Puzzle Hunt - you can try logging in now, just head over to the login tab!"


decoderSendEmailResponse : Decoder SendEmailResponseData
decoderSendEmailResponse =
    Decode.succeed "Email sent!"



-- Helpers


buildUrl : List String -> String
buildUrl stringList =
    Builder.crossOrigin apiBase stringList [] |> (\x -> String.append x "/")


getNoAuth : List String -> (WebData a -> Msg) -> Decoder a -> Cmd Msg
getNoAuth stringList function aDecoder =
    Http.getWithConfig noAuthConfig (buildUrl stringList) function aDecoder


postNoAuth : List String -> (WebData a -> Msg) -> Decoder a -> Decode.Value -> Cmd Msg
postNoAuth stringList function aDecoder valueDecode =
    Http.post (buildUrl stringList) function aDecoder valueDecode


getWithAuth : AuthToken -> List String -> (WebData a -> Msg) -> Decoder a -> Cmd Msg
getWithAuth authToken stringList function aDecoder =
    Http.getWithConfig (authConfig authToken) (buildUrl stringList) function aDecoder


postWithAuth : AuthToken -> List String -> (WebData a -> Msg) -> Decoder a -> Decode.Value -> Cmd Msg
postWithAuth authToken stringList function aDecoder valueDecode =
    Http.postWithConfig (authConfig authToken) (buildUrl stringList) function aDecoder valueDecode



-- Requests


getProfile : AuthToken -> Cmd Msg
getProfile authToken =
    getWithAuth authToken [ "profile" ] HomeGotProfileResponse decoderProfileData


getPrizeList : Cmd Msg
getPrizeList =
    getNoAuth [ "prizes" ] PrizesGotResponse decoderPrizeData


getPuzzleListPublic : Cmd Msg
getPuzzleListPublic =
    getNoAuth [ "puzzles" ] PuzzleListPublicGotResponse decoderPuzzlePageData


getPuzzleListPublicforLeaderboard : Cmd Msg
getPuzzleListPublicforLeaderboard =
    getNoAuth [ "puzzles" ] LeaderboardGotPuzzleOptions decoderPuzzleList


getPuzzleListUser : AuthToken -> Cmd Msg
getPuzzleListUser authToken =
    getWithAuth authToken [ "puzzles" ] PuzzleListUserGotResponse decoderPuzzlePageData


getPuzzleDetailPublic : PuzzleId -> Cmd Msg
getPuzzleDetailPublic puzzleId =
    getNoAuth [ "puzzles", String.fromInt puzzleId ] PuzzleDetailGotPublic decoderDetailPuzzleData


getPuzzleDetailUser : PuzzleId -> AuthToken -> Cmd Msg
getPuzzleDetailUser puzzleId authToken =
    getWithAuth authToken [ "puzzles", String.fromInt puzzleId ] PuzzleDetailGotUser decoderDetailPuzzleData


postSubmit : AuthToken -> Submission -> PuzzleId -> Cmd Msg
postSubmit authToken submission puzzleId =
    postWithAuth authToken [ "submissions", String.fromInt puzzleId ] PuzzleDetailGotSubmissionResponse decoderSubmissionResponse (encodeSubmission submission)


getLeaderboardByTotal : Cmd Msg
getLeaderboardByTotal =
    getNoAuth [ "leaderboard" ] LeaderboardGotByTotal decoderLeaderboardByTotal


getLeaderboardByPuzzle : PuzzleId -> Cmd Msg
getLeaderboardByPuzzle puzzleId =
    getNoAuth [ "leaderboard", "puzzle", String.fromInt puzzleId ] LeaderboardGotByPuzzle decoderLeaderboardByPuzzle


getLeaderboardBySet : PuzzleSet -> Cmd Msg
getLeaderboardBySet puzzleSet =
    let
        setString =
            case puzzleSet of
                AbstractPuzzle ->
                    "A"

                BeginnerPuzzle ->
                    "B"

                ChallengePuzzle ->
                    "C"

                MetaPuzzle ->
                    "M"
    in
    getNoAuth [ "leaderboard", "set", setString ] LeaderboardGotBySet decoderLeaderboardBySet


postRegister : UserData -> Cmd Msg
postRegister userData =
    postNoAuth [ "users" ] RegisterGotResponse decoderRegisterResponse (encodeRegister userData)


postSendEmail : Email -> Cmd Msg
postSendEmail email =
    postNoAuth [ "auth", "email" ] LoginGotSendEmailResponse decoderSendEmailResponse (encodeEmail email)


postLogin : Token -> Cmd Msg
postLogin token =
    postNoAuth [ "callback", "auth" ] LoginGotLoginResponse decoderCredentials (encodeToken token)