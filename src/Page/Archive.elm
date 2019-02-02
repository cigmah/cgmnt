module Page.Archive exposing (Model, Msg, init, subscriptions, toSession, update, view)

import Api
import Decoders exposing (decoderArchiveData)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Html.Lazy exposing (..)
import Json.Decode as Decode exposing (Decoder)
import Markdown
import Page.Error exposing (..)
import Page.Nav exposing (navMenu)
import Page.Puzzle exposing (..)
import Page.Shared exposing (..)
import RemoteData exposing (RemoteData(..), WebData)
import Session exposing (Session(..))
import Time exposing (millisToPosix)
import Types exposing (..)
import Utils exposing (..)
import Viewer exposing (Viewer)



-- MODEL


type alias Model =
    { session : Session
    , state : State
    , navActive : Bool
    }


type State
    = Full (WebData (List FullPuzzleData))
    | Detail (List FullPuzzleData) FullPuzzleData
    | AcceptedFull (WebData ClosedData)
    | AcceptedDetail ClosedData FullPuzzleData


type alias ClosedData =
    { complete : List FullPuzzleData
    , incomplete : List FullPuzzleData
    }


decoderClosedData : Decoder ClosedData
decoderClosedData =
    Decode.map2 ClosedData
        (Decode.field "complete" decoderArchiveData)
        (Decode.field "incomplete" decoderArchiveData)


init : Session -> ( Model, Cmd Msg )
init session =
    case session of
        LoggedIn keyNav viewer ->
            ( { session = session, state = AcceptedFull Loading, navActive = False }
            , Api.get "puzzles/inactive/" (Just <| Viewer.cred viewer) ReceivedClosedData decoderClosedData
            )

        Guest keyNav ->
            ( { session = session
              , state = Full Loading
              , navActive = False
              }
            , Api.get "puzzles/archive/public/" Nothing ReceivedArchiveData decoderArchiveData
            )


toSession : Model -> Session
toSession model =
    model.session



-- UPDATE


type Msg
    = ClickedRefresh
    | ReceivedArchiveData (WebData (List FullPuzzleData))
    | ReceivedClosedData (WebData ClosedData)
    | ClickedPuzzle FullPuzzleData
    | ClickedBackToFull
    | ToggledNavMenu
    | GotSession Session


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ClickedRefresh ->
            ( model, Cmd.none )

        ReceivedArchiveData data ->
            ( { model | state = Full data }, Cmd.none )

        ReceivedClosedData response ->
            ( { model | state = AcceptedFull response }, Cmd.none )

        ClickedPuzzle puzzle ->
            case model.state of
                Full (Success data) ->
                    ( { model | state = Detail data puzzle }, Cmd.none )

                AcceptedFull (Success data) ->
                    ( { model | state = AcceptedDetail data puzzle }, Cmd.none )

                _ ->
                    ( model, Cmd.none )

        ClickedBackToFull ->
            case model.state of
                Detail archiveData _ ->
                    ( { model | state = Full (Success archiveData) }, Cmd.none )

                AcceptedDetail closedData _ ->
                    ( { model | state = AcceptedFull (Success closedData) }, Cmd.none )

                _ ->
                    ( model, Cmd.none )

        GotSession session ->
            ( { model | session = session }, Cmd.none )

        ToggledNavMenu ->
            ( { model | navActive = not model.navActive }, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Session.changes GotSession (Session.navKey model.session)



-- VIEW


navMenuLinked model body =
    div [ class "" ] [ lazy3 navMenu ToggledNavMenu model.navActive (Session.viewer model.session), body ]


view : Model -> { title : String, content : Html Msg }
view model =
    case model.state of
        Full fullPuzzleDataListWebData ->
            { title = "Archive - CIGMAH"
            , content = navMenuLinked model <| bodyFullPublic fullPuzzleDataListWebData
            }

        Detail fullPuzzleDataList fullPuzzleData ->
            { title = "Archive - CIGMAH"
            , content = mainBody model
            }

        AcceptedFull closedDataWebData ->
            { title = "Archive - CIGMAH"
            , content = navMenuLinked model <| bodyFullUser closedDataWebData
            }

        AcceptedDetail closedData fullPuzzleData ->
            { title = "Archive - CIGMAH"
            , content = mainBody model
            }


isLoading model =
    case model.state of
        Full Loading ->
            True

        AcceptedFull Loading ->
            True

        _ ->
            False


mainBody model =
    div [] []


defaultPuzzleData =
    { id = 0
    , theme =
        { id = 0
        , year = 2000
        , theme = String.slice 0 15 loremIpsum
        , themeSet = RTheme
        , tagline = String.slice 0 50 loremIpsum
        , openDatetime = millisToPosix 0
        , closeDatetime = millisToPosix 0
        }
    , set = M
    , imagePath = "https://i.imgur.com/qu0J7Wb.png"
    , title = String.slice 0 20 loremIpsum
    }


bodyFullPublic webData =
    case webData of
        Loading ->
            fullPuzzlePage True Nothing (ArchivePublic (List.repeat 6 defaultPuzzleData)) Nothing

        Success data ->
            fullPuzzlePage False Nothing (ArchivePublic data) <| Just ClickedPuzzle

        Failure e ->
            fullPuzzlePage True (Just "There was an error :(") (ArchivePublic (List.repeat 6 defaultPuzzleData)) Nothing

        _ ->
            errorPage


bodyFullUser webData =
    case webData of
        Loading ->
            fullPuzzlePage True Nothing (ArchiveUser (List.repeat 4 defaultPuzzleData) (List.repeat 4 defaultPuzzleData)) Nothing

        Success data ->
            fullPuzzlePage False Nothing (ArchiveUser data.incomplete data.complete) <| Just ClickedPuzzle

        Failure e ->
            fullPuzzlePage True (Just "There was an error :(") (ArchiveUser (List.repeat 4 defaultPuzzleData) (List.repeat 4 defaultPuzzleData)) Nothing

        _ ->
            errorPage


makePuzzleCards : Model -> Html Msg
makePuzzleCards model =
    div [] []
