module Main exposing (main)

import Browser
import Dict
import Html exposing (Html, div, h1, img, p, text)
import Html.Attributes exposing (class)
import Time exposing (Posix)


type Party
    = W
    | I


type alias Transmission =
    { sender : Party
    , message : String
    }


broadcast : List Transmission
broadcast =
    [ Transmission I "RADIO CHECK"
    , Transmission W "I READ YOU LOUD AND CLEAR"
    , Transmission I "UH,       ON LEVEL ONE, WITNESSED CASE PRESENTING WITH   CHRONIC ENLARGEMENT     OF    LACRIMAL GLAND"
    , Transmission W "ROGER"
    , Transmission I "ON LEVEL TWO,   WITNESSED CASE PRESENTING WITH    IDIOPATHIC     INFLAMMATORY MYOPATHY"
    , Transmission W "ROGER"
    , Transmission I "ON LEVEL ONE,   WITNESSED CASE PRESENTING WITH,     UH,         ANKYLOBLEPHARON FILIFORME ADNATUM        "
    , Transmission W "         ROGER      "
    , Transmission I "ON LEVEL TWO, WITNESSED CASE PRESENTING WITH GASTROENTERITIS         DUE TO ROTAVIRUS"
    , Transmission W "ROGER "
    , Transmission I "ON LEVEL TWO, WITNESSED CASE PRESENTING WITH INFECTIOUS MENINGITIS         NOT ELSEWHERE CLASSIFIED"
    , Transmission W "ROGER"
    , Transmission I "ON LEVEL FOUR, WITNESSED CASE PRESENTING WITH   OTHER SPECIFIED      NON ORGAN SPECIFIC      SYSTEMIC AUTOIMMUNE DISORDERS,        END OF CASES      "
    , Transmission W "       ROGER        "
    ]


spacer =
    ".            .            .            .            "


toSentence : Int -> Int -> Transmission -> String
toSentence lastIndex currentIndex transmission =
    let
        ender =
            if lastIndex == currentIndex then
                "       OUT.             " ++ spacer ++ spacer

            else
                "             OVER.             " ++ spacer
    in
    case transmission.sender of
        I ->
            "WHISKEY HOTEL OSCAR,       THIS IS INDIA CHARLIE DELTA ONE ONE,      " ++ transmission.message ++ ender

        W ->
            "INDIA CHARLIE DELTA ONE ONE,      THIS IS WHISKEY HOTEL OSCAR,     " ++ transmission.message ++ ender


message : String
message =
    let
        lastIndex =
            List.length broadcast - 1

        curriedToSentence =
            toSentence lastIndex
    in
    List.indexedMap curriedToSentence broadcast
        |> List.map (String.split " ")
        |> List.concat
        |> String.join " "


messageLength : Int
messageLength =
    String.length message


scale =
    50



---- MODEL ----


type alias Model =
    { index : Maybe Int }


init : ( Model, Cmd Msg )
init =
    ( { index = Nothing }, Cmd.none )



---- UPDATE ----


type Msg
    = NoOp
    | Tick Posix


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Tick time ->
            ( { index = modBy messageLength (Time.posixToMillis time // scale) |> Just }, Cmd.none )

        NoOp ->
            ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Time.every scale Tick



---- VIEW ----


view : Model -> Html Msg
view model =
    case model.index of
        Just index ->
            let
                currentMessage =
                    String.dropRight (messageLength - index) message

                splitMessage =
                    String.split spacer currentMessage

                messageToHtml string =
                    p [] [ text string ]
            in
            div [ class "transmission" ]
                (List.map messageToHtml splitMessage)

        Nothing ->
            div [ class "connecting" ] [ p [] [ text "Connecting to broadcast..." ] ]



---- PROGRAM ----


main : Program () Model Msg
main =
    Browser.element
        { view = view
        , init = \_ -> init
        , update = update
        , subscriptions = subscriptions
        }
