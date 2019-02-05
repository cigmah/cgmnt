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
import Views.Leaderboard
import Views.Login
import Views.PuzzleDetail
import Views.PuzzleList
import Views.Register
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

        ( LeaderboardClickedByTotal, Leaderboard _ ) ->
            ( { model | page = Leaderboard (ByTotal Loading) }, Requests.getLeaderboardByTotal )

        ( LeaderboardGotByTotal leaderTotalDataWebData, Leaderboard (ByTotal webData) ) ->
            ( { model | page = Leaderboard (ByTotal leaderTotalDataWebData) }, Cmd.none )

        ( LeaderboardClickedByPuzzle, Leaderboard _ ) ->
            ( { model | page = Leaderboard (ByPuzzleNotChosen False Loading) }, Requests.getPuzzleListPublic )

        ( PuzzleListPublicGotResponse miniPublicPuzzleDataListWebData, Leaderboard (ByPuzzleNotChosen isSelectActive Loading) ) ->
            ( { model | page = Leaderboard (ByPuzzleNotChosen False miniPublicPuzzleDataListWebData) }, Cmd.none )

        ( LeaderboardClickedPuzzle puzzleOption, Leaderboard (ByPuzzleNotChosen _ (Success data)) ) ->
            ( { model | page = Leaderboard (ByPuzzleChosen False data puzzleOption Loading) }, Requests.getLeaderboardByPuzzle puzzleOption.id )

        ( LeaderboardClickedPuzzle puzzleOption, Leaderboard (ByPuzzleChosen _ data _ _) ) ->
            ( { model | page = Leaderboard (ByPuzzleChosen False data puzzleOption Loading) }, Requests.getLeaderboardByPuzzle puzzleOption.id )

        ( LeaderboardGotByPuzzle leaderPuzzleDataWebData, Leaderboard (ByPuzzleChosen isSelectActive data puzzleOption Loading) ) ->
            ( { model | page = Leaderboard (ByPuzzleChosen isSelectActive data puzzleOption leaderPuzzleDataWebData) }, Cmd.none )

        ( LeaderboardTogglePuzzleOptions, Leaderboard (ByPuzzleNotChosen isSelectActive webData) ) ->
            ( { model | page = Leaderboard (ByPuzzleNotChosen (not isSelectActive) webData) }, Cmd.none )

        ( LeaderboardTogglePuzzleOptions, Leaderboard (ByPuzzleChosen isSelectActive data chosenPuzzle webData) ) ->
            ( { model | page = Leaderboard (ByPuzzleChosen (not isSelectActive) data chosenPuzzle webData) }, Cmd.none )

        ( RegisterChangedUsername string, Register (NewUser userData webData) ) ->
            ( { model | page = Register (NewUser { userData | username = string } webData) }, Cmd.none )

        ( RegisterChangedEmail string, Register (NewUser userData webData) ) ->
            ( { model | page = Register (NewUser { userData | email = string } webData) }, Cmd.none )

        ( RegisterChangedFirstName string, Register (NewUser userData webData) ) ->
            ( { model | page = Register (NewUser { userData | firstName = string } webData) }, Cmd.none )

        ( RegisterChangedLastName string, Register (NewUser userData webData) ) ->
            ( { model | page = Register (NewUser { userData | lastName = string } webData) }, Cmd.none )

        ( RegisterClicked, Register (NewUser userData Loading) ) ->
            ( model, Cmd.none )

        ( RegisterClicked, Register (NewUser userData _) ) ->
            ( { model | page = Register (NewUser userData Loading) }, Requests.postRegister userData )

        ( RegisterGotResponse registerResponseDataWebData, Register (NewUser userData Loading) ) ->
            ( { model | page = Register (NewUser userData registerResponseDataWebData) }, Cmd.none )

        ( LoginChangedEmail string, Login (InputEmail email webData) ) ->
            ( { model | page = Login (InputEmail string webData) }, Cmd.none )

        ( LoginClickedSendEmail, Login (InputEmail email webData) ) ->
            ( { model | page = Login (InputEmail email Loading) }, Requests.postSendEmail email )

        ( LoginGotSendEmailResponse responseData, Login (InputEmail email Loading) ) ->
            case responseData of
                Success message ->
                    ( { model | page = Login (InputToken email message "" NotAsked) }, Cmd.none )

                _ ->
                    ( { model | page = Login (InputEmail email responseData) }, Cmd.none )

        ( LoginChangedToken string, Login (InputToken email data token webData) ) ->
            ( { model | page = Login (InputToken email data string webData) }, Cmd.none )

        ( LoginClickedLogin, Login (InputToken email data token Loading) ) ->
            ( model, Cmd.none )

        ( LoginClickedLogin, Login (InputToken email data token webData) ) ->
            ( { model | page = Login (InputToken email data token Loading) }, Requests.postLogin token )

        ( LoginGotLoginResponse credentialsWebData, Login (InputToken email data token Loading) ) ->
            case credentialsWebData of
                Success credentials ->
                    let
                        meta =
                            model.meta
                    in
                    ( { model
                        | meta = { meta | auth = User credentials }
                        , page = Login (InputToken email data token credentialsWebData)
                      }
                    , Handlers.login credentials
                    )

                _ ->
                    ( { model | page = Login (InputToken email data token credentialsWebData) }, Cmd.none )

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
                    Views.Leaderboard.view model.meta leaderboardState

                Register registerState ->
                    Views.Register.view model.meta registerState

                Login loginState ->
                    Views.Login.view model.meta loginState

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