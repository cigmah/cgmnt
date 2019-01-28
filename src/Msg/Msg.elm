module Msg.Msg exposing (ArchiveEvent(..), CompletedEvent(..), LeaderEvent(..), LeaderPuzzleEvent(..), LeaderTotalEvent(..), LoginEvent(..), Msg(..), PuzzlesEvent(..), RegisterEvent(..), SubmissionEvent(..))

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
    | RegisterMsg RegisterEvent
    | LoginMsg LoginEvent
    | ArchiveMsg ArchiveEvent
    | LeaderMsg LeaderEvent
    | PuzzlesMsg PuzzlesEvent
    | CompletedMsg CompletedEvent
    | SubmissionMsg SubmissionEvent


type ArchiveEvent
    = OnGetArchive
    | OnSelectArchivePuzzle PuzzleData
    | OnDeselectArchivePuzzle
    | ReceivedArchive (WebData ArchiveData)


type LeaderEvent
    = LeaderTotalMsg LeaderTotalEvent
    | LeaderPuzzleMsg LeaderPuzzleEvent


type LeaderTotalEvent
    = OnGetLeaderTotal
    | ReceivedLeaderTotal (Result Http.Error (List LeaderTotalData))


type LeaderPuzzleEvent
    = OnGetLeaderPuzzle
    | ReceivedLeaderPuzzle (Result Http.Error (List LeaderPuzzleData))


type PuzzlesEvent
    = OnGetActiveData
    | ReceivedActiveData (WebData PuzzlesData)
    | OnSelectActivePuzzle PuzzleData
    | OnDeselectActivePuzzle
    | OnChangeInput String
    | OnPostSubmission
    | ReceivedSubmissionResponse (WebData SubmissionResponse)


type RegisterEvent
    = OnChangeRegisterUsername String
    | OnChangeRegisterEmail String
    | OnChangeRegisterFirstName String
    | OnChangeRegisterLastName String
    | OnRegister
    | ReceivedRegister (WebData Message)


type LoginEvent
    = ToggleLoginModal
    | OnChangeLoginEmail String
    | OnChangeLoginToken String
    | OnLogin
    | OnSendEmail
    | ReceivedSendEmail (WebData Message)
    | ReceivedLogin (WebData Message)


type CompletedEvent
    = OnGetCompleted
    | ReceivedCompleted (WebData ArchiveData)
    | OnSelectCompletedPuzzle PuzzleData
    | OnDeselectCompletedPuzzle


type SubmissionEvent
    = OnGetSubmission
    | ReceivedSubmission (Result Http.Error (List UserSubmission))
