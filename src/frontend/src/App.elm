module App exposing (init, subscriptions, update, view)

import Browser
import Browser.Navigation as Navigation
import Handlers
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Html.Lazy exposing (..)
import Http exposing (Error(..))
import Json.Decode as Decode
import Regex
import RemoteData exposing (RemoteData(..), WebData)
import Requests
import Types exposing (..)
import Url
import Views.Contact
import Views.Home
import Views.Leaderboard
import Views.Login
import Views.Prizes
import Views.PuzzleDetail
import Views.Register
import Views.Shared exposing (..)
import Views.Stats


init : Decode.Value -> Url.Url -> Navigation.Key -> ( Model, Cmd Msg )
init =
    Handlers.init


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( msg, model.modal ) of
        ( Ignored, _ ) ->
            ( model, Cmd.none )

        ( ToggledTheme, _ ) ->
            let
                ( nextTheme, nextThemeString ) =
                    case model.colourTheme of
                        Light ->
                            ( Fun, "fun" )

                        Fun ->
                            ( Dark, "dark" )

                        Dark ->
                            ( Light, "light" )
            in
            ( { model | colourTheme = nextTheme }, Handlers.theme nextThemeString )

        ( ClickedLink urlRequestBrowser, _ ) ->
            Handlers.clickedLink model urlRequestBrowser

        ( ChangedUrl url, _ ) ->
            Handlers.changedUrl model url

        ( ChangedRoute route, _ ) ->
            Handlers.changedRoute model route

        ( ToggledMessage, _ ) ->
            ( { model | message = Nothing }, Cmd.none )

        ( HomeGotResponse response, _ ) ->
            ( { model | webDataHome = response }, Cmd.none )

        ( LeaderboardGotResponse response, Just (Leaderboard Loading) ) ->
            ( { model | modal = Just (Leaderboard response) }, Cmd.none )

        ( UserGotResponse response, Just (UserInfo username Loading) ) ->
            ( { model | modal = Just (UserInfo username response) }, Cmd.none )

        ( PrizesGotResponse response, Just (Prizes Loading) ) ->
            ( { model | modal = Just (Prizes response) }, Cmd.none )

        ( PuzzleMsg puzzleMsg, Just (Puzzle puzzleId puzzleDetailState) ) ->
            updatePuzzle puzzleMsg model puzzleId puzzleDetailState

        ( RegisterMsg registerMsg, Just (Register fullUser webData) ) ->
            updateRegister registerMsg model fullUser webData

        ( LoginMsg loginMsg, Just (Login loginState) ) ->
            updateLogin loginMsg model loginState

        ( ContactMsg contactMsg, Just (Contact contactData contactResponseWebData) ) ->
            updateContact contactMsg model contactData contactResponseWebData

        ( _, _ ) ->
            ( model, Cmd.none )


