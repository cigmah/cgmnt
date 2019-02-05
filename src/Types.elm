module Types exposing (Auth(..), AuthToken, ContactData, ContactResponseData, Credentials, DetailPuzzleData, Email, HomeState(..), IsSelectActive, LeaderPuzzleData, LeaderPuzzleUnit, LeaderTotalData, LeaderTotalUnit, LeaderboardState(..), LoginState(..), Meta, MiniPuzzleData, Model, Msg(..), OkSubmitData, Page(..), ProfileData, PuzzleData, PuzzleDetailState(..), PuzzleId, PuzzleListState(..), PuzzleSet(..), RegisterResponseData, RegisterState(..), Route(..), SendEmailResponseData, Submission, SubmissionData, SubmissionResponseData(..), ThemeData, ThemeSet(..), Token, TooSoonSubmitData, UserBaseData, UserData, defaultContactData, defaultMeta, defaultRegister)

import Browser
import Browser.Navigation as Navigation
import RemoteData exposing (RemoteData(..), WebData)
import Time exposing (Posix)
import Url



-- MODEL


type alias Model =
    { meta : Meta
    , page : Page
    }


type alias Meta =
    { isNavActive : Bool
    , key : Navigation.Key
    , auth : Auth
    }


type Page
    = Home HomeState
    | Resources
    | PuzzleList PuzzleListState
    | PuzzleDetail PuzzleDetailState
    | Leaderboard LeaderboardState
    | Register RegisterState
    | Login LoginState
    | NotFound


type Route
    = HomeRoute
    | ResourcesRoute
    | PuzzleListRoute
    | PuzzleDetailRoute PuzzleId
    | LeaderboardRoute
    | RegisterRoute
    | LoginRoute
    | LogoutRoute
    | NotFoundRoute



-- ROUTE STATES


type HomeState
    = HomePublic ContactData (WebData ContactResponseData)
    | HomeUser UserData (WebData ProfileData)


type PuzzleListState
    = ListPublic (WebData (List MiniPuzzleData))
    | ListUser (WebData (List MiniPuzzleData))


type PuzzleDetailState
    = UserPuzzle PuzzleId (WebData DetailPuzzleData)
    | UnsolvedPuzzleLoaded PuzzleId DetailPuzzleData Submission (WebData SubmissionResponseData)
    | PublicPuzzle PuzzleId (WebData DetailPuzzleData)


type LeaderboardState
    = ByTotal (WebData LeaderTotalData)
    | ByPuzzleNotChosen IsSelectActive (WebData (List MiniPuzzleData))
    | ByPuzzleChosen IsSelectActive (List MiniPuzzleData) MiniPuzzleData (WebData LeaderPuzzleData)


type RegisterState
    = NewUser UserData (WebData RegisterResponseData)
    | AlreadyUser


type LoginState
    = InputEmail Email (WebData SendEmailResponseData)
    | InputToken Email SendEmailResponseData Token (WebData Credentials)
    | AlreadyLoggedIn



-- ROUTE DATA


type alias Submission =
    String


type alias Email =
    String


type alias Token =
    String


type alias IsSelectActive =
    Bool


type alias ContactResponseData =
    String


type alias RegisterResponseData =
    String


type alias SendEmailResponseData =
    String



-- USER AND CREDENTIALS


type Auth
    = User Credentials
    | Public


type alias UserBaseData a =
    { a
        | username : String
        , email : String
        , firstName : String
        , lastName : String
    }


type alias UserData =
    { username : String
    , email : String
    , firstName : String
    , lastName : String
    }


type alias Credentials =
    { username : String
    , email : String
    , firstName : String
    , lastName : String
    , token : AuthToken
    }


type alias AuthToken =
    String



-- CONTACT


type alias ContactData =
    { name : String
    , email : String
    , subject : String
    , body : String
    }



-- PROFILE


type alias ProfileData =
    { submissions : List SubmissionData
    , solvedImages : List String
    , numSolved : Int
    , points : Int
    , next : ThemeData
    }


type alias SubmissionData =
    { id : Int
    , username : String
    , puzzle : MiniPuzzleData
    , submissionDatetime : Posix
    , submission : String
    , isResponseCorrect : Bool
    , points : Int
    }



-- THEME


type alias ThemeData =
    { id : Int
    , theme : String
    , themeSet : ThemeSet
    , tagline : String
    , openDatetime : Posix
    }


