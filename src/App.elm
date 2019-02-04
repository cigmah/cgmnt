module App exposing (init, subscriptions, update, view)

import Browser
import Browser.Navigation as Navigation
import Handlers
import Html exposing (Html, div)
import Json.Decode as Decode
import Types exposing (..)
import Url


init : Decode.Value -> Url.Url -> Navigation.Key -> ( Model, Cmd Msg )
init =
    Handlers.init


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( msg, model ) of
        ( Ignored, _ ) ->
            ( model, Cmd.none )

        ( ClickedLink urlRequestBrowser, _ ) ->
            ( model, Cmd.none )

        ( ChangedUrl urlUrl, _ ) ->
            ( model, Cmd.none )

        ( ChangedRoute routeMaybe, _ ) ->
            ( model, Cmd.none )

        ( ToggledNav, _ ) ->
            ( model, Cmd.none )

        ( HomeChangedName string, _ ) ->
            ( model, Cmd.none )

        ( HomeChangedEmail string, _ ) ->
            ( model, Cmd.none )

        ( HomeChangedSubject string, _ ) ->
            ( model, Cmd.none )

        ( HomeChangedBody string, _ ) ->
            ( model, Cmd.none )

        ( HomeClickedSend, _ ) ->
            ( model, Cmd.none )

        ( HomeGotContactResponse contactResponseDataWebData, _ ) ->
            ( model, Cmd.none )

        ( HomeGotProfileResponse profileDataWebData, _ ) ->
            ( model, Cmd.none )

        ( PuzzleListPublicGotResponse miniPublicPuzzleDataListWebData, _ ) ->
            ( model, Cmd.none )

        ( PuzzleListUserGotResponse miniUserPuzzleDataListWebData, _ ) ->
            ( model, Cmd.none )

        ( PuzzleListClickedPuzzle puzzleId, _ ) ->
            ( model, Cmd.none )

        ( PuzzleDetailGotUser userPuzzleDataWebData, _ ) ->
            ( model, Cmd.none )

        ( PuzzleDetailChangedSubmission submission, _ ) ->
            ( model, Cmd.none )

        ( PuzzleDetailClickedSubmit puzzleId, _ ) ->
            ( model, Cmd.none )

        ( PuzzleDetailGotSubmissionResponse submissionResponseDataWebData, _ ) ->
            ( model, Cmd.none )

        ( PuzzleDetailGotPublic publicPuzzleDataWebData, _ ) ->
            ( model, Cmd.none )

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


view : Model -> Browser.Document Msg
view model =
    let
        ( title, body ) =
            case model.page of
                Home homeState ->
                    ( "CIGMAH", div [] [] )

                Resources ->
                    ( "CIGMAH", div [] [] )

                PuzzleList puzzleListState ->
                    ( "CIGMAH", div [] [] )

                PuzzleDetail puzzleDetailState ->
                    ( "CIGMAH", div [] [] )

                Leaderboard leaderboardState ->
                    ( "CIGMAH", div [] [] )

                Register registerState ->
                    ( "CIGMAH", div [] [] )

                Login loginState ->
                    ( "CIGMAH", div [] [] )

                NotFound ->
                    ( "CIGMAH", div [] [] )
    in
    { title = title, body = [ body ] }
