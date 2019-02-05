module App exposing (init, subscriptions, update, view)

import Browser
import Browser.Navigation as Navigation
import Handlers
import Html exposing (Html, div)
import Html.Lazy exposing (lazy2)
import Json.Decode as Decode
import RemoteData exposing (RemoteData(..), WebData)
import Requests
import Types exposing (..)
import Url
import Views.Home
import Views.PuzzleDetail
import Views.PuzzleList
import Views.Resources
import Views.Shared


init : Decode.Value -> Url.Url -> Navigation.Key -> ( Model, Cmd Msg )
init =
    Handlers.init


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( msg, model.page ) of
        ( Ignored, _ ) ->
            ( model, Cmd.none )

        ( ClickedLink urlRequestBrowser, _ ) ->
            Handlers.clickedLink model urlRequestBrowser

        ( ChangedUrl url, _ ) ->
            Handlers.changedUrl model.meta url

        ( ChangedRoute route, _ ) ->
            Handlers.changedRoute model.meta route

        ( ToggledNav, _ ) ->
            let
                oldMeta =
                    model.meta
            in
            ( { model | meta = { oldMeta | isNavActive = not oldMeta.isNavActive } }, Cmd.none )

        ( ToggledMessage, PuzzleDetail (UnsolvedPuzzleLoaded puzzleId detailData submission (Failure e)) ) ->
            ( { model | page = PuzzleDetail (UnsolvedPuzzleLoaded puzzleId detailData submission NotAsked) }, Cmd.none )

        ( HomeChangedName string, Home (HomePublic contactData webData) ) ->
            case webData of
                Success _ ->
                    ( model, Cmd.none )

                Loading ->
                    ( model, Cmd.none )

                _ ->
                    ( { model | page = Home <| HomePublic { contactData | name = string } webData }, Cmd.none )

        ( HomeChangedEmail string, Home (HomePublic contactData webData) ) ->
            case webData of
                Success _ ->
                    ( model, Cmd.none )

                Loading ->
                    ( model, Cmd.none )

                _ ->
                    ( { model | page = Home <| HomePublic { contactData | email = string } webData }, Cmd.none )

        ( HomeChangedSubject string, Home (HomePublic contactData webData) ) ->
            case webData of
                Success _ ->
                    ( model, Cmd.none )

                Loading ->
                    ( model, Cmd.none )

                _ ->
                    ( { model | page = Home <| HomePublic { contactData | subject = string } webData }, Cmd.none )

        ( HomeChangedBody string, Home (HomePublic contactData webData) ) ->
            case webData of
                Success _ ->
                    ( model, Cmd.none )

                Loading ->
                    ( model, Cmd.none )

                _ ->
                    ( { model | page = Home <| HomePublic { contactData | body = string } webData }, Cmd.none )

        ( HomeClickedSend, Home (HomePublic contactData webData) ) ->
            case webData of
                Success _ ->
                    ( model, Cmd.none )

                Loading ->
                    ( model, Cmd.none )

                _ ->
                    ( { model | page = Home <| HomePublic contactData Loading }, Requests.postContact contactData )

        ( HomeGotContactResponse contactResponseDataWebData, Home (HomePublic contactData webData) ) ->
            ( { model | page = Home <| HomePublic contactData contactResponseDataWebData }, Cmd.none )

        ( HomeGotProfileResponse profileDataWebData, _ ) ->
            ( model, Cmd.none )

        ( PuzzleListPublicGotResponse miniPublicPuzzleDataListWebData, PuzzleList (ListPublic webData) ) ->
            ( { model | page = PuzzleList <| ListPublic miniPublicPuzzleDataListWebData }, Cmd.none )

        ( PuzzleListUserGotResponse miniUserPuzzleDataListWebData, _ ) ->
            ( model, Cmd.none )

        ( PuzzleListClickedPuzzle puzzleId, PuzzleList _ ) ->
            Handlers.changedRoute model.meta (PuzzleDetailRoute puzzleId)

        ( PuzzleDetailGotUser userPuzzleDataWebData, _ ) ->
            ( model, Cmd.none )

        ( PuzzleDetailChangedSubmission submission, _ ) ->
            ( model, Cmd.none )

        ( PuzzleDetailClickedSubmit puzzleId, _ ) ->
            ( model, Cmd.none )

        ( PuzzleDetailGotSubmissionResponse submissionResponseDataWebData, _ ) ->
            ( model, Cmd.none )

        ( PuzzleDetailGotPublic publicPuzzleDataWebData, PuzzleDetail (PublicPuzzle puzzleId Loading) ) ->
            ( { model | page = PuzzleDetail <| PublicPuzzle puzzleId publicPuzzleDataWebData }, Cmd.none )

        ( LeaderboardClickedByTotal, _ ) ->
            ( model, Cmd.none )

        ( LeaderboardGotByTotal leaderTotalDataWebData, _ ) ->
            ( model, Cmd.none )

        ( LeaderboardClickedByPuzzle, _ ) ->
            ( model, Cmd.none )

        ( LeaderboardGotPuzzleOptions miniPublicPuzzleDataListWebData, _ ) ->
            ( model, Cmd.none )

        ( LeaderboardClickedPuzzle puzzleOption, _ ) ->
            ( model, Cmd.none )

        ( LeaderboardGotByPuzzle leaderPuzzleDataWebData, _ ) ->
            ( model, Cmd.none )

        ( LeaderboardTogglePuzzleOptions, _ ) ->
            ( model, Cmd.none )

        ( RegisterChangedUsername string, _ ) ->
            ( model, Cmd.none )

        ( RegisterChangedEmail string, _ ) ->
            ( model, Cmd.none )

        ( RegisterChangedFirstName string, _ ) ->
            ( model, Cmd.none )

        ( RegisterChangedLastName string, _ ) ->
            ( model, Cmd.none )

        ( RegisterClicked string, _ ) ->
            ( model, Cmd.none )

        ( RegisterGotResponse registerResponseDataWebData, _ ) ->
            ( model, Cmd.none )

        ( LoginChangedEmail string, _ ) ->
            ( model, Cmd.none )

        ( LoginClickedSendEmail, _ ) ->
            ( model, Cmd.none )

        ( LoginGotSendEmailResponse sendEmailResponseDataWebData, _ ) ->
            ( model, Cmd.none )

        ( LoginChangedToken string, _ ) ->
            ( model, Cmd.none )

        ( LoginClickedLogin, _ ) ->
            ( model, Cmd.none )

        ( LoginGotLoginResponse credentialsWebData, _ ) ->
            ( model, Cmd.none )

        ( _, _ ) ->
            ( model, Cmd.none )


view : Model -> Browser.Document Msg
view model =
    let
        ( title, body ) =
            case model.page of
                Home homeState ->
                    Views.Home.view model.meta homeState

                Resources ->
                    Views.Resources.view model.meta

                PuzzleList puzzleListState ->
                    Views.PuzzleList.view model.meta puzzleListState

                PuzzleDetail puzzleDetailState ->
                    Views.PuzzleDetail.view model.meta puzzleDetailState

                Leaderboard leaderboardState ->
                    ( "CIGMAH", div [] [] )

                Register registerState ->
                    ( "CIGMAH", div [] [] )

                Login loginState ->
                    ( "CIGMAH", div [] [] )

                NotFound ->
                    ( "Not Found - CIGMAH", Views.Shared.notFoundPage )

        navMenu =
            case model.page of
                PuzzleDetail puzzleDetailState ->
                    div [] []

                _ ->
                    lazy2 Views.Shared.navMenu model.meta.isNavActive model.meta.auth
    in
    { title = title
    , body =
        [ navMenu
        , body
        ]
    }
