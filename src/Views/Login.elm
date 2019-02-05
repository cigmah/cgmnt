module Views.Login exposing (view)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Html.Lazy exposing (..)
import RemoteData exposing (RemoteData(..), WebData)
import Types exposing (..)
import Views.Shared exposing (..)


view : Meta -> LoginState -> ( String, Html Msg )
view meta loginState =
    let
        title =
            "Login - CIGMAH"

        body =
            case ( meta.auth, loginState ) of
                ( Public, InputEmail email sendEmailResponseDataWebData ) ->
                    loginPage loginState

                ( Public, InputToken email sendEmailResponseData token credentialsWebData ) ->
                    loginPage loginState

                ( User credentials, _ ) ->
                    loginPage (InputToken "" "" "" (Success credentials))

                ( _, _ ) ->
                    notFoundPage
    in
    ( title, body )


loginPage state =
    let
        isTokenDisabled =
            case state of
                InputToken _ _ _ NotAsked ->
                    False

                InputToken _ _ _ (Failure e) ->
                    False

                InputToken _ _ _ Loading ->
                    False

                _ ->
                    True

        sendTokenText =
            case state of
                InputEmail _ Loading ->
                    "Loading..."

                InputToken _ _ _ _ ->
                    "Sent!"

                _ ->
                    "Send Token"

        loginText =
            case state of
                InputToken _ _ _ Loading ->
                    "Loading..."

                _ ->
                    "Login"

        messageDiv =
            case state of
                InputEmail _ (Failure e) ->
                    div
                        [ class "bg-grey-lighter border-green text-grey-darkest border-l-2 rounded rounded-l-none p-4 mt-3 mb-3" ]
                        [ text "We're sorry, there was an issue with sending a token to your email. Maybe you haven't registered? Or a typo?" ]

                InputToken _ _ _ (Failure e) ->
                    div
                        [ class "bg-grey-lighter border-green text-grey-darkest border-l-2 rounded rounded-l-none p-4 mt-3 mb-3" ]
                        [ text "We're sorry, that token didn't work. Is it right? Maybe it's expired? Maybe there was some other error?" ]

                InputToken _ _ _ (Success credentials) ->
                    div
                        [ class "bg-grey-lighter border-green text-grey-darkest border-l-2 rounded rounded-l-none p-4 mt-3 mb-3" ]
                        [ text <| "Great, you've logged in successfully! Welcome to the puzzle hunt, " ++ credentials.username ++ ". "
                        , text "You can now start "
                        , a [ routeHref PuzzleListRoute, class "no-underline text-blue" ] [ text "tackling the open puzzles" ]
                        , text " or "
                        , a [ routeHref HomeRoute, class "no-underline text-blue" ] [ text "head to your dashboard!" ]
                        ]

                _ ->
                    div [] []

        isFormHidden =
            case state of
                InputToken _ _ _ (Success _) ->
                    True

                _ ->
                    False

        onSubmitMessage =
            case state of
                InputEmail _ Loading ->
                    []

                InputEmail _ _ ->
                    [ onSubmit LoginClickedSendEmail ]

                InputToken _ _ _ Loading ->
                    []

                InputToken _ _ _ _ ->
                    [ onSubmit LoginClickedLogin ]

                _ ->
                    []
    in
    div
        [ class "px-2 md:px-8 bg-grey-lightest" ]
        [ div
            [ class "flex flex-wrap md:h-screen content-center justify-center items-center pt-16 md:pt-12" ]
            [ div
                [ class "block w-full md:w-3/4 lg:w-2/3 xl:w-1/2" ]
                [ div
                    [ class "inline-flex flex justify-center w-full" ]
                    [ div
                        [ class "flex items-center sm:text-xl justify-center sm:h-12 sm:w-10 px-5 py-3 rounded-l-lg font-black bg-green text-grey-lighter border-b-2 border-green-dark" ]
                        [ span
                            [ class "fas fa-sign-in-alt" ]
                            []
                        ]
                    , div
                        [ class "flex items-center w-full p-3 px-5 sm:h-12 rounded-r-lg text-grey-darkest sm:text-lg font-bold uppercase bg-grey-lighter border-b-2 border-grey" ]
                        [ text "User Login" ]
                    ]
                , div
                    [ class "block px-4 md:w-full my-3 bg-white rounded-lg p-6 text-base border-b-2 border-grey-light" ]
                    [ p
                        []
                        [ text "Input your email first and press  "
                        , span
                            [ class "bg-green px-2 py-1 text-xs rounded text-white" ]
                            [ text "Send Token" ]
                        , text "."
                        ]
                    , br
                        []
                        []
                    , p
                        []
                        [ text "A login code will be sent to your email. Input the code, and you're all set to login!" ]
                    , div
                        [ class "block w-full p-4 pb-1 mt-1", classList [ ( "hidden", isFormHidden ) ] ]
                        [ Html.form
                            onSubmitMessage
                            [ div ([ class "inline-flex w-full" ] ++ onSubmitMessage)
                                [ input
                                    [ class "flex-grow flex-shrink w-auto my-1 pl-3 pr-2 md:px-4 py-2 rounded-lg  outline-none text-grey-darker  rounded-r-none"
                                    , placeholder "Email"
                                    , onInput LoginChangedEmail
                                    , classList [ ( "bg-grey-lighter focus:bg-grey-lightest focus:text-grey-darkest ", isTokenDisabled ), ( "bg-grey cursor-not-allowed", not isTokenDisabled ) ]
                                    , disabled (not isTokenDisabled)
                                    , type_ "email"
                                    ]
                                    []
                                , button
                                    [ class "my-1 px-1 md:px-4 py-2 text-xs md:text-base text-white rounded rounded-l-none border-b-2 border-green-dark focus:outline-none outline-none hover:bg-green-dark "
                                    , onClick LoginClickedLogin
                                    , disabled (not isTokenDisabled)
                                    , classList [ ( "bg-green-dark", not isTokenDisabled ), ( "bg-green active:border-0", isTokenDisabled ) ]
                                    ]
                                    [ text sendTokenText ]
                                ]
                            , input
                                [ class "w-full my-1 px-3 md:px-4 py-2 rounded-lg  outline-none text-grey-darkest focus:bg-grey-lightest focus:text-grey-darkest"
                                , placeholder "Token"
                                , disabled isTokenDisabled
                                , classList [ ( "bg-grey cursor-not-allowed", isTokenDisabled ), ( "bg-grey-lighter", not isTokenDisabled ) ]
                                , onInput LoginChangedToken
                                ]
                                []
                            , div
                                [ class "flex w-full justify-center" ]
                                [ button
                                    [ class "px-3 py-2 mt-2 bg-green rounded-full border-b-4 border-green-dark w-full md:w-1/2 text-white active:border-0 outline-none focus:outline-none active:outline-none hover:bg-green-dark"
                                    , onClick LoginClickedLogin
                                    , classList [ ( "hidden", isFormHidden ) ]
                                    ]
                                    [ text loginText ]
                                ]
                            ]
                        ]
                    , messageDiv
                    ]
                ]
            ]
        ]
