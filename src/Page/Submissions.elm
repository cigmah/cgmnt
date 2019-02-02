module Page.Submissions exposing (Model, Msg, init, subscriptions, toSession, update, view)

import Api
import Decoders exposing (decoderPuzzleSet, decoderThemeSet)
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
    = Denied
    | Accepted (WebData SubmissionsData)


type alias SubmissionsData =
    List UserSubmission


type alias UserSubmission =
    { username : String
    , puzzleTitle : String
    , theme : String
    , set : PuzzleSet
    , submissionDatetime : Posix
    , submission : String
    , isCorrect : Bool
    , points : Int
    }


init : Session -> ( Model, Cmd Msg )
init session =
    case session of
        LoggedIn _ viewer ->
            ( { session = session, state = Accepted Loading, navActive = False }
            , Api.get "submissions/user/" (Just <| Viewer.cred viewer) ReceivedData decoderSubmissionsData
            )

        Guest _ ->
            ( { session = session, state = Denied, navActive = False }
            , Cmd.none
            )


decoderUserSubmission : Decoder UserSubmission
decoderUserSubmission =
    Decode.map8 UserSubmission
        (Decode.field "user" <| Decode.field "username" Decode.string)
        (Decode.field "puzzle" <| Decode.field "title" Decode.string)
        (Decode.field "puzzle" <| Decode.field "theme" <| Decode.field "theme" Decode.string)
        (Decode.field "puzzle" <| Decode.field "puzzle_set" decoderPuzzleSet)
        (Decode.field "submission_datetime" Iso8601.decoder)
        (Decode.field "submission" Decode.string)
        (Decode.field "is_response_correct" Decode.bool)
        (Decode.field "points" Decode.int)


decoderSubmissionsData : Decoder SubmissionsData
decoderSubmissionsData =
    Decode.list decoderUserSubmission


toSession : Model -> Session
toSession model =
    model.session



-- UPDATE


type Msg
    = GotSession Session
    | ReceivedData (WebData SubmissionsData)
    | ToggledNavMenu


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotSession session ->
            ( { model | session = session }, Cmd.none )

        ReceivedData response ->
            ( { model | state = Accepted response }, Cmd.none )

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


mainHero model =
    case model.state of
        Accepted (Success data) ->
            viewPage data

        Accepted Loading ->
            loadingPage

        Accepted _ ->
            errorPage

        Denied ->
            whoopsPage


viewPage data =
    pageTemplate False <| tableMaker [ "Puzzle", "Time", "Submission", "Correct", "Points" ] data


loadingPage =
    pageTemplate True <| div [ class "h-64 bg-grey-lighter block my-2 w-full" ] []


pageTemplate isLoading tableToShow =
    div
        [ class "px-8 bg-grey-lightest" ]
        [ div
            [ class "mb-4 flex flex-wrap content-center justify-center items-center pt-16" ]
            [ div
                [ class "block md:w-5/6 lg:w-4/5 xl:w-3/4" ]
                [ div
                    [ class "inline-flex flex justify-center w-full" ]
                    [ div
                        [ class "flex items-center  sm:text-xl justify-center  px-5 py-3 rounded-l-lg font-black bg-green border-b-2 border-green-dark"
                        , classList [ ( "text-green", isLoading ), ( "text-white", not isLoading ) ]
                        ]
                        [ span
                            [ class "fas fa-table" ]
                            []
                        ]
                    , div
                        [ class "flex items-center  w-full p-3 px-5 rounded-r-lg text-grey-darkest sm:text-lg font-bold uppercase bg-grey-lighter border-b-2 border-grey" ]
                        [ textWithLoad isLoading "My Submissions" ]
                    ]
                , div
                    [ class "block w-full my-3 bg-white rounded-lg p-6 w-full text-base border-b-2 border-grey-light" ]
                    [ p
                        []
                        [ textWithLoad isLoading "Here is a list of your submissions." ]
                    , br
                        []
                        []
                    , tableToShow
                    ]
                ]
            ]
        ]


tableRowExtended isHeader strList =
    let
        classes =
            if isHeader then
                "w-full bg-grey-light text-sm text-grey-darker"

            else
                "w-full bg-grey-lightest text-center hover:bg-grey-lighter text-grey-darkest"
    in
    tr [ class classes ] <| List.map2 (\x y -> tableCell x y isHeader) (List.repeat 5 "w-auto") strList


tableMaker headerList unitList =
    let
        isCorrectString a =
            if a then
                "✓"

            else
                "x"
    in
    div
        [ id "table-block", class "block py-2" ]
        [ table
            [ class "w-full" ]
          <|
            tableRowExtended True headerList
                :: List.map (\x -> tableRowExtended False [ x.puzzleTitle, Utils.posixToString x.submissionDatetime, x.submission, isCorrectString x.isCorrect, String.fromInt x.points ]) unitList
        ]
