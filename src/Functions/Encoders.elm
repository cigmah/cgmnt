module Functions.Coders exposing (decodeAuthToken, encodeLogin, encodeSendToken)

import Json.Encode as Encode exposing (..)
import Types.Types exposing (..)


encodeSendToken : LoginInfo -> Value
encodeSendToken info =
    object
        [ ( "email", string info.email ) ]


encodeLogin : LoginInfo -> Value
encodeLogin info =
    object
        [ ( "token", string info.token ) ]
