module Page.OpenPuzzles exposing (Model, Msg, init, subscriptions, toSession, update, view)

import Api
import Decoders exposing (decoderPuzzleSet, decoderThemeData)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Html.Lazy exposing (..)
import Http exposing (Error(..))
import Iso8601
import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline exposing (optional, required)
import Json.Encode as Encode exposing (Value)
import Markdown
import Page.Error exposing (..)
import Page.Nav exposing (..)
import Page.Puzzle exposing (..)
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
    | Unloaded (WebData OpenData)
    | Full OpenData
    | Detail OpenData SelectedPuzzleInfo (WebData SubmissionResponse)
    | Completed SelectedPuzzleInfo OkSubmitData


type alias OpenData =
    { complete : List LimitedPuzzleData
    , incomplete : List LimitedPuzzleData
    }


type alias SelectedPuzzleInfo =
    { puzzle : LimitedPuzzleData
    , input : String
    , isCompleted : Bool
    }


type SubmissionResponse
    = OkSubmit OkSubmitData
    | TooSoonSubmit TooSoonSubmitData


type alias OkSubmitData =
    { id : Int
    , submission : String
    , isCorrect : Bool
    , points : Int
    }


type alias TooSoonSubmitData =
    { message : String
    , attempts : Int
    , last : Posix
    , wait : Int
    , next : Posix
    }



-- DECODERS


decoderLimitedPuzzleData : Decoder LimitedPuzzleData
decoderLimitedPuzzleData =
    Decode.succeed LimitedPuzzleData
        |> required "id" Decode.int
        |> required "theme" decoderThemeData
        |> required "puzzle_set" decoderPuzzleSet
        |> required "image_link" Decode.string
        |> required "title" Decode.string
        |> required "body" Decode.string
        |> required "example" Decode.string
        |> required "statement" Decode.string
        |> required "references" Decode.string
        |> optional "input" (Decode.maybe Decode.string) Nothing


decoderOpenData : Decoder OpenData
decoderOpenData =
    Decode.map2 OpenData
        (Decode.field "complete" (Decode.list decoderLimitedPuzzleData))
        (Decode.field "incomplete" (Decode.list decoderLimitedPuzzleData))


decodeOkSubmit : Decoder OkSubmitData
decodeOkSubmit =
    Decode.map4 OkSubmitData
        (Decode.field "id" Decode.int)
        (Decode.field "submission" Decode.string)
        (Decode.field "is_response_correct" Decode.bool)
        (Decode.field "points" Decode.int)


decodeTooSoonSubmit : Decoder TooSoonSubmitData
decodeTooSoonSubmit =
    Decode.map5 TooSoonSubmitData
        (Decode.field "message" Decode.string)
        (Decode.field "num_attempts" Decode.int)
        (Decode.field "last_submission" Iso8601.decoder)
        (Decode.field "wait_time_seconds" Decode.int)
        (Decode.field "next_allowed" Iso8601.decoder)


decodeSubmissionResponse : Decoder SubmissionResponse
decodeSubmissionResponse =
    Decode.map OkSubmit decodeOkSubmit


encoderSubmission : SelectedPuzzleInfo -> Value
encoderSubmission selectedPuzzle =
    Encode.object
        [ ( "puzzle_id", Encode.int selectedPuzzle.puzzle.id )
        , ( "submission", Encode.string selectedPuzzle.input )
        ]


init : Session -> ( Model, Cmd Msg )
init session =
    case session of
        LoggedIn _ viewer ->
            ( { session = session, state = Unloaded Loading, navActive = False }
            , Api.get "puzzles/active/" (Just <| Viewer.cred viewer) ReceivedOpenData decoderOpenData
            )

        Guest _ ->
            ( { session = session, state = Denied, navActive = False }, Cmd.none )


toSession : Model -> Session
toSession model =
    model.session



-- UPDATE


