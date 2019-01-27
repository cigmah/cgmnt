module View.Home exposing (view)

import Content.Home as Content
import Functions.Functions exposing (timeStringWithDefault)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Html.Lazy exposing (..)
import Markdown
import Msg.Msg exposing (..)
import Time exposing (Posix, millisToPosix)
import View.NavBar exposing (navBar)


view model =
    { title = "CIGMAH Puzzle Hunt 2019"
    , body = body model
    }


body model =
    let
        -- Hard coded for now, corresponds to 2019/09/21 5PM AEST
        endTime =
            millisToPosix 1569049200000

        tagline =
            case model.currentTime of
                Just currentTime ->
                    timeStringWithDefault currentTime endTime "The Puzzle Hunt has ended." "The Puzzle Hunt ends in "

                Nothing ->
                    "Getting the time..."

        title x =
            h1 [ class "subtitle has-text-centered is-family-monospace" ]
                [ text tagline ]
    in
    [ lazy2 navBar model.authToken model.navBarMenuActive
    , section [ class "hero is-dark is-fullheight-with-navbar" ]
        [ div [ class "hero-body" ]
            [ div [ class "container" ]
                [ h1 [ class "subtitle has-text-centered" ]
                    [ text "Coding Interest Group in Medicine And Healthcare" ]
                , h1 [ class "title has-text-centered" ] [ text "Puzzle Hunt 2019" ]
                , lazy renderBody model.route
                ]
            ]
        ]
    ]


renderBody route =
    div [ class "columns is-centered" ]
        [ div [ class "column has-background-dark is-two-thirds" ]
            [ div [ class "card" ]
                [ div [ class "card-header" ] [ span [ class "card-header-title has-background-danger has-text-white has-text-weight-semibold is-centered has-text-centered" ] [ text "Registrations open." ] ]
                , div [ class "card-content has-background-grey-dark" ]
                    [ registerField "Username" "" <| RegisterMsg << OnChangeRegisterUsername
                    , registerField "Email" "" <| RegisterMsg << OnChangeRegisterEmail
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
                    , div [ class "field is-horizontal" ]
                        [ div [ class "field-body" ]
                            [ div [ class "field " ]
                                [ div [ class "control" ]
                                    [ button [ class "button is-medium is-danger is-fullwidth" ]
                                        [ text "Register" ]
                                    ]
                                ]
                            ]
                        ]
                    ]
                ]
            ]
        ]


registerField : String -> String -> (String -> Msg) -> Html Msg
registerField fieldLabel fieldPlaceholder fieldOnChange =
    div [ class "field is-horizontal" ]
        [ div [ class "field-label is-normal" ]
            [ label [ class "label has-text-white" ] [ text fieldLabel ] ]
        , div [ class "field-body  is-expanded" ]
            [ div [ class "field" ]
                [ div [ class "control is-expanded" ]
                    [ input [ class "input has-background-grey-dark has-text-white", type_ "text", placeholder fieldPlaceholder, onInput fieldOnChange ]
                        []
                    ]
                ]
            ]
        ]
