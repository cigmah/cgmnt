module Functions.Encoders exposing (encodeEmail, encodeRegister, encodeToken)

import Json.Encode as Encode exposing (..)
import Types.Types exposing (..)


encodeEmail : Email -> Value
encodeEmail email =
    object
        [ ( "email", string email ) ]


encodeToken : Token -> Value
encodeToken token =
    object
        [ ( "token", string token ) ]


encodeRegister : RegisterInfo -> Encode.Value
encodeRegister info =
    Encode.object
        [ ( "username", Encode.string info.username )
        , ( "email", Encode.string info.email )
        , ( "first_name", Encode.string info.firstName )
        , ( "last_name", Encode.string info.lastName )
        ]