type Msg
    = GotSession Session
    | ReceivedOpenData (WebData OpenData)
    | ReceivedSubmissionResponse (WebData SubmissionResponse)
    | ClickedPuzzle Bool LimitedPuzzleData
    | ChangedSubmission String
    | ClickedSubmit
    | ClickedBackToFull
    | ToggledNavMenu


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotSession session ->
            ( { model | session = session }, Cmd.none )

        ReceivedOpenData response ->
            case response of
                Success openData ->
                    ( { model | state = Full openData }, Cmd.none )

                _ ->
                    ( { model | state = Unloaded response }, Cmd.none )

        ClickedPuzzle isCompleted puzzle ->
            case model.state of
                Full openData ->
                    ( { model | state = Detail openData { puzzle = puzzle, input = "", isCompleted = isCompleted } NotAsked }, Cmd.none )

                _ ->
                    ( model, Cmd.none )

        ChangedSubmission input ->
            case model.state of
                Detail openData selectedPuzzleInfo submissionResponseWebData ->
                    ( { model | state = Detail openData { selectedPuzzleInfo | input = input } submissionResponseWebData }, Cmd.none )

                _ ->
                    ( model, Cmd.none )

        ClickedSubmit ->
            case model.state of
                Detail openData selectedPuzzleInfo submissionResponseWebData ->
                    ( { model | state = Detail openData selectedPuzzleInfo Loading }
                    , Api.post "submissions/" (Session.cred model.session) ReceivedSubmissionResponse decodeSubmissionResponse (encoderSubmission selectedPuzzleInfo)
                    )

                _ ->
                    ( model, Cmd.none )

        ReceivedSubmissionResponse response ->
            case model.state of
                Detail openData selectedPuzzleInfo submissionResponseWebData ->
                    case response of
                        Success (OkSubmit okSubmitData) ->
                            case okSubmitData.isCorrect of
                                True ->
                                    ( { model | state = Completed selectedPuzzleInfo okSubmitData }, Cmd.none )

                                _ ->
                                    ( { model | state = Detail openData selectedPuzzleInfo response }, Cmd.none )

                        Failure (BadStatus e) ->
                            case e.status.code of
                                412 ->
                                    let
                                        decodedErrorData =
                                            Decode.decodeString decodeTooSoonSubmit e.body
                                    in
                                    case decodedErrorData of
                                        Ok tooSoonData ->
                                            ( { model | state = Detail openData selectedPuzzleInfo (Success (TooSoonSubmit tooSoonData)) }, Cmd.none )

                                        Err _ ->
                                            ( { model | state = Detail openData selectedPuzzleInfo response }, Cmd.none )

                                _ ->
                                    ( { model | state = Detail openData selectedPuzzleInfo response }, Cmd.none )

                        _ ->
                            ( { model | state = Detail openData selectedPuzzleInfo response }, Cmd.none )

                _ ->
                    ( model, Cmd.none )

        ClickedBackToFull ->
            case model.state of
                Detail _ _ Loading ->
                    ( model, Cmd.none )

                Detail openData _ _ ->
                    ( { model | state = Full openData }, Cmd.none )

                Completed selectedPuzzleInfo okSubmitData ->
                    ( { model | state = Unloaded Loading }
                    , Api.get "puzzles/active/" (Session.cred model.session) ReceivedOpenData decoderOpenData
                    )

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


mainHero model =
    let
        mainBody =
            case model.state of
                Unloaded Loading ->
                    div [ class "pageloader is-active" ] []

                Unloaded _ ->
                    errorPage

                Denied ->
                    whoopsPage

                Full openData ->
                    puzzleContainer openData

                Detail _ selectedPuzzle submissionResponse ->
                    detailPuzzleLimited selectedPuzzle ClickedBackToFull ChangedSubmission ClickedSubmit submissionResponse

                Completed selectedPuzzle okSubmitData ->
                    completedPage selectedPuzzle okSubmitData ClickedBackToFull
    in
    mainBody


puzzleContainer openData =
    div [ class "container" ]
        [ h1 [ class "title" ] [ text "Unsolved Puzzles" ]
        , div [ class "columns is-multiline" ] <| List.map (puzzleCard (ClickedPuzzle False)) openData.incomplete
        , hr [] []
        , h2 [ class "title" ] [ text "Solved Puzzles" ]
        , div [ class "columns is-multiline" ] <| List.map (puzzleCard (ClickedPuzzle True)) openData.complete
        ]


