module Main exposing (Model, Msg(..), Route(..), bodyAbout, bodyContact, bodyHome, bodyNotFound, bodyPuzzleHunt, fromUrl, init, main, routeParser, subscriptions, update, view, viewAbout, viewContact, viewHome, viewLink, viewNotFound, viewPuzzleHunt)

import Browser
import Browser.Navigation as Nav
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Maybe
import Url
import Url.Parser as Parser exposing ((</>), Parser, map, oneOf, s, string, top)



---- ROUTER ----


type Route
    = Home
    | About
    | PuzzleHunt
    | Contact
    | NotFound


routeParser : Parser (Route -> a) a
routeParser =
    oneOf
        [ map Home top
        , map About (s "about")
        , map PuzzleHunt (s "PuzzleHunt")
        , map Contact (s "contact")
        ]


fromUrl : Url.Url -> Route
fromUrl url =
    Maybe.withDefault NotFound (Parser.parse routeParser url)



---- MODEL ----


type alias Model =
    { key : Nav.Key, route : Route, componentStates : ComponentStates }


init : () -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url key =
    ( { key = key, route = fromUrl url, componentStates = { navbarMenuActive = False } }, Cmd.none )


type alias ComponentStates =
    { navbarMenuActive : Bool }



---- UPDATE ----


type Msg
    = LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url
    | ToggleBurgerMenu


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LinkClicked urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    ( model, Nav.pushUrl model.key (Url.toString url) )

                Browser.External href ->
                    ( model, Nav.load href )

        UrlChanged url ->
            ( { model | route = fromUrl url }, Cmd.none )

        ToggleBurgerMenu ->
            let
                componentStates =
                    model.componentStates
            in
            case componentStates.navbarMenuActive of
                True ->
                    ( { model | componentStates = { componentStates | navbarMenuActive = False } }, Cmd.none )

                False ->
                    ( { model | componentStates = { componentStates | navbarMenuActive = True } }, Cmd.none )



---- SUBSCRIPTIONS ----


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



---- VIEW ----


view : Model -> Browser.Document Msg
view model =
    case model.route of
        Home ->
            viewHome model

        About ->
            viewAbout model

        PuzzleHunt ->
            viewPuzzleHunt model

        Contact ->
            viewContact model

        NotFound ->
            viewNotFound model


viewHome model =
    { title = "CIGMAH - Coding Interest Group in Medicine and Healthcare"
    , body = bodyHome model
    }


viewAbout model =
    { title = "About CIGMAH"
    , body = bodyAbout model
    }


viewPuzzleHunt model =
    { title = "CIGMAH PuzzleHunt"
    , body = bodyPuzzleHunt model
    }


viewContact model =
    { title = "Contact CIGMAH"
    , body = bodyContact model
    }


viewNotFound model =
    { title = "Page Not Found"
    , body = bodyNotFound model
    }


navBar model =
    let
        navbarMenuClass =
            case model.componentStates.navbarMenuActive of
                True ->
                    "navbar-menu is-active"

                False ->
                    "navbar-menu"
    in
    nav [ class "navbar" ]
        [ div [ class "navbar-brand" ]
            [ a [ class "navbar-item", href "/" ]
                [ text "CIGMAH" ]
            , div
                [ class "navbar-burger", onClick ToggleBurgerMenu ]
                [ span [] [], span [] [], span [] [], span [] [] ]
            ]
        , div [ class navbarMenuClass ]
            [ div [ class "navbar-start" ]
                [ a [ class "navbar-item", href "/" ]
                    [ text "Home" ]
                , a [ class "navbar-item", href "/about" ]
                    [ text "About" ]
                , a [ class "navbar-item", href "/PuzzleHunt" ]
                    [ text "Puzzle Hunt 2019" ]
                , a [ class "navbar-item", href "/contact" ]
                    [ text "Contact" ]
                ]
            ]
        ]


bodyHome model =
    [ navBar model
    , section [ class "hero is-primary is-fullheight-with-navbar" ]
        [ div [ class "hero-body" ]
            [ div [ class "container" ]
                [ h1 [ class "title" ]
                    [ text "CIGMAH" ]
                , h2 [ class "subtitle" ]
                    [ text "Coding Interest Group in Medicine And Healthcare" ]
                ]
            ]
        ]
    ]


bodyAbout model =
    [ div [] [] ]


bodyPuzzleHunt model =
    [ div [] [] ]


bodyContact model =
    [ div [] [] ]


bodyNotFound model =
    [ div [] [] ]


viewLink : String -> Html Msg
viewLink path =
    li [] [ a [ href path ] [ text path ] ]



---- PROGRAM ----


main : Program () Model Msg
main =
    Browser.application
        { view = view
        , init = init
        , update = update
        , subscriptions = subscriptions
        , onUrlRequest = LinkClicked
        , onUrlChange = UrlChanged
        }
