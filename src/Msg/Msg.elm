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
    = OnGetDashData
    | ReceivedDashData (Result Http.Error ActiveData)
    | OnSelectDashPuzzle PuzzleData
    | OnChangeInput String
    | OnPostSubmission
    | ReceivedSubmissionData (Result Http.Error OkSubmitData)


type RegisterEvent
    = OnChangeRegisterUsername String
    | OnChangeRegisterEmail String
    | OnChangeRegisterFirstName String
    | OnChangeRegisterLastName String
    | OnRegister
    | ReceivedRegister (Result Http.Error String)


type LoginEvent
    = ToggleLoginModal
    | OnChangeLoginEmail String
    | OnChangeLoginToken String
    | OnLogin
    | OnSendToken
    | ReceivedSendToken (Result Http.Error String)
    | ReceivedLogin (Result Http.Error String)


type CompletedEvent
    = OnGetCompleted
    | ReceivedCompleted (Result Http.Error (List PuzzleData))
    | OnSelectCompletedPuzzle PuzzleData


type SubmissionEvent
    = OnGetSubmission
    | ReceivedSubmission (Result Http.Error (List UserSubmission))
