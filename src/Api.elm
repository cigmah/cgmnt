port module Api exposing (Cred(..), Email, FirstName, LastName, Username, application, decodeFromChange, decoderFromCred, emailVal, firstNameVal, get, lastNameVal, login, logout, onStoreChange, post, storageDecoder, storeCache, storeCredWith, usernameVal, viewerChanges)

import Api.ApiBase exposing (apiBase)
import Browser
import Browser.Navigation as Nav
import Http exposing (Body, Expect)
import Json.Decode as Decode exposing (Decoder, Value, decodeString, field, string)
import Json.Decode.Pipeline as Pipeline exposing (optional, required)
import Json.Encode as Encode
import RemoteData.Http as RemoteHttp exposing (Config)
import Url exposing (Url)



-- CRED


type alias Username =
    String


type alias Email =
    String


type alias FirstName =
    String


type alias LastName =
    String


type Cred
    = Cred Username Email FirstName LastName String


usernameVal : Cred -> Username
usernameVal (Cred val _ _ _ _) =
    val


emailVal : Cred -> Email
emailVal (Cred _ val _ _ _) =
    val


firstNameVal : Cred -> FirstName
firstNameVal (Cred _ _ val _ _) =
    val


lastNameVal : Cred -> LastName
lastNameVal (Cred _ _ _ val _) =
    val


credHeader : Cred -> Http.Header
credHeader (Cred _ _ _ _ str) =
    Http.header "Authorization" ("Token " ++ str)


credDecoder : Decoder Cred
credDecoder =
    Decode.succeed Cred
        |> required "username" Decode.string
        |> required "email" Decode.string
        |> optional "first_name" Decode.string "Anon"
        |> optional "last_name" Decode.string "User"
        |> required "token" Decode.string


decode : Decoder (Cred -> viewer) -> Value -> Result Decode.Error viewer
decode decoder value =
    Decode.decodeValue Decode.string value
        |> Result.andThen (\str -> Decode.decodeString (Decode.field "user" (decoderFromCred decoder)) str)


port onStoreChange : (Value -> msg) -> Sub msg


viewerChanges : (Maybe viewer -> msg) -> Decoder (Cred -> viewer) -> Sub msg
viewerChanges toMsg decoder =
    onStoreChange (\value -> toMsg (decodeFromChange decoder value))


decodeFromChange : Decoder (Cred -> viewer) -> Value -> Maybe viewer
decodeFromChange viewerDecoder val =
    Decode.decodeValue (storageDecoder viewerDecoder) val
        |> Result.toMaybe


storeCredWith : Cred -> Cmd msg
storeCredWith (Cred uname email firstName lastName token) =
    let
        json =
            Encode.object
                [ ( "user"
                  , Encode.object
                        [ ( "username", Encode.string uname )
                        , ( "email", Encode.string email )
                        , ( "first_name", Encode.string firstName )
                        , ( "last_name", Encode.string lastName )
                        , ( "token", Encode.string token )
                        ]
                  )
                ]
    in
    storeCache (Just json)


logout : Cmd msg
logout =
    storeCache Nothing


port storeCache : Maybe Value -> Cmd msg



-- Http


authConfig : Maybe Cred -> Config
authConfig maybeCred =
    { headers =
        case maybeCred of
            Just cred ->
                [ credHeader cred ]

            Nothing ->
                []
    , withCredentials = False
    , timeout = Nothing
    }


get urlAdd maybeCred callback decoder =
    RemoteHttp.getWithConfig (authConfig maybeCred) (apiBase ++ urlAdd) callback decoder


post urlAdd maybeCred callback decoder encodeValue =
    RemoteHttp.postWithConfig (authConfig maybeCred) (apiBase ++ urlAdd) callback decoder encodeValue


login callback encodeValue decoder =
    post "callback/auth/" Nothing callback (decoderFromCred decoder) encodeValue



-- SERIALIZATION
-- APPLICATION


application :
    Decoder (Cred -> viewer)
    ->
        { init : Maybe viewer -> Url -> Nav.Key -> ( model, Cmd msg )
        , onUrlChange : Url -> msg
        , onUrlRequest : Browser.UrlRequest -> msg
        , subscriptions : model -> Sub msg
        , update : msg -> model -> ( model, Cmd msg )
        , view : model -> Browser.Document msg
        }
    -> Program Value model msg
application viewerDecoder config =
    let
        init flags url navKey =
            let
                maybeViewer =
                    Decode.decodeValue Decode.string flags
                        |> Result.andThen (Decode.decodeString (storageDecoder viewerDecoder))
                        |> Result.toMaybe
            in
            config.init maybeViewer url navKey
    in
    Browser.application
        { init = init
        , onUrlChange = config.onUrlChange
        , onUrlRequest = config.onUrlRequest
        , subscriptions = config.subscriptions
        , update = config.update
        , view = config.view
        }


storageDecoder : Decoder (Cred -> viewer) -> Decoder viewer
storageDecoder viewerDecoder =
    Decode.field "user" (decoderFromCred viewerDecoder)


decoderFromCred : Decoder (Cred -> a) -> Decoder a
decoderFromCred decoder =
    Decode.map2 (\fromCred cred -> fromCred cred)
        decoder
        credDecoder



-- LOCALSTORAGE KEYS


cacheStorageKey : String
cacheStorageKey =
    "cache"


credStorageKey : String
credStorageKey =
    "cred"
