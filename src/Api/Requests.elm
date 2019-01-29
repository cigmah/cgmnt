module Functions.Requests exposing (authConfig, authHeader, getActivePuzzles, getArchive, getCompleted, getLeader, getSubmissions, noAuthConfig, postLogin, postRegister, postSendEmail, postSubmit)

import Functions.ApiBase exposing (apiBase)
import Functions.Decoders exposing (..)
import Functions.Encoders exposing (..)
import Http as ElmHttp exposing (header)
import Json.Encode as Encode
import Msg.Msg exposing (..)
import RemoteData.Http as Http exposing (Config)
import Types.Types exposing (..)


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


getArchive : Cmd Msg
getArchive =
    Http.getWithConfig noAuthConfig (apiBase ++ "puzzles/archive/public/") (ArchiveMsg << ReceivedArchive) decodeArchiveData


getLeader : Cmd Msg
getLeader =
    Http.getWithConfig noAuthConfig (apiBase ++ "submissions/leaderboard/") (LeaderTotalMsg << ReceivedLeaderTotal) decodeLeaderTotal


getSubmissions : AuthToken -> Cmd Msg
getSubmissions token =
    Http.getWithConfig (authConfig token) (apiBase ++ "submissions/user/") (SubmissionsMsg << ReceivedSubmissions) decodeSubmissionsData


getCompleted : AuthToken -> Cmd Msg
getCompleted token =
    Http.getWithConfig (authConfig token) (apiBase ++ "puzzles/completed/") (CompletedMsg << ReceivedCompleted) decodeArchiveData


getActivePuzzles : AuthToken -> Cmd Msg
getActivePuzzles token =
    Http.getWithConfig (authConfig token) (apiBase ++ "puzzles/active/") (PuzzlesMsg << ReceivedActiveData) decodePuzzlesData


postRegister : RegisterInfo -> Cmd Msg
postRegister registerInfo =
    Http.post (apiBase ++ "users/") (RegisterMsg << ReceivedRegister) decodeRegisterResponse (encodeRegister registerInfo)


postSendEmail : Email -> Cmd Msg
postSendEmail email =
    Http.post (apiBase ++ "auth/email/") (LoginMsg << ReceivedSendEmail) decodeSendEmail (encodeEmail email)


postLogin : Token -> Cmd Msg
postLogin token =
    Http.post (apiBase ++ "callback/auth/") (LoginMsg << ReceivedLogin) decodeAuthToken (encodeToken token)


postSubmit : AuthToken -> SelectedPuzzleInfo -> Cmd Msg
postSubmit token selectedPuzzle =
    Http.postWithConfig (authConfig token) (apiBase ++ "submissions/") (PuzzlesMsg << ReceivedSubmissionResponse) decodeSubmissionResponse (encodeSubmission selectedPuzzle)
