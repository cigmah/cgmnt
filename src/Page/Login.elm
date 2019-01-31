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
    let
        _ =
            Debug.log "update" msg
    in
    case ( msg, model.loginState ) of
        ( ChangedLoginEmail str, InputEmail _ (Success _) ) ->
            ( model, Cmd.none )

        ( ChangedLoginEmail str, InputEmail _ state ) ->
            let
                _ =
                    Debug.log "test" "LOGED"
            in
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
    , content = navMenuLinked model <| mainHero model
    }


loggedInPage viewer =
    div [ class "hero is-fullheight-with-navbar" ]
        [ div [ class "hero-body" ]
            [ div [ class "container" ]
                [ h1 [ class "title" ]
                    [ text <| "Success! Welcome to the Puzzle Hunt, " ++ Viewer.username viewer ++ "." ]
                , h2 [ class "subtitle" ]
                    [ text "You can now access the Puzzle Hunt tab to check out the open puzzles :)" ]
                , h2 [ class "" ]
                    [ text "(Or, if you like, "
                    , a [ Route.href Route.Home ] [ text "click here" ]
                    , text " for the dashboard."
                    ]
                ]
            ]
        ]


mainHero model =
    let
        mainBody =
            case ( model.loginState, model.session ) of
                ( LoginSuccess viewer, _ ) ->
                    loggedInPage viewer

                ( _, LoggedIn _ viewer ) ->
                    loggedInPage viewer

                ( _, _ ) ->
                    div [ class "hero is-fullheight-with-navbar" ]
                        [ div [ class "hero-body" ]
                            [ div [ class "container" ]
                                [ loginForm model ]
                            ]
                        ]
    in
    mainBody


loginForm model =
    let
        loadingState =
            case model.loginState of
                InputEmail _ Loading ->
                    " is-loading "

                InputToken _ _ _ Loading ->
                    " is-loading "

                _ ->
                    ""

        tokenField =
            case model.loginState of
                InputToken _ (Success _) _ (Success _) ->
                    loginField "Token" "012345" "text" True <| ChangedLoginToken

                InputToken _ (Success _) _ _ ->
                    loginField "Token" "012345" "text" False <| ChangedLoginToken

                _ ->
                    loginButton "Token" loadingState "Send Token"

        disabledState =
            case model.loginState of
                InputToken _ _ _ _ ->
                    True

                _ ->
                    False

        fullSubmit =
            case model.loginState of
                InputToken _ _ _ (Success _) ->
                    div [] []

                InputToken _ _ _ _ ->
                    loginButton "" loadingState "Login"

                _ ->
                    div [] []

        message =
            case model.loginState of
                InputToken _ (Success msgEmail) _ (Success _) ->
                    div [ class "card-footer has-background-success has-text-white" ] [ p [ class "card-footer-item" ] [ text "You have successfully logged in!" ] ]

                InputEmail _ (Failure error) ->
                    div [ class "card-footer has-background-info has-text-white" ] [ p [ class "card-footer-item" ] [ text "There was an error with your email." ] ]

                InputToken _ _ _ (Failure error) ->
                    div [ class "card-footer has-background-info has-text-white" ] [ p [ class "card-footer-item" ] [ text "There was an error with your token." ] ]

                InputToken _ (Success msg) _ NotAsked ->
                    div [ class "card-footer has-background-success has-text-white" ] [ p [ class "card-footer-item" ] [ text msg ] ]

                _ ->
                    div [] []

        submitMsg =
            case model.loginState of
                InputEmail _ _ ->
                    ClickedSendEmail

                InputToken _ _ _ _ ->
                    ClickedSendToken

                LoginSuccess _ ->
                    ClickedSendToken
    in
    div [ class "columns is-centered" ]
        [ div [ class "column is-two-thirds" ]
            [ div [ class "card" ]
                [ Html.form
                    [ class "card-content"
                    , onSubmit submitMsg
                    ]
                    [ loginField "Email" "roy.basch@bestmedicalschool.com" "email" disabledState <| ChangedLoginEmail
                    , tokenField
                    , fullSubmit
                    ]
                , message
                ]
            ]
        ]


loginField : String -> String -> String -> Bool -> (String -> Msg) -> Html Msg
loginField fieldLabel fieldPlaceholder fieldType disabledState fieldOnChange =
    div [ class "field is-horizontal" ]
        [ div [ class "field-label is-normal" ]
            [ label [ class "label" ] [ text fieldLabel ] ]
        , div [ class "field-body  is-expanded" ]
            [ div [ class "field" ]
                [ div [ class "control is-expanded" ]
                    [ input [ class "input", disabled disabledState, type_ fieldType, placeholder fieldPlaceholder, onInput fieldOnChange ]
                        []
                    ]
                ]
            ]
        ]


loginButton labelText loadingState buttonText =
    div [ class "field is-horizontal" ]
        [ div [ class "field-label is-normal" ]
            [ label [ class "label" ] [ text labelText ] ]
        , div [ class "field-body  is-expanded" ]
            [ div [ class "field" ]
                [ div [ class "control is-expanded" ]
                    [ button [ class <| "button is-info is-fullwidth" ++ loadingState, type_ "submit" ]
                        [ text buttonText ]
                    ]
                ]
            ]
        ]
