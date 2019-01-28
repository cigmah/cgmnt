module Functions.Encoders exposing (encodeRegister)

import Json.Encode as Encode exposing (..)
import Types.Types exposing (..)



-- encodeSendToken : LoginInfo -> Value
-- encodeSendToken info =
--     object
--         [ ( "email", string info.email ) ]
-- encodeLogin : LoginInfo -> Value
-- encodeLogin info =
--     object
--         [ ( "token", string info.token ) ]


encodeRegister : RegisterInfo -> Encode.Value
encodeRegister info =
    Encode.object
        [ ( "username", Encode.string info.username )
        , ( "email", Encode.string info.email )
        , ( "first_name", Encode.string info.firstName )
        , ( "last_name", Encode.string info.lastName )
        ]
