module Page.Home exposing (Model, Msg, init, subscriptions, toSession, update, view)

import Html exposing (Html, div, h1, text)
import Html.Attributes exposing (class)
import RemoteData exposing (RemoteData(..), WebData)
import Session exposing (Session)



-- MODEL


type alias Model =
    { session : Session
    , username : String
    , email : String
    , firstName : Maybe String
    , lastName : Maybe String
    , response : WebData Response
    }


type alias Response =
    String


init : Session -> ( Model, Cmd Msg )
init session =
    ( { session = session
      , username = ""
      , email = ""
      , firstName = Nothing
      , lastName = Nothing
      , response = NotAsked
      }
    , Cmd.none
    )


toSession : Model -> Session
toSession model =
    model.session



-- UPDATE


type Msg
    = ChangeRegisterUsername String
    | ChangeRegisterEmail String
    | GotSession Session


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ChangeRegisterUsername input ->
            ( { model | username = input }, Cmd.none )

        ChangeRegisterEmail input ->
            ( { model | email = input }, Cmd.none )

        GotSession session ->
            ( { model | session = session }, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Session.changes GotSession (Session.navKey model.session)



-- VIEW


view : Model -> { title : String, content : Html Msg }
view model =
    { title = "CIGMAH"
    , content = mainHero
    }


mainHero =
    div [ class "hero is-primary is-fullheight-with-navbar" ]
        [ div [ class "hero-body" ]
            [ div [ class "container" ]
                [ div [ class "columns is-multiline" ]
                    [ tableColumn
                    , registerColumn
                    ]
                ]
            ]
        ]


tableColumn =
    div [ class "column" ]
        [ div [ class "title" ] [ text "Leaderboard" ] ]


registerColumn =
    div [ class "column" ]
        [ div [ class "title" ] [ text "Registration" ] ]
