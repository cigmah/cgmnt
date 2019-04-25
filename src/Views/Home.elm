module Views.Home exposing (view)

import Browser
import Handlers
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Html.Lazy exposing (..)
import RemoteData exposing (RemoteData(..), WebData)
import Time
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
                    dashboardPage
                        True
                        "Lorem"
                        defaultProfileData

                ( User credentials, HomeUser userData (Failure e) ) ->
                    errorPage "Placeholder."

                ( User credentials, HomeUser userData (Success profileData) ) ->
                    dashboardPage
                        False
                        credentials.username
                        profileData

                ( Public, HomePublic contactData webData ) ->
                    landingPage contactData webData

                ( _, _ ) ->
                    notFoundPage

        body =
            div [] [ bodyCenter ]
    in
    ( title, body )


defaultProfileData =
    { submissions = []
    , numSolved = 0
    , points = 0
    }


themeCard : Bool -> ThemeData -> Html Msg
themeCard isLoading theme =
    div
        [ class "theme-card block mb-2" ]
        [ div
            [ class "inline-flex w-full" ]
            [ div
                [ class "flex items-center justify-center px-3 py-1 w-8 md:h-8 rounded-l font-black text-grey-darkest" ]
                [ span
                    [ class "fas fa-arrow-right", classList [ ( "rounded text-grey-light bg-grey-light px-1", isLoading ) ] ]
                    []
                ]
            , div
                [ class "flex items-center w-full py-1 px-2 md:h-8 rounded-tr text-grey-darkest flex-grow" ]
                [ textWithLoad isLoading theme.theme ]
            ]
        , div
            [ class "px-2 pb-2 pt-0 text-sm ml-8 rounded-b text-grey-darkest" ]
            [ textWithLoad isLoading theme.tagline ]
        , div
            [ class "px-2 pb-2 pt-0 text-xs ml-8 rounded-b text-grey-dark" ]
            [ textWithLoad isLoading <| String.concat [ "Opens ", Handlers.posixToString theme.openDatetime, " AEDT (GMT+11)." ] ]
        ]


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
                    let
                        buttonString =
                            case contactResponse of
                                Loading ->
                                    "Sending..."

                                _ ->
                                    "Send"
                    in
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
                                [ class "px-3 py-2 bg-grey-light mt-2 rounded-lg border-b-2 border-grey w-full text-grey-darkest active:border-0 outline-none focus:outline-none active:outline-none hover:mt-0 hover:border-b-4" ]
                                [ text buttonString ]
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
                [ class "block sm:w-4/5 md:w-3/4 lg:w-2/3" ]
                [ div
                    [ class "inline-flex flex justify-center w-full" ]
                    [ div
                        [ class "flex sm:text-2xl md:text-3xl w-12 h-12 md:h-16 md:w-16 rounded-l-lg font-black bg-red-light text-grey-lighter " ]
                        [ img [ class "resize w-12 h-12 md:w-16 md:h-16 ", src "icon.png" ] []
                        ]
                    , div
                        [ class "flex items-center  w-full p-3 sm:h-12 md:h-16 px-5 flex-grow rounded-r-lg text-grey-darkest sm:text-lg md:text-2xl lg:text-2xl font-bold uppercase bg-grey-lighter border-b-2 border-grey" ]
                        [ text "CIGMAH Puzzle Hunt 2019" ]
                    ]
                , div
                    [ class "block w-full my-3 bg-white rounded-lg p-6 w-full text-base border-b-2 border-grey-light" ]
                    [ p
                        []
                        [ text "The ", a [ href "https://cigmah.github.io" ] [ text "Coding Interest Group in Medicine and Healthcare" ], text " is running a free puzzle hunt for biomedical and medical students interested in learning how to program." ]
                    , br
                        []
                        []
                    , p
                        []
                        [ text "We post three puzzles on the first or second Saturday of each month merging medicine (both bench and clinical!) and computer science from March to September." ]
                    , br [] []
                    , p [] [ text "Puzzles come in Abstract, Beginner and Challenge flavours, so there's something for everyone regardless of prior coding experience." ]
                    , br
                        []
                        []
                    , p
                        []
                        [ text "Our Beginner puzzles come with Jupyter notebooks to help beginners go step-by-step through one puzzle a month in Python as a fill-in-the-blank style tutorial. " ]
                    , br
                        []
                        []
                    , p
                        []
                        [ text "The puzzle hunt runs from March 9th to September 30th. We award prizes to the fastest solver of each puzzle, and four total prizes at the end of the puzzle hunt." ]
                    , br [] []
                    , p [] [ text "If you'd like regular updates, please join our ", a [ href "http://facebook.com/groups/cigmah/" ] [ text "Facebook group" ], text "." ]
                    ]
                , div
                    [ class "flex w-full justify-center" ]
                    [ a [ routeHref RegisterRoute, class "px-3 pb-2 pt-2 mt-2 bg-red rounded-lg border-b-2 border-red-dark w-full lg:w-1/2 text-white text-center no-underline  active:border-0 outline-none focus:outline-none active:outline-none hover:border-b-4 hover:mt-0 " ]
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
                        [ class "resize w-64 h-64", src "https://lh3.googleusercontent.com/Dsc5AZdfMxBMXgKl9BGIRFCiquLJgnRq72wyb-Z_z-Ngjce7v8BbdIQLS1-ViNLCqApwCtvKZKshSSKmMtQBNHPzcUVfnJTRK02YIKjwJG3PyTzT9jTHkxqMbnmVraBRGOsWtbmCeA=w800" ]
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
                            [ text "CIGMAH is a coding interest group at Monash University mostly made up of pre-medical and medical students. We're all trying to pick up some extra skills to help us as future doctors." ]
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
                        [ class "resize", src "https://lh3.googleusercontent.com/QvjwSUr9VHS99cMlvOa6R88uhknEfq4i9iYXZmBfDNL64MJXJP9BpN0Gy1JpfK1Uj3jnGmAR5LTDGUC2lnTVaK7SRZii7BT_TEZtmnFcxzMS45gw8R0Y8NHQTqfnJ9-NRsyRBp1a=w800" ]
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


miniPuzzleBadge : String -> Html Msg
miniPuzzleBadge imageLink =
    div [ class "flex p-2 w-16 h-16" ]
        [ div [ class "block rounded-lg w-full h-full bg-grey-lighter" ]
            [ img [ class "resize overflow-hidden", src imageLink ] []
            ]
        ]


submissionsTable : List SubmissionData -> Html Msg
submissionsTable data =
    tableMaker [ "Puzzle", "Time", "Submission", "Correct", "Points" ] data


tableRowExtended isHeader strList =
    let
        classes =
            if isHeader then
                "w-full bg-grey-light text-sm text-grey-darker"

            else
                "w-full bg-grey-lightest text-center hover:bg-grey-lighter text-grey-darkest"
    in
    tr [ class classes ] <| List.map2 (\x y -> tableCell x y isHeader) (List.repeat 5 "w-auto") strList


tableMaker : List String -> List SubmissionData -> Html Msg
tableMaker headerList unitList =
    let
        isCorrectString a =
            if a then
                "✓"

            else
                "x"
    in
    div
        [ id "table-block", class "block py-2" ]
        [ table
            [ class "w-full" ]
          <|
            tableRowExtended True headerList
                :: List.map (\x -> tableRowExtended False [ x.puzzle.title, Handlers.posixToString x.submissionDatetime, x.submission, isCorrectString x.isResponseCorrect, String.fromInt x.points ]) unitList
        ]


dashboardPage : Bool -> String -> ProfileData -> Html Msg
dashboardPage isLoading username profileData =
    let
        numSolved =
            profileData.numSolved

        points =
            profileData.points

        submissions =
            profileData.submissions

        startMessage =
            case ( numSolved, points ) of
                ( 0, 0 ) ->
                    "We're stoked that you're here! Start solving puzzles on the puzzle tab and add some new knowledge to your toolkit :)"

                ( 1, 0 ) ->
                    "Amazing stuff! You've solved one puzzle - keep it up! No points yet, but you know what they say - it's not about the points, it's about the journey. Or something like that."

                ( 1, _ ) ->
                    "Woohoo! You've solved one puzzle now - and even earned " ++ String.fromInt points ++ " points! "

                ( _, _ ) ->
                    "Brilliant work! You've solved " ++ String.fromInt numSolved ++ " puzzles and earned " ++ String.fromInt points ++ " points!"

        submissionsDiv =
            case List.length submissions of
                0 ->
                    div [] []

                _ ->
                    div [ class "m-1" ]
                        [ text "Here are your most recent submissions:"
                        , submissionsTable submissions
                        ]
    in
    div
        [ class "px-2 bg-grey-lightest" ]
        [ div
            [ class "flex flex-wrap content-center justify-center items-center pb-12 pt-16" ]
            [ div
                [ class "block w-full md:w-5/6 lg:w-4/5" ]
                [ div
                    [ class "inline-flex flex justify-center w-full" ]
                    [ div
                        [ class "flex items-center  sm:text-xl justify-center  px-5 py-3 rounded-l-lg font-black bg-red-light text-grey-lighter border-b-2 border-red" ]
                        [ span
                            [ classList [ ( "fas fa-chart-line", not isLoading ) ] ]
                            []
                        ]
                    , div
                        [ class "flex items-center w-full p-3 px-5 rounded-r-lg text-grey-darkest sm:text-lg font-bold uppercase bg-grey-lighter border-b-2 border-grey" ]
                        [ textWithLoad isLoading "Home" ]
                    ]
                , div
                    [ class "block w-full my-3 bg-white rounded-lg p-6 pb-2 w-full text-base border-b-2 border-grey-light" ]
                    [ span
                        [ class "text-xl" ]
                        [ p
                            []
                            [ textWithLoad isLoading <| String.concat [ "Welcome, ", username, "!" ] ]
                        ]
                    , br
                        []
                        []
                    , p
                        []
                        [ textWithLoad isLoading startMessage ]
                    , br
                        []
                        []
                    , br [] []
                    , p
                        []
                        [ textWithLoad isLoading "The next theme that'll open is:" ]
                    , br [] []
                    , br [] []

                    --                    , div
                    --                        [ class "flex w-full justify-center" ]
                    --                        [ a [ routeHref PuzzleListRoute, class "w-full md:w-1/2 lg:w-1/3" ]
                    --                            [ button
                    --                                [ class "px-3 py-2 bg-red-light rounded-full border-b-4 border-red w-full active:border-b-0 active:border-t-4  outline-none focus:outline-none active:outline-none hover:bg-red"
                    --                                , classList [ ( "text-white", not isLoading ), ( "text-red-light", isLoading ) ]
                    --                                ]
                    --                                [ text "Take me to the open puzzles!" ]
                    --                            ]
                    --                        ]
                    , br [] []
                    , submissionsDiv
                    ]
                ]
            ]
        ]
