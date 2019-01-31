module Page.Archive exposing (Model, Msg, init, subscriptions, toSession, update, view)

import Api
import Decoders exposing (decoderArchiveData)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Html.Lazy exposing (..)
import Json.Decode as Decode exposing (Decoder)
import Markdown
import Page.Nav exposing (navMenu)
import Page.Puzzle exposing (..)
import Page.Shared exposing (..)
import RemoteData exposing (RemoteData(..), WebData)
import Session exposing (Session(..))
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
    div [ class "h-full bg-grey" ] [ lazy3 navMenu ToggledNavMenu model.navActive (Session.viewer model.session), body ]


view : Model -> { title : String, content : Html Msg }
view model =
    case model.state of
        Full fullPuzzleDataListWebData ->
            { title = "Archive - CIGMAH"
            , content = navMenuLinked model <| mainBody model
            }

        Detail fullPuzzleDataList fullPuzzleData ->
            { title = "Archive - CIGMAH"
            , content = mainBody model
            }

        AcceptedFull closedDataWebData ->
            { title = "Archive - CIGMAH"
            , content = navMenuLinked model <| mainBody model
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
    div [ class "h-screen bg-grey-lighter" ]
        [ div [ class "container mx-auto pr-4 pl-4  h-full" ] [ makePuzzleCards model ]
        ]


makePuzzleCards : Model -> Html Msg
makePuzzleCards model =
    case model.state of
        Full Loading ->
            loadingPuzzlePage

        Full (Success puzzles) ->
            div [ class "pt-12" ]
                [ h1 [ class "font-sans font-normal text-2xl border-primary border-b-4 text-primary rounded-lg rounded-b-none  p-3 mt-8 mb-4" ] [ text "Archive" ]
                , div [ class "block md:flex md:flex-wrap" ] <| List.map (puzzleCard ClickedPuzzle) puzzles
                ]

        Detail puzzles selectedPuzzle ->
            detailPuzzle selectedPuzzle ClickedBackToFull

        AcceptedFull Loading ->
            loadingPuzzlePage

        AcceptedFull (Success data) ->
            let
                incompleteCards : List (Html Msg)
                incompleteCards =
                    List.map (puzzleCard ClickedPuzzle) data.incomplete

                completeCards : List (Html Msg)
                completeCards =
                    List.map (puzzleCard ClickedPuzzle) data.complete
            in
            div [ class "" ]
                [ div [ class "h-16" ] []
                , h1 [ class "font-sans font-normal text-2xl  border-primary border-b-4 text-primary rounded-lg rounded-b-none  p-3 mt-8 mb-4" ] [ text "Unsolved Puzzles" ]
                , div [ class "block md:flex md:flex-wrap" ] <| incompleteCards
                , hr [] []
                , h1 [ class "font-sans font-normal text-2xl  border-primary border-b-4 text-primary rounded-lg rounded-b-none  p-3 mt-8 mb-4" ] [ text "Solved Puzzles" ]
                , div [ class "block md:flex md:flex-wrap" ] <| completeCards
                ]

        AcceptedDetail puzzles selectedPuzzle ->
            detailPuzzle selectedPuzzle ClickedBackToFull

        _ ->
            div [] []
