module Views.Register exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Html.Lazy exposing (..)
import Http exposing (Error(..))
import RemoteData exposing (RemoteData(..), WebData)
import Types exposing (..)
import Views.Shared exposing (..)


registerForm : FullUser -> Bool -> Html Msg
registerForm fullUser isLoading =
    let
        ( submitMessage, buttonText ) =
            if isLoading then
                ( [], "Loading..." )

            else
                ( [ onSubmit (RegisterMsg ClickedRegister) ], "Register." )
    in
    Html.form (class "register" :: submitMessage)
        [ input [ type_ "text", value fullUser.username, disabled isLoading, placeholder "Username (required)", onInput (RegisterMsg << ChangedRegisterUsername) ] []
        , input [ type_ "email", value fullUser.email, disabled isLoading, placeholder "Email (required)", onInput (RegisterMsg << ChangedRegisterEmail) ] []
        , input [ type_ "text", value fullUser.firstName, disabled isLoading, placeholder "First Name (optional)", onInput (RegisterMsg << ChangedFirstName) ] []
        , input [ type_ "text", value fullUser.lastName, disabled isLoading, placeholder "Last Name (optional)", onInput (RegisterMsg << ChangedLastName) ] []
        , button [ disabled isLoading ] [ text buttonText ]
        ]


view : Model -> FullUser -> WebData RegisterResponse -> Html Msg
view model fullUser registerResponseWebData =
    let
        registerFormMaybe =
            case registerResponseWebData of
                Success _ ->
                    div []
                        [ text "Your registration was successful."
                        , br [] []
                        , br [] []
                        , a [ routeHref LoginRoute ] [ text "Now you can proceed to start logging in." ]
                        ]

                Loading ->
                    registerForm fullUser True

                _ ->
                    registerForm fullUser False
    in
    div []
        [ h1 [] [ text "Register" ]
        , div [ class "footnote" ]
            [ text <| "Registration requires only a username and an email."
            , br [] []
            , br [] []
            , text <| "After registering, you can start logging in immediately. We use an email-based login system. When you attempt to login, you will automatically be sent an email to confirm your identity."
            , br [] []
            , br [] []
            , text "Your username may be visible on the Leaderboard or Prizes list. We therefore suggest not using your email as your username."
            , br [] []
            , br [] []
            , text "We never share your email. We only ever email you to send you login tokens or liaise with you if you are awarded a prize."
            ]
        , registerFormMaybe
        ]
