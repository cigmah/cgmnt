module Types.Msg exposing (Msg(..))

import Browser exposing (UrlRequest)
import Http
import RemoteData exposing (WebData)
import Time exposing (Posix)
import Types.Types exposing (..)
import Url exposing (Url)


type Msg
    = LinkClicked UrlRequest
    | UrlChanged Url
    | NewTime Posix
    | GetCurrentTime
    | ToggleBurgerMenu
    | OnLogout
    | OnGetArchive
    | OnSelectArchivePuzzle PuzzleData
    | OnDeselectArchivePuzzle
    | ReceivedArchive (WebData ArchiveData)
    | OnGetLeaderTotal
    | ReceivedLeaderTotal (WebData LeaderTotalData)
    | OnGetLeaderPuzzle
    | ReceivedLeaderPuzzle (Result Http.Error (List LeaderPuzzleData))
    | OnGetActiveData
    | ReceivedActiveData (WebData PuzzlesData)
    | OnSelectActivePuzzle PuzzleData
    | OnDeselectActivePuzzle
    | OnChangeInput String
    | OnPostSubmission
    | ReceivedSubmissionResponse (WebData SubmissionResponse)
    | OnChangeRegisterUsername String
    | OnChangeRegisterEmail String
    | OnChangeRegisterFirstName String
    | OnChangeRegisterLastName String
    | OnRegister
    | ReceivedRegister (WebData Message)
    | ToggleLoginModal
    | OnChangeLoginEmail String
    | OnChangeLoginToken String
    | OnLogin
    | OnSendEmail
    | ReceivedSendEmail (WebData Message)
    | ReceivedLogin (WebData Message)
    | OnGetCompleted
    | ReceivedCompleted (WebData ArchiveData)
    | OnSelectCompletedPuzzle PuzzleData
    | OnDeselectCompletedPuzzle
    | OnGetSubmissions
    | ReceivedSubmissions (WebData SubmissionsData)