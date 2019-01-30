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
            div [ class "hero is-fullheight-with-navbar" ]
                [ div [ class "hero-body" ]
                    [ div [ class "container" ]
                        [ div [ class "columns is-multiline" ] <|
                            [ submissionsBody
                                data
                            ]
                        ]
                    ]
                ]

        Accepted Loading ->
            div [ class "pageloader is-active" ] []

        Accepted _ ->
            errorPage

        Denied ->
            whoopsPage


makeTableHeadings : List String -> Html Msg
makeTableHeadings headingList =
    let
        makeRow heading =
            th [ class "has-background-info has-text-white" ] [ text heading ]
    in
    thead []
        [ tr [] <| List.map makeRow headingList ]


submissionsBody data =
    let
        headings =
            makeTableHeadings [ "Puzzle", "Theme", "Set", "Submission Time", "Submission", "Status", "Points" ]

        numRows =
            List.length data

        dataRows =
            List.map makeRowUserSubmission data

        tableBody =
            table [ class "table is-hoverable is-fullwidth" ]
                [ headings
                , tbody [] dataRows
                ]
    in
    section [ class "hero" ]
        [ div [ class "hero-body" ]
            [ div [ class "container" ]
                [ div [ class "columns is-centered" ]
                    [ div [ class "column" ] [ tableBody ]
                    ]
                ]
            ]
        ]


makeRowUserSubmission dataRow =
    let
        makeStatus isCorrect =
            case isCorrect of
                True ->
                    "Correct"

                False ->
                    "Incorrect"
    in
    tr []
        [ td [] [ text <| dataRow.puzzleTitle ]
        , td [] [ text <| dataRow.theme ]
        , td [] [ text <| Utils.puzzleSetString dataRow.set ]
        , td [] [ text <| Utils.posixToString dataRow.submissionDatetime ]
        , td [] [ text <| dataRow.submission ]
        , td [] [ text <| makeStatus dataRow.isCorrect ]
        , td [] [ text <| String.fromInt dataRow.points ]
        ]
