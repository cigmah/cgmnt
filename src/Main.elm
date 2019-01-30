module Main exposing (main)

import Api
import Browser exposing (Document)
import Browser.Navigation as Nav
import Html
import Json.Decode exposing (Value)
import Page
import Page.Archive as Archive
import Page.Blank as Blank
import Page.ClosedPuzzles as ClosedPuzzles
import Page.Dashboard as Dashboard
import Page.Home as Home
import Page.Leaderboard as Leaderboard
import Page.Login as Login
import Page.NotFound as NotFound
import Page.OpenPuzzles as OpenPuzzles
import Page.Resources as Resources
import Page.Submissions as Submissions
import Route exposing (Route)
import Session exposing (Session)
import Time exposing (Posix)
import Url exposing (Url)
import Viewer exposing (Viewer)



-- MODEL


type Model
    = Home Home.Model
    | Resources Resources.Model
    | Archive Archive.Model
    | Login Login.Model
    | Dashboard Dashboard.Model
    | OpenPuzzles OpenPuzzles.Model
    | ClosedPuzzles ClosedPuzzles.Model
    | Leaderboard Leaderboard.Model
    | Submissions Submissions.Model
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

        Resources session ->
            session

        Archive modelArchive ->
            Archive.toSession modelArchive

        Login modelLogin ->
            Login.toSession modelLogin

        Dashboard modelLogin ->
            Dashboard.toSession modelLogin

        OpenPuzzles modelLogin ->
            OpenPuzzles.toSession modelLogin

        ClosedPuzzles modelLogin ->
            ClosedPuzzles.toSession modelLogin

        Leaderboard modelLogin ->
            Leaderboard.toSession modelLogin

        Submissions modelLogin ->
            Submissions.toSession modelLogin

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

        Just Route.Archive ->
            Archive.init session |> updateWith Archive GotArchiveMsg model

        Just Route.Resources ->
            ( Resources session, Cmd.none )

        Just Route.Login ->
            Login.init session |> updateWith Login GotLoginMsg model

        Just Route.Dashboard ->
            Dashboard.init session |> updateWith Dashboard GotDashboardMsg model

        Just Route.OpenPuzzles ->
            OpenPuzzles.init session |> updateWith OpenPuzzles GotOpenPuzzlesMsg model

        Just Route.ClosedPuzzles ->
            ClosedPuzzles.init session |> updateWith ClosedPuzzles GotClosedPuzzlesMsg model

        Just Route.Leaderboard ->
            Leaderboard.init session |> updateWith Leaderboard GotLeaderboardMsg model

        Just Route.Submissions ->
            Submissions.init session |> updateWith Submissions GotSubmissionsMsg model


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
    | GotArchiveMsg Archive.Msg
    | GotLoginMsg Login.Msg
    | GotDashboardMsg Dashboard.Msg
    | GotOpenPuzzlesMsg OpenPuzzles.Msg
    | GotClosedPuzzlesMsg ClosedPuzzles.Msg
    | GotLeaderboardMsg Leaderboard.Msg
    | GotSubmissionsMsg Submissions.Msg
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

        ( GotHomeMsg subMsg, Home data ) ->
            Home.update subMsg data |> updateWith Home GotHomeMsg model

        ( GotArchiveMsg subMsg, Archive data ) ->
            Archive.update subMsg data |> updateWith Archive GotArchiveMsg model

        ( GotDashboardMsg subMsg, Dashboard data ) ->
            Dashboard.update subMsg data |> updateWith Dashboard GotDashboardMsg model

        ( GotOpenPuzzlesMsg subMsg, OpenPuzzles data ) ->
            OpenPuzzles.update subMsg data |> updateWith OpenPuzzles GotOpenPuzzlesMsg model

        ( GotClosedPuzzlesMsg subMsg, ClosedPuzzles data ) ->
            ClosedPuzzles.update subMsg data |> updateWith ClosedPuzzles GotClosedPuzzlesMsg model

        ( GotLeaderboardMsg subMsg, Leaderboard data ) ->
            Leaderboard.update subMsg data |> updateWith Leaderboard GotLeaderboardMsg model

        ( GotSubmissionsMsg subMsg, Submissions data ) ->
            Submissions.update subMsg data |> updateWith Submissions GotSubmissionsMsg model

        ( GotLoginMsg subMsg, Login data ) ->
            Login.update subMsg data |> updateWith Login GotLoginMsg model

        ( _, _ ) ->
            ( model, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    case model of
        Home modelHome ->
            Sub.map GotHomeMsg (Home.subscriptions modelHome)

        Archive modelArchive ->
            Sub.map GotArchiveMsg (Archive.subscriptions modelArchive)

        Resources _ ->
            Sub.none

        Login modelLogin ->
            Sub.map GotLoginMsg (Login.subscriptions modelLogin)

        Dashboard modelDashboard ->
            Sub.map GotDashboardMsg (Dashboard.subscriptions modelDashboard)

        OpenPuzzles modelOpenPuzzles ->
            Sub.map GotOpenPuzzlesMsg (OpenPuzzles.subscriptions modelOpenPuzzles)

        ClosedPuzzles modelClosedPuzzles ->
            Sub.map GotClosedPuzzlesMsg (ClosedPuzzles.subscriptions modelClosedPuzzles)

        Leaderboard modelLeaderboard ->
            Sub.map GotLeaderboardMsg (Leaderboard.subscriptions modelLeaderboard)

        Submissions modelSubmissions ->
            Sub.map GotSubmissionsMsg (Submissions.subscriptions modelSubmissions)

        NotFound _ ->
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

        Archive modelArchive ->
            viewPage Page.Archive GotArchiveMsg (Archive.view modelArchive)

        Resources session ->
            viewPage Page.Other (\_ -> Ignored) Resources.view

        Login modelLogin ->
            viewPage Page.Login GotLoginMsg (Login.view modelLogin)

        Dashboard modelDashboard ->
            viewPage Page.Dashboard GotDashboardMsg (Dashboard.view modelDashboard)

        OpenPuzzles modelOpenPuzzles ->
            viewPage Page.OpenPuzzles GotOpenPuzzlesMsg (OpenPuzzles.view modelOpenPuzzles)

        ClosedPuzzles modelClosedPuzzles ->
            viewPage Page.ClosedPuzzles GotClosedPuzzlesMsg (ClosedPuzzles.view modelClosedPuzzles)

        Leaderboard modelLeaderboard ->
            viewPage Page.Leaderboard GotLeaderboardMsg (Leaderboard.view modelLeaderboard)

        Submissions modelLogin ->
            viewPage Page.Submissions GotSubmissionsMsg (Submissions.view modelLogin)

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
