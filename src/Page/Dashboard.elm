module Page.Dashboard exposing (Model, Msg, init, subscriptions, toSession, update, view)

import Api
import Decoders exposing (decoderThemeData)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Lazy exposing (..)
import Json.Decode as Decode
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


type State
    = Denied
    | Accepted (WebData DashData)


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
            ( { session = session, state = Accepted Loading, navActive = False }
            , Api.get "dashboard/" (Just <| Viewer.cred viewer) ReceivedData decoderDashData
            )

        Guest _ ->
            ( { session = session, state = Denied, navActive = False }
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
    case msg of
        ReceivedData response ->
            ( { model | state = Accepted response }, Cmd.none )

        GotSession session ->
            ( { model | session = session }, Cmd.none )

        ToggledNavMenu ->
            ( { model | navActive = not model.navActive }, Cmd.none )



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
    , content = navMenuLinked model <| mainHero model
    }


welcomeMsg viewer data =
    let
        numSolvedString =
            String.fromInt data.numSolved

        username =
            Viewer.username viewer

        totalString =
            String.fromInt data.totalPoints
    in
    [ h1 [ class "title" ] [ text <| "Welcome, " ++ username ++ "." ]
    , h2 [ class "subtitle" ] [ text <| "You've solved " ++ numSolvedString ++ " puzzle(s) and have earned " ++ totalString ++ " points." ]
    ]


themeCard theme =
    div [ class "column is-one-third" ]
        [ div [ class "card is-fullheight" ]
            [ div [ class "card-header" ]
                [ div [ class "card-header-title" ] [ text theme.theme ] ]
            , div [ class "card-content" ]
                [ div [ class "content" ] [ text theme.tagline ]
                ]
            ]
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


whoopsPage =
    div [ class "hero is-fullheight-with-navbar" ]
        [ div [ class "hero-body" ]
            [ div [ class "container" ]
                [ h1 [ class "title" ] [ text "Whoops!" ]
                , h2 [ class "subtitle" ] [ text "You need to be logged in to see this page." ]
                ]
            ]
        ]


errorPage =
    div [ class "hero is-fullheight-with-navbar" ]
        [ div [ class "hero-body" ]
            [ div [ class "container" ]
                [ h1 [ class "title" ] [ text "Whoops!" ]
                , h2 [ class "subtitle" ] [ text "There was an error when loading this data. Contact us!" ]
                ]
            ]
        ]


mainHero model =
    case model.session of
        LoggedIn _ viewer ->
            case model.state of
                Accepted (Success data) ->
                    div [ class "hero  is-fullheight-with-navbar" ]
                        [ div [ class "hero-body" ]
                            [ div [ class "container" ] <|
                                welcomeMsg viewer data
                                    ++ themeBody data
                            ]
                        ]

                Accepted Loading ->
                    div [ class "pageloader is-active" ] [ span [ class "title" ] [ text "Loading..." ] ]

                _ ->
                    errorPage

        _ ->
            whoopsPage
