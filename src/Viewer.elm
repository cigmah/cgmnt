module Viewer exposing (Viewer(..), cred, decoder, email, firstName, lastName, store, username)

import Api exposing (Cred)
import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline exposing (custom, required)
import Json.Encode as Encode exposing (Value)



-- TYPES


type Viewer
    = Viewer Cred



-- INFO


cred : Viewer -> Cred
cred (Viewer val) =
    val


username : Viewer -> String
username (Viewer val) =
    Api.usernameVal val


email : Viewer -> String
email (Viewer val) =
    Api.emailVal val


firstName : Viewer -> String
firstName (Viewer val) =
    Api.firstNameVal val


lastName : Viewer -> String
lastName (Viewer val) =
    Api.lastNameVal val



-- SERIALIZATION


decoder : Decoder (Cred -> Viewer)
decoder =
    Decode.succeed Viewer


store : Viewer -> Cmd msg
store (Viewer credVal) =
    Api.storeCredWith
        credVal
