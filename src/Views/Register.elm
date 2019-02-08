module Views.Register exposing (view)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Html.Lazy exposing (..)
import Http exposing (Error(..))
import RemoteData exposing (RemoteData(..), WebData)
import Types exposing (..)
import Views.Shared exposing (..)


view : Meta -> RegisterState -> ( String, Html Msg )
view meta registerState =
    let
        title =
            "Register - CIGMAH"

        body =
            case ( meta.auth, registerState ) of
                ( Public, NewUser userData registerResponseDataWebData ) ->
                    registerPage registerState

                ( User credentials, AlreadyUser ) ->
                    registerPage registerState

                ( _, _ ) ->
                    errorPage ""
    in
    ( title, body )


registerPage : RegisterState -> Html Msg
registerPage state =
    let
        messageDiv =
            case state of
                NewUser _ (Success _) ->
                    div
                        [ class "bg-grey-lighter border-red text-grey-darkest border-l-2 rounded rounded-l-none p-4 mt-3" ]
                        [ text "Registration was successful! Head over to the ", a [ routeHref LoginRoute ] [ text "login tab" ], text " to start logging in!" ]

                NewUser _ (Failure e) ->
                    case e of
                        BadStatus errorData ->
                            case errorData.status.code of
                                400 ->
                                    div
                                        [ class "bg-grey-lighter border-red text-grey-darkest border-l-2 rounded rounded-l-none p-4 mt-3" ]
                                        [ text "There was a problem with that username or email - either they were invalid (make sure there are no spaces!) or they're taken. Either way, you'll have to change one or both of them (sorry!)" ]

                                code ->
                                    div
                                        [ class "bg-grey-lighter border-red text-grey-darkest border-l-2 rounded rounded-l-none p-4 mt-3" ]
                                        [ text <| "It seems like there was an error...sorry about that. Let us know! To help us, let us know that the status code was " ++ String.fromInt code ]

                        NetworkError ->
                            div
                                [ class "bg-grey-lighter border-red text-grey-darkest border-l-2 rounded rounded-l-none p-4 mt-3" ]
                                [ text "There was something wrong with the network. Is your internet working?" ]

                        _ ->
                            div
                                [ class "bg-grey-lighter border-red text-grey-darkest border-l-2 rounded rounded-l-none p-4 mt-3" ]
                                [ text "It seems like there was an error...sorry about that. Let us know!" ]

                AlreadyUser ->
                    div
                        [ class "bg-grey-lighter border-red text-grey-darkest border-l-2 rounded rounded-l-none p-4 mt-3" ]
                        [ text "You've already registered...in fact, you're logged in right now!" ]

                _ ->
                    div [] []

        hideForm =
            case state of
                NewUser _ (Success _) ->
                    True

                AlreadyUser ->
                    True

                _ ->
                    False

        usernameColour =
            case state of
                NewUser data _ ->
                    case data.username of
                        "" ->
                            "red"

                        _ ->
                            case String.contains " " data.username of
                                True ->
                                    "red"

                                False ->
                                    "green"

                _ ->
                    "grey"

        emailColour =
            case state of
                NewUser data _ ->
                    case String.contains "@" data.email && String.contains "." data.email of
                        True ->
                            "green"

                        False ->
                            "red"

                _ ->
                    "grey"

        buttonText =
            case state of
                NewUser _ Loading ->
                    "Loading..."

                _ ->
                    "Sign me up!"
    in
    div
        [ class "px-2 md:px-8 bg-grey-lightest" ]
        [ div
            [ class "flex flex-wrap md:h-screen content-center justify-center items-center pt-16 pb-12 md:pb-0 md:pt-12 md:pt-12" ]
            [ Html.form
                [ class "block md:w-3/4 lg:w-2/3 xl:w-1/2", onSubmit RegisterClicked ]
                [ div
                    [ class "inline-flex flex justify-center w-full" ]
                    [ div
                        [ class "flex items-center  sm:text-xl justify-center sm:h-12 sm:w-10 px-5 py-3 rounded-l-lg font-black bg-red-light text-grey-lighter border-b-2 border-red-dark" ]
                        [ span
                            [ class "fas fa-user-plus" ]
                            []
                        ]
                    , div
                        [ class "flex items-center w-full p-3 px-5 sm:h-12 rounded-r-lg text-grey-darkest sm:text-lg font-bold uppercase bg-grey-lighter border-b-2 border-grey" ]
                        [ text "Register for the 2019 Puzzle Hunt" ]
                    ]
                , div
                    [ class "block w-full my-3 bg-white rounded-lg p-6 w-full text-base border-b-2 border-grey-light" ]
                    [ p
                        []
                        [ text "We use a password-less login system similar to"
                        , a
                            [ class "text-blue no-underline", href "https://blog.medium.com/signing-in-to-medium-by-email-aacc21134fcd" ]
                            [ text " one coined by Medium." ]
                        , br
                            []
                            []
                        , br
                            []
                            []
                        , text
                            "All we require is a username and email - a name is optional."
                        ]
                    , br
                        []
                        []
                    , p
                        []
                        [ text "Once you've registered, you can start logging in immediately. When you login, a short-term code will be sent to your email to confirm your identity. We never share your email, and will only email you to send you login codes." ]
                    , div
                        [ class "block w-full px-1 py-4 md:px-4 pb-1 mt-1", classList [ ( "hidden", hideForm ) ] ]
                        [ input
                            [ class <| "w-full my-1 mt-0 px-4 py-2 rounded-lg bg-grey-lighter outline-none text-grey-darker focus:bg-grey-lightest focus:text-grey-darkest border-l-2 rounded-l-none border-" ++ usernameColour ++ "-light focus:border-" ++ usernameColour
                            , onInput RegisterChangedUsername
                            , placeholder "Username"
                            ]
                            []
                        , input
                            [ class <| "w-full my-1 px-4 py-2 rounded-lg bg-grey-lighter outline-none text-grey-darker focus:bg-grey-lightest focus:text-grey-darkest border-l-2 rounded-l-none border-" ++ emailColour ++ "-light focus:border-" ++ emailColour
                            , onInput RegisterChangedEmail
                            , placeholder "Email"
                            , type_ "email"
                            ]
                            []
                        , div
                            [ class "sm:flex inline-flex flex-wrap w-full" ]
                            [ div
                                [ class "w-full md:w-1/2 md:pr-1" ]
                                [ input
                                    [ class "w-full my-1 px-4 py-2 rounded-lg bg-grey-lighter outline-none text-grey-darker focus:bg-grey-lightest focus:text-grey-darkest"
                                    , onInput RegisterChangedFirstName
                                    , placeholder "First Name"
                                    ]
                                    []
                                ]
                            , div
                                [ class "w-full md:w-1/2 md:pl-1" ]
                                [ input
                                    [ class "w-full my-1 px-4 py-2 rounded-lg bg-grey-lighter outline-none text-grey-darker focus:bg-grey-lightest focus:text-grey-darkest"
                                    , onInput RegisterChangedLastName
                                    , placeholder "Last Name"
                                    ]
                                    []
                                ]
                            ]
                        ]
                    , messageDiv
                    ]
                , div
                    [ class "flex w-full justify-center", classList [ ( "hidden invisible", hideForm ) ] ]
                    [ button
                        [ class "px-3 py-2 bg-red-light rounded-full border-b-4 border-red-dark w-full md:w-1/2 text-white active:border-0 outline-none focus:outline-none active:outline-none hover:bg-red-dark"
                        ]
                        [ text buttonText ]
                    ]
                ]
            ]
        ]
