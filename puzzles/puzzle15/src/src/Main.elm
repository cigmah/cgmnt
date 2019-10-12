port module Main exposing (Model(..), Msg(..), init, main, subscriptions, update, view)

import Browser
import Card exposing (..)
import Color
import Delay exposing (TimeUnit(..))
import Game exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import List.Extra
import Random
import Risk exposing (..)
import SideEffect exposing (..)
import Time
import TypedSvg exposing (..)
import TypedSvg.Attributes as SA
import TypedSvg.Core as SC
import TypedSvg.Types as ST


port sound : String -> Cmd msg



-- Model


type Model
    = Start
    | Loading
    | Playing Game
    | Success Game
    | Failure Game



-- init


init : () -> ( Model, Cmd Msg )
init _ =
    ( Start, Cmd.none )



-- Msg


type Msg
    = NoOp
    | ClickedStart
    | ClickedRestart
    | GotRandomGame Game
    | Tick
    | ClickedCard Int



-- Update


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        none =
            ( model, Cmd.none )
    in
    case model of
        Start ->
            case msg of
                ClickedStart ->
                    ( Loading, Random.generate GotRandomGame Game.generator )

                _ ->
                    none

        Loading ->
            case msg of
                GotRandomGame game ->
                    ( Playing game, sound "play" )

                _ ->
                    none

        Playing game ->
            let
                phase =
                    game.phase
            in
            case msg of
                Tick ->
                    case phase of
                        DealPhase ->
                            ( Playing { game | phase = ShowEffectPhase }, Cmd.none )

                        ShowEffectPhase ->
                            ( Playing
                                { game
                                    | phase = TurnPhase (Turn T1 (game.lastWon |> Maybe.withDefault A))
                                }
                            , Cmd.none
                            )

                        TurnPhase turn ->
                            let
                                autoPlayed =
                                    Game.autoPlay game.players turn.playerId game.inPlay

                                nextTurnMaybe =
                                    Game.nextTurn turn

                                newPhase =
                                    case nextTurnMaybe of
                                        Just newTurn ->
                                            TurnPhase newTurn

                                        Nothing ->
                                            ShowRiskPhase
                            in
                            ( Playing
                                { game
                                    | phase = newPhase
                                    , players = Maybe.withDefault game.players autoPlayed
                                }
                            , Cmd.none
                            )

                        ShowRiskPhase ->
                            let
                                collectResult =
                                    Game.collect game.players game.inPlay
                                        |> Maybe.withDefault NoOne

                                -- shouldn't happen.
                            in
                            ( Playing
                                { game
                                    | phase = CollectPhase collectResult
                                }
                            , Cmd.none
                            )

                        CollectPhase collectResult ->
                            let
                                players =
                                    game.players

                                newSideEffectCardMaybe =
                                    List.Extra.uncons game.sideEffectList

                                updatedGame =
                                    Game.updateWithCollect collectResult game

                                newGame =
                                    case collectResult of
                                        One playerId ->
                                            { updatedGame | lastWon = Just playerId }

                                        NoOne ->
                                            updatedGame
                            in
                            case newSideEffectCardMaybe of
                                Nothing ->
                                    let
                                        tricksA =
                                            newGame.players.playerA.tricks

                                        tricksB =
                                            newGame.players.playerB.tricks

                                        tricksC =
                                            newGame.players.playerC.tricks

                                        tricksD =
                                            newGame.players.playerD.tricks
                                    in
                                    if tricksD > tricksA && tricksD > tricksB && tricksD > tricksC then
                                        ( Success newGame, Cmd.none )

                                    else
                                        ( Failure newGame, Cmd.none )

                                Just ( newSideEffect, rest ) ->
                                    ( Playing
                                        { newGame
                                            | sideEffectList = rest
                                            , inPlay = newSideEffect
                                            , phase = ShowEffectPhase
                                            , round = game.round + 1
                                        }
                                    , Cmd.none
                                    )

                ClickedCard index ->
                    case game.phase of
                        TurnPhase turn ->
                            case turn.playerId of
                                D ->
                                    let
                                        ( first, tail ) =
                                            List.Extra.splitAt index game.players.playerD.hand

                                        played =
                                            List.head tail |> Maybe.withDefault Aripiprazole

                                        -- Shouldn't happen as index value depends on list length anyway
                                        newPlayers =
                                            Game.updatePlayer game.players D ( played, first ++ List.drop 1 tail )

                                        nextTurnMaybe =
                                            Game.nextTurn turn

                                        newPhase =
                                            case nextTurnMaybe of
                                                Just newTurn ->
                                                    TurnPhase newTurn

                                                Nothing ->
                                                    ShowRiskPhase
                                    in
                                    ( Playing { game | phase = newPhase, players = newPlayers }
                                    , Cmd.none
                                    )

                                _ ->
                                    none

                        _ ->
                            none

                _ ->
                    none

        Success game ->
            case msg of
                ClickedRestart ->
                    ( Start, sound "stop" )

                _ ->
                    none

        Failure game ->
            case msg of
                ClickedRestart ->
                    ( Start, sound "stop" )

                _ ->
                    none



