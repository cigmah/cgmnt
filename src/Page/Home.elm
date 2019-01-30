module Page.Home exposing (Model, Msg, init, subscriptions, toSession, update, view)

import Api
import Decoders exposing (decoderLeaderTotal)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Html.Lazy exposing (..)
import Json.Decode as Decode exposing (Decoder)
import Json.Encode as Encode
import Page.Nav exposing (navMenu)
import RemoteData exposing (RemoteData(..), WebData)
import Session exposing (Session)
import Types exposing (..)



-- MODEL


type alias Model =
    { session : Session
    , isRegisterActive : Bool
    , navActive : Bool
    , username : String
    , email : String
    , firstName : String
    , lastName : String
    , miniLeader : WebData LeaderTotalData
    , registerResponse : WebData Response
    }


type alias Response =
    String


init : Session -> ( Model, Cmd Msg )
init session =
    ( { session = session
      , isRegisterActive = False
      , navActive = False
      , username = ""
      , email = ""
      , firstName = ""
      , lastName = ""
      , miniLeader = Loading
      , registerResponse = NotAsked
      }
    , Api.get "submissions/leaderboard/mini/" Nothing ReceivedMiniLeader decoderLeaderTotal
    )


decoderRegister =
    Decode.succeed "Registration was succesful!"


encoderRegister : Model -> Encode.Value
encoderRegister model =
    Encode.object
        [ ( "username", Encode.string model.username )
        , ( "email", Encode.string model.email )
        , ( "first_name", Encode.string model.firstName )
        , ( "last_name", Encode.string model.lastName )
        ]


toSession : Model -> Session
toSession model =
    model.session



-- UPDATE


type Msg
    = ChangeRegisterUsername String
    | ChangeRegisterEmail String
    | ChangeRegisterFirstName String
    | ChangeRegisterLastName String
    | ClickedRegister
    | ToggleRegister
    | ReceivedRegisterResponse (WebData Response)
    | ReceivedMiniLeader (WebData LeaderTotalData)
    | GotSession Session
    | ToggledNavMenu


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ChangeRegisterUsername input ->
            ( { model | username = input }, Cmd.none )

        ChangeRegisterEmail input ->
            ( { model | email = input }, Cmd.none )

        ChangeRegisterFirstName input ->
            ( { model | firstName = input }, Cmd.none )

        ChangeRegisterLastName input ->
            ( { model | lastName = input }, Cmd.none )

        ToggleRegister ->
            ( { model | isRegisterActive = not model.isRegisterActive }, Cmd.none )

        ClickedRegister ->
            case model.registerResponse of
                Success _ ->
                    ( model, Cmd.none )

                _ ->
                    ( { model | registerResponse = Loading }
                    , Api.post "users/" (Session.cred model.session) ReceivedRegisterResponse decoderRegister (encoderRegister model)
                    )

        ReceivedRegisterResponse response ->
            ( { model | registerResponse = response }, Cmd.none )

        ReceivedMiniLeader response ->
            ( { model | miniLeader = response }, Cmd.none )

        ToggledNavMenu ->
            ( { model | navActive = not model.navActive }, Cmd.none )

        GotSession session ->
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
    { title = "CIGMAH - Home"
    , content = navMenuLinked model <| mainHero model
    }


mainHero model =
    let
        isLoading =
            case model.miniLeader of
                Loading ->
                    True

                _ ->
                    False
    in
    div []
        [ div [ classList [ ( "pageloader", True ), ( "is-active", isLoading ) ] ] [ span [ class "title" ] [ text "Loading..." ] ]
        , div [ classList [ ( "modal", True ), ( "is-active", model.isRegisterActive ) ] ]
            [ div [ class "modal-background", onClick ToggleRegister ] []
            , div [ class "modal-content" ] [ registerColumn model ]
            , div [ class "modal-close" ] []
            ]
        , div [ class "section" ]
            [ div [ class "hero is-fullheight-with-navbar" ]
                [ div [ class "hero-body" ]
                    [ div [ class "container" ]
                        [ h2 [ class "subtitle" ] [ text "The Coding Interest Group in Medicine and Healthcare presents" ]
                        , h1 [ class "title" ] [ text "The CIGMAH Puzzle Hunt 2019" ]
                        , p [ class "content" ] [ text "A puzzle hunt for biomedical and medical students to learn how to code." ]
                        , p [ class "button", onClick ToggleRegister ] [ text "Register" ]
                        ]
                    ]
                ]
            ]
        , div [ class "section" ]
            [ div [ class "hero is-fullheight-with-navbar" ]
                [ div [ class "hero-body" ]
                    [ div [ class "container" ]
                        [ text "Description text" ]
                    ]
                ]
            ]
        ]


