module Page.Leaderboard exposing (Model, Msg, init, subscriptions, toSession, update, view)

import Api
import Decoders exposing (decoderLeaderTotal, decoderLeaderTotalUnit, decoderPuzzleSet, decoderThemeSet)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Html.Lazy exposing (..)
import Iso8601
import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline exposing (optional, required)
import Json.Encode as Encode
import Page.Nav exposing (..)
import RemoteData exposing (RemoteData(..), WebData)
import Session exposing (Session(..))
import Time exposing (Posix)
import Types exposing (..)
import Viewer exposing (Viewer(..))



-- MODEL


type alias Model =
    { session : Session
    , state : State
    , navActive : Bool
    }


type State
    = ByTotal (WebData LeaderTotalData)
    | ByPuzzleNotChosen (WebData PuzzleOptionsData)
    | ByPuzzleChosen PuzzleOptionsData PuzzleOption (WebData LeaderPuzzleData)
    | ByThemeNotChosen (WebData ThemeOptionsData)
    | ByThemeChosen ThemeOptionsData ThemeOption (WebData LeaderThemeData)


type alias ThemeOptionsData =
    List ThemeOption


type alias ThemeOption =
    { id : Int
    , theme : String
    , set : ThemeSet
    }


type alias PuzzleOptionsData =
    List PuzzleOption


type alias PuzzleOption =
    { id : Int
    , theme : ThemeOption
    , set : PuzzleSet
    , title : String
    }


type alias LeaderPuzzleData =
    List LeaderPuzzleUnit


type alias LeaderPuzzleUnit =
    { username : String
    , puzzleTitle : String
    , submissionDatetime : Posix
    , points : Int
    }


type alias LeaderThemeData =
    List LeaderThemeUnit


type alias LeaderThemeUnit =
    { username : String
    , puzzle : PuzzleOption
    , submissionDatetime : Posix
    , points : Int
    }



-- DECODERS


decoderThemeOption : Decoder ThemeOption
decoderThemeOption =
    Decode.map3 ThemeOption
        (Decode.field "id" Decode.int)
        (Decode.field "theme" Decode.string)
        (Decode.field "set" decoderThemeSet)


decoderPuzzleOption : Decoder PuzzleOption
decoderPuzzleOption =
    Decode.map4 PuzzleOption
        (Decode.field "id" Decode.int)
        (Decode.field "theme" decoderThemeOption)
        (Decode.field "set" decoderPuzzleSet)
        (Decode.field "title" Decode.string)


decoderPuzzleOptionList =
    Decode.list decoderPuzzleOption


decoderThemeOptionList =
    Decode.list decoderThemeOption


decoderLeaderPuzzleUnit : Decoder LeaderPuzzleUnit
decoderLeaderPuzzleUnit =
    Decode.map4 LeaderPuzzleUnit
        (Decode.field "username" Decode.string)
        (Decode.field "puzzle" Decode.string)
        (Decode.field "submission_datetime" Iso8601.decoder)
        (Decode.field "points" Decode.int)


decoderLeaderPuzzle : Decoder LeaderPuzzleData
decoderLeaderPuzzle =
    Decode.list decoderLeaderPuzzleUnit


decoderLeaderThemeUnit : Decoder LeaderThemeUnit
decoderLeaderThemeUnit =
    Decode.map4 LeaderThemeUnit
        (Decode.field "username" Decode.string)
        (Decode.field "puzzle" decoderPuzzleOption)
        (Decode.field "submission_datetime" Iso8601.decoder)
        (Decode.field "points" Decode.int)


decoderLeaderTheme : Decoder LeaderThemeData
decoderLeaderTheme =
    Decode.list decoderLeaderThemeUnit



-- REQUESTS


getLeaderTotal =
    Api.get "submissions/leaderboard/" Nothing ReceivedLeaderTotal decoderLeaderTotal


getPuzzleOptions =
    Api.get "puzzles/current/" Nothing ReceivedPuzzlesCurrent decoderPuzzleOptionList


getThemeOptions =
    Api.get "themes/current/" Nothing ReceivedThemesCurrent decoderThemeOptionList


getLeaderPuzzle id =
    Api.get ("submissions/leaderboard/puzzle/" ++ String.fromInt id) Nothing ReceivedLeaderPuzzle decoderLeaderPuzzle


