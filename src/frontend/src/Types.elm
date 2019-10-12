module Types exposing (Auth(..), AuthToken, ColourTheme(..), Comment, CommentResponse, ContactData, ContactMsgType(..), ContactResponse, Credentials, Email, EmailToken, FullUser, HomeData, LoginMsgType(..), LoginState(..), Modal(..), Model, Msg(..), OkSubmitData, Prize, PrizeType(..), PuzzleDetail, PuzzleDetailState(..), PuzzleId, PuzzleLeaderboardUnit, PuzzleMini, PuzzleMsgType(..), PuzzleSet(..), PuzzleStats, RegisterMsgType(..), RegisterResponse, Route(..), SendEmailResponse, Submission, SubmissionData, SubmissionResponse(..), Theme, ThemeSet(..), TooSoonSubmitData, User, UserAggregate, UserStats, Username, defaultContactData, defaultModel, defaultRegister)

import Browser
import Browser.Navigation as Navigation
import RemoteData exposing (RemoteData(..), WebData)
import Time exposing (Posix)
import Url



-- MODEL


type alias Model =
    { key : Navigation.Key
    , auth : Auth
    , colourTheme : ColourTheme
    , webDataHome : WebData HomeData
    , message : Maybe String
    , modal : Maybe Modal
    }


type Auth
    = User Credentials
    | Public


type ColourTheme
    = Light
    | Dark
    | Fun


type alias HomeData =
    { puzzles : List PuzzleMini
    , next : Theme
    , numRegistrations : Int
    , numSubmissions : Int
    }


type Modal
    = Contact ContactData (WebData ContactResponse)
    | Register FullUser (WebData RegisterResponse)
    | Login LoginState
    | Puzzle PuzzleId PuzzleDetailState
    | Prizes (WebData (List Prize))
    | Leaderboard (WebData (List UserAggregate))
    | UserInfo Username (WebData UserStats)
    | Logout
    | NotFound


type Route
    = HomeRoute
    | ContactRoute
    | RegisterRoute
    | LoginRoute
    | PuzzleRoute PuzzleId
    | PrizesRoute
    | LeaderboardRoute
    | UserRoute Username
    | LogoutRoute
    | NotFoundRoute



-- ROUTE STATES


type LoginState
    = InputEmail Email (WebData SendEmailResponse)
    | InputToken Email SendEmailResponse EmailToken (WebData Credentials)


type PuzzleDetailState
    = UserSolvedPuzzle (WebData PuzzleDetail) String (WebData CommentResponse)
    | UserUnsolvedPuzzle (WebData PuzzleDetail) Submission (WebData SubmissionResponse)
    | PublicPuzzle (WebData PuzzleDetail)



-- ROUTE DATA


type alias Submission =
    String


type alias Username =
    String


type alias Email =
    String


type alias EmailToken =
    String


type alias ContactResponse =
    String


type alias CommentResponse =
    List Comment


type alias RegisterResponse =
    String


type alias SendEmailResponse =
    String



-- USER AND CREDENTIALS


type alias User base =
    { base | username : String }


type alias FullUser =
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
    , authToken : AuthToken
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



-- USER


type alias UserStats =
    { username : Username
    , numSubmit : Int
    , numSolved : Int
    , points : Int
    , rank : Int
    , numPrizes : Int
    , submissions : Maybe (List SubmissionData)
    }


type alias SubmissionData =
    { id : Int
    , username : String
    , puzzle : PuzzleMini
    , submissionDatetime : Posix
    , submission : String
    , isResponseCorrect : Bool
    , points : Int
    }



-- PRIZES


type PrizeType
    = AbstractPrize
    | BeginnerPrize
    | ChallengePrize
    | PuzzlePrize
    | GrandPrize


type alias Prize =
    { username : String
    , prizeType : PrizeType
    , awardedDatetime : Time.Posix
    , note : String
    }



-- THEME


type alias Theme =
    { id : Int
    , themeTitle : String
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


type alias PuzzleMini =
    { id : Int
    , themeData : Theme
    , puzzleSet : PuzzleSet
    , title : String
    , isSolved : Maybe Bool
    }


type alias PuzzleDetail =
    { id : Int
    , puzzleSet : PuzzleSet
    , theme : Theme
    , title : String
    , body : String
    , input : String
    , statement : String
    , references : String
    , stats : PuzzleStats
    , answer : Maybe String
    , explanation : Maybe String
    , comments : Maybe (List Comment)
    }


type alias PuzzleStats =
    { correct : Int
    , incorrect : Int
    , leaderboard : List PuzzleLeaderboardUnit
    }


type alias PuzzleLeaderboardUnit =
    { username : String
    , submissionDatetime : Posix
    }


type alias Comment =
    { username : String
    , timestamp : Posix
    , text : String
    }



-- LEADERBOARD


type alias UserAggregate =
    { username : String
    , totalAbstract : Int
    , totalBeginner : Int
    , totalChallenge : Int
    , totalMeta : Int
    , totalGrand : Int
    }



-- SUBMISSIONS


type SubmissionResponse
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
    | ToggledTheme
    | ChangedRoute Route
    | ToggledMessage
    | HomeGotResponse (WebData HomeData)
    | PrizesGotResponse (WebData (List Prize))
    | LeaderboardGotResponse (WebData (List UserAggregate))
    | UserGotResponse (WebData UserStats)
    | LoginMsg LoginMsgType
    | ContactMsg ContactMsgType
    | PuzzleMsg PuzzleMsgType
    | RegisterMsg RegisterMsgType


type LoginMsgType
    = ChangedLoginEmail String
    | ClickedSendEmail
    | GotSendEmailResponse (WebData SendEmailResponse)
    | ChangedToken String
    | ClickedLogin
    | GotLoginResponse (WebData Credentials)


type ContactMsgType
    = ChangedContactName String
    | ChangedContactEmail String
    | ChangedContactSubject String
    | ChangedContactBody String
    | ClickedSend
    | GotContactResponse (WebData ContactResponse)


type PuzzleMsgType
    = GotPuzzle (WebData PuzzleDetail)
    | ChangedSubmission Submission
    | ClickedSubmit PuzzleId
    | GotSubmissionResponse (WebData SubmissionResponse)
    | ChangedComment String
    | ClickedComment
    | GotCommentResponse (WebData CommentResponse)


type RegisterMsgType
    = ChangedRegisterUsername String
    | ChangedRegisterEmail String
    | ChangedFirstName String
    | ChangedLastName String
    | ClickedRegister
    | GotRegisterResponse (WebData RegisterResponse)



-- INITIALS


defaultModel : Navigation.Key -> Maybe Credentials -> ColourTheme -> Model
defaultModel key maybeCredentials colourTheme =
    let
        auth =
            case maybeCredentials of
                Just credentials ->
                    User credentials

                Nothing ->
                    Public
    in
    { key = key
    , auth = auth
    , colourTheme = colourTheme
    , webDataHome = Loading
    , message = Nothing
    , modal = Nothing
    }


defaultContactData : ContactData
defaultContactData =
    { name = "", email = "", subject = "", body = "" }


defaultRegister : FullUser
defaultRegister =
    { username = "", email = "", firstName = "", lastName = "" }