makeHeaderCell headerText =
    th [] [ text headerText ]


makeRow rank leaderUnit =
    tr []
        [ td [] [ text <| String.fromInt rank ]
        , td [] [ text leaderUnit.username ]
        , td [] [ text <| String.fromInt leaderUnit.total ]
        ]


tableColumn model =
    let
        tableHeaders =
            [ "Rank", "Username", "Points" ]

        tableHead =
            tr [] <| List.map makeHeaderCell tableHeaders

        ranks miniLeader =
            List.range 1 (List.length miniLeader)

        rows miniLeader =
            List.map2 makeRow (ranks miniLeader) miniLeader

        leaderContent =
            case model.miniLeader of
                Success miniLeader ->
                    [ table [ class "table is-fullwidth is-hoverable" ]
                        [ thead [] [ tableHead ], tbody [] <| rows miniLeader ]
                    ]

                _ ->
                    [ div [] [ text "Loading..." ] ]
    in
    div [ class "column is-half is-narrow is-centered" ]
        [ div [ class "card is-fullheight", id "register" ]
            [ div [ class "card-header" ]
                [ div [ class "card-header-title" ] [ text "Leaderboard" ] ]
            , div [ class "card-content" ] leaderContent
            ]
        ]


registerColumn model =
    div [] <| registerForm model


registerForm model =
    let
        colourState =
            case model.registerResponse of
                Success _ ->
                    "is-success"

                _ ->
                    ""

        loadingState =
            case model.registerResponse of
                Loading ->
                    " is-loading "

                _ ->
                    ""

        registerButton =
            case model.registerResponse of
                Success _ ->
                    div [] []

                _ ->
                    div [ class "field is-horizontal" ]
                        [ div [ class "field-body" ]
                            [ div [ class "field " ]
                                [ div [ class "control" ]
                                    [ button
                                        [ type_ "submit"
                                        , class <| "button is-medium is-fullwidth" ++ loadingState ++ colourState
                                        ]
                                        [ text "Register" ]
                                    ]
                                ]
                            ]
                        ]

        message =
            case model.registerResponse of
                NotAsked ->
                    div [] []

                Loading ->
                    div [] []

                Success msg ->
                    footer [ class "card-footer has-text-white is-success has-background-success" ] [ span [ class "card-footer-item content has-text-centered" ] [ text msg ] ]

                Failure error ->
                    footer [ class "card-footer has-text-white has-background-danger" ] [ span [ class "card-footer-item content has-text-centered" ] [ text "There was an error." ] ]
    in
    [ div [ class "card is-fullheight" ]
        [ div [ class "card-header" ]
            [ span [ class <| "card-header-title has-text-weight-semibold is-centered has-text-centered" ++ colourState ]
                [ text "Registrations are open." ]
            ]
        , Html.form
            [ class "card-content "
            , onSubmit ClickedRegister
            ]
            [ registerField "Username" "bms_intern" "text" <| ChangeRegisterUsername
            , registerField "Email" "roy.basch@bestmedicalschool.com" "email" <| ChangeRegisterEmail
            , div [ class "field is-horizontal" ]
                [ div [ class "field-label is-normal " ] [ label [ class "label " ] [ text "Name" ] ]
                , div [ class "field-body" ]
                    [ div [ class "field " ]
                        [ div [ class "control" ]
                            [ input
                                [ class "input "
                                , type_ "text"
                                , placeholder "Roy"
                                , onInput <| ChangeRegisterFirstName
                                ]
                                []
                            ]
                        ]
                    , div [ class "field" ]
                        [ div [ class "control" ]
                            [ input
                                [ class "input "
                                , type_ "text"
                                , placeholder "Basch"
                                , onInput <| ChangeRegisterLastName
                                ]
                                []
                            ]
                        ]
                    ]
                ]
            , registerButton
            ]
        , message
        ]
    ]


registerField : String -> String -> String -> (String -> Msg) -> Html Msg
registerField fieldLabel fieldPlaceholder fieldType fieldOnChange =
    div [ class "field is-horizontal" ]
        [ div [ class "field-label is-normal" ]
            [ label [ class "label " ] [ text fieldLabel ] ]
        , div [ class "field-body  is-expanded" ]
            [ div [ class "field" ]
                [ div [ class "control is-expanded" ]
                    [ input [ class "input ", type_ fieldType, placeholder fieldPlaceholder, onInput fieldOnChange ]
                        []
                    ]
                ]
            ]
        ]