updatePuzzle : PuzzleMsgType -> Model -> PuzzleId -> PuzzleDetailState -> ( Model, Cmd Msg )
updatePuzzle puzzleMsgType model puzzleId puzzleDetailState =
    let
        makePublicPuzzle response =
            { model | modal = Just (Puzzle puzzleId (PublicPuzzle response)) }

        makeUnsolvedPuzzle puzzleResponse submission submissionResponse =
            { model | modal = Just (Puzzle puzzleId (UserUnsolvedPuzzle puzzleResponse submission submissionResponse)) }

        makeSolvedPuzzle puzzleResponse comment commentResponse =
            { model | modal = Just (Puzzle puzzleId (UserSolvedPuzzle puzzleResponse comment commentResponse)) }
    in
    case ( puzzleMsgType, puzzleDetailState ) of
        ( GotPuzzle response, PublicPuzzle Loading ) ->
            case response of
                Success puzzleDetail ->
                    ( makePublicPuzzle response, Cmd.none )

                Failure _ ->
                    let
                        newModel =
                            makePublicPuzzle response
                    in
                    ( { newModel | message = Just "There was an error with loading this puzzle." }, Cmd.none )

                _ ->
                    ( makePublicPuzzle response, Cmd.none )

        ( GotPuzzle response, UserUnsolvedPuzzle Loading submission submissionResponse ) ->
            case response of
                Success puzzleDetail ->
                    case ( puzzleDetail.answer, puzzleDetail.explanation, puzzleDetail.comments ) of
                        ( Just _, Just _, Just comments ) ->
                            ( { model | modal = Just <| Puzzle puzzleId <| UserSolvedPuzzle response "" NotAsked }, Cmd.none )

                        _ ->
                            ( { model | modal = Just <| Puzzle puzzleId <| UserUnsolvedPuzzle response "" NotAsked }, Cmd.none )

                Failure _ ->
                    let
                        newModel =
                            makePublicPuzzle response
                    in
                    ( { newModel | message = Just "There was an error with loading this puzzle." }, Cmd.none )

                _ ->
                    ( { model | modal = Just <| Puzzle puzzleId <| UserUnsolvedPuzzle response "" NotAsked }, Cmd.none )

        ( GotSubmissionResponse newResponse, UserUnsolvedPuzzle puzzleResponse submission Loading ) ->
            case newResponse of
                Success (OkSubmit data) ->
                    case data.isResponseCorrect of
                        True ->
                            ( makeUnsolvedPuzzle puzzleResponse submission newResponse, Cmd.none )

                        False ->
                            let
                                base =
                                    makeUnsolvedPuzzle puzzleResponse submission newResponse
                            in
                            ( { base | message = Just <| "Your submission, " ++ submission ++ ", was incorrect. Have a break and try again later." }, Cmd.none )

                Failure f ->
                    let
                        modelBase =
                            makeUnsolvedPuzzle puzzleResponse submission newResponse
                    in
                    case f of
                        BadStatus e ->
                            case e.status.code of
                                412 ->
                                    let
                                        decodedTooSoon =
                                            Decode.decodeString Requests.decoderTooSoonSubmit e.body
                                    in
                                    case decodedTooSoon of
                                        Ok data ->
                                            ( { modelBase
                                                | message =
                                                    Just <|
                                                        "Your last attempt (on "
                                                            ++ Handlers.posixToString data.last
                                                            ++ ", attempt no. "
                                                            ++ String.fromInt data.attempts
                                                            ++ ") was too soon. You may next submit at "
                                                            ++ Handlers.posixToString data.next
                                                            ++ "."
                                              }
                                            , Cmd.none
                                            )

                                        Err _ ->
                                            ( { modelBase | message = Just <| "There was an issue with checking your submission. We apologise for the inconvenience. Try again later and let us know if it occurs again. There was status code " ++ String.fromInt e.status.code ++ "." }, Cmd.none )

                                _ ->
                                    ( { modelBase | message = Just <| "There was an issue with checking your submission. We apologise for the inconvenience. Try again later and let us know if it occurs again. There was status code " ++ String.fromInt e.status.code ++ "." }, Cmd.none )

                        NetworkError ->
                            ( { modelBase | message = Just "There was an issue with your network. Check your internet and try again." }, Cmd.none )

                        _ ->
                            ( { modelBase | message = Just "There was an issue with checking your submission. We apologise for the inconvenience. Try again later and let us know if it occurs again." }, Cmd.none )

                _ ->
                    ( makeUnsolvedPuzzle puzzleResponse submission newResponse, Cmd.none )

        ( GotCommentResponse newResponse, UserSolvedPuzzle puzzleResponse comment Loading ) ->
            case newResponse of
                Success response ->
                    case puzzleResponse of
                        Success puzzleData ->
                            ( makeSolvedPuzzle (Success { puzzleData | comments = Just response }) comment newResponse, Cmd.none )

                        _ ->
                            ( makeSolvedPuzzle puzzleResponse comment newResponse, Cmd.none )

                Failure f ->
                    let
                        base =
                            makeSolvedPuzzle puzzleResponse comment newResponse
                    in
                    ( { base | message = Just "There was an issue with posting your comment. Try again later and let us know if the issue persists. Apologies for the inconvenience." }, Cmd.none )

                _ ->
                    ( makeSolvedPuzzle puzzleResponse comment newResponse, Cmd.none )

        ( ChangedSubmission string, UserUnsolvedPuzzle puzzleResponse submission submissionResponse ) ->
            ( makeUnsolvedPuzzle puzzleResponse (String.toUpper string) submissionResponse, Cmd.none )

        ( ClickedSubmit _, UserUnsolvedPuzzle _ _ Loading ) ->
            ( model, Cmd.none )

        ( ClickedSubmit puzzleIdSubmit, UserUnsolvedPuzzle puzzleResponse submission submissionResponse ) ->
            case model.auth of
                User credentials ->
                    if submission == "" then
                        ( { model | message = Just "You need to write something in the submission box." }, Cmd.none )

                    else
                        ( makeUnsolvedPuzzle puzzleResponse submission Loading, Requests.postSubmit credentials.authToken submission puzzleIdSubmit )

                Public ->
                    ( model, Cmd.none )

        ( ChangedComment string, UserSolvedPuzzle puzzleResponse comment NotAsked ) ->
            ( makeSolvedPuzzle puzzleResponse string NotAsked, Cmd.none )

        ( ChangedComment string, UserSolvedPuzzle puzzleResponse comment (Failure f) ) ->
            ( makeSolvedPuzzle puzzleResponse string (Failure f), Cmd.none )

        ( ClickedComment, UserSolvedPuzzle _ _ Loading ) ->
            ( model, Cmd.none )

        ( ClickedComment, UserSolvedPuzzle puzzleResponse comment oldResponse ) ->
            if not <| comment == "" then
                case model.auth of
                    User credentials ->
                        ( makeSolvedPuzzle puzzleResponse comment Loading, Requests.postComment credentials.authToken puzzleId comment )

                    Public ->
                        ( model, Cmd.none )

            else
                ( { model | message = Just "You need to write something in your comment first." }, Cmd.none )

        ( _, _ ) ->
            ( model, Cmd.none )


