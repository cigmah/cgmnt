module Functions.Requests exposing (getArchive)

import Functions.ApiBase exposing (apiBase)
import Functions.Decoders exposing (..)
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
