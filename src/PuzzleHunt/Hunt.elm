module PuzzleHunt.Hunt exposing (decodeDashboardData, decodeThemeData, emptyHuntDashboard, getDashboardDataCmd, handleHuntEvent, handleOnDashboardLoad, handleReceivedDashboardData)

import Http
import Iso8601
import Json.Decode as Decode
import Shared.ApiBase exposing (apiBase)
import Shared.Types exposing (DashboardData, HuntEvent(..), Model, Msg(..), ThemeData)


emptyHuntDashboard =
    { isLoading = False
    , data = Nothing
    , message = Nothing
    }


handleHuntEvent msg model =
    case msg of
        OnDashboardLoad ->
            ( model, Cmd.none )

        ReceivedDashboardData result ->
            handleReceivedDashboardData model result


getDashboardDataCmd token =
    Http.request
        { method = "GET"
        , headers = [ Http.header "Authorization" <| "Token " ++ token ]
        , url = apiBase ++ "themes/"
        , body = Http.emptyBody
        , expect = Http.expectJson (HuntMsg << ReceivedDashboardData) decodeDashboardData
        , timeout = Nothing
        , tracker = Nothing
        }


handleOnDashboardLoad model =
    case model.authToken of
        Just token ->
            let
                cmd =
                    getDashboardDataCmd token
            in
            ( { model | huntDashboardInformation = Just { emptyHuntDashboard | isLoading = True } }, cmd )

        Nothing ->
            ( model, Cmd.none )


handleReceivedDashboardData model result =
    case model.huntDashboardInformation of
        Just info ->
            case result of
                Ok data ->
                    ( { model | huntDashboardInformation = Just { emptyHuntDashboard | data = Just data } }, Cmd.none )

                Err error ->
                    case error of
                        Http.BadBody message ->
                            ( { model | huntDashboardInformation = Just { info | isLoading = False, message = Just message } }, Cmd.none )

                        Http.BadStatus code ->
                            case code of
                                401 ->
                                    ( { model | huntDashboardInformation = Just { info | isLoading = False, message = Just "Authentication failed! Maybe your token expired?" } }, Cmd.none )

                                _ ->
                                    ( { model | huntDashboardInformation = Just { info | isLoading = False, message = Just <| String.fromInt code } }, Cmd.none )

                        _ ->
                            ( { model | huntDashboardInformation = Just { info | isLoading = False, message = Just "There was an error." } }, Cmd.none )

        Nothing ->
            ( model, Cmd.none )


decodeDashboardData : Decode.Decoder DashboardData
decodeDashboardData =
    Decode.map2 DashboardData
        (Decode.field "current" (Decode.list decodeThemeData))
        (Decode.field "next" (Decode.maybe decodeThemeData))


decodeThemeData : Decode.Decoder ThemeData
decodeThemeData =
    Decode.map6 ThemeData
        (Decode.field "id" Decode.int)
        (Decode.field "year" Decode.int)
        (Decode.field "theme" Decode.string)
        (Decode.field "tagline" Decode.string)
        (Decode.field "open_datetime" Iso8601.decoder)
        (Decode.field "close_datetime" Iso8601.decoder)