updateContact : ContactMsgType -> Model -> ContactData -> WebData ContactResponse -> ( Model, Cmd Msg )
updateContact contactMsg model contactData contactResponseWebData =
    let
        makeModel newData newResponse =
            { model | modal = Just (Contact newData newResponse) }
    in
    case ( contactMsg, contactResponseWebData ) of
        ( GotContactResponse newResponse, Loading ) ->
            case newResponse of
                Failure f ->
                    ( { model | modal = Just (Contact contactData newResponse), message = Just <| "There was an error with sending your message. Try again soon, or you can also email us at cigmah.contact@gmail.com. We apologise for the inconvenience." }, Cmd.none )

                _ ->
                    ( makeModel contactData newResponse, Cmd.none )

        ( GotContactResponse _, _ ) ->
            ( model, Cmd.none )

        ( _, Loading ) ->
            ( model, Cmd.none )

        ( _, Success _ ) ->
            ( model, Cmd.none )

        ( ChangedContactName string, response ) ->
            ( makeModel { contactData | name = string } response, Cmd.none )

        ( ChangedContactEmail string, response ) ->
            ( makeModel { contactData | email = string } response, Cmd.none )

        ( ChangedContactSubject string, response ) ->
            ( makeModel { contactData | subject = string } response, Cmd.none )

        ( ChangedContactBody string, response ) ->
            ( makeModel { contactData | body = string } response, Cmd.none )

        ( ClickedSend, response ) ->
            if contactData.body == "" || contactData.subject == "" then
                ( { model | message = Just "You need to write something in both the subject and message body." }, Cmd.none )

            else
                ( makeModel contactData Loading, Requests.postContact contactData )


