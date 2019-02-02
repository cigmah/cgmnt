module Page.Home exposing (Model, Msg, init, subscriptions, toSession, update, view)

import Api
import Decoders exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Html.Lazy exposing (..)
import Json.Decode as Decode exposing (Decoder)
import Json.Encode as Encode
import List
import Page.Error exposing (errorPage)
import Page.Nav exposing (navMenu)
import Page.Shared exposing (loadingState, loremIpsum, textWithLoad)
import RemoteData exposing (RemoteData(..), WebData)
import Route
import Session exposing (Session(..))
import Time exposing (millisToPosix)
import Types exposing (..)
import Utils
import Viewer exposing (Viewer)



-- MODEL


type alias Model =
    { session : Session
    , state : State
    , navActive : Bool
    }


type State
    = Static ContactData (WebData String)
    | Dashboard Viewer (WebData DashData)


type alias ContactData =
    { name : String
    , email : String
    , subject : String
    , message : String
    }


defaultContactData =
    { name = ""
    , email = ""
    , subject = ""
    , message = ""
    }


type alias DashData =
    { numSolved : Int
    , currentThemes : List ThemeData
    , nextTheme : ThemeData
    , totalPoints : Int
    }


decoderDashData =
    Decode.map4 DashData
        (Decode.oneOf [ Decode.field "num_solved" Decode.int, Decode.succeed 0 ])
        (Decode.field "current" <| Decode.list decoderThemeData)
        (Decode.field "next" decoderThemeData)
        (Decode.oneOf [ Decode.field "total" Decode.int, Decode.succeed 0 ])


init : Session -> ( Model, Cmd Msg )
init session =
    case session of
        LoggedIn _ viewer ->
            ( { state = Dashboard viewer Loading
              , session = session
              , navActive = False
              }
            , Api.get "dashboard/" (Just <| Viewer.cred viewer) ReceivedData decoderDashData
            )

        Guest _ ->
            ( { state = Static defaultContactData NotAsked
              , session = session
              , navActive = False
              }
            , Cmd.none
            )


toSession : Model -> Session
toSession model =
    model.session



-- UPDATE