-- Subscriptions


subscriptions : Model -> Sub Msg
subscriptions model =
    case model of
        Playing game ->
            case game.phase of
                TurnPhase turn ->
                    case turn.playerId of
                        D ->
                            Sub.none

                        _ ->
                            Time.every 1000 (\_ -> Tick)

                _ ->
                    Time.every 3000 (\_ -> Tick)

        _ ->
            Sub.none



--- View


view : Model -> Html Msg
view model =
    let
        body =
            case model of
                Start ->
                    viewStart

                Loading ->
                    div [] []

                Playing game ->
                    viewGame game

                Success game ->
                    div [ class "success end" ] [ text "Success! Submit the four letters below as your submission.", br [] [], br [] [], viewCard False "lonesome" 1 Ziprasidone, button [ onClick ClickedRestart ] [ text "Restart" ] ]

                Failure game ->
                    div [ class "failure end" ] [ text "I'm afraid you didn't win.", br [] [], br [] [], button [ onClick ClickedRestart ] [ text "Restart" ] ]
    in
    div [ class "container" ] [ body ]


viewStart : Html Msg
viewStart =
    div [ class "start-screen" ]
        [ h1 [] [ text "Worst Offender" ]
        , div [ class "intro-text" ]
            [ text "Worst Offender is a trick-taking game. "
            , br [] []
            , br [] []
            , text "Four players are each dealt a hand of 8 cards, each representing an antipsychotic. "
            , text "Every round, an adverse effect of antipsychotic medications is declared. "
            , text "Each player must then play a card in turn. "
            , br [] []
            , br [] []
            , text "Once each player has played a card, the player who played the \"worst offender\" of the declared side effect (i.e. the one which causes it most frequently) takes the trick. "
            , text "If there is a tie during a round, which is not uncommon, then no one takes the trick. "
            , text "Everyone's hands are revealed at all times. You also can see what side effect will come next at the top left of the screen; hover over it to make it more visible. You have almost complete knowledge of the game, so you can strategise accordingly."
            , text "Every game is random."
            , br [] []
            , br [] []
            , text "You play as Diane."
            , text "Your task is to collect the most tricks and win the game, without being tied with anyone else."
            , br [] []
            , br [] []
            , text "Good luck. "
            ]
        , button [ onClick ClickedStart ] [ text "Start" ]
        ]


isReveal : Game.Phase -> Bool
isReveal phaseGame =
    case phaseGame of
        ShowRiskPhase ->
            True

        CollectPhase collectResult ->
            True

        _ ->
            False


viewSideEffect : SideEffect -> Html Msg
viewSideEffect sideEffect =
    div [ class "side-effect-item" ] [ text <| SideEffect.toString sideEffect ]


viewGame : Game -> Html Msg
viewGame game =
    let
        showingRisk =
            isReveal game.phase
    in
    div [ class "board" ]
        [ div [ class "central" ]
            [ div [ class "side-effect" ] [ text <| SideEffect.toString game.inPlay ]
            , div [ class "guide" ] [ text <| Game.toString game ]
            ]
        , div [ class "players" ]
            [ div [ id "player-a", class "player-container" ] [ viewPlayer False showingRisk game.inPlay game.players.playerA ]
            , div [ id "player-b", class "player-container" ] [ viewPlayer False showingRisk game.inPlay game.players.playerB ]
            , div [ id "player-c", class "player-container" ] [ viewPlayer False showingRisk game.inPlay game.players.playerC ]
            , div [ id "player-d", class "player-container" ] [ viewPlayer True showingRisk game.inPlay game.players.playerD ]
            ]
        , div [ class "side-effect-list" ] (List.map viewSideEffect game.sideEffectList)
        ]


viewPlayer : Bool -> Bool -> SideEffect -> Player -> Html Msg
viewPlayer isUser showingRisk sideEffect player =
    div [ class "player" ] <|
        [ div [ class "in-play" ] [ viewMaybeCard player.inPlay sideEffect showingRisk ]
        , div [ class "text" ]
            [ span [ class "player-name", classList [ ( "is-user", isUser ) ] ] [ text <| player.name ++ " " ]
            , text " has "
            , span [ class "player-tricks" ] [ text <| String.fromInt player.tricks ]
            , text " trick(s)."
            ]
        , div [ class "hand" ] (List.indexedMap (viewCard isUser "") player.hand)
        ]