updateRegister : RegisterMsgType -> Model -> FullUser -> WebData RegisterResponse -> ( Model, Cmd Msg )
updateRegister registerMsgType model fullUser registerResponseWebData =
    let
        makeModel newData newResponse =
            { model | modal = Just (Register newData newResponse) }
    in
    case ( registerMsgType, registerResponseWebData ) of
        ( GotRegisterResponse newResponse, Loading ) ->
            case newResponse of
                Failure f ->
                    case f of
                        BadStatus badResponse ->
                            ( { model | modal = Just (Register fullUser newResponse), message = Just <| "Registration didn't succeed with status code " ++ String.fromInt badResponse.status.code ++ ". Most likely your username or email were taken. Please try changing both and trying again." }, Cmd.none )

                        _ ->
                            ( { model | modal = Just (Register fullUser newResponse), message = Just <| "Registration didn't succeed. Maybe your network connection cut out. If not, let us know and we can try to resolve the issue." }, Cmd.none )

                _ ->
                    ( makeModel fullUser newResponse, Cmd.none )

        ( GotRegisterResponse _, _ ) ->
            ( model, Cmd.none )

        ( _, Loading ) ->
            ( model, Cmd.none )

        ( _, Success _ ) ->
            ( model, Cmd.none )

        ( ChangedRegisterUsername string, response ) ->
            ( makeModel { fullUser | username = string } response, Cmd.none )

        ( ChangedRegisterEmail string, response ) ->
            ( makeModel { fullUser | email = string } response, Cmd.none )

        ( ChangedFirstName string, response ) ->
            ( makeModel { fullUser | firstName = string } response, Cmd.none )

        ( ChangedLastName string, response ) ->
            ( makeModel { fullUser | lastName = string } response, Cmd.none )

        ( ClickedRegister, response ) ->
            if Handlers.validateEmail fullUser.email && Handlers.validateUsername fullUser.username then
                ( makeModel fullUser Loading, Requests.postRegister fullUser )

            else
                ( { model | message = Just "Your username and email didn't pass our basic checks. Make sure there are no spaces, your email is correct and your username is greater than 1 character and less than 20 characters." }, Cmd.none )


updateLogin : LoginMsgType -> Model -> LoginState -> ( Model, Cmd Msg )
updateLogin loginMsgType model loginState =
    let
        makeEmailModel newEmail newResponse =
            { model | modal = Just (Login (InputEmail newEmail newResponse)) }

        makeTokenModel email response newToken newResponse =
            { model | modal = Just (Login (InputToken email response newToken newResponse)) }
    in
    case ( loginMsgType, loginState ) of
        ( GotSendEmailResponse newResponse, InputEmail email Loading ) ->
            case newResponse of
                Success responseUnwrapped ->
                    ( makeTokenModel email responseUnwrapped "" NotAsked, Cmd.none )

                Failure f ->
                    ( { model
                        | modal = Just (Login (InputEmail email newResponse))
                        , message = Just "There was an error. Try again soon or let us know and we can help resolve the issue."
                      }
                    , Cmd.none
                    )

                response ->
                    ( makeEmailModel email newResponse, Cmd.none )

        ( GotLoginResponse newResponse, InputToken email response token Loading ) ->
            case newResponse of
                Success credentials ->
                    let
                        newModel =
                            makeTokenModel email response token newResponse
                    in
                    ( { newModel | auth = User credentials }, Handlers.login credentials )

                Failure f ->
                    ( { model
                        | modal = Just (Login (InputToken email response token newResponse))
                        , message = Just "There was an error. Maybe you made a typo or you haven't registered yet. Try again soon or let us know and we can help resolve the issue."
                      }
                    , Cmd.none
                    )

                tokenResponse ->
                    ( makeTokenModel email response token tokenResponse, Cmd.none )

        ( ChangedLoginEmail _, InputEmail _ (Success _) ) ->
            ( model, Cmd.none )

        ( ChangedLoginEmail _, InputEmail _ Loading ) ->
            ( model, Cmd.none )

        ( ChangedLoginEmail string, InputEmail _ response ) ->
            ( makeEmailModel string response, Cmd.none )

        ( ClickedSendEmail, InputEmail _ (Success _) ) ->
            ( model, Cmd.none )

        ( ClickedSendEmail, InputEmail _ Loading ) ->
            ( model, Cmd.none )

        ( ClickedSendEmail, InputEmail email _ ) ->
            if Handlers.validateEmail email then
                ( makeEmailModel email Loading, Requests.postSendEmail email )

            else
                ( { model | message = Just "That email wasn't valid. Make sure you haven't made a typo." }, Cmd.none )

        ( ChangedToken _, InputToken _ _ _ (Success _) ) ->
            ( model, Cmd.none )

        ( ChangedToken _, InputToken _ _ _ Loading ) ->
            ( model, Cmd.none )

        ( ChangedToken string, InputToken email response _ tokenResponse ) ->
            ( makeTokenModel email response string tokenResponse, Cmd.none )

        ( ClickedLogin, InputToken email response token NotAsked ) ->
            ( makeTokenModel email response token Loading, Requests.postLogin token )

        ( ClickedLogin, InputToken email response token (Failure _) ) ->
            ( makeTokenModel email response token Loading, Requests.postLogin token )

        ( _, _ ) ->
            ( model, Cmd.none )



