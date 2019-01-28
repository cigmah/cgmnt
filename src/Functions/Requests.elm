module Functions.Requests exposing (getArchive, noAuthConfig, postRegister)

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
