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
import Page.Shared exposing (..)
import RemoteData exposing (RemoteData(..), WebData)
import Session exposing (Session(..))
import Time exposing (Posix)
import Types exposing (..)
import Utils
import Viewer exposing (Viewer(..))



-- MODEL


type alias Model =
    { session : Session
    , state : State
    , navActive : Bool
    }


type State
    = ByTotal (WebData LeaderTotalData)
    | ByPuzzleNotChosen Bool (WebData PuzzleOptionsData)
    | ByPuzzleChosen Bool PuzzleOptionsData PuzzleOption (WebData LeaderPuzzleData)
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
    | ToggleShowPuzzleOptions
    | ToggledNavMenu


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotSession session ->
            ( { model | session = session }, Cmd.none )

        ClickedLeaderTotal ->
            ( { model | state = ByTotal Loading }, getLeaderTotal )

        ClickedLeaderPuzzle ->
            ( { model | state = ByPuzzleNotChosen False Loading }, getPuzzleOptions )

        ClickedLeaderTheme ->
            ( { model | state = ByThemeNotChosen Loading }, getThemeOptions )

        ClickedPuzzle puzzle ->
            case model.state of
                ByPuzzleNotChosen _ puzzleOptionsDataWebData ->
                    case puzzleOptionsDataWebData of
                        Success data ->
                            ( { model | state = ByPuzzleChosen False data puzzle Loading }, getLeaderPuzzle puzzle.id )

                        _ ->
                            ( model, Cmd.none )

                ByPuzzleChosen _ data _ _ ->
                    ( { model | state = ByPuzzleChosen False data puzzle Loading }, getLeaderPuzzle puzzle.id )

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
            ( { model | state = ByPuzzleNotChosen False response }, Cmd.none )

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
                ByPuzzleChosen _ puzzleOptionsData puzzleOption leaderPuzzleDataWebData ->
                    ( { model | state = ByPuzzleChosen False puzzleOptionsData puzzleOption response }, Cmd.none )

                _ ->
                    ( model, Cmd.none )

        ToggleShowPuzzleOptions ->
            case model.state of
                ByPuzzleNotChosen bool puzzleOptionsDataWebData ->
                    ( { model | state = ByPuzzleNotChosen (not bool) puzzleOptionsDataWebData }, Cmd.none )

                ByPuzzleChosen bool puzzleOptionsData puzzleOption leaderPuzzleDataWebData ->
                    ( { model | state = ByPuzzleChosen (not bool) puzzleOptionsData puzzleOption leaderPuzzleDataWebData }, Cmd.none )

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
    , content = navMenuLinked model <| viewRouter model
    }


viewRouter model =
    case model.state of
        ByTotal leaderTotalDataWebData ->
            case leaderTotalDataWebData of
                Success data ->
                    leaderboardByTotal data

                Loading ->
                    leaderboardLoading

                _ ->
                    errorPage

        ByPuzzleNotChosen bool puzzleOptionsDataWebData ->
            case puzzleOptionsDataWebData of
                Success data ->
                    leaderboardByPuzzle data bool Nothing Nothing

                Loading ->
                    leaderboardLoading

                _ ->
                    errorPage

        ByPuzzleChosen bool puzzleOptionsData puzzleOption leaderPuzzleDataWebData ->
            case leaderPuzzleDataWebData of
                Success data ->
                    leaderboardByPuzzle puzzleOptionsData bool (Just puzzleOption) (Just data)

                Loading ->
                    leaderboardLoading

                _ ->
                    errorPage

        ByThemeNotChosen themeOptionsDataWebData ->
            errorPage

        ByThemeChosen themeOptionsData themeOption leaderThemeDataWebData ->
            errorPage



-- CONVERTED Html


puzzleOptionDiv : PuzzleOption -> (PuzzleOption -> Msg) -> Html Msg
puzzleOptionDiv puzzleOption clickEvent =
    div
        [ class "block" ]
        [ div
            [ class "bg-grey-lightest px-6 py-2 hover:bg-grey-light cursor-pointer text-grey-darker"
            , onClick (clickEvent puzzleOption)
            ]
            [ text <| String.concat [ "№ ", String.fromInt puzzleOption.id, " ", puzzleOption.title ] ]
        ]


tableMakerPuzzle headerList unitList =
    let
        rankList =
            List.range 1 (List.length unitList)
    in
    div
        [ id "table-block", class "block py-2" ]
        [ table
            [ class "w-full" ]
          <|
            [ tableRow True headerList ]
                ++ List.map2 (\x y -> tableRow False [ String.fromInt y, x.username, Utils.posixToString x.submissionDatetime ]) unitList rankList
        ]


tableMakerTotal headerList unitList =
    let
        rankList =
            List.range 1 (List.length unitList)
    in
    div
        [ id "table-block", class "block py-2" ]
        [ table
            [ class "w-full" ]
          <|
            tableRow True headerList
                :: List.map2 (\x y -> tableRow False [ String.fromInt y, x.username, String.fromInt x.total ]) unitList rankList
        ]


