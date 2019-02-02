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
import Page.Shared exposing (..)
import RemoteData exposing (RemoteData(..), WebData)
import Session exposing (Session(..))
import Time exposing (Posix, millisToPosix)
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
    | RemoveMsg
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

        RemoveMsg ->
            case model.state of
                Detail data puzzle response ->
                    ( { model | state = Detail data puzzle NotAsked }, Cmd.none )

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
    case model.state of
        Detail openData selectedPuzzleInfo submissionResponseWebData ->
            { title = selectedPuzzleInfo.puzzle.title ++ " - CIGMAH"
            , content = mainBody selectedPuzzleInfo submissionResponseWebData
            }

        Completed selectedPuzzleInfo okSubmitData ->
            { title = selectedPuzzleInfo.puzzle.title ++ " - CIGMAH"
            , content = successScreen selectedPuzzleInfo okSubmitData
            }

        Full data ->
            { title = "Open Puzzles - CIGMAH"
            , content = navMenuLinked model <| bodyFullUser data
            }

        Unloaded Loading ->
            { title = "Open Puzzles - CIGMAH"
            , content = navMenuLinked model <| bodyFullPlaceholder
            }

        _ ->
            { title = "Open Puzzles - CIGMAH"
            , content = navMenuLinked model <| errorPage
            }


successScreen selectedPuzzleInfo okSubmitData =
    div
        [ class "px-8 bg-grey-lightest" ]
        [ div
            [ class "flex flex-wrap h-screen content-center justify-center items-center" ]
            [ div
                [ class "block md:w-3/4 lg:w-2/3 xl:w-1/2" ]
                [ div
                    [ class "inline-flex flex justify-center w-full" ]
                    [ div
                        [ class "flex items-center sm:text-xl justify-center sm:h-12 sm:w-10 px-5 py-3 rounded-l-lg font-black bg-green text-grey-lighter border-b-2 border-green-dark" ]
                        [ span
                            [ class "fas fa-glass-cheers" ]
                            []
                        ]
                    , div
                        [ class "flex items-center w-full p-3 px-5 sm:h-12 rounded-r-lg text-grey-darkest sm:text-lg font-bold uppercase bg-grey-lighter border-b-2 border-grey" ]
                        [ text "Congratulations!" ]
                    ]
                , div
                    [ class "block w-full my-3 bg-white rounded-lg p-6 w-full text-base border-b-2 border-grey-light" ]
                    [ div
                        [ class "text-lg" ]
                        [ text <| String.concat [ "You completed ", selectedPuzzleInfo.puzzle.title, " and earned ", String.fromInt okSubmitData.points, " points!" ]
                        , br
                            []
                            []
                        , div
                            [ class "text-lg" ]
                            [ text "Great job!" ]
                        ]
                    , div
                        [ class "flex w-full justify-center" ]
                        [ button
                            [ class "px-3 py-2 bg-green rounded-full border-b-4 border-green-dark w-full md:w-1/2 text-white active:border-0 outline-none focus:outline-none active:outline-none hover:bg-green-dark"
                            , onClick ClickedBackToFull
                            ]
                            [ text "Go Back to Puzzles" ]
                        ]
                    ]
                ]
            ]
        ]


mainBody selectedPuzzleInfo webData =
    case selectedPuzzleInfo.isCompleted of
        True ->
            viewDetailPuzzle (OpenSolved selectedPuzzleInfo.puzzle) ClickedBackToFull Nothing Nothing RemoveMsg

        False ->
            viewDetailPuzzle (OpenUnsolved selectedPuzzleInfo.puzzle webData) ClickedBackToFull (Just ChangedSubmission) (Just ClickedSubmit) RemoveMsg


bodyFullUser data =
    fullPuzzlePage False Nothing (Open data.incomplete data.complete) (Just (ClickedPuzzle False)) (Just (ClickedPuzzle True))


bodyFullPlaceholder =
    fullPuzzlePage True Nothing (Open (List.repeat 4 defaultPuzzleData) (List.repeat 4 defaultPuzzleData)) Nothing Nothing


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
