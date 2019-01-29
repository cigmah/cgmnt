module View.Home exposing (view)

import Content.Home as Content
import Functions.Functions exposing (safeOnSubmit, timeStringWithDefault)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Html.Lazy exposing (..)
import Markdown
import Msg.Msg exposing (..)
import RemoteData exposing (RemoteData(..), WebData)
import Time exposing (Posix, millisToPosix)
import View.NavBar exposing (navBar)


view meta registerInfo registerData =
    { title = "CIGMAH Puzzle Hunt 2019"
    , body = body meta registerInfo registerData
    }


body meta registerInfo registerData =
    let
        -- Hard coded for now, corresponds to 2019/09/21 5PM AEST
        endTime =
            millisToPosix 1569049200000

        tagline =
            case meta.currentTime of
                Just currentTime ->
                    timeStringWithDefault currentTime endTime "The Puzzle Hunt has ended." "The Puzzle Hunt ends in "

                Nothing ->
                    "Getting the time..."

        title x =
            h1 [ class "subtitle has-text-centered is-family-monospace" ]
                [ text tagline ]
    in
    [ lazy2 navBar meta.authToken meta.navBarMenuActive
    , section [ class "hero is-dark is-fullheight-with-navbar" ]
        [ div [ class "hero-body" ]
            [ div [ class "container" ]
                [ h1 [ class "subtitle has-text-centered" ]
                    [ text "Coding Interest Group in Medicine And Healthcare" ]
                , h1 [ class "title has-text-centered" ] [ text "Puzzle Hunt 2019" ]
                , h2 [ class "subtitle has-text-centered has-text-weight-light" ] [ text tagline ]
                , lazy2 renderBody registerInfo registerData
                ]
            ]
        ]
    ]


renderBody registerInfo registerData =
    let
        loadingState =
            case registerData of
                Loading ->
                    " is-loading "

                _ ->
                    ""

        colourState =
            case registerData of
                Success msg ->
                    " is-success has-background-success "

                _ ->
                    " is-danger has-background-danger  "

        registerButton =
            case registerData of
                Success _ ->
                    div [] []

                _ ->
                    div [ class "field is-horizontal" ]
                        [ div [ class "field-body" ]
                            [ div [ class "field " ]
                                [ div [ class "control" ]
                                    [ button [ type_ "submit", class <| "button is-medium is-fullwidth" ++ loadingState ++ colourState ]
                                        [ text "Register" ]
                                    ]
                                ]
                            ]
                        ]

        message =
            case registerData of
                NotAsked ->
                    div [] []

                Loading ->
                    div [] []

                Success msg ->
                    footer [ class "card-footer has-text-white is-success has-background-success" ] [ span [ class "card-footer-item content has-text-centered" ] [ text msg ] ]

                Failure error ->
                    footer [ class "card-footer has-text-white has-background-danger" ] [ span [ class "card-footer-item content has-text-centered" ] [ text "There was an error." ] ]
    in
    div [ class "columns is-centered" ]
        [ div [ class "column has-background-dark is-two-thirds" ]
            [ div [ class "card" ]
                [ div [ class "card-header" ] [ span [ class <| "card-header-title has-text-white has-text-weight-semibold is-centered has-text-centered" ++ colourState ] [ text "Registrations open." ] ]
                , Html.form
                    [ class "card-content has-background-grey-dark"
                    , safeOnSubmit <| RegisterMsg OnRegister
                    ]
                    [ registerField "Username" "" "text" <| RegisterMsg << OnChangeRegisterUsername
                    , registerField "Email" "" "email" <| RegisterMsg << OnChangeRegisterEmail
                    , div [ class "field is-horizontal" ]
                        [ div [ class "field-label is-normal " ] [ label [ class "label has-text-white" ] [ text "Name" ] ]
                        , div [ class "field-body" ]
                            [ div [ class "field " ]
                                [ div [ class "control" ]
                                    [ input [ class "input has-background-grey-dark has-text-white", type_ "text", placeholder "", onInput <| RegisterMsg << OnChangeRegisterFirstName ]
                                        []
                                    ]
                                ]
                            , div [ class "field" ]
                                [ div [ class "control" ]
                                    [ input [ class "input has-background-grey-dark has-text-white", type_ "text", placeholder "", onInput <| RegisterMsg << OnChangeRegisterLastName ]
                                        []
                                    ]
                                ]
                            ]
                        ]
                    , registerButton
                    ]
                , message
                ]
            ]
        ]


registerField : String -> String -> String -> (String -> Msg) -> Html Msg
registerField fieldLabel fieldPlaceholder fieldType fieldOnChange =
    div [ class "field is-horizontal" ]
        [ div [ class "field-label is-normal" ]
            [ label [ class "label has-text-white" ] [ text fieldLabel ] ]
        , div [ class "field-body  is-expanded" ]
            [ div [ class "field" ]
                [ div [ class "control is-expanded" ]
                    [ input [ class "input has-background-grey-dark has-text-white", type_ fieldType, placeholder fieldPlaceholder, onInput fieldOnChange ]
                        []
                    ]
                ]
            ]
        ]
