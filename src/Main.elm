module Main exposing (main)

import Api
import Browser exposing (Document)
import Browser.Navigation as Nav
import Html
import Json.Decode exposing (Value)
import Page
import Page.Blank as Blank
import Page.Home as Home
import Page.NotFound as NotFound
import Route exposing (Route)
import Session exposing (Session)
import Time exposing (Posix)
import Url exposing (Url)
import Viewer exposing (Viewer)



-- MODEL


type Model
    = Home Home.Model
    | NotFound Session
    | Redirect Session


init : Maybe Viewer -> Url -> Nav.Key -> ( Model, Cmd Msg )
init maybeViewer url navKey =
    changeRouteTo (Route.fromUrl url)
        (Redirect (Session.fromViewer navKey maybeViewer))


toSession : Model -> Session
toSession model =
    case model of
        Home modelHome ->
            Home.toSession modelHome

        NotFound session ->
            session

        Redirect session ->
            session



-- UPDATE


changeRouteTo : Maybe Route -> Model -> ( Model, Cmd Msg )
changeRouteTo routeMaybe model =
    let
        session =
            toSession model
    in
    case routeMaybe of
        Nothing ->
            ( NotFound session, Cmd.none )

        Just Route.Home ->
            Home.init session |> updateWith Home GotHomeMsg model


updateWith : (subModel -> Model) -> (subMsg -> Msg) -> Model -> ( subModel, Cmd subMsg ) -> ( Model, Cmd Msg )
updateWith toModel toMsg model ( subModel, subCmd ) =
    ( toModel subModel
    , Cmd.map toMsg subCmd
    )


type Msg
    = Ignored
    | ClickedLink Browser.UrlRequest
    | ChangedUrl Url
    | ChangedRoute (Maybe Route)
    | ToggledNavMenu
    | GotHomeMsg Home.Msg
    | GotSession Session


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( msg, model ) of
        ( ClickedLink urlRequest, _ ) ->
            case urlRequest of
                Browser.Internal url ->
                    case url.fragment of
                        Nothing ->
                            ( model, Cmd.none )

                        Just _ ->
                            ( model, Nav.pushUrl (Session.navKey <| toSession model) <| Url.toString url )

                Browser.External href ->
                    ( model, Nav.load href )

        ( ChangedUrl url, _ ) ->
            changeRouteTo (Route.fromUrl url) model

        ( ChangedRoute route, _ ) ->
            changeRouteTo route model

        ( GotHomeMsg subMsg, Home home ) ->
            Home.update subMsg home |> updateWith Home GotHomeMsg model

        ( _, _ ) ->
            ( model, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    case model of
        Home modelHome ->
            Sub.map GotHomeMsg (Home.subscriptions modelHome)

        NotFound session ->
            Sub.none

        Redirect _ ->
            Session.changes GotSession (Session.navKey (toSession model))



-- VIEW


view : Model -> Document Msg
view model =
    let
        viewPage page toMsg config =
            let
                { title, body } =
                    Page.view (Session.viewer (toSession model)) page config
            in
            { title = title
            , body = List.map (Html.map toMsg) body
            }
    in
    case model of
        Home modelHome ->
            viewPage Page.Home GotHomeMsg (Home.view modelHome)

        NotFound session ->
            viewPage Page.Other (\_ -> Ignored) NotFound.view

        Redirect session ->
            viewPage Page.Other (\_ -> Ignored) Blank.view



-- APPLICATION


main : Program Value Model Msg
main =
    Api.application Viewer.decoder
        { init = init
        , onUrlChange = ChangedUrl
        , onUrlRequest = ClickedLink
        , subscriptions = subscriptions
        , update = update
        , view = view
        }
