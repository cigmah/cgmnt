module Page.Login exposing (Email, LoginState(..), Model, Msg(..), Response, Token, init, mainHero, subscriptions, toSession, update, view)

import Api
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Html.Lazy exposing (..)
import Json.Decode as Decode
import Json.Encode as Encode
import Page.Nav exposing (navMenu)
import RemoteData exposing (RemoteData(..), WebData)
import Route
import Session exposing (Session(..))
import Viewer



-- MODEL


type alias Email =
    String


type alias Token =
    String


type alias Response =
    String


type alias Model =
    { session : Session
    , loginState : LoginState
    , navActive : Bool
    }


type LoginState
    = InputEmail Email (WebData Response)
    | InputToken Email (WebData Response) Token (WebData Viewer.Viewer)
    | LoginSuccess Viewer.Viewer


init : Session -> ( Model, Cmd Msg )
init session =
    case session of
        LoggedIn _ viewer ->
            ( { session = session
              , loginState = LoginSuccess viewer
              , navActive = False
              }
            , Cmd.none
            )

        _ ->
            ( { session = session
              , loginState = InputEmail "" NotAsked
              , navActive = False
              }
            , Cmd.none
            )


toSession : Model -> Session
toSession model =
    model.session


encoderEmail : Email -> Encode.Value
encoderEmail email =
    Encode.object
        [ ( "email", Encode.string email ) ]


encoderToken : Token -> Encode.Value
encoderToken token =
    Encode.object
        [ ( "token", Encode.string token ) ]


decoderSendEmail =
    Decode.succeed "A login token was sent to your email!"



-- UPDATE


