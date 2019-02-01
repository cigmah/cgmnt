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
import Page.Error exposing (..)
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
        (Decode.field "theme_set" decoderThemeSet)


decoderPuzzleOption : Decoder PuzzleOption
decoderPuzzleOption =
    Decode.map4 PuzzleOption
        (Decode.field "id" Decode.int)
        (Decode.field "theme" decoderThemeOption)
        (Decode.field "puzzle_set" decoderPuzzleSet)
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
    , content = navMenuLinked model <| mainHero model
    }


makeHeaderCell headerText =
    th [ class "py-2 px-4 bg-primary text-white text-left" ] [ text headerText ]


makeRow rank leaderUnit =
    tr [ class "w-full md:w-1/2 table-row hover:bg-grey-lighter" ]
        [ td [ class "font-light px-4 py-2" ] [ text <| String.fromInt rank ]
        , td [ class "md:w-1/2 font-light px-4 py-2" ] [ text leaderUnit.username ]
        , td [ class "md:w-1/3 font-light px-4 py-2" ] [ text <| String.fromInt leaderUnit.total ]
        ]


tableColumn data =
    let
        tableHeaders =
            [ "Rank", "Username", "Points" ]

        tableHead =
            tr [ class "w-full lg:w-1/2" ] <| List.map makeHeaderCell tableHeaders

        ranks =
            List.range 1 (List.length data)

        rows =
            List.map2 makeRow ranks data

        leaderContent =
            [ table [ class "table w-full" ]
                [ thead [] [ tableHead ], tbody [] <| rows ]
            ]
    in
    div [ class "flex justify-center mt-24 lg:mt-6 lg:ml-4 lg:mr-4 flex items-center w-full lg:w-1/2 overflow-auto" ]
        [ div [ class "px-3 w-full" ] leaderContent
        ]


selectorColumn =
    [ button
        [ class "rounded-full px-3 py-2 border-primary border-2 mr-4 text-primary hover:text-white hover:bg-primary"
        , onClick ClickedLeaderTotal
        ]
        [ text "By Total" ]
    , button
        [ class "rounded-full px-3 py-2 border-primary border-2 mr-4 text-primary hover:text-white hover:bg-primary"
        , onClick ClickedLeaderTheme
        ]
        [ text "By Theme" ]
    , button
        [ class "rounded-full px-3 py-2 border-primary border-2 text-primary hover:text-white hover:bg-primary"
        , onClick ClickedLeaderPuzzle
        ]
        [ text "By Puzzle" ]
    ]


themeOptionUnit themeOption =
    div [ class "block w-full px-3 py-2 shadow bg-white font-sans font-light cursor-pointer", onClick (ClickedTheme themeOption) ]
        [ text <| "#" ++ String.fromInt themeOption.id ++ " " ++ themeOption.theme ]


themeOptionView data =
    case data of
        Success themeOptions ->
            div [ class "ml-2 mr-2 lg:mx-0" ] <| List.map themeOptionUnit themeOptions

        _ ->
            div [] []


tableTheme data =
    div [] []


mainHero model =
    case model.state of
        ByTotal (Success data) ->
            div [ class "container mx-auto mt-16 lg:flex lg:justify-between" ]
                [ div [ class "lg:w-1/2" ]
                    [ div [ class "flex justify-center mt-24 lg:mt-6 mb-8" ] selectorColumn ]
                , tableColumn data
                ]

        ByThemeNotChosen data ->
            div [ class "container mx-auto mt-16 lg:flex lg:justify-between" ]
                [ div [ class "lg:w-1/2" ]
                    [ div [ class "flex justify-center mt-24 lg:mt-6 mb-8" ] selectorColumn
                    , div [ class "block mt-2 mb-4" ] [ themeOptionView data ]
                    ]
                , div [] []
                ]

        ByThemeChosen data chosen response ->
            case response of
                Success responseData ->
                    div [ class "container mx-auto mt-16 lg:flex lg:justify-between" ]
                        [ div [ class "lg:w-1/2" ]
                            [ div [ class "flex justify-center mt-24 lg:mt-6 mb-8" ] selectorColumn
                            , div [ class "block mt-2 mb-4" ] [ themeOptionView (Success data) ]
                            ]
                        , div [] []
                        ]

                Loading ->
                    div [] []

                _ ->
                    errorPage

        ByTotal Loading ->
            div [ class "pageloader is-active" ] [ span [ class "title" ] [ text "Loading..." ] ]

        _ ->
            errorPage
