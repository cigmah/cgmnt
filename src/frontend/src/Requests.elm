module Requests exposing (authConfig, authHeader, buildUrl, decoderComment, decoderCommentResponse, decoderContactResponse, decoderCredentials, decoderFullUser, decoderHomeData, decoderLeaderboard, decoderPrizeData, decoderPuzzleDetail, decoderPuzzleMini, decoderPuzzleSet, decoderPuzzleStats, decoderRegisterResponse, decoderSendEmailResponse, decoderSubmissionData, decoderSubmissionResponse, decoderThemeData, decoderTooSoonSubmit, decoderUserStats, decoderVideoLink, encodeComment, encodeContact, encodeCredentials, encodeEmail, encodeRegister, encodeSubmission, encodeToken, getHomeDataPublic, getHomeDataUser, getLeaderboard, getNoAuth, getPrizeList, getPuzzlePublic, getPuzzleUser, getStatsPublic, getStatsUser, getWithAuth, noAuthConfig, noInputString, postComment, postContact, postLogin, postNoAuth, postRegister, postSendEmail, postSubmit, postWithAuth)

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


encodeRegister : FullUser -> Encode.Value
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
        , ( "token", Encode.string v.authToken )
        ]


encodeEmail : Email -> Encode.Value
encodeEmail v =
    Encode.object [ ( "email", Encode.string v ) ]


encodeToken : EmailToken -> Encode.Value
encodeToken v =
    Encode.object [ ( "token", Encode.string v ) ]


encodeComment : String -> Encode.Value
encodeComment v =
    Encode.object [ ( "comment", Encode.string v ) ]


encodeContact : ContactData -> Encode.Value
encodeContact v =
    Encode.object
        [ ( "name", Encode.string v.name )
        , ( "email", Encode.string v.email )
        , ( "subject", Encode.string v.subject )
        , ( "body", Encode.string v.body )
        ]



-- DECODERS


decoderFullUser : Decoder FullUser
decoderFullUser =
    Decode.map4 FullUser
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


decoderPrizeData : Decoder (List Prize)
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


decoderPuzzleMini : Decoder PuzzleMini
decoderPuzzleMini =
    Decode.map5 PuzzleMini
        (Decode.field "id" Decode.int)
        (Decode.field "theme" decoderThemeData)
        (Decode.field "puzzle_set" decoderPuzzleSet)
        (Decode.field "title" Decode.string)
        (Decode.maybe (Decode.field "is_solved" Decode.bool))


decoderHomeData : Decoder HomeData
decoderHomeData =
    Decode.map4 HomeData
        (Decode.field "puzzles" (Decode.list decoderPuzzleMini))
        (Decode.field "next" decoderThemeData)
        (Decode.field "num_registrations" Decode.int)
        (Decode.field "num_submissions" Decode.int)


decoderUserStats : Decoder UserStats
decoderUserStats =
    Decode.succeed UserStats
        |> required "username" Decode.string
        |> required "num_submit" Decode.int
        |> required "num_solved" Decode.int
        |> required "points" Decode.int
        |> required "rank" Decode.int
        |> required "num_prizes" Decode.int
        |> optional "submissions" (Decode.maybe <| Decode.list decoderSubmissionData) Nothing


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


decoderPuzzleDetail : Decoder PuzzleDetail
decoderPuzzleDetail =
    Decode.succeed PuzzleDetail
        |> required "id" Decode.int
        |> required "puzzle_set" decoderPuzzleSet
        |> required "theme" decoderThemeData
        |> required "title" Decode.string
        |> required "body" Decode.string
        |> optional "puzzle_input" Decode.string noInputString
        |> required "statement" Decode.string
        |> required "references" Decode.string
        |> required "stats" decoderPuzzleStats
        |> optional "answer" (Decode.maybe Decode.string) Nothing
        |> optional "explanation" (Decode.maybe Decode.string) Nothing
        |> optional "comments" (Decode.maybe (Decode.list decoderComment)) Nothing


decoderPuzzleStats : Decoder PuzzleStats
decoderPuzzleStats =
    Decode.map3 PuzzleStats
        (Decode.field "correct" Decode.int)
        (Decode.field "incorrect" Decode.int)
        (Decode.field "leaderboard"
            (Decode.list
                (Decode.map2 PuzzleLeaderboardUnit
                    (Decode.field "username" Decode.string)
                    (Decode.field "submission_datetime" Iso8601.decoder)
                )
            )
        )


decoderComment : Decoder Comment
decoderComment =
    Decode.map3 Comment
        (Decode.field "username" Decode.string)
        (Decode.field "timestamp" Iso8601.decoder)
        (Decode.field "comment" Decode.string)


decoderSubmissionData : Decoder SubmissionData
decoderSubmissionData =
    Decode.map7 SubmissionData
        (Decode.field "id" Decode.int)
        (Decode.at [ "user", "username" ] Decode.string)
        (Decode.field "puzzle" decoderPuzzleMini)
        (Decode.field "submission_datetime" Iso8601.decoder)
        (Decode.field "submission" Decode.string)
        (Decode.field "is_response_correct" Decode.bool)
        (Decode.field "points" Decode.int)


decoderThemeData : Decoder Theme
decoderThemeData =
    Decode.map5 Theme
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


decoderSubmissionResponse : Decoder SubmissionResponse
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


decoderLeaderboard : Decoder (List UserAggregate)
decoderLeaderboard =
    Decode.list
        (Decode.map6 UserAggregate
            (Decode.field "username" Decode.string)
            (Decode.field "total_abstract" Decode.int)
            (Decode.field "total_beginner" Decode.int)
            (Decode.field "total_challenge" Decode.int)
            (Decode.field "total_meta" Decode.int)
            (Decode.field "total_grand" Decode.int)
        )


decoderRegisterResponse : Decoder RegisterResponse
decoderRegisterResponse =
    Decode.succeed "Thanks for registering for the 2019 Puzzle Hunt - you can try logging in now, just head over to the login tab!"


decoderSendEmailResponse : Decoder SendEmailResponse
decoderSendEmailResponse =
    Decode.succeed "Email sent!"


decoderCommentResponse : Decoder CommentResponse
decoderCommentResponse =
    Decode.list decoderComment


decoderContactResponse : Decoder ContactResponse
decoderContactResponse =
    Decode.succeed "Successfully messaged."



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


getPrizeList : Cmd Msg
getPrizeList =
    getNoAuth [ "prizes" ] PrizesGotResponse decoderPrizeData


getHomeDataPublic : Cmd Msg
getHomeDataPublic =
    getNoAuth [ "puzzles" ] HomeGotResponse decoderHomeData


getHomeDataUser : AuthToken -> Cmd Msg
getHomeDataUser authToken =
    getWithAuth authToken [ "puzzles" ] HomeGotResponse decoderHomeData


postContact : ContactData -> Cmd Msg
postContact contactData =
    postNoAuth [ "message" ] (ContactMsg << GotContactResponse) decoderContactResponse (encodeContact contactData)


getPuzzlePublic : PuzzleId -> Cmd Msg
getPuzzlePublic puzzleId =
    getNoAuth [ "puzzles", String.fromInt puzzleId ] (PuzzleMsg << GotPuzzle) decoderPuzzleDetail


getPuzzleUser : PuzzleId -> AuthToken -> Cmd Msg
getPuzzleUser puzzleId authToken =
    getWithAuth authToken [ "puzzles", String.fromInt puzzleId ] (PuzzleMsg << GotPuzzle) decoderPuzzleDetail


getStatsPublic : Username -> Cmd Msg
getStatsPublic username =
    getNoAuth [ "stats", username ] UserGotResponse decoderUserStats


getStatsUser : Username -> AuthToken -> Cmd Msg
getStatsUser username authToken =
    getWithAuth authToken [ "stats", username ] UserGotResponse decoderUserStats


postSubmit : AuthToken -> Submission -> PuzzleId -> Cmd Msg
postSubmit authToken submission puzzleId =
    postWithAuth authToken [ "submissions", String.fromInt puzzleId ] (PuzzleMsg << GotSubmissionResponse) decoderSubmissionResponse (encodeSubmission submission)


postComment : AuthToken -> PuzzleId -> String -> Cmd Msg
postComment authToken puzzleId string =
    postWithAuth authToken [ "puzzles", String.fromInt puzzleId, "comment" ] (PuzzleMsg << GotCommentResponse) decoderCommentResponse (encodeComment string)


getLeaderboard : Cmd Msg
getLeaderboard =
    getNoAuth [ "leaderboard" ] LeaderboardGotResponse decoderLeaderboard


postRegister : FullUser -> Cmd Msg
postRegister userData =
    postNoAuth [ "users" ] (RegisterMsg << GotRegisterResponse) decoderRegisterResponse (encodeRegister userData)


postSendEmail : Email -> Cmd Msg
postSendEmail email =
    postNoAuth [ "auth", "email" ] (LoginMsg << GotSendEmailResponse) decoderSendEmailResponse (encodeEmail email)


postLogin : EmailToken -> Cmd Msg
postLogin token =
    postNoAuth [ "callback", "auth" ] (LoginMsg << GotLoginResponse) decoderCredentials (encodeToken token)
