port module Functions.Ports exposing (cache)

import Json.Encode as Encode


port cache : Encode.Value -> Cmd msg
