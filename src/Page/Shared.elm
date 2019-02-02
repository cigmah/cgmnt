module Page.Shared exposing (loadingState, loremIpsum, textWithLoad)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Html.Lazy exposing (..)
import Markdown
import RemoteData exposing (RemoteData(..), WebData)
import String exposing (slice)
import Types exposing (..)
import Utils


loadingState isLoading textMsg =
    case isLoading of
        True ->
            span [ class "text-grey-lighter bg-grey-lighter rounded" ] [ textMsg ]

        False ->
            textMsg


textWithLoad isLoading str =
    case isLoading of
        True ->
            span [ class "text-grey-lighter bg-grey-lighter rounded" ] [ text str ]

        False ->
            text str


loremIpsum =
    """ Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do
eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim
veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo
consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum
dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident,
sunt in culpa qui officia deserunt mollit anim id est laborum.
"""
