module Requests exposing (authConfig, authHeader, buildUrl, decoderContactResponseData, decoderCredentials, decoderDetailPuzzleData, decoderLeaderboardByPuzzle, decoderLeaderboardByTotal, decoderMiniPuzzleData, decoderProfileData, decoderPuzzleSet, decoderRegisterResponse, decoderSendEmailResponse, decoderSubmissionData, decoderSubmissionResponse, decoderThemeData, decoderTooSoonSubmit, decoderUserData, encodeContact, encodeEmail, encodeRegister, encodeSubmission, encodeToken, getLeaderboardByPuzzle, getLeaderboardByTotal, getNoAuth, getProfile, getPuzzleDetailPublic, getPuzzleDetailUser, getPuzzleListPublic, getPuzzleListUser, getWithAuth, noAuthConfig, noInputString, postContact, postLogin, postNoAuth, postRegister, postSendEmail, postSubmit, postWithAuth)

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


encodeContact : ContactData -> Encode.Value
encodeContact v =
    Encode.object
        [ ( "name", Encode.string v.name )
        , ( "email", Encode.string v.email )
        , ( "subject", Encode.string v.subject )
        , ( "body", Encode.string v.body )
        ]


encodeSubmission : Submission -> Encode.Value
encodeSubmission v =
    Encode.string v


encodeRegister : UserData -> Encode.Value
encodeRegister v =
    Encode.object
        [ ( "username", Encode.string v.username )
        , ( "email", Encode.string v.email )
        , ( "first_name", Encode.string v.firstName )
        , ( "last_name", Encode.string v.lastName )
        ]


encodeEmail : Email -> Encode.Value
encodeEmail v =
    Encode.string v


encodeToken : Token -> Encode.Value
encodeToken v =
    Encode.string v


decoderContactResponseData : Decoder ContactResponseData
decoderContactResponseData =
    Decode.succeed "Thanks for your message! We'll get back to you as soon as we can."


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


noInputString =
    "There aren't extra materials for this puzzle - you have everything you need!"


decoderDetailPuzzleData : Decoder DetailPuzzleData
decoderDetailPuzzleData =
    Decode.succeed DetailPuzzleData
        |> required "id" Decode.int
        |> required "puzzle_set" decoderPuzzleSet
        |> required "theme" decoderThemeData
        |> required "title" Decode.string
        |> required "image_link" Decode.string
        |> required "body" Decode.string
        |> required "example" Decode.string
        |> required "statement" Decode.string
        |> required "references" Decode.string
        |> optional "input" Decode.string noInputString
        |> optional "is_solved" (Decode.maybe Decode.bool) Nothing
        |> optional "answer" (Decode.maybe Decode.string) Nothing
        |> optional "explanation" (Decode.maybe Decode.string) Nothing


decoderSubmissionData : Decoder SubmissionData
decoderSubmissionData =
    Decode.map7 SubmissionData
        (Decode.field "id" Decode.int)
        (Decode.field "user" Decode.string)
        (Decode.field "puzzle" decoderMiniPuzzleData)
        (Decode.field "submission_datetime" Iso8601.decoder)
        (Decode.field "submission" Decode.string)
        (Decode.field "is_response_c  orrect" Decode.bool)
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
    Decode.map5 ProfileData
        (Decode.field "submissions" (Decode.list decoderSubmissionData))
        (Decode.field "solved_images" (Decode.list Decode.string))
        (Decode.field "num_solved" Decode.int)
        (Decode.field "points" Decode.int)
        (Decode.field "next" decoderThemeData)


decoderSubmissionResponse : Decoder SubmissionResponseData
decoderSubmissionResponse =
    Decode.map OkSubmit <|
        Decode.map4
            OkSubmitData
            (Decode.field "id" Decode.int)
            (Decode.field "submission" Decode.string)
            (Decode.field "is_correct" Decode.bool)
            (Decode.field "points" Decode.int)


decoderTooSoonSubmit : Decoder TooSoonSubmitData
decoderTooSoonSubmit =
    Decode.map5 TooSoonSubmitData
        (Decode.field "message" Decode.string)
        (Decode.field "attempts" Decode.int)
        (Decode.field "last" Iso8601.decoder)
        (Decode.field "wait" Decode.int)
        (Decode.field "next" Iso8601.decoder)


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
            (Decode.field "puzzle" decoderMiniPuzzleData)
            (Decode.field "submission_datetime" Iso8601.decoder)
            (Decode.field "points" Decode.int)
        )


decoderRegisterResponse : Decoder RegisterResponseData
decoderRegisterResponse =
    Decode.string


decoderSendEmailResponse : Decoder SendEmailResponseData
decoderSendEmailResponse =
    Decode.string



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


postContact : ContactData -> Cmd Msg
postContact contactData =
    postNoAuth [ "message" ] HomeGotContactResponse decoderContactResponseData (encodeContact contactData)


getProfile : AuthToken -> Cmd Msg
getProfile authToken =
    getWithAuth authToken [ "profile" ] HomeGotProfileResponse decoderProfileData


getPuzzleListPublic : Cmd Msg
getPuzzleListPublic =
    getNoAuth [ "puzzles" ] PuzzleListPublicGotResponse (Decode.list decoderMiniPuzzleData)


getPuzzleListUser : AuthToken -> Cmd Msg
getPuzzleListUser authToken =
    getWithAuth authToken [ "puzzles" ] PuzzleListUserGotResponse (Decode.list decoderMiniPuzzleData)


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


postRegister : UserData -> Cmd Msg
postRegister userData =
    postNoAuth [ "users" ] RegisterGotResponse decoderRegisterResponse (encodeRegister userData)


postSendEmail : Email -> Cmd Msg
postSendEmail email =
    postNoAuth [ "auth", "email" ] LoginGotSendEmailResponse decoderSendEmailResponse (encodeEmail email)


postLogin : Token -> Cmd Msg
postLogin token =
    postNoAuth [ "callback", "auth" ] LoginGotLoginResponse decoderCredentials (encodeToken token)