type Msg
    = ChangedLoginEmail String
    | ClickedSendEmail
    | ReceivedSendEmailResponse (WebData Response)
    | ChangedLoginToken String
    | ClickedSendToken
    | ReceivedSendTokenResponse (WebData Viewer.Viewer)
    | GotSession Session
    | ToggledNavMenu


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( msg, model.loginState ) of
        ( ChangedLoginEmail str, InputEmail _ (Success _) ) ->
            ( model, Cmd.none )

        ( ChangedLoginEmail str, InputEmail _ state ) ->
            ( { model | loginState = InputEmail str state }, Cmd.none )

        ( ClickedSendEmail, InputEmail email (Success _) ) ->
            ( model, Cmd.none )

        ( ClickedSendEmail, InputEmail email Loading ) ->
            ( model, Cmd.none )

        ( ClickedSendEmail, InputEmail email state ) ->
            ( { model | loginState = InputEmail email Loading }
            , Api.post "auth/email/" (Session.cred model.session) ReceivedSendEmailResponse decoderSendEmail (encoderEmail email)
            )

        ( ReceivedSendEmailResponse response, InputEmail email Loading ) ->
            case response of
                Success emailResponse ->
                    ( { model | loginState = InputToken email response "" NotAsked }, Cmd.none )

                _ ->
                    ( { model | loginState = InputEmail email response }, Cmd.none )

        ( ChangedLoginToken str, InputToken email data _ (Success _) ) ->
            ( model, Cmd.none )

        ( ChangedLoginToken str, InputToken email data _ state ) ->
            ( { model | loginState = InputToken email data str state }, Cmd.none )

        ( ClickedSendToken, InputToken email (Success _) token (Success _) ) ->
            ( model, Cmd.none )

        ( ClickedSendToken, InputToken email (Success s) token state ) ->
            ( { model | loginState = InputToken email (Success s) token Loading }
            , Api.login ReceivedSendTokenResponse (encoderToken token) Viewer.decoder
            )

        ( ReceivedSendTokenResponse response, InputToken email data token Loading ) ->
            case response of
                Success viewer ->
                    case model.session of
                        Guest key ->
                            ( { model | session = LoggedIn key viewer, loginState = LoginSuccess viewer }, Viewer.store viewer )

                        LoggedIn key user ->
                            ( { model | session = LoggedIn key viewer, loginState = LoginSuccess viewer }, Viewer.store viewer )

                _ ->
                    ( { model | loginState = InputToken email data token response }, Cmd.none )

        ( GotSession session, _ ) ->
            ( { model | session = session }
            , Route.replaceUrl (Session.navKey session) Route.Home
            )

        ( ToggledNavMenu, _ ) ->
            ( { model | navActive = not model.navActive }, Cmd.none )

        ( _, _ ) ->
            ( model, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Session.changes GotSession (Session.navKey model.session)



-- VIEW


navMenuLinked model body =
    div [] [ lazy3 navMenu ToggledNavMenu model.navActive (Session.viewer model.session), body ]


view : Model -> { title : String, content : Html Msg }
view model =
    { title = "Login"
    , content = navMenuLinked model <| mainHero model.loginState
    }


mainHero state =
    let
        isTokenDisabled =
            case state of
                InputToken _ _ _ NotAsked ->
                    False

                InputToken _ _ _ (Failure e) ->
                    False

                InputToken _ _ _ Loading ->
                    False

                _ ->
                    True

        sendTokenText =
            case state of
                InputEmail _ Loading ->
                    "Loading..."

                InputToken _ _ _ _ ->
                    "Sent!"

                _ ->
                    "Send Token"

        loginText =
            case state of
                InputToken _ _ _ Loading ->
                    "Loading..."

                _ ->
                    "Login"

        messageDiv =
            case state of
                InputEmail _ (Failure e) ->
                    div
                        [ class "bg-grey-lighter border-green text-grey-darkest border-l-2 rounded rounded-l-none p-4 mt-3 mb-3" ]
                        [ text "We're sorry, there was an issue with sending a token to your email. Maybe you haven't registered? Or a typo?" ]

                InputToken _ _ _ (Failure e) ->
                    div
                        [ class "bg-grey-lighter border-green text-grey-darkest border-l-2 rounded rounded-l-none p-4 mt-3 mb-3" ]
                        [ text "We're sorry, that token didn't work. Is it right? Maybe it's expired? Maybe there was some other error?" ]

                LoginSuccess viewer ->
                    div
                        [ class "bg-grey-lighter border-green text-grey-darkest border-l-2 rounded rounded-l-none p-4 mt-3 mb-3" ]
                        [ text <| "Great, you've logged in successfully! Welcome to the puzzle hunt, " ++ Viewer.username viewer ++ ". "
                        , text "You can now start "
                        , a [ Route.href Route.OpenPuzzles, class "no-underline text-blue" ] [ text "tackling the open puzzles" ]
                        , text " or "
                        , a [ Route.href Route.Home, class "no-underline text-blue" ] [ text "head to your dashboard!" ]
                        ]

                _ ->
                    div [] []

        isFormHidden =
            case state of
                LoginSuccess _ ->
                    True

                _ ->
                    False

        onSubmitMessage =
            case state of
                InputEmail _ Loading ->
                    []

                InputEmail _ _ ->
                    [ onSubmit ClickedSendEmail ]

                InputToken _ _ _ Loading ->
                    []

                InputToken _ _ _ _ ->
                    [ onSubmit ClickedSendToken ]

                _ ->
                    []
    in
    div
        [ class "px-2 md:px-8 bg-grey-lightest" ]
        [ div
            [ class "flex flex-wrap md:h-screen content-center justify-center items-center pt-16 md:pt-12" ]
            [ div
                [ class "block w-full md:w-3/4 lg:w-2/3 xl:w-1/2" ]
                [ div
                    [ class "inline-flex flex justify-center w-full" ]
                    [ div
                        [ class "flex items-center sm:text-xl justify-center sm:h-12 sm:w-10 px-5 py-3 rounded-l-lg font-black bg-green text-grey-lighter border-b-2 border-green-dark" ]
                        [ span
                            [ class "fas fa-sign-in-alt" ]
                            []
                        ]
                    , div
                        [ class "flex items-center w-full p-3 px-5 sm:h-12 rounded-r-lg text-grey-darkest sm:text-lg font-bold uppercase bg-grey-lighter border-b-2 border-grey" ]
                        [ text "User Login" ]
                    ]
                , div
                    [ class "block px-4 md:w-full my-3 bg-white rounded-lg p-6 text-base border-b-2 border-grey-light" ]
                    [ p
                        []
                        [ text "Input your email first and press  "
                        , span
                            [ class "bg-green px-2 py-1 text-xs rounded text-white" ]
                            [ text "Send Token" ]
                        , text "."
                        ]
                    , br
                        []
                        []
                    , p
                        []
                        [ text "A login code will be sent to your email. Input the code, and you're all set to login!" ]
                    , div
                        [ class "block w-full p-4 pb-1 mt-1", classList [ ( "hidden", isFormHidden ) ] ]
                        [ Html.form
                            ([ class "inline-flex w-full" ] ++ onSubmitMessage)
                            [ input
                                [ class "flex-grow flex-shrink w-auto my-1 pl-3 pr-2 md:px-4 py-2 rounded-lg  outline-none text-grey-darker focus:bg-grey-lightest focus:text-grey-darkest rounded-r-none"
                                , placeholder "Email"
                                , onInput ChangedLoginEmail
                                , classList [ ( "bg-grey-lighter", isTokenDisabled ), ( "bg-grey cursor-not-allowed", not isTokenDisabled ) ]
                                , disabled (not isTokenDisabled)
                                , type_ "email"
                                ]
                                []
                            , button
                                [ class "my-1 px-1 md:px-4 py-2 text-xs md:text-base text-white rounded rounded-l-none border-b-2 border-green-dark focus:outline-none outline-none hover:bg-green-dark "
                                , onClick ClickedSendEmail
                                , disabled (not isTokenDisabled)
                                , classList [ ( "bg-green-dark", not isTokenDisabled ), ( "bg-green active:border-0", isTokenDisabled ) ]
                                ]
                                [ text sendTokenText ]
                            ]
                        , input
                            [ class "w-full my-1 px-3 md:px-4 py-2 rounded-lg  outline-none text-grey-darkest focus:bg-grey-lightest focus:text-grey-darkest"
                            , placeholder "Token"
                            , disabled isTokenDisabled
                            , classList [ ( "bg-grey cursor-not-allowed", isTokenDisabled ), ( "bg-grey-lighter", not isTokenDisabled ) ]
                            , onInput ChangedLoginToken
                            ]
                            []
                        ]
                    , messageDiv
                    , div
                        [ class "flex w-full justify-center" ]
                        [ button
                            [ class "px-3 py-2 bg-green rounded-full border-b-4 border-green-dark w-full md:w-1/2 text-white active:border-0 outline-none focus:outline-none active:outline-none hover:bg-green-dark"
                            , onClick ClickedSendToken
                            ]
                            [ text loginText ]
                        ]
                    ]
                ]
            ]
        ]