completedPage selectedPuzzle okSubmitData backEvent =
    div [ class "hero is-fullheight-with-navbar" ]
        [ div [ class "hero-body" ]
            [ div [ class "container" ]
                [ h1 [ class "title" ] [ text "Congratulations!" ]
                , h2 [ class "subtitle" ]
                    [ text <|
                        "You solved "
                            ++ selectedPuzzle.puzzle.title
                            ++ " and earned "
                            ++ String.fromInt okSubmitData.points
                            ++ " points!"
                    ]
                , button [ class "button", onClick backEvent ] [ text "Go Back to Open Puzzles" ]
                ]
            ]
        ]


detailPuzzleLimited selectedPuzzle onDeselectEvent onInputChangeEvent onSubmitEvent submissionResponse =
    let
        afterText =
            case selectedPuzzle.isCompleted of
                True ->
                    "You've completed this puzzle! The solution and explanation will be disclosed when this theme closes."

                False ->
                    "Enter your submission in the submission box below."

        isLoadingClass =
            case submissionResponse of
                Loading ->
                    " is-loading "

                _ ->
                    ""

        submitField =
            case selectedPuzzle.isCompleted of
                True ->
                    div [] []

                False ->
                    div [ class "field is-grouped" ]
                        [ div [ class "control" ]
                            [ div [ class "field has-addons" ]
                                [ div [ class "control is-expanded" ]
                                    [ input [ class "input", type_ "text", placeholder "Your submission here.", onInput <| onInputChangeEvent ] [] ]
                                , div [ class "control" ]
                                    [ button [ class <| "button is-info " ++ isLoadingClass, onClick <| onSubmitEvent ] [ text "Submit" ] ]
                                ]
                            ]
                        ]

        footerSection =
            case submissionResponse of
                Success submitData ->
                    case submitData of
                        OkSubmit submission ->
                            case submission.isCorrect of
                                True ->
                                    div [ class "field" ]
                                        [ div [ class "control is-expanded" ]
                                            [ button [ class "button has-background-success has-text-white is-static" ]
                                                [ text <| "Congratulations! You scored " ++ String.fromInt submission.points ++ " points!" ]
                                            ]
                                        ]

                                False ->
                                    submitField

                        _ ->
                            submitField

                _ ->
                    submitField

        baseHeaderMessage colour msg =
            header [ class <| "modal-card-head has-text-white has-background-" ++ colour ] [ p [ class "content" ] [ text msg ] ]

        headerMessage =
            case submissionResponse of
                Success submitData ->
                    case submitData of
                        OkSubmit submission ->
                            case submission.isCorrect of
                                True ->
                                    div [] []

                                False ->
                                    baseHeaderMessage "warning" "Your response was incorrect. Have a break and have another go later :) "

                        TooSoonSubmit submission ->
                            baseHeaderMessage "danger" <| "Your last attempt (" ++ Utils.posixToString submission.last ++ ", attempt no. " ++ String.fromInt submission.attempts ++ ") was too recent. You can next submit at " ++ Utils.posixToString submission.next ++ "."

                Failure _ ->
                    baseHeaderMessage "danger" "Hm. There was an error with submitting your submission...maybe a network issue? If not, get in contact with us - we'd like to know!"

                _ ->
                    div [] []
    in
    div [ class "modal is-active" ]
        [ div [ class "modal-background" ] []
        , div [ class "modal-card" ]
            [ header [ class "modal-card-head" ]
                [ p [ class "modal-card-title" ]
                    [ text selectedPuzzle.puzzle.title ]
                , button [ class "delete is-medium", onClick onDeselectEvent ] []
                ]
            , headerMessage
            , div [ class "modal-card-body" ]
                [ puzzleTags selectedPuzzle.puzzle
                , div [ class "container" ]
                    [ div [ class "content" ]
                        [ p [] <| Markdown.toHtml Nothing selectedPuzzle.puzzle.body ]
                    , div [ class "message" ]
                        [ div [ class "message-body" ] <| Markdown.toHtml Nothing selectedPuzzle.puzzle.example
                        ]
                    , div [ class "notification is-info" ] <| Markdown.toHtml Nothing selectedPuzzle.puzzle.statement
                    , hr [] []
                    , div [ class "content" ] [ text afterText ]
                    ]
                ]
            , div [ class "modal-card-foot" ]
                [ footerSection ]
            ]
        ]
