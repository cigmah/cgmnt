module Functions.Requests exposing (getArchive, noAuthConfig, postLogin, postRegister, postSendEmail)

import Functions.ApiBase exposing (apiBase)
import Functions.Decoders exposing (..)
import Functions.Encoders exposing (..)
import Msg.Msg exposing (..)
import RemoteData.Http as Http exposing (Config)
import Types.Types exposing (..)


noAuthConfig : Config
noAuthConfig =
    { headers = []
    , withCredentials = False
    , timeout = Nothing
    }


getArchive : Cmd Msg
getArchive =
    Http.getWithConfig noAuthConfig (apiBase ++ "puzzles/archive/public/") (ArchiveMsg << ReceivedArchive) decodeArchiveData


postRegister : RegisterInfo -> Cmd Msg
postRegister registerInfo =
    Http.post (apiBase ++ "users/") (RegisterMsg << ReceivedRegister) decodeRegisterResponse (encodeRegister registerInfo)


postSendEmail : Email -> Cmd Msg
postSendEmail email =
    Http.post (apiBase ++ "auth/email/") (LoginMsg << ReceivedSendEmail) decodeSendEmail (encodeEmail email)


postLogin : Token -> Cmd Msg
postLogin token =
    Http.post (apiBase ++ "callback/auth/") (LoginMsg << ReceivedLogin) decodeAuthToken (encodeToken token)
