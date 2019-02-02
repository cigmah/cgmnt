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
import Page.Home as Home
import Page.Leaderboard as Leaderboard
import Page.Login as Login
import Page.NotFound as NotFound
import Page.OpenPuzzles as OpenPuzzles
import Page.Register as Register
import Page.Resources as Resources
import Page.Submissions as Submissions
import Route exposing (Route)
import Session exposing (Session(..))
import Time exposing (Posix)
import Url exposing (Url)
import Viewer exposing (Viewer)



-- MODEL


type Model
    = Home Home.Model
    | Resources Resources.Model
    | Archive Archive.Model
    | Login Login.Model
    | Register Register.Model
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

        Resources modelResources ->
            Resources.toSession modelResources

        Archive modelArchive ->
            Archive.toSession modelArchive

        Login modelLogin ->
            Login.toSession modelLogin

        Register modelDashboard ->
            Register.toSession modelDashboard

        OpenPuzzles modelOpenPuzzles ->
            OpenPuzzles.toSession modelOpenPuzzles

        ClosedPuzzles modelClosedPuzzles ->
            ClosedPuzzles.toSession modelClosedPuzzles

        Leaderboard modelLeaderboard ->
            Leaderboard.toSession modelLeaderboard

        Submissions modelSubmissions ->
            Submissions.toSession modelSubmissions

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
            Resources.init session |> updateWith Resources GotResourcesMsg model

        Just Route.Login ->
            Login.init session |> updateWith Login GotLoginMsg model

        Just Route.Register ->
            Register.init session |> updateWith Register GotRegisterMsg model

        Just Route.OpenPuzzles ->
            OpenPuzzles.init session |> updateWith OpenPuzzles GotOpenPuzzlesMsg model

        Just Route.ClosedPuzzles ->
            ClosedPuzzles.init session |> updateWith ClosedPuzzles GotClosedPuzzlesMsg model

        Just Route.Leaderboard ->
            Leaderboard.init session |> updateWith Leaderboard GotLeaderboardMsg model

        Just Route.Submissions ->
            Submissions.init session |> updateWith Submissions GotSubmissionsMsg model

        Just Route.Logout ->
            case session of
                LoggedIn key _ ->
                    ( model, Api.logout )

                Guest _ ->
                    ( model, Cmd.none )


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
    | GotResourcesMsg Resources.Msg
    | GotLoginMsg Login.Msg
    | GotRegisterMsg Register.Msg
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

        ( GotResourcesMsg subMsg, Resources data ) ->
            Resources.update subMsg data |> updateWith Resources GotResourcesMsg model

        ( GotRegisterMsg subMsg, Register data ) ->
            Register.update subMsg data |> updateWith Register GotRegisterMsg model

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

        Register modelDashboard ->
            Sub.map GotRegisterMsg (Register.subscriptions modelDashboard)

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

        Resources modelResources ->
            viewPage Page.Other GotResourcesMsg (Resources.view modelResources)

        Login modelLogin ->
            viewPage Page.Login GotLoginMsg (Login.view modelLogin)

        Register modelDashboard ->
            viewPage Page.Register GotRegisterMsg (Register.view modelDashboard)

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