viewMaybeCard : Maybe Card -> SideEffect -> Bool -> Html Msg
viewMaybeCard cardMaybe sideEffect showingRisk =
    let
        cardFill =
            case cardMaybe of
                Just card ->
                    viewCard False riskClass 0 card

                Nothing ->
                    div [] []

        riskClass =
            case cardMaybe of
                Just card ->
                    case showingRisk of
                        True ->
                            card
                                |> SideEffect.profile sideEffect
                                |> Risk.toClass

                        False ->
                            ""

                Nothing ->
                    ""
    in
    div [ class "in-play-placeholder" ] [ cardFill ]


viewCard : Bool -> String -> Int -> Card -> Html Msg
viewCard isUser extraClass index card =
    let
        clickEvent =
            if isUser then
                ClickedCard index

            else
                NoOp
    in
    div
        [ class <| "card " ++ extraClass
        , Html.Attributes.attribute "data-tooltip" (Card.toString card)
        , onClick clickEvent
        , classList [ ( "pointer", isUser ) ]
        ]
        [ svg
            [ SA.width (ST.percent 100), SA.height (ST.percent 100), SA.viewBox 0 0 240 240 ]
            [ viewCardSvg card ]
        , div [ class "card-short" ] [ text <| Card.toShort card ]
        ]



-- card SVG


patternCircle : String -> Color.Color -> SC.Svg Msg
patternCircle idString color =
    TypedSvg.pattern
        [ SC.attribute "id" idString
        , SA.width <| ST.px 20
        , SA.height <| ST.px 20
        , SA.viewBox 0 0 10 10
        , SA.patternUnits <| ST.CoordinateSystemUserSpaceOnUse
        ]
        [ circle [ SA.cx (ST.px 5), SA.cy (ST.px 5), SA.r (ST.px 5), SA.fill <| ST.Fill color ] [] ]