leaderboardTemplate isLoading optionsToShow tableToShow =
    let
        messageDiv =
            --not used for now
            if False then
                div
                    [ id "message-box", class "flex pin-b pin-x h-auto p-4 pb-6 fixed bg-grey-light text-grey-darkest justify-center text" ]
                    [ span
                        [ class "text-center md:w-3/4 " ]
                        [ text "Hmm, it looks like there was an error. Let us know!" ]
                    ]

            else
                div [] []
    in
    div
        [ class "px-2 md:px-8 bg-grey-lightest" ]
        [ div
            [ class "mb-4 flex flex-wrap content-center justify-center items-center pt-16" ]
            [ div
                [ class "block md:w-5/6 lg:w-4/5 xl:w-3/4" ]
                [ div
                    [ class "inline-flex flex justify-center w-full" ]
                    [ div
                        [ class "flex items-center  sm:text-xl justify-center  px-5 py-3 rounded-l-lg font-black bg-green text-grey-lighter border-b-2 border-green-dark"
                        , classList [ ( "text-green", isLoading ), ( "text-white", not isLoading ) ]
                        ]
                        [ span
                            [ class "fas fa-table" ]
                            []
                        ]
                    , div
                        [ class "flex items-center  w-full p-3 px-5 rounded-r-lg text-grey-darkest sm:text-lg font-bold uppercase bg-grey-lighter border-b-2 border-grey" ]
                        [ textWithLoad isLoading "Leaderboard" ]
                    ]
                , div
                    [ class "block w-full my-3 bg-white rounded-lg p-6 w-full text-base border-b-2 border-grey-light" ]
                    [ p
                        []
                        [ textWithLoad isLoading "You can choose to view the total leaderboard, or a per-puzzle leaderboard." ]
                    , br
                        []
                        []
                    , div
                        [ id "leader-options", class "block my-1 w-full" ]
                        [ div
                            [ class "inline-flex flex:wrap w-full justify-center items-center" ]
                            [ div
                                [ id "leader-button", class "block p-1 w-1/2" ]
                                [ button
                                    [ class "rounded-lg px-3 py-2 bg-green border-b-2 border-green-dark focus:outline-none outline-none hover:bg-green-dark active:border-b-0 w-full"
                                    , classList [ ( "text-white", not isLoading ), ( "text-green hover:text-green-dark", isLoading ) ]
                                    , onClick ClickedLeaderTotal
                                    ]
                                    [ text "Total" ]
                                ]
                            , div
                                [ class "block p-1 w-1/2" ]
                                [ button
                                    [ class "rounded-lg px-3 py-2 bg-green border-b-2 border-green-dark focus:outline-none outline-none hover:bg-green-dark active:border-b-0 w-full"
                                    , classList [ ( "text-white", not isLoading ), ( "text-green hover:text-green-dark", isLoading ) ]
                                    , onClick ClickedLeaderPuzzle
                                    ]
                                    [ text "By Puzzle" ]
                                ]
                            ]
                        ]
                    , optionsToShow
                    , tableToShow
                    ]
                ]
            ]
        , messageDiv
        ]


leaderboardLoading =
    leaderboardTemplate True (div [] []) (div [ class "block my-2 bg-grey-lightest rounded-lg h-64" ] [])


leaderboardByTotal leaderUnits =
    leaderboardTemplate False (div [] []) (tableMakerTotal [ "Rank", "Username", "Points" ] leaderUnits)


leaderboardByPuzzle puzzleOptions isOptionsVisible maybeSelectedPuzzle maybeLeaderPuzzleUnits =
    let
        puzzleOptionSelector =
            let
                selectorText =
                    case maybeSelectedPuzzle of
                        Nothing ->
                            "Select a puzzle..."

                        Just puzzle ->
                            String.concat [ "№ ", String.fromInt puzzle.id, " ", puzzle.title ]
            in
            div
                [ class "flex-col w-full mb-3 mt-2" ]
                [ div
                    [ class "flex justify-between px-6 py-2 rounded-t-lg border-grey border-b-2 bg-grey-light text-grey-darker hover:bg-grey-light cursor-pointer active:border-b-0"
                    , onClick ToggleShowPuzzleOptions
                    ]
                    [ div
                        []
                        [ text selectorText ]
                    , div
                        []
                        [ span
                            [ class "fas fa-caret-down text-grey-dark text-right" ]
                            []
                        ]
                    ]
                , div [ classList [ ( "hidden", not isOptionsVisible ) ] ] <| List.map (\x -> puzzleOptionDiv x ClickedPuzzle) puzzleOptions
                ]

        leaderTable =
            case maybeLeaderPuzzleUnits of
                Just units ->
                    tableMakerPuzzle [ "Rank", "Username", "Correct Submission" ] units

                Nothing ->
                    div [] []
    in
    leaderboardTemplate False puzzleOptionSelector leaderTable
