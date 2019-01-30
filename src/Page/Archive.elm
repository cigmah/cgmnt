module Page.Archive exposing (Model, Msg, init, subscriptions, toSession, update, view)

import Api
import Decoders exposing (decoderArchiveData)
import Html exposing (Html, div, h1, text)
import Html.Attributes exposing (class)
import RemoteData exposing (RemoteData(..), WebData)
import Session exposing (Session)
import Types exposing (..)



-- MODEL


type alias Model =
    { session : Session
    , state : State
    }


type State
    = Full (WebData ArchiveData)
    | Detail ArchiveData FullPuzzleData


init : Session -> ( Model, Cmd Msg )
init session =
    ( { session = session
      , state = Full Loading
      }
    , Api.get "puzzles/archive/public/" Nothing ReceivedData decoderArchiveData
    )


toSession : Model -> Session
toSession model =
    model.session



-- UPDATE


type Msg
    = ClickedRefresh
    | ReceivedData (WebData ArchiveData)
    | ClickedPuzzle FullPuzzleData
    | ClickedBackToFull
    | GotSession Session


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ClickedRefresh ->
            ( model, Cmd.none )

        ReceivedData data ->
            ( { model | state = Full data }, Cmd.none )

        ClickedPuzzle puzzle ->
            case model.state of
                Full (Success data) ->
                    ( { model | state = Detail data puzzle }, Cmd.none )

                _ ->
                    ( model, Cmd.none )

        ClickedBackToFull ->
            case model.state of
                Full archiveDataWebData ->
                    ( model, Cmd.none )

                Detail archiveData _ ->
                    ( { model | state = Full (Success archiveData) }, Cmd.none )

        GotSession session ->
            ( { model | session = session }, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Session.changes GotSession (Session.navKey model.session)



-- VIEW


view : Model -> { title : String, content : Html Msg }
view model =
    { title = "Archive"
    , content = div [] [ h1 [] [ text "THIS IS THE Archive PAGE!" ] ]
    }
