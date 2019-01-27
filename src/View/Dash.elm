module View.Dash exposing (body, bodyPuzzleHunt, getTimeString, loadingModal, makeOpenCard, registerForm, registerModal, view)

import Content.Dash as Content
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Iso8601
import List
import Markdown
import Maybe exposing (withDefault)
import Msg.Msg exposing (..)
import String
import Time exposing (millisToPosix, posixToMillis)
import Types.Init as Init
import Types.Types exposing (..)
import View.Login
import View.NavBar exposing (navBar)


view model =
    case model.authToken of
        Nothing ->
            { title = "CIGMAH PuzzleHunt"
            , body = PuzzleHunt.NotAuthenticated.bodyPuzzleHunt model
            }

        Just token ->
            { title = "PuzzleHunt Portal"
            , body = PuzzleHunt.Authenticated.bodyPuzzleHunt model token
            }


body model token =
    let
        loadingBarOn =
            case model.huntDashboardInformation of
                Just info ->
                    case info.isLoading of
                        True ->
                            "is-active"

                        False ->
                            case model.currentTime of
                                Nothing ->
                                    "is-active"

                                _ ->
                                    ""

                Nothing ->
                    ""

        nextPuzzle =
            case model.huntDashboardInformation of
                Just info ->
                    case model.currentTime of
                        Just currentTime ->
                            case info.data of
                                Just data ->
                                    case data.next of
                                        Just next ->
                                            "The next theme is ''" ++ next.theme ++ "'' and opens in " ++ getTimeString (posixToMillis next.openDatetime - posixToMillis currentTime)

                                        Nothing ->
                                            "The next theme has not been announced yet."

                                Nothing ->
                                    ""

                        Nothing ->
                            ""

                Nothing ->
                    ""

        openCards =
            case model.huntDashboardInformation of
                Just info ->
                    case info.data of
                        Just data ->
                            case model.currentTime of
                                Just currentTime ->
                                    List.map (\x -> makeOpenCard x <| posixToMillis x.closeDatetime - posixToMillis currentTime) data.current

                                Nothing ->
                                    [ div [] [] ]

                        Nothing ->
                            [ div [] [] ]

                Nothing ->
                    [ div [] [] ]
    in
    [ navBar model
    , loadingModal loadingBarOn
    , section [ class "hero is-dark" ]
        [ div [ class "hero-body" ]
            [ div [ class "container" ]
                [ h1 [ class "title" ] [ text "Puzzle Hunt 2019 Portal" ]
                , h2 [ class "subtitle" ] [ text nextPuzzle ]
                ]
            ]
        ]
    , section [ class "hero" ]
        [ div [ class "hero-body" ]
            [ div [ class "container" ]
                [ div [ class "tile is-ancestor" ]
                    openCards
                ]
            ]
        ]
    ]


makeOpenCard themeData timeDelta =
    let
        timeString =
            getTimeString timeDelta
    in
    div [ class "tile is-parent" ]
        [ div [ class "tile is-child box" ]
            [ h1 [ class "subtitle" ] [ text themeData.theme ]
            , div [ class "field is-grouped is-grouped-multiline" ]
                [ div [ class "control" ]
                    [ div
                        [ class "tag has-addons" ]
                        [ span [ class "tag is-danger" ]
                            [ text "Closes" ]
                        , span [ class "tag" ] [ text <| getTimeString timeDelta ]
                        ]
                    ]
                ]
            , div [ class "content" ]
                [ text themeData.tagline ]
            ]
        ]


getTimeString timeDelta =
    let
        seconds d =
            modBy 60 <| d // 1000

        minutes d =
            modBy 60 <| d // (60 * 1000)

        hours d =
            modBy 24 <| d // (60 * 60 * 1000)

        days d =
            d // (24 * 60 * 60 * 1000)

        phrase d f qualifier =
            String.fromInt (f d) ++ qualifier

        timeString d =
            phrase d days "d" ++ ":" ++ phrase d hours "h" ++ ":" ++ phrase d minutes "m" ++ ":" ++ phrase d seconds "s"
    in
    timeString timeDelta