type ThemeSet
    = RegularTheme
    | MetaTheme
    | SampleTheme



-- PUZZLE


type alias PuzzleId =
    Int


type PuzzleSet
    = AbstractPuzzle
    | BeginnerPuzzle
    | ChallengePuzzle
    | MetaPuzzle


type alias PuzzleData a =
    { a
        | id : Int
        , puzzleSet : String
        , title : String
        , imageLink : String
    }


type alias MiniPuzzleData =
    { id : Int
    , themeTitle : String
    , puzzleSet : PuzzleSet
    , title : String
    , imageLink : String
    , isSolved : Maybe Bool
    }


type alias DetailPuzzleData =
    { id : Int
    , puzzleSet : PuzzleSet
    , theme : ThemeData
    , title : String
    , imageLink : String
    , body : String
    , example : String
    , statement : String
    , references : String
    , input : String
    , isSolved : Maybe Bool
    , answer : Maybe String
    , explanation : Maybe String
    }



-- LEADERBOARD


type alias LeaderPuzzleData =
    List LeaderPuzzleUnit


type alias LeaderPuzzleUnit =
    { username : String
    , puzzle : String
    , submissionDatetime : Posix
    , points : Int
    }


type alias LeaderTotalData =
    List LeaderTotalUnit


type alias LeaderTotalUnit =
    { username : String
    , total : Int
    }



-- SUBMISSIONS


type SubmissionResponseData
    = OkSubmit OkSubmitData
    | TooSoonSubmit TooSoonSubmitData


type alias OkSubmitData =
    { id : Int
    , submission : String
    , isResponseCorrect : Bool
    , points : Int
    }


type alias TooSoonSubmitData =
    { message : String
    , attempts : Int
    , last : Posix
    , wait : Int
    , next : Posix
    }



-- MSG


type Msg
    = Ignored
    | ClickedLink Browser.UrlRequest
    | ChangedUrl Url.Url
    | ChangedRoute Route
    | ToggledNav
    | ToggledMessage
    | HomeChangedName String
    | HomeChangedEmail String
    | HomeChangedSubject String
    | HomeChangedBody String
    | HomeClickedSend
    | HomeGotContactResponse (WebData ContactResponseData)
    | HomeGotProfileResponse (WebData ProfileData)
    | PuzzleListPublicGotResponse (WebData (List MiniPuzzleData))
    | PuzzleListUserGotResponse (WebData (List MiniPuzzleData))
    | PuzzleListClickedPuzzle PuzzleId
    | PuzzleDetailGotUser (WebData DetailPuzzleData)
    | PuzzleDetailChangedSubmission Submission
    | PuzzleDetailClickedSubmit PuzzleId
    | PuzzleDetailGotSubmissionResponse (WebData SubmissionResponseData)
    | PuzzleDetailGotPublic (WebData DetailPuzzleData)
    | LeaderboardClickedByTotal
    | LeaderboardGotByTotal (WebData LeaderTotalData)
    | LeaderboardClickedByPuzzle
    | LeaderboardGotPuzzleOptions (WebData (List MiniPuzzleData))
    | LeaderboardClickedPuzzle MiniPuzzleData
    | LeaderboardGotByPuzzle (WebData LeaderPuzzleData)
    | LeaderboardTogglePuzzleOptions
    | RegisterChangedUsername String
    | RegisterChangedEmail String
    | RegisterChangedFirstName String
    | RegisterChangedLastName String
    | RegisterClicked
    | RegisterGotResponse (WebData RegisterResponseData)
    | LoginChangedEmail String
    | LoginClickedSendEmail
    | LoginGotSendEmailResponse (WebData SendEmailResponseData)
    | LoginChangedToken String
    | LoginClickedLogin
    | LoginGotLoginResponse (WebData Credentials)



-- INITIALS


defaultMeta : Navigation.Key -> Maybe Credentials -> Meta
defaultMeta key maybeCredentials =
    let
        auth =
            case maybeCredentials of
                Just credentials ->
                    User credentials

                Nothing ->
                    Public
    in
    { isNavActive = False
    , key = key
    , auth = auth
    }


defaultContactData : ContactData
defaultContactData =
    { name = "", email = "", subject = "", body = "" }


defaultRegister : UserData
defaultRegister =
    { username = "", email = "", firstName = "", lastName = "" }
