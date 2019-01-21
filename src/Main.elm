module Main exposing (Model, Msg(..), Route(..), bodyAbout, bodyContact, bodyHome, bodyNotFound, bodyPuzzleHunt, fromUrl, init, main, routeParser, subscriptions, update, view, viewAbout, viewContact, viewHome, viewLink, viewNotFound, viewPuzzleHunt)

import Browser
import Browser.Hash as Hash
import Browser.Navigation as Nav
import Content exposing (content)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Markdown
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
    let
        componentStates =
            model.componentStates
    in
    case msg of
        LinkClicked urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    ( { model | componentStates = { componentStates | navbarMenuActive = False } }, Nav.pushUrl model.key (Url.toString url) )

                Browser.External href ->
                    ( model, Nav.load href )

        UrlChanged url ->
            ( { model | route = fromUrl url }, Cmd.none )

        ToggleBurgerMenu ->
            ( { model | componentStates = { componentStates | navbarMenuActive = not componentStates.navbarMenuActive } }, Cmd.none )



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
                [ img [ src "./icon.svg", height 28 ] [], text "CIGMAH" ]
            , div
                [ class "navbar-burger", onClick ToggleBurgerMenu ]
                [ span [] [], span [] [], span [] [], span [] [] ]
            ]
        , div [ class navbarMenuClass ]
            [ div [ class "navbar-start" ]
                [ a [ class "navbar-item", href "/" ]
                    [ text "Home" ]
                , a [ class "navbar-item", href "/#/about" ]
                    [ text "About" ]
                , a [ class "navbar-item", href "/#/PuzzleHunt" ]
                    [ text "Puzzle Hunt 2019" ]
                , a [ class "navbar-item", href "/#/contact" ]
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
                , div [ class "content" ] <|
                    Markdown.toHtml
                        Nothing
                        content.homeIntroText
                , div [ class "message is-danger" ]
                    [ div [ class "message-header" ]
                        [ text "News [2019-01-21]"
                        , span [ class "icon is-danger" ] [ i [ class "fas fa-exclamation-triangle" ] [] ]
                        ]
                    , div [ class "message-body content" ] <|
                        Markdown.toHtml Nothing content.homeNotification
                    ]
                ]
            ]
        ]
    ]


aboutBox title textMarkdown =
    article [ class "message is-primary" ]
        [ div [ class "message-header" ]
            [ h2 [] [ text title ] ]
        , div
            [ class "message-body" ]
            [ div [ class "content" ] <| Markdown.toHtml Nothing textMarkdown ]
        ]


bodyAbout model =
    [ navBar model
    , section [ class "hero is-primary" ]
        [ div [ class "hero-body" ]
            [ div [ class "container" ]
                [ h1 [ class "title" ] [ text "About CIGMAH" ]
                , h2 [ class "subtitle" ] [ text "Frequently Asked Questions" ]
                ]
            ]
        ]
    , section [ class "hero" ]
        [ div [ class "hero-body" ]
            [ div [ class "container" ]
                [ aboutBox "Why should doctors be interested in coding?" content.aboutText.whyLearn
                , aboutBox "Shouldn't doctors be concentrating on learning medicine?" content.aboutText.butConcentrate
                , aboutBox "What can coding do for doctors?" content.aboutText.whatCanDo
                , aboutBox "What does CIGMAH do?" content.aboutText.whatCIGMAH
                , aboutBox "What is thie website made from?" content.aboutText.thisSite
                ]
            ]
        ]
    ]


bodyPuzzleHunt model =
    [ navBar model
    , section [ class "hero is-dark" ]
        [ div [ class "hero-body" ]
            [ div [ class "container" ]
                [ h1 [ class "title" ]
                    [ text "CIGMAH Puzzle Hunt 2019" ]
                , h2 [ class "subtitle" ]
                    [ text "Coming Soon" ]
                ]
            ]
        ]
    , section [ class "hero" ]
        [ div [ class "hero-body" ]
            [ div [ class "container" ]
                [ div []
                    [ div [ class "content" ] <| Markdown.toHtml Nothing content.puzzleHuntIntroText ]
                ]
            ]
        ]
    , section [ class "hero" ]
        [ div [ class "hero-body" ]
            [ div [ class "message container is-danger" ]
                [ div [ class "message-header" ]
                    [ h2 [] [ text "Never coded before?" ] ]
                , div [ class "message-body" ] [ div [ class "content" ] <| Markdown.toHtml Nothing content.neverCodedText ]
                ]
            ]
        ]
    ]


bodyContact model =
    [ navBar model
    , section [ class "hero is-primary" ]
        [ div [ class "hero-body" ]
            [ div [ class "container" ]
                [ h1 [ class "title" ]
                    [ text "Contact Us" ]
                , h2 [ class "subtitle" ]
                    [ text "Questions, Issues, Suggestions etc." ]
                ]
            ]
        ]
    , section [ class "hero" ]
        [ div [ class "hero-body" ]
            [ div [ class "message container is-info" ]
                [ div [ class "message-header" ]
                    [ h2 [] [ text "Contact Email" ] ]
                , div [ class "message-body" ]
                    [ div [ class "content" ]
                        [ text "Drop us a line at ", a [ href "mailto:cigmah.contact@gmail.com" ] [ text "cigmah.contact@gmail.com" ], text "." ]
                    , div [ class "content" ] [ text "We'd love to hear from you!" ]
                    ]
                ]
            , div [ class "message container is-danger" ]
                [ div [ class "message-header" ]
                    [ h2 [] [ text "Help Wanted!" ] ]
                , div [ class "message-body" ]
                    [ div [ class "content" ] <| Markdown.toHtml Nothing content.helpWanted
                    ]
                ]
            ]
        ]
    ]


bodyNotFound model =
    [ navBar model
    , section [ class "hero is-dark is-fullheight-with-navbar" ]
        [ div [ class "hero-body" ]
            [ div [ class "container" ]
                [ h1 [ class "title" ]
                    [ text "This page doesn't exist." ]
                , h2 [ class "subtitle" ]
                    [ text "We're sorry. Go "
                    , a [ href "/", class "has-text-link" ] [ text "home" ]
                    , text "?"
                    ]
                ]
            ]
        ]
    ]


viewLink : String -> Html Msg
viewLink path =
    li [] [ a [ href path ] [ text path ] ]



---- PROGRAM ----


main : Program () Model Msg
main =
    Hash.application
        { view = view
        , init = init
        , update = update
        , subscriptions = subscriptions
        , onUrlRequest = LinkClicked
        , onUrlChange = UrlChanged
        }
