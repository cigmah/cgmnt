module Page.Register exposing (Model, Msg, init, subscriptions, toSession, update, view)

import Api
import Decoders exposing (decoderThemeData)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Html.Lazy exposing (..)
import Json.Decode as Decode
import Json.Encode as Encode
import Page.Error exposing (..)
import Page.Nav exposing (navMenu)
import RemoteData exposing (RemoteData(..), WebData)
import Session exposing (Session(..))
import Types exposing (..)
import Utils
import Viewer



-- MODEL


type alias Model =
    { session : Session
    , state : State
    , navActive : Bool
    }


type alias RegisterInfo =
    { username : String
    , email : String
    , firstName : String
    , lastName : String
    }


type State
    = NewUser RegisterInfo (WebData Response)
    | AlreadyUser


init : Session -> ( Model, Cmd Msg )
init session =
    case session of
        LoggedIn _ viewer ->
            ( { session = session, state = AlreadyUser, navActive = False }
            , Cmd.none
            )

        Guest _ ->
            ( { session = session
              , state = NewUser { username = "", email = "", firstName = "", lastName = "" } NotAsked
              , navActive = False
              }
            , Cmd.none
            )


toSession : Model -> Session
toSession model =
    model.session


decoderRegister =
    Decode.succeed "Registration was succesful!"


encoderRegister : RegisterInfo -> Encode.Value
encoderRegister registerInfo =
    Encode.object
        [ ( "username", Encode.string registerInfo.username )
        , ( "email", Encode.string registerInfo.email )
        , ( "first_name", Encode.string registerInfo.firstName )
        , ( "last_name", Encode.string registerInfo.lastName )
        ]


type alias Response =
    String


type Msg
    = ChangeRegisterUsername String
    | ChangeRegisterEmail String
    | ChangeRegisterFirstName String
    | ChangeRegisterLastName String
    | ClickedRegister
    | ToggledNavMenu
    | ReceivedRegisterResponse (WebData Response)
    | GotSession Session


update msg model =
    case ( msg, model.state ) of
        ( _, NewUser _ (Success _) ) ->
            ( model, Cmd.none )

        ( _, AlreadyUser ) ->
            ( model, Cmd.none )

        ( ChangeRegisterUsername input, NewUser info webData ) ->
            ( { model | state = NewUser { info | username = input } webData }, Cmd.none )

        ( ChangeRegisterEmail input, NewUser info webData ) ->
            ( { model | state = NewUser { info | email = input } webData }, Cmd.none )

        ( ChangeRegisterFirstName input, NewUser info webData ) ->
            ( { model | state = NewUser { info | firstName = input } webData }, Cmd.none )

        ( ChangeRegisterLastName input, NewUser info webData ) ->
            ( { model | state = NewUser { info | lastName = input } webData }, Cmd.none )

        ( ClickedRegister, NewUser info webData ) ->
            case webData of
                Loading ->
                    ( model, Cmd.none )

                _ ->
                    ( { model | state = NewUser info Loading }
                    , Api.post "users/" (Session.cred model.session) ReceivedRegisterResponse decoderRegister (encoderRegister info)
                    )

        ( ToggledNavMenu, _ ) ->
            ( { model | navActive = not model.navActive }, Cmd.none )

        ( ReceivedRegisterResponse response, NewUser info _ ) ->
            ( { model | state = NewUser info response }, Cmd.none )

        ( GotSession session, _ ) ->
            ( { model | session = session }, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Session.changes GotSession (Session.navKey model.session)



-- VIEW


navMenuLinked model body =
    div [] [ lazy3 navMenu ToggledNavMenu model.navActive (Session.viewer model.session), body ]


view : Model -> { title : String, content : Html Msg }
view model =
    { title = "Puzzle Hunt Dashboard"
    , content = navMenuLinked model <| mainHero model.state
    }


mainHero state =
    let
        messageDiv =
            case state of
                NewUser _ (Success _) ->
                    div
                        [ class "bg-grey-lighter border-red text-grey-darkest border-l-2 rounded rounded-l-none p-4 mt-3" ]
                        [ text "Registration was successful! Head over to the login tab to start logging in." ]

                NewUser _ (Failure e) ->
                    div
                        [ class "bg-grey-lighter border-red text-grey-darkest border-l-2 rounded rounded-l-none p-4 mt-3" ]
                        [ text "It seems like there was an error...sorry about that. Let us know!" ]

                AlreadyUser ->
                    div
                        [ class "bg-grey-lighter border-red text-grey-darkest border-l-2 rounded rounded-l-none p-4 mt-3" ]
                        [ text "You've already registered...in fact, you're logged in right now!" ]

                _ ->
                    div [] []

        hideForm =
            case state of
                NewUser _ (Success _) ->
                    True

                AlreadyUser ->
                    True

                _ ->
                    False

        buttonText =
            case state of
                NewUser _ Loading ->
                    "Loading..."

                _ ->
                    "Sign me up!"
    in
    div
        [ class "px-8 bg-grey-lightest" ]
        [ div
            [ class "flex flex-wrap h-screen content-center justify-center items-center pt-20 md:pt-12" ]
            [ Html.form
                [ class "block md:w-3/4 lg:w-2/3 xl:w-1/2", onSubmit ClickedRegister ]
                [ div
                    [ class "inline-flex flex justify-center w-full" ]
                    [ div
                        [ class "flex items-center  sm:text-xl justify-center sm:h-12 sm:w-10 px-5 py-3 rounded-l-lg font-black bg-red-light text-grey-lighter border-b-2 border-red-dark" ]
                        [ span
                            [ class "fas fa-user-plus" ]
                            []
                        ]
                    , div
                        [ class "flex items-center w-full p-3 px-5 sm:h-12 rounded-r-lg text-grey-darkest sm:text-lg font-bold uppercase bg-grey-lighter border-b-2 border-grey" ]
                        [ text "Register for the 2019 Puzzle Hunt" ]
                    ]
                , div
                    [ class "block w-full my-3 bg-white rounded-lg p-6 w-full text-base border-b-2 border-grey-light" ]
                    [ p
                        []
                        [ text "We use a password-less login system similar to"
                        , a
                            [ class "text-blue no-underline", href "https://blog.medium.com/signing-in-to-medium-by-email-aacc21134fcd" ]
                            [ text " one coined by Medium." ]
                        , br
                            []
                            []
                        , br
                            []
                            []
                        , text
                            "All we require is a username and email - a name is optional."
                        ]
                    , br
                        []
                        []
                    , p
                        []
                        [ text "Once you've registered, you can start logging in immediately. When you login, a short-term code will be sent to your email to confirm your identity. We never share your email, and will only email you to send you login codes." ]
                    , div
                        [ class "block w-full p-4 pb-1 mt-1", classList [ ( "hidden", hideForm ) ] ]
                        [ input
                            [ class "w-full my-1 mt-0 px-4 py-2 rounded-lg bg-grey-lighter outline-none text-grey-darker focus:bg-grey-lightest focus:text-grey-darkest border-l-2 border-red-lighter rounded-l-none focus:border-red"
                            , onInput ChangeRegisterUsername
                            , placeholder "Username"
                            ]
                            []
                        , input
                            [ class "w-full my-1 px-4 py-2 rounded-lg bg-grey-lighter outline-none text-grey-darker focus:bg-grey-lightest focus:text-grey-darkest border-l-2 border-red-lighter rounded-l-none focus:border-red"
                            , onInput ChangeRegisterEmail
                            , placeholder "Email"
                            , type_ "email"
                            ]
                            []
                        , div
                            [ class "sm:flex inline-flex flex-wrap w-full" ]
                            [ div
                                [ class "w-full md:w-1/2 md:pr-1" ]
                                [ input
                                    [ class "w-full my-1 px-4 py-2 rounded-lg bg-grey-lighter outline-none text-grey-darker focus:bg-grey-lightest focus:text-grey-darkest"
                                    , onInput ChangeRegisterFirstName
                                    , placeholder "First Name"
                                    ]
                                    []
                                ]
                            , div
                                [ class "w-full md:w-1/2 md:pl-1" ]
                                [ input
                                    [ class "w-full my-1 px-4 py-2 rounded-lg bg-grey-lighter outline-none text-grey-darker focus:bg-grey-lightest focus:text-grey-darkest"
                                    , onInput ChangeRegisterLastName
                                    , placeholder "Last Name"
                                    ]
                                    []
                                ]
                            ]
                        ]
                    , messageDiv
                    ]
                , div
                    [ class "flex w-full justify-center", classList [ ( "hidden invisible", hideForm ) ] ]
                    [ button
                        [ class "px-3 py-2 bg-red-light rounded-full border-b-4 border-red-dark w-full md:w-1/2 text-white active:border-0 outline-none focus:outline-none active:outline-none hover:bg-red-dark"
                        ]
                        [ text buttonText ]
                    ]
                ]
            ]
        ]