-- VIEW


view : Model -> Browser.Document Msg
view model =
    let
        title =
            modelToTitle model

        body =
            modelToBody model
    in
    { title = title
    , body = body
    }


modelToTitle : Model -> String
modelToTitle model =
    case model.modal of
        Just modal ->
            case modal of
                Contact _ _ ->
                    "FAQ - CIGMAH"

                Register _ _ ->
                    "Register - CIGMAH"

                Login _ ->
                    "Login - CIGMAH"

                Puzzle puzzleId _ ->
                    "Puzzle No. " ++ String.fromInt puzzleId ++ " - CIGMAH"

                Prizes _ ->
                    "Prizes - CIGMAH"

                Leaderboard _ ->
                    "Leaderboard - CIGMAH"

                UserInfo username _ ->
                    "Participant " ++ username ++ "'s Stats - CIGMAH'"

                Logout ->
                    "Logout - CIGMAH"

                NotFound ->
                    "Not Found - CIGMAH"

        Nothing ->
            "CIGMAH Puzzle Hunt"


modelToBody : Model -> List (Html Msg)
modelToBody model =
    let
        homeDiv =
            webDataWrapper model.webDataHome <| Views.Home.view model

        modalDiv =
            case model.modal of
                Nothing ->
                    []

                Just modal ->
                    [ modalView model modal ]

        messageDiv =
            case model.message of
                Just string ->
                    [ div [ class "message", onClick ToggledMessage ]
                        [ div [ class "message-text" ] [ text string ], div [ class "message-footer" ] [ text "Click to close." ] ]
                    ]

                Nothing ->
                    []
    in
    (homeDiv :: modalDiv) ++ messageDiv


modalView : Model -> Modal -> Html Msg
modalView model modal =
    let
        contents =
            case modal of
                Contact contactData contactResponseWebData ->
                    [ Views.Contact.view model contactData contactResponseWebData ]

                Register fullUser registerResponseWebData ->
                    [ Views.Register.view model fullUser registerResponseWebData ]

                Login loginState ->
                    [ Views.Login.view model loginState ]

                Puzzle puzzleId puzzleDetailState ->
                    [ Views.PuzzleDetail.view model puzzleId puzzleDetailState ]

                Prizes prizeListWebData ->
                    [ webDataWrapper prizeListWebData (Views.Prizes.view model) ]

                Leaderboard userAggregateListWebData ->
                    [ webDataWrapper userAggregateListWebData (Views.Leaderboard.view model) ]

                UserInfo username userStatsWebData ->
                    [ webDataWrapper userStatsWebData (Views.Stats.view model username) ]

                Logout ->
                    [ div [] [ h1 [] [ text "Thanks for participating." ], p [] [ text "You have successfully logged out. ", a [ routeHref HomeRoute ] [ text "Go home?" ] ] ] ]

                NotFound ->
                    [ div [] [ h1 [] [ text "Not Found" ], p [] [ text "That page wasn't found. ", a [ routeHref HomeRoute ] [ text "Go home?" ] ] ] ]
    in
    div [ class "modal" ]
        [ div [ class "pseudobody" ]
            [ div [ class "close-button" ] [ button [ onClick <| ChangedRoute HomeRoute ] [ text "Back Home" ] ]
            , div [ class "container" ]
                contents
            ]
        ]
