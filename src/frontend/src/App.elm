module App exposing (init, subscriptions, update, view)

import Browser
import Browser.Navigation as Navigation
import Handlers
import Html exposing (Html, div)
import Html.Lazy exposing (lazy4)
import Http exposing (Error(..))
import Json.Decode as Decode
import RemoteData exposing (RemoteData(..), WebData)
import Requests
import Types exposing (..)
import Url
import Views.Format
import Views.Home
import Views.Leaderboard
import Views.Login
import Views.Logout
import Views.Prizes
import Views.PuzzleDetail
import Views.PuzzleList
import Views.Register
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

        ( ToggledTheme, _ ) ->
            let
                oldMeta =
                    model.meta

                ( newColourTheme, themeLight ) =
                    case oldMeta.colourTheme of
                        Light ->
                            ( Dark, False )

                        Dark ->
                            ( Light, True )
            in
            ( { model | meta = { oldMeta | colourTheme = newColourTheme } }, Handlers.themeLight themeLight )

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

        ( ToggledMessage, PuzzleDetail puzzleShow (UnsolvedPuzzleLoaded puzzleId detailData submission (Failure _)) ) ->
            ( { model | page = PuzzleDetail puzzleShow (UnsolvedPuzzleLoaded puzzleId detailData submission NotAsked) }, Cmd.none )

        ( ToggledMessage, PuzzleDetail puzzleShow (UnsolvedPuzzleLoaded puzzleId detailData submission (Success _)) ) ->
            ( { model | page = PuzzleDetail puzzleShow (UnsolvedPuzzleLoaded puzzleId detailData submission NotAsked) }, Cmd.none )

        ( HomeGotProfileResponse profileDataWebData, Home (HomeUser userData Loading) ) ->
            ( { model | page = Home (HomeUser userData profileDataWebData) }, Cmd.none )

        ( PrizesGotResponse webData, Prizes Loading ) ->
            ( { model | page = Prizes webData }, Cmd.none )

        ( PuzzleListPublicGotResponse miniPublicPuzzleDataListWebData, PuzzleList (ListPublic Loading) ) ->
            ( { model | page = PuzzleList <| ListPublic miniPublicPuzzleDataListWebData }, Cmd.none )

        ( PuzzleListUserGotResponse miniPuzzleDataListWebData, PuzzleList (ListUser Loading) ) ->
            ( { model | page = PuzzleList <| ListUser miniPuzzleDataListWebData }, Cmd.none )

        ( PuzzleListClickedPuzzle puzzleId, PuzzleList _ ) ->
            Handlers.changedRoute model.meta (PuzzleDetailRoute puzzleId)

        ( PuzzleDetailGotUser webData, PuzzleDetail puzzleShow (UserPuzzle puzzleId Loading) ) ->
            case webData of
                Success puzzle ->
                    case puzzle.isSolved of
                        Just False ->
                            ( { model | page = PuzzleDetail puzzleShow <| UnsolvedPuzzleLoaded puzzleId puzzle "" NotAsked }, Cmd.none )

                        _ ->
                            ( { model | page = PuzzleDetail puzzleShow <| UserPuzzle puzzleId webData }, Cmd.none )

                _ ->
                    ( { model | page = PuzzleDetail puzzleShow <| UserPuzzle puzzleId webData }, Cmd.none )

        ( PuzzleDetailChangedSubmission submission, PuzzleDetail puzzleShow (UnsolvedPuzzleLoaded puzzleId puzzle _ webData) ) ->
            ( { model | page = PuzzleDetail puzzleShow (UnsolvedPuzzleLoaded puzzleId puzzle submission webData) }, Cmd.none )

        ( PuzzleDetailClickedSubmit puzzleId, PuzzleDetail puzzleShow (UnsolvedPuzzleLoaded _ _ _ Loading) ) ->
            ( model, Cmd.none )

        ( PuzzleDetailClickedSubmit puzzleId, PuzzleDetail puzzleShow (UnsolvedPuzzleLoaded puzzleIdSame puzzle submission webData) ) ->
            case model.meta.auth of
                User credentials ->
                    case submission of
                        "" ->
                            ( model, Cmd.none )

                        _ ->
                            ( { model | page = PuzzleDetail puzzleShow (UnsolvedPuzzleLoaded puzzleId puzzle submission Loading) }, Requests.postSubmit credentials.token submission puzzleId )

                Public ->
                    ( model, Cmd.none )

        ( PuzzleDetailGotSubmissionResponse webData, PuzzleDetail puzzleShow (UnsolvedPuzzleLoaded puzzleId data submission Loading) ) ->
            case webData of
                Failure (BadStatus e) ->
                    case e.status.code of
                        412 ->
                            let
                                decodedErrorData =
                                    Decode.decodeString Requests.decoderTooSoonSubmit e.body
                            in
                            case decodedErrorData of
                                Ok tooSoonData ->
                                    ( { model | page = PuzzleDetail puzzleShow (UnsolvedPuzzleLoaded puzzleId data submission (Success (TooSoonSubmit tooSoonData))) }, Cmd.none )

                                Err _ ->
                                    ( { model | page = PuzzleDetail puzzleShow (UnsolvedPuzzleLoaded puzzleId data submission webData) }, Cmd.none )

                        _ ->
                            ( { model | page = PuzzleDetail puzzleShow (UnsolvedPuzzleLoaded puzzleId data submission webData) }, Cmd.none )

                _ ->
                    ( { model | page = PuzzleDetail puzzleShow (UnsolvedPuzzleLoaded puzzleId data submission webData) }, Cmd.none )

        ( PuzzleDetailGotPublic publicPuzzleDataWebData, PuzzleDetail puzzleShow (PublicPuzzle puzzleId Loading) ) ->
            ( { model | page = PuzzleDetail puzzleShow <| PublicPuzzle puzzleId publicPuzzleDataWebData }, Cmd.none )

        ( PuzzleDetailTogglePuzzleShow, PuzzleDetail puzzleShow puzzleDetailState ) ->
            case puzzleShow of
                Video ->
                    ( { model | page = PuzzleDetail Text puzzleDetailState }, Cmd.none )

                Text ->
                    ( { model | page = PuzzleDetail Video puzzleDetailState }, Cmd.none )

        ( LeaderboardClickedByTotal, Leaderboard _ ) ->
            ( { model | page = Leaderboard (ByTotal Loading) }, Requests.getLeaderboardByTotal )

        ( LeaderboardGotByTotal leaderTotalDataWebData, Leaderboard (ByTotal webData) ) ->
            ( { model | page = Leaderboard (ByTotal leaderTotalDataWebData) }, Cmd.none )

        ( LeaderboardClickedByPuzzle, Leaderboard _ ) ->
            ( { model | page = Leaderboard (ByPuzzleNotChosen False Loading) }, Requests.getPuzzleListPublicforLeaderboard )

        ( LeaderboardGotPuzzleOptions miniPublicPuzzleDataListWebData, Leaderboard (ByPuzzleNotChosen isSelectActive Loading) ) ->
            ( { model | page = Leaderboard (ByPuzzleNotChosen False miniPublicPuzzleDataListWebData) }, Cmd.none )

        ( LeaderboardClickedPuzzle puzzleOption, Leaderboard (ByPuzzleNotChosen _ (Success data)) ) ->
            ( { model | page = Leaderboard (ByPuzzleChosen False data puzzleOption Loading) }, Requests.getLeaderboardByPuzzle puzzleOption.id )

        ( LeaderboardClickedPuzzle puzzleOption, Leaderboard (ByPuzzleChosen _ data _ _) ) ->
            ( { model | page = Leaderboard (ByPuzzleChosen False data puzzleOption Loading) }, Requests.getLeaderboardByPuzzle puzzleOption.id )

        ( LeaderboardGotByPuzzle leaderPuzzleDataWebData, Leaderboard (ByPuzzleChosen isSelectActive data puzzleOption Loading) ) ->
            ( { model | page = Leaderboard (ByPuzzleChosen isSelectActive data puzzleOption leaderPuzzleDataWebData) }, Cmd.none )

        ( LeaderboardTogglePuzzleOptions, Leaderboard (ByPuzzleNotChosen isSelectActive webData) ) ->
            ( { model | page = Leaderboard (ByPuzzleNotChosen (not isSelectActive) webData) }, Cmd.none )

        ( LeaderboardClickedBySet, Leaderboard _ ) ->
            ( { model | page = Leaderboard (BySetNotChosen False) }, Cmd.none )

        ( LeaderboardClickedSet puzzleSet, Leaderboard _ ) ->
            ( { model | page = Leaderboard (BySetChosen False puzzleSet Loading) }, Requests.getLeaderboardBySet puzzleSet )

        ( LeaderboardGotBySet webData, Leaderboard (BySetChosen isSelectActive puzzleSet (Success _)) ) ->
            ( model, Cmd.none )

        ( LeaderboardGotBySet webData, Leaderboard (BySetChosen isSelectActive puzzleSet _) ) ->
            ( { model | page = Leaderboard (BySetChosen False puzzleSet webData) }, Cmd.none )

        ( LeaderboardTogglePuzzleOptions, Leaderboard (ByPuzzleChosen isSelectActive data chosenPuzzle webData) ) ->
            ( { model | page = Leaderboard (ByPuzzleChosen (not isSelectActive) data chosenPuzzle webData) }, Cmd.none )

        ( LeaderboardToggleSetOptions, Leaderboard (BySetChosen isSelectActive puzzleSet webData) ) ->
            ( { model | page = Leaderboard (BySetChosen (not isSelectActive) puzzleSet webData) }, Cmd.none )

        ( LeaderboardToggleSetOptions, Leaderboard (BySetNotChosen isSelectActive) ) ->
            ( { model | page = Leaderboard (BySetNotChosen (not isSelectActive)) }, Cmd.none )

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

                Format ->
                    Views.Format.view model.meta

                Prizes webData ->
                    Views.Prizes.view model.meta webData

                PuzzleList puzzleListState ->
                    Views.PuzzleList.view model.meta puzzleListState

                PuzzleDetail puzzleShow puzzleDetailState ->
                    Views.PuzzleDetail.view model.meta puzzleShow puzzleDetailState

                Leaderboard leaderboardState ->
                    Views.Leaderboard.view model.meta leaderboardState

                Register registerState ->
                    Views.Register.view model.meta registerState

                Login loginState ->
                    Views.Login.view model.meta loginState

                Logout ->
                    Views.Logout.view model.meta

                NotFound ->
                    ( "Not Found - CIGMAH", Views.Shared.notFoundPage )

        navMenu =
            lazy4 Views.Shared.navMenu model.meta.isNavActive model.meta.auth model.page model.meta.colourTheme
    in
    { title = title
    , body =
        [ navMenu
        , body
        ]
    }