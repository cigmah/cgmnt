module Page.Home exposing (Model, Msg, init, subscriptions, toSession, update, view)

import Api
import Decoders exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Html.Lazy exposing (..)
import Json.Decode as Decode exposing (Decoder)
import Json.Encode as Encode
import List
import Page.Nav exposing (navMenu)
import Page.Shared exposing (loadingState)
import RemoteData exposing (RemoteData(..), WebData)
import Session exposing (Session(..))
import Types exposing (..)
import Utils
import Viewer exposing (Viewer)



-- MODEL


type alias Model =
    { session : Session
    , state : State
    , navActive : Bool
    }


type State
    = Static
    | Dashboard Viewer (WebData DashData)


type alias DashData =
    { numSolved : Int
    , currentThemes : List ThemeData
    , nextTheme : ThemeData
    , totalPoints : Int
    }


decoderDashData =
    Decode.map4 DashData
        (Decode.oneOf [ Decode.field "num_solved" Decode.int, Decode.succeed 0 ])
        (Decode.field "current" <| Decode.list decoderThemeData)
        (Decode.field "next" decoderThemeData)
        (Decode.oneOf [ Decode.field "total" Decode.int, Decode.succeed 0 ])


init : Session -> ( Model, Cmd Msg )
init session =
    case session of
        LoggedIn _ viewer ->
            ( { state = Dashboard viewer Loading
              , session = session
              , navActive = False
              }
            , Api.get "dashboard/" (Just <| Viewer.cred viewer) ReceivedData decoderDashData
            )

        Guest _ ->
            ( { state = Static
              , session = session
              , navActive = False
              }
            , Cmd.none
            )


toSession : Model -> Session
toSession model =
    model.session



-- UPDATE


type Msg
    = GotSession Session
    | ReceivedData (WebData DashData)
    | ToggledNavMenu


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( msg, model.state ) of
        ( ReceivedData response, Dashboard viewer Loading ) ->
            ( { model | state = Dashboard viewer response }, Cmd.none )

        ( ToggledNavMenu, _ ) ->
            ( { model | navActive = not model.navActive }, Cmd.none )

        ( GotSession session, _ ) ->
            ( { model | session = session }, Cmd.none )

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
    { title = "Home - CIGMAH"
    , content = navMenuLinked model <| mainHero model
    }


mainHero model =
    let
        isLoading =
            case model.state of
                Dashboard _ Loading ->
                    True

                _ ->
                    False

        mainContainer =
            case model.state of
                Dashboard viewer webData ->
                    dashboardContainer viewer webData

                _ ->
                    landingContainer
    in
    div []
        [ mainContainer
        , aboutContainer
        , contactContainer
        ]


themeBody data =
    let
        leadInOpen =
            "The currently open themes are: "

        leadInNext =
            "The next theme, " ++ data.nextTheme.theme ++ ", will open on " ++ Utils.posixToString data.nextTheme.openDatetime ++ "."
    in
    [ div [ class "container" ]
        [ div [ class "subtitle" ] [ text leadInOpen ]
        , div [ class "columns is-multiline" ] <| List.map themeCard data.currentThemes
        , div [ class "subtitle" ] [ text leadInNext ]
        ]
    ]


welcomeMsg username =
    text <| "Welcome, " ++ username ++ "."


tagMsg ( numSolved, totalPoints ) =
    let
        numSolvedString =
            String.fromInt numSolved

        totalString =
            String.fromInt totalPoints
    in
    text <| "You've solved " ++ numSolvedString ++ " puzzle(s) and have earned " ++ totalString ++ " points."


themeCard ( titleText, taglineText ) =
    div [ class "p-4 shadow bg-white mb-4 mr-4 rounded-lg lg:w-1/3 " ]
        [ div [ class "font-sans font-normal text-xl mt-3 mb-5" ] [ titleText ]
        , div [ class "font-sans font-normal text-lg mb-5" ] [ taglineText ]
        ]


template viewer webData =
    let
        texts =
            case webData of
                Loading ->
                    { welcome = loadingState <| welcomeMsg "placeholder"
                    , tagline = loadingState <| tagMsg ( 0, 0 )
                    , currentLeadIn = loadingState <| text "The currently open themes are: "
                    , themeCards =
                        List.map themeCard <|
                            List.repeat 3
                                ( loadingState <| text "Placeholder"
                                , loadingState <| text "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
                                )
                    , nextTheme =
                        loadingState <| text "The next theme, Lorem ipsum dolor sit amet, will open on AAA 00 0000."
                    }

                Success data ->
                    { welcome = welcomeMsg <| Viewer.username viewer
                    , tagline = tagMsg ( data.numSolved, data.totalPoints )
                    , currentLeadIn = text "The currently open themes are: "
                    , themeCards = List.map themeCard <| List.map (\x -> ( text x.theme, text x.tagline )) data.currentThemes
                    , nextTheme =
                        text <| "The next theme, " ++ data.nextTheme.theme ++ ", will open on " ++ Utils.posixToString data.nextTheme.openDatetime ++ "."
                    }

                _ ->
                    { welcome = div [] [ text "We're sorry, there was an error." ]
                    , tagline = div [] [ text "We'd like to know - get in touch with us." ]
                    , currentLeadIn = div [] []
                    , themeCards = [ div [] [] ]
                    , nextTheme = div [] []
                    }
    in
    div [ class "container mx-auto h-screen p-4 justify-center items-center" ]
        [ div [ class "text-4xl font-sans font-normal mt-5 mb-4" ] [ texts.welcome ]
        , div [ class "text-2xl font-sans font-light mb-8" ] [ texts.tagline ]
        , div [ class "text-xl font-sans font-light mb-4" ] [ texts.currentLeadIn ]
        , div [ class "block lg:flex mb-6" ] texts.themeCards
        , div [ class "text-xl font-sans font-light mb-3" ] [ texts.nextTheme ]
        ]


dashboardContainer viewer webData =
    div [] [ div [ class "h-16" ] [], template viewer webData ]


landingContainer =
    div [ class " h-screen mx-auto px-4 justify-center items-center w-full lg:flex lg:flex-wrap " ]
        [ div [ class "h-16" ] []
        , div [ class "flex-1 align-middle px-4 py-4 lg:w-1/2 m-2 items-center w-full" ]
            [ h1 [ class "text-xl font-light mb-5 font-sans" ] [ text "The Coding Interest Group in Medicine and Healthcare presents" ]
            , h2 [ class "text-3xl font-sans font-normal mb-5" ] [ text "The CIGMAH Puzzle Hunt 2019" ]
            , p [ class "content font-sans font-light" ] [ text "A puzzle hunt integrating programming and medicine with a focus on learning." ]
            ]
        , div [ class "flex-1  px-4 py-4 w-1/2 m-2" ]
            [ text "Placeholder" ]
        ]


aboutContainer =
    div [] []


contactContainer =
    div [] []