getLeaderTheme id =
    Api.get ("submissions/leaderboard/theme/" ++ String.fromInt id) Nothing ReceivedLeaderTheme decoderLeaderTheme


init : Session -> ( Model, Cmd Msg )
init session =
    ( { session = session, state = ByTotal Loading, navActive = False }
    , getLeaderTotal
    )


toSession : Model -> Session
toSession model =
    model.session



-- UPDATE


type Msg
    = GotSession Session
    | ReceivedLeaderTotal (WebData LeaderTotalData)
    | ReceivedPuzzlesCurrent (WebData (List PuzzleOption))
    | ReceivedThemesCurrent (WebData (List ThemeOption))
    | ReceivedLeaderPuzzle (WebData LeaderPuzzleData)
    | ReceivedLeaderTheme (WebData LeaderThemeData)
    | ClickedLeaderTotal
    | ClickedLeaderPuzzle
    | ClickedPuzzle PuzzleOption
    | ClickedLeaderTheme
    | ClickedTheme ThemeOption
    | ToggledNavMenu


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotSession session ->
            ( { model | session = session }, Cmd.none )

        ClickedLeaderTotal ->
            ( { model | state = ByTotal Loading }, getLeaderTotal )

        ClickedLeaderPuzzle ->
            ( { model | state = ByPuzzleNotChosen Loading }, getPuzzleOptions )

        ClickedLeaderTheme ->
            ( { model | state = ByThemeNotChosen Loading }, getThemeOptions )

        ClickedPuzzle puzzle ->
            case model.state of
                ByPuzzleNotChosen puzzleOptionsDataWebData ->
                    case puzzleOptionsDataWebData of
                        Success data ->
                            ( { model | state = ByPuzzleChosen data puzzle Loading }, getLeaderPuzzle puzzle.id )

                        _ ->
                            ( model, Cmd.none )

                ByPuzzleChosen data _ _ ->
                    ( { model | state = ByPuzzleChosen data puzzle Loading }, getLeaderPuzzle puzzle.id )

                _ ->
                    ( model, Cmd.none )

        ClickedTheme theme ->
            case model.state of
                ByThemeNotChosen themeOptionsDataWebData ->
                    case themeOptionsDataWebData of
                        Success data ->
                            ( { model | state = ByThemeChosen data theme Loading }, getLeaderTheme theme.id )

                        _ ->
                            ( model, Cmd.none )

                ByThemeChosen themeOptionsData _ _ ->
                    ( { model | state = ByThemeChosen themeOptionsData theme Loading }, getLeaderTheme theme.id )

                _ ->
                    ( model, Cmd.none )

        ReceivedLeaderTotal response ->
            ( { model | state = ByTotal response }, Cmd.none )

        ReceivedPuzzlesCurrent response ->
            ( { model | state = ByPuzzleNotChosen response }, Cmd.none )

        ReceivedThemesCurrent response ->
            ( { model | state = ByThemeNotChosen response }, Cmd.none )

        ReceivedLeaderTheme response ->
            case model.state of
                ByThemeChosen themeOptionsData themeOption leaderThemeDataWebData ->
                    ( { model | state = ByThemeChosen themeOptionsData themeOption response }, Cmd.none )

                _ ->
                    ( model, Cmd.none )

        ReceivedLeaderPuzzle response ->
            case model.state of
                ByPuzzleChosen puzzleOptionsData puzzleOption leaderPuzzleDataWebData ->
                    ( { model | state = ByPuzzleChosen puzzleOptionsData puzzleOption response }, Cmd.none )

                _ ->
                    ( model, Cmd.none )

        ToggledNavMenu ->
            ( { model | navActive = not model.navActive }, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Session.changes GotSession (Session.navKey model.session)



-- VIEW


navMenuLinked model body =
    div [] [ lazy3 navMenu ToggledNavMenu model.navActive (Session.viewer model.session), body ]


view : Model -> { title : String, content : Html Msg }
view model =
    { title = "CIGMAH"
    , content = navMenuLinked model <| mainHero
    }


mainHero =
    div [ class "hero is-primary is-fullheight-with-navbar" ]
        [ div [ class "hero-body" ]
            [ div [ class "container" ]
                [ div [ class "columns is-multiline" ]
                    [ div [] [ text "TEST" ]
                    ]
                ]
            ]
        ]
