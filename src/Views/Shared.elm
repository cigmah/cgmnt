module Views.Shared exposing (colourThemeToToggleString, errorPage, loadingPage, notFoundPage, routeHref)

import Handlers
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Html.Lazy exposing (..)
import Http exposing (Error(..))
import RemoteData exposing (RemoteData(..), WebData)
import Types exposing (..)


routeHref : Route -> Attribute Msg
routeHref targetRoute =
    href (Handlers.routeToString targetRoute)



-- Navmenu


colourThemeToToggleString colourTheme =
    case colourTheme of
        Dark ->
            "lighten"

        Light ->
            "darken"



-- Not Found and Error Page


loadingPage : Html Msg
loadingPage =
    div [ class "main" ]
        [ div [ class "loading-container" ]
            [ div [ class "loader" ] []
            ]
        ]


notFoundPage =
    div [ class "main" ]
        [ div [ class "loading-container" ]
            [ text "that page wasn't found."
            ]
        ]


errorPage : String -> Html Msg
errorPage errorString =
    div [ class "main" ]
        [ div [ class "loading-container", style "max-width" "600px" ]
            [ text "There was an error. Here's what we know."
            , br [] []
            , text errorString
            ]
        ]


notAskedPage : Html Msg
notAskedPage =
    div [ class "container" ]
        [ h1 [] [ text "Welcome to the CIGMAH Puzzle Hunt" ]
        , p [] [ text "Reload?" ]
        ]


webDataWrapper : WebData a -> (a -> Html Msg) -> Html Msg
webDataWrapper aWebData aFunction =
    case aWebData of
        NotAsked ->
            notAskedPage

        Loading ->
            loadingPage

        Failure e ->
            case e of
                BadStatus metadata ->
                    errorPage metadata.body

                NetworkError ->
                    errorPage "There's something wrong with your network or with accessing the backend - check your internet connection first and check the console for any network errors."

                _ ->
                    errorPage "Unfortunately, we don't yet know what this error is. :(  "

        Success a ->
            aFunction a



-- Loading Helpers
--- TABLES