bodyPuzzleHunt model =
    [ navBar model
    , View.Register.modal model
    , View.Login.modal model
    , section [ class "hero is-dark is-fullheight-with-navbar" ]
        [ div [ class "hero-body" ]
            [ div [ class "container" ]
                [ h1 [ class "title" ]
                    [ text "CIGMAH Puzzle Hunt 2019" ]
                , h2 [ class "subtitle" ]
                    [ text "Testing Phase" ]
                , div [ class "buttons has-addons" ]
                    [ span [ class "button is-large is-dark is-inverted is-outlined", onClick <| RegisterMsg ToggleRegisterModal ]
                        [ text "Register" ]
                    , span [ class "button is-large is-dark is-inverted is-outlined", onClick <| LoginMsg ToggleLoginModal ]
                        [ text "Login" ]
                    ]
                ]
            ]
        ]
    , section [ class "hero" ]
        [ div [ class "hero-body" ]
            [ div [ class "container" ]
                [ div []
                    [ div [ class "content" ] <| Markdown.toHtml Nothing Content.puzzleHuntIntroText ]
                ]
            ]
        ]
    , section [ class "hero" ]
        [ div [ class "hero-body" ]
            [ div [ class "message container is-danger" ]
                [ div [ class "message-header" ]
                    [ h2 [] [ text "Never coded before?" ] ]
                , div [ class "message-body" ] [ div [ class "content" ] <| Markdown.toHtml Nothing Content.neverCodedText ]
                ]
            ]
        ]
    ]


registerModal model =
    let
        modalClass =
            case model.registerInformation of
                Just _ ->
                    "modal is-active"

                Nothing ->
                    "modal"
    in
    div [ class modalClass ]
        [ div [ class "modal-background", onClick <| RegisterMsg ToggleRegisterModal ] []
        , div [ class "modal-content" ] [ registerForm model ]
        , button [ class "modal-close is-large", onClick <| RegisterMsg ToggleRegisterModal ] []
        ]


registerForm model =
    let
        registerParams =
            case model.registerInformation of
                Just info ->
                    info

                Nothing ->
                    Init.register

        registerColour =
            case registerParams.response of
                Just _ ->
                    "success"

                Nothing ->
                    "danger"

        loadingStatus =
            case registerParams.isLoading of
                True ->
                    "is-loading"

                False ->
                    ""

        errorStatus =
            case registerParams.message of
                Just message ->
                    div [ class <| "notification has-text-centered is-" ++ registerColour ]
                        [ text message
                        ]

                Nothing ->
                    div [] []

        maybeFooter =
            case registerParams.response of
                Just _ ->
                    div [] []

                Nothing ->
                    footer [ class "card-footer" ]
                        [ div [ class "card-footer-item" ]
                            [ button
                                [ class <| "button is-medium is-fullwidth is-outlined is-" ++ registerColour ++ " " ++ loadingStatus
                                , onClick <| RegisterMsg OnRegister
                                ]
                                [ text "Register" ]
                            ]
                        ]
    in
    div [ class "card" ]
        [ div [ class <| "card-header has-background-" ++ registerColour ] [ span [ class "card-header-title has-text-white" ] [ text "User Registration" ] ]
        , div [ class "card-content" ]
            [ div [ class "field" ]
                [ label [ class "label" ] [ text "Username" ]
                , div [ class "control" ]
                    [ input
                        [ class "input"
                        , type_ "text"
                        , placeholder "e.g. bms_intern"
                        , value registerParams.username
                        , onInput <| RegisterMsg << OnChangeRegisterUsername
                        ]
                        []
                    ]
                ]
            , div [ class "field" ]
                [ label [ class "label" ] [ text "Email" ]
                , div [ class "control" ]
                    [ input
                        [ class "input"
                        , type_ "text"
                        , placeholder "e.g. roy.basch@bestmedicalschool.com"
                        , value registerParams.email
                        , onInput <| RegisterMsg << OnChangeRegisterEmail
                        ]
                        []
                    ]
                ]
            , div [ class "field" ]
                [ label [ class "label" ] [ text "First Name" ]
                , div [ class "control" ]
                    [ input
                        [ class "input"
                        , type_ "text"
                        , placeholder "e.g. Roy"
                        , value registerParams.firstName
                        , onInput <| RegisterMsg << OnChangeRegisterFirstName
                        ]
                        []
                    ]
                ]
            , div [ class "field" ]
                [ label [ class "label" ] [ text "Last Name" ]
                , div [ class "control" ]
                    [ input
                        [ class "input"
                        , type_ "text"
                        , placeholder "e.g. Basch"
                        , value registerParams.lastName
                        , onInput <| RegisterMsg << OnChangeRegisterLastName
                        ]
                        []
                    ]
                ]
            , errorStatus
            ]
        , maybeFooter
        ]