type Msg
    = GotSession Session
    | ReceivedData (WebData DashData)
    | ToggledNavMenu
    | ChangedContactName String
    | ChangedContactEmail String
    | ChangedContactSubject String
    | ChangedContactMessage String
    | ClickedSendContact
    | ReceivedContact (WebData String)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( msg, model.state ) of
        ( ReceivedData response, Dashboard viewer Loading ) ->
            ( { model | state = Dashboard viewer response }, Cmd.none )

        ( ToggledNavMenu, _ ) ->
            ( { model | navActive = not model.navActive }, Cmd.none )

        ( GotSession session, _ ) ->
            ( { model | session = session }, Cmd.none )

        ( _, _ ) ->
            ( model, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Session.changes GotSession (Session.navKey model.session)



-- VIEW


navMenuLinked model body =
    div [] [ lazy3 navMenu ToggledNavMenu model.navActive (Session.viewer model.session), body ]


view : Model -> { title : String, content : Html Msg }
view model =
    { title = "Home - CIGMAH"
    , content = navMenuLinked model <| mainHero model
    }


mainHero model =
    case model.state of
        Static _ webData ->
            landingPage webData

        Dashboard viewer (Success data) ->
            dashboardPage False Nothing (Viewer.username viewer) data.numSolved data.totalPoints data.currentThemes data.nextTheme

        Dashboard viewer Loading ->
            dashboardPage True Nothing "username" 0 100 placeholderThemeList (placeholderTheme RTheme)

        Dashboard viewer (Failure e) ->
            dashboardPage True (Just "There was an error :( Let use know!") "username" 0 100 placeholderThemeList (placeholderTheme RTheme)

        _ ->
            errorPage


placeholderTheme themeSet =
    { id = 0
    , year = 2000
    , theme = String.slice 0 10 loremIpsum
    , themeSet = themeSet
    , tagline = String.slice 0 80 loremIpsum
    , openDatetime = millisToPosix 0
    , closeDatetime = millisToPosix 0
    }


placeholderThemeList =
    [ placeholderTheme RTheme, placeholderTheme MTheme, placeholderTheme STheme ]



--- VIEWS FROM HTML CONVERSION


landingPage contactResponse =
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
                        [ class "block w-full p-4", onSubmit ClickedSendContact ]
                        [ input
                            [ class "w-full my-1 mt-0 px-4 py-2 rounded-lg bg-grey-lighter outline-none text-grey-darker focus:bg-grey-lightest focus:text-grey-darker"
                            , placeholder "Name"
                            , onInput ChangedContactName
                            ]
                            []
                        , input
                            [ class "w-full my-1 px-4 py-2 rounded-lg bg-grey-lighter outline-none text-grey-darker focus:bg-grey-lightest focus:text-grey-darker"
                            , placeholder "Contact Email"
                            , type_ "email"
                            , onInput ChangedContactEmail
                            ]
                            []
                        , input
                            [ class "w-full my-1 px-4 py-2 rounded-lg bg-grey-lighter outline-none text-grey-darker focus:bg-grey-lightest focus:text-grey-darker"
                            , placeholder "Subject"
                            , onInput ChangedContactSubject
                            ]
                            []
                        , textarea
                            [ class "w-full h-24 my-1 px-4 py-2 rounded-lg bg-grey-lighter outline-none text-grey-darker focus:bg-grey-lightest focus:text-grey-darker align-top"
                            , placeholder "Your message here!"
                            , onInput ChangedContactMessage
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
        [ class "px-8 bg-grey-lightest" ]
        [ div
            [ class "flex flex-wrap h-screen content-center justify-center items-center pt-8 md:pt-0" ]
            [ div
                [ class "block sm:w-3/4 md:w-2/3 lg:w-1/2" ]
                [ div
                    [ class "inline-flex flex justify-center w-full" ]
                    [ div
                        [ class "flex items-center  sm:text-xl md:text-3xl justify-center sm:h-12 sm:w-12 md:w-16 py-3 rounded-l-lg font-black bg-red-light text-grey-lighter border-b-2 border-red" ]
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
                    [ button
                        [ class "px-3 py-2 bg-red-light rounded-full border-b-4 border-red w-full md:w-1/2 text-white active:border-0 outline-none focus:outline-none active:outline-none hover:bg-red-dark" ]
                        [ text "Register" ]
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
                            [ class "flex items-center text-xl justify-center h-12 w-12 py-3 rounded-l-lg font-black bg-teal text-grey-lighter border-b-2 border-teal-dark" ]
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
            [ class "lg:flex lg:flex-wrap h-screen content-center items-center lg:p-8" ]
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


themeCard : Bool -> ThemeData -> Html msg
themeCard isLoading theme =
    case theme.themeSet of
        RTheme ->
            div
                [ class "theme-card block mb-2" ]
                [ div
                    [ class "inline-flex w-full" ]
                    [ div
                        [ class "flex items-center justify-center px-3 py-1 w-8 md:h-8 rounded-l font-black text-grey-darkest" ]
                        [ span
                            [ class "fas fa-exclamation-circle" ]
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
                    [ textWithLoad isLoading <| String.concat [ "Ends ", Utils.posixToString theme.closeDatetime, "." ] ]
                ]

        _ ->
            div
                [ class "theme-card block mb-2" ]
                [ div
                    [ class "inline-flex w-full" ]
                    [ div
                        [ class "flex items-center justify-center px-3 py-1 w-8 md:h-8 rounded-l font-black text-grey-darkest" ]
                        [ span
                            [ class "fas fa-ellipsis-h" ]
                            []
                        ]
                    , div
                        [ class "flex items-center w-full py-1 px-2 md:h-8 rounded-tr text-grey-darkest flex-grow" ]
                        [ textWithLoad isLoading theme.theme ]
                    ]
                , div
                    [ class "px-2 pb-2 pt-0 text-sm ml-8 rounded-b text-grey-darkest" ]
                    [ textWithLoad isLoading theme.tagline ]
                ]


dashboardPage : Bool -> Maybe String -> String -> Int -> Int -> List ThemeData -> ThemeData -> Html msg
dashboardPage isLoading errorMsg username numSolved points currentThemes nextTheme =
    let
        errorDiv =
            case errorMsg of
                Just message ->
                    div
                        [ id "message-box", class "flex pin-b pin-x h-auto p-4 pb-6 fixed bg-grey-light text-grey-darkest justify-center text" ]
                        [ span
                            [ class "text-center md:w-3/4 " ]
                            [ text message ]
                        ]

                Nothing ->
                    div [] []
    in
    div
        [ class "px-8 bg-grey-lightest" ]
        [ div
            [ class "flex flex-wrap content-center justify-center items-center pb-12 pt-20" ]
            [ div
                [ class "block md:w-3/4 lg:w-2/3" ]
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
                        [ textWithLoad isLoading "Dashboard" ]
                    ]
                , div
                    [ class "block w-full my-3 bg-white rounded-lg p-6 pb-2 w-full text-base border-b-2 border-grey-light" ]
                    [ span
                        [ class "text-xl" ]
                        [ p
                            []
                            [ textWithLoad isLoading <| String.concat [ "Welcome, ", username, "." ] ]
                        ]
                    , br
                        []
                        []
                    , p
                        []
                        [ textWithLoad isLoading <| String.concat [ "You've solved ", String.fromInt numSolved, " puzzle(s) and earned ", String.fromInt points, " points." ]
                        , br
                            []
                            []
                        , br [] []
                        , p
                            []
                            [ textWithLoad isLoading "The theme(s) that are currently open are:" ]
                        , br
                            []
                            []
                        , div [] <|
                            List.map (themeCard isLoading)
                                (List.filter
                                    (\x ->
                                        if x.themeSet == RTheme then
                                            True

                                        else
                                            False
                                    )
                                    currentThemes
                                )
                        , div
                            [ class "pt-3 pb-2" ]
                            [ p
                                []
                                [ textWithLoad isLoading "We also have two ongoing themes that will be open until the end:" ]
                            ]
                        , div [] <|
                            List.map (themeCard isLoading)
                                (List.filter
                                    (\x ->
                                        if x.themeSet == RTheme then
                                            False

                                        else
                                            True
                                    )
                                    currentThemes
                                )
                        , div
                            [ class "pt-3 pb-4" ]
                            [ p
                                []
                                [ textWithLoad isLoading <| String.concat [ "The next theme, ", nextTheme.theme, " will open on ", Utils.posixToString nextTheme.openDatetime, "." ]
                                ]
                            ]
                        ]
                    ]
                , div
                    [ class "flex w-full justify-center" ]
                    [ a [ Route.href Route.OpenPuzzles, class "w-full" ]
                        [ button
                            [ class "px-3 py-2 bg-red-light rounded-full border-b-4 border-red w-full active:border-b-0 active:border-t-4  outline-none focus:outline-none active:outline-none hover:bg-red"
                            , classList [ ( "text-white", not isLoading ), ( "text-red-light", isLoading ) ]
                            ]
                            [ text "Take me to the open puzzles!" ]
                        ]
                    ]
                ]
            ]
        , errorDiv
        ]
