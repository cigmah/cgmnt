module Views.Home exposing (view)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Html.Lazy exposing (..)
import RemoteData exposing (RemoteData(..), WebData)
import Types exposing (..)
import Views.Shared exposing (..)


view : Meta -> HomeState -> ( String, Html Msg )
view meta homeState =
    let
        title =
            "Home - CIGMAH"

        bodyCenter =
            case ( meta.auth, homeState ) of
                ( User credentials, HomeUser userData Loading ) ->
                    div [] []

                ( User credentials, HomeUser userData (Failure e) ) ->
                    errorPage "Placeholder."

                ( User credentials, HomeUser userData (Success profileData) ) ->
                    notFoundPage

                ( Public, HomePublic contactData webData ) ->
                    landingPage contactData webData

                ( _, _ ) ->
                    notFoundPage

        body =
            div [] [ lazy2 navMenu meta.isNavActive meta.auth, bodyCenter ]
    in
    ( title, body )


landingPage contactData contactResponse =
    let
        contactBody =
            case contactResponse of
                Success str ->
                    div
                        [ class "block p-4 text-center border-green border-l-4 rounded-lg rounded-l-none bg-grey-lighter" ]
                        [ p
                            []
                            [ text "Thanks for your message!" ]
                        , br
                            []
                            []
                        , p
                            []
                            [ text "We'll be in touch as soon as we can." ]
                        ]

                _ ->
                    Html.form
                        [ class "block w-full p-4", onSubmit HomeClickedSend ]
                        [ input
                            [ class "w-full my-1 mt-0 px-4 py-2 rounded-lg bg-grey-lighter outline-none text-grey-darker focus:bg-grey-lightest focus:text-grey-darker"
                            , placeholder "Name"
                            , onInput HomeChangedName
                            ]
                            []
                        , input
                            [ class "w-full my-1 px-4 py-2 rounded-lg bg-grey-lighter outline-none text-grey-darker focus:bg-grey-lightest focus:text-grey-darker"
                            , placeholder "Contact Email"
                            , type_ "email"
                            , onInput HomeChangedEmail
                            ]
                            []
                        , input
                            [ class "w-full my-1 px-4 py-2 rounded-lg bg-grey-lighter outline-none text-grey-darker focus:bg-grey-lightest focus:text-grey-darker"
                            , placeholder "Subject"
                            , onInput HomeChangedSubject
                            ]
                            []
                        , textarea
                            [ class "w-full h-24 my-1 px-4 py-2 rounded-lg bg-grey-lighter outline-none text-grey-darker focus:bg-grey-lightest focus:text-grey-darker align-top"
                            , placeholder "Your message here!"
                            , onInput HomeChangedBody
                            ]
                            []
                        , div
                            [ class "flex w-full justify-center my-1" ]
                            [ button
                                [ class "px-3 py-2 bg-grey-light rounded-full border-b-2 border-grey w-full text-grey-darkest active:border-0 outline-none focus:outline-none active:outline-none hover:bg-grey hover:border-grey-dark" ]
                                [ text "Send" ]
                            ]
                        ]

        errorDiv =
            case contactResponse of
                Failure _ ->
                    div
                        [ id "message-box", class "flex pin-b pin-x h-auto p-4 pb-6 fixed bg-grey-light text-grey-darkest justify-center text" ]
                        [ span
                            [ class "text-center md:w-3/4 " ]
                            [ text "Hmm, it looks like there was an error. Let us know!" ]
                        ]

                _ ->
                    div [] []
    in
    div
        [ class "px-3 md:px-8 bg-grey-lightest " ]
        [ div
            [ class "flex flex-wrap lg:h-screen content-center justify-center items-center pt-16 lg:pt-0" ]
            [ div
                [ class "block sm:w-3/4 md:w-2/3 lg:w-1/2" ]
                [ div
                    [ class "inline-flex flex justify-center w-full" ]
                    [ div
                        [ class "flex items-center sm:text-2xl md:text-3xl justify-center  w-16  md:h-12 md:w-16 py-3 rounded-l-lg font-black bg-red-light text-grey-lighter border-b-2 border-red" ]
                        [ span
                            [ class "fas fa-code" ]
                            []
                        ]
                    , div
                        [ class "flex items-center  w-full p-3 px-5 sm:h-12 rounded-r-lg text-grey-darkest sm:text-lg md:text-2xl lg:text-2xl font-bold uppercase bg-grey-lighter border-b-2 border-grey" ]
                        [ text "CIGMAH Puzzle Hunt 2019" ]
                    ]
                , div
                    [ class "block w-full my-3 bg-white rounded-lg p-6 w-full text-base border-b-2 border-grey-light" ]
                    [ p
                        []
                        [ text "The Coding Interest Group in Medicine and Healthcare is running a free puzzle hunt for biomedical and medical students interested in learning how to program." ]
                    , br
                        []
                        []
                    , p
                        []
                        [ text "We'll post three puzzles every month merging medicine (both bench and clinical!) and computer science from March to September." ]
                    , br
                        []
                        []
                    , p
                        []
                        [ text "We'll also link to interactive Jupyter notebooks to help beginners go step-by-step through one puzzle a month in Python as a fill-in-the-blank style tutorial." ]
                    , br
                        []
                        []
                    , p
                        []
                        [ text "Every month, we offer the fastest solver a $25 gift card or a $50 donation on their behalf to a nominated charity. At the end of September, the participant with the most total points will also win a prize!" ]
                    ]
                , div
                    [ class "flex w-full justify-center" ]
                    [ a [ routeHref RegisterRoute, class "px-3 py-2 bg-red-light rounded-full border-b-4 border-red w-full lg:w-1/2 text-white text-center no-underline  active:border-0 outline-none focus:outline-none active:outline-none hover:bg-red-dark" ]
                        [ text "Register"
                        ]
                    ]
                ]
            ]
        , div
            [ class "lg:flex lg:flex-wrap items-center mb-4 lg:p-8" ]
            [ div
                [ class "lg:inline-flex lg:flex-row-reverse justify-apart w-full pt-8 mb-4 md:px-8 lg:px-0" ]
                [ div
                    [ class "flex self-center flex-none lg:w-1/2 justify-center p-8 " ]
                    [ img
                        [ class "resize", src "http://placekitten.com/200/200" ]
                        []
                    ]
                , div
                    [ class "block mt-6 lg:mt-0 lg:w-1/2 lg:ml-4" ]
                    [ div
                        [ class "inline-flex flex justify-center w-full" ]
                        [ div
                            [ class "flex items-center text-xl justify-center h-12 w-12 py-3 rounded-l-lg font-black bg-yellow text-grey-lighter border-b-2 border-yellow-dark" ]
                            [ span
                                [ class "fas fa-info-circle" ]
                                []
                            ]
                        , div
                            [ class "flex items-center w-full p-3 px-5 h-12 rounded-r-lg text-grey-darkest text-lg bg-grey-lighter border-b-2 border-grey-light mb-2" ]
                            [ text "About CIGMAH" ]
                        ]
                    , div
                        [ class "w-full p-6 bg-white border-b-2 border-grey-light rounded-lg text-base" ]
                        [ p
                            []
                            [ text "CIGMAH is a coding interest group mostly made up of pre-medical and medical students. We're all trying to pick up some extra skills to help us as future doctors." ]
                        , br
                            []
                            []
                        , p
                            []
                            [ text "We often get the question 'Shouldn't medical students just focus on learning medicine?' We believe there's no harm in learning a few more things, and that learning principles of coding can help develop logical, systematic thinking - a useful skill for any doctor." ]
                        , br
                            []
                            []
                        , p
                            []
                            [ text "This year, we are running and encouraging participation in a puzzle hunt to help beginners learn, and to help experienced coders practise." ]
                        , br
                            []
                            []
                        , p
                            []
                            [ text "The puzzle hunt is, at the moment, managed by two volunteers. Our frontend is built in Elm and styled with Tailwind CSS, and our backend is built in Python with Django. We are believers in free and open source software." ]
                        , br
                            []
                            []
                        , p
                            []
                            [ text "Our puzzle writers include volunteers from amongst the medical community who have experience working with or developing code." ]
                        , br
                            []
                            []
                        ]
                    ]
                ]
            ]
        , div
            [ class "lg:flex lg:flex-wrap lg:h-screen content-center items-center lg:p-8 pb-16 lg:pb-8" ]
            [ div
                [ class "lg:inline-flex justify-apart w-full pt-8 mb-4 md:px-8 lg:px-0" ]
                [ div
                    [ class "flex self-center flex-none lg:w-1/2 justify-center p-8 " ]
                    [ img
                        [ class "resize", src "http://placekitten.com/200/200" ]
                        []
                    ]
                , div
                    [ class "block mt-6 lg:mt-0 lg:w-1/2 lg:ml-8" ]
                    [ div
                        [ class "inline-flex flex justify-center w-full" ]
                        [ div
                            [ class "flex items-center text-xl  justify-center h-12 w-12 py-3 rounded-l-lg font-black bg-green text-grey-lighter border-b-2 border-green-dark" ]
                            [ span
                                [ class "fas fa-envelope" ]
                                []
                            ]
                        , div
                            [ class "flex items-center w-full p-3 px-5 h-12 rounded-r-lg text-grey-darkest text-lg bg-grey-lighter border-b-2 border-grey-light mb-2" ]
                            [ text "Contact Us" ]
                        ]
                    , div
                        [ class "w-full p-6 bg-white border-b-2 border-grey-light rounded-lg text-base" ]
                        [ p
                            []
                            [ text "Interested in knowing more? Want to help? Don't know where to start?" ]
                        , br
                            []
                            []
                        , p
                            []
                            [ text "We'd love to get in touch. Our email is:" ]
                        , div
                            [ class "text-center my-3" ]
                            [ a
                                [ class "text-blue no-underline", href "mailto:cigmah.contact@gmail.com" ]
                                [ text "cigmah.contact@gmail.com" ]
                            ]
                        , p
                            []
                            [ text "or just use the form below and we'll reply as soon as we can!" ]
                        , br
                            []
                            []
                        , contactBody
                        ]
                    ]
                ]
            ]
        , errorDiv
        ]