viewCardSvg : Card -> SC.Svg Msg
viewCardSvg card =
    case card of
        Haloperidol ->
            g []
                [ patternCircle "circle-halo" (Color.rgb255 232 148 64)
                , rect
                    [ SA.x <| ST.px 60
                    , SA.y <| ST.px 40
                    , SA.width <| ST.px 120
                    , SA.height <| ST.px 20
                    , SC.attribute "fill" "url(#circle-halo)"
                    , SA.rx <| ST.px 10
                    , SA.ry <| ST.px 10
                    ]
                    []
                , circle
                    [ SA.cx <| ST.px 120
                    , SA.cy <| ST.px 140
                    , SA.r <| ST.px 60
                    , SC.attribute "fill" "url(#circle-halo)"
                    ]
                    []
                ]

        Chlorpromazine ->
            g []
                [ patternCircle "circle-chlor" (Color.rgb255 181 78 10)
                , rect
                    [ SA.x <| ST.px 100
                    , SA.y <| ST.px 30
                    , SA.width <| ST.px 40
                    , SA.height <| ST.px 180
                    , SC.attribute "fill" "url(#circle-chlor)"
                    , SA.ry <| ST.px 10
                    , SA.rx <| ST.px 10
                    ]
                    []
                , circle
                    [ SA.cx <| ST.px 120
                    , SA.cy <| ST.px 120
                    , SA.r <| ST.px 70
                    , SC.attribute "fill" "url(#circle-chlor)"
                    ]
                    []
                ]

        Aripiprazole ->
            g []
                [ patternCircle "circle-ari" (Color.rgb255 229 208 139)
                , path
                    [ SA.d "M 120,35 A 55,55 0 0 0 65,90 c 0,70 40,90 55,110 15,-20 55,-40 55,-110 A 55,55 0 0 0 120,35 Z"
                    , SC.attribute "fill" "url(#circle-ari)"
                    ]
                    []
                ]

        Clozapine ->
            g []
                [ patternCircle "circle-cloz" (Color.rgb255 183 176 121)
                , path
                    [ SA.d "M 170.24938,170.24938 c -23.43397,23.43397 -1.83485,-12.22991 -33.11574,-1.28426 -31.28089,10.94566 7.84204,25.36198 -25.09021,21.6514 -32.932254,-3.71057 8.41772,-9.05977 -19.643257,-26.69165 C 64.339195,146.29299 77.460819,185.86896 59.828938,157.80798 42.197058,129.74701 72.160513,158.74055 68.44994,125.8083 64.739366,92.876044 41.978827,127.81016 52.924484,96.529262 63.870141,65.24837 59.883986,106.75192 83.317953,83.317954 106.75192,59.883986 65.248369,63.870143 96.529262,52.924484 127.81015,41.978826 92.876044,64.739366 125.8083,68.449939 c 32.93225,3.710574 3.93871,-26.252881 31.99968,-8.621001 28.06098,17.63188 -11.51499,4.510257 6.11689,32.571234 17.63188,28.060978 22.98108,-13.288997 26.69165,19.643258 3.71058,32.93225 -10.70574,-6.19068 -21.65139,25.09021 -10.94566,31.28089 24.71822,9.68177 1.28425,33.11574 Z"
                    , SC.attribute "fill" "url(#circle-cloz)"
                    ]
                    []
                , circle
                    [ SA.cx <| ST.px 120
                    , SA.cy <| ST.px 120
                    , SA.r <| ST.px 30
                    , SA.fill <| ST.Fill <| Color.white
                    ]
                    []
                ]

        Olanzapine ->
            g []
                [ patternCircle "circle-olanz" (Color.rgb255 200 148 211)
                , path
                    [ SA.d "m 64.375,60.625 c -0.296892,0 -0.532463,0.209129 -0.596924,0.48584 C 63.760986,61.155896 63.75,61.201751 63.75,61.25 V 92.5 119.375 147.5 c 0,0.34625 0.27875,0.625 0.625,0.625 H 145 v 30.625 c 0,0.34625 0.46418,0.625 1.04126,0.625 h 29.16748 c 0.57708,0 1.04126,-0.27875 1.04126,-0.625 V 147.5 120.625 92.5 c 0,-0.34625 -0.27875,-0.625 -0.625,-0.625 H 95 V 61.25 c 0,-0.34625 -0.464176,-0.625 -1.04126,-0.625 H 81.875 Z"
                    , SC.attribute "fill" "url(#circle-olanz)"
                    ]
                    []
                ]

        Quetiapine ->
            g []
                [ patternCircle "circle-quet" (Color.rgb255 119 112 204)
                , path
                    [ SA.d "M 120 80 C 60 80 50 120 50 120 C 50 120 60 160 120 160 C 180 160 190 120 190 120 C 190 120 180 80 120 80 z "
                    , SC.attribute "fill" "url(#circle-quet)"
                    ]
                    []
                , circle [ SA.cx <| ST.px 120, SA.cy <| ST.px 120, SA.r <| ST.px 30, SA.fill <| ST.Fill <| Color.white ] []
                , circle [ SA.cx <| ST.px 120, SA.cy <| ST.px 120, SA.r <| ST.px 20, SC.attribute "fill" "url(#circle-quet)" ] []
                ]

        Risperidone ->
            g []
                [ patternCircle "circle-risp" (Color.rgb255 96 137 82)
                , path
                    [ SA.d "M 120 42.429688 A 25 25 0 0 0 95 67.429688 A 25 25 0 0 0 115 91.923828 L 115 115 L 94.974609 115 A 25 25 0 0 0 70.505859 95 A 25 25 0 0 0 45.505859 120 A 25 25 0 0 0 70.505859 145 A 25 25 0 0 0 95 125 L 115 125 L 115 145.02539 A 25 25 0 0 0 95 169.49414 A 25 25 0 0 0 120 194.49414 A 25 25 0 0 0 145 169.49414 A 25 25 0 0 0 125 145 L 125 125 L 145.53125 125 A 25 25 0 0 0 170 145 A 25 25 0 0 0 195 120 A 25 25 0 0 0 170 95 A 25 25 0 0 0 145.50586 115 L 125 115 L 125 91.898438 A 25 25 0 0 0 145 67.429688 A 25 25 0 0 0 120 42.429688 z"
                    , SC.attribute "fill" "url(#circle-risp)"
                    ]
                    []
                ]

        Ziprasidone ->
            g []
                [ patternCircle "circle-zipr" (Color.rgb255 96 147 160)
                , path
                    [ SA.d "M 70.666667,90 C 70.297333,90 70,90.446 70,91 V 109.33398 130.66602 149 c 0,0.554 0.297333,1 0.666667,1 H 109.33333 C 109.70267,150 110,149.554 110,149 v -17.33398 h 20 V 149 c 0,0.554 0.29733,1 0.66667,1 h 38.66666 C 169.70267,150 170,149.554 170,149 V 130.66602 109.33398 91 c 0,-0.554 -0.29733,-1 -0.66667,-1 H 130.66667 C 130.29733,90 130,90.446 130,91 v 17.33398 H 110 V 91 c 0,-0.554 -0.29733,-1 -0.66667,-1 z"
                    , SC.attribute "fill" "url(#circle-zipr)"
                    ]
                    []
                ]



-- Main


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }
