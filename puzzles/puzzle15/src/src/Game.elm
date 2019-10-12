module Game exposing
    ( CollectResult(..)
    , Game
    , Phase(..)
    , Player
    , PlayerId(..)
    , Players
    , Turn
    , TurnNumber(..)
    , autoPlay
    , collect
    , generator
    , nextPlayer
    , nextTurn
    , playerAtId
    , toString
    , updatePlayer
    , updateWithCollect
    )

import Card exposing (..)
import List.Extra
import Maybe.Extra
import Random exposing (Generator)
import Random.List
import Risk exposing (..)
import SideEffect exposing (..)


type alias Game =
    { round : Int
    , phase : Phase
    , lastWon : Maybe PlayerId
    , players : Players
    , sideEffectList : List SideEffect
    , inPlay : SideEffect
    }


type alias Players =
    { playerA : Player
    , playerB : Player
    , playerC : Player
    , playerD : Player
    }


type alias Player =
    { hand : List Card
    , name : String
    , tricks : Int
    , inPlay : Maybe Card
    , strategy : Strategy -- Meaningless for Player D i.e. the user, but we'll give the user one just because it's easier.
    }


type Strategy
    = Aggressive
    | Saver
    | Fool


type Phase
    = DealPhase
    | ShowEffectPhase
    | TurnPhase Turn
    | ShowRiskPhase
    | CollectPhase CollectResult


type alias Turn =
    { turnNumber : TurnNumber
    , playerId : PlayerId
    }


type PlayerId
    = A
    | B
    | C
    | D


type TurnNumber
    = T1
    | T2
    | T3
    | T4



-- Random


makePlayer : List Card -> String -> Strategy -> Player
makePlayer cards name strategy =
    { hand = cards
    , name = name
    , tricks = 0
    , inPlay = Nothing
    , strategy = strategy
    }


generator : Generator Game
generator =
    randomCards
        |> Random.map makeGame


makeGame : ( Players, List SideEffect ) -> Game
makeGame ( players, sideEffects ) =
    let
        newSideEffectMaybe =
            List.Extra.uncons sideEffects

        ( sideEffectCard, sideEffectList ) =
            case newSideEffectMaybe of
                Just ( card, rest ) ->
                    ( card, rest )

                Nothing ->
                    ( Sedation, [] )
    in
    { round = 0
    , phase = DealPhase
    , lastWon = Nothing
    , players = players
    , sideEffectList = sideEffectList
    , inPlay = sideEffectCard
    }


dummyPlayers : Players
dummyPlayers =
    { playerA = makePlayer [] "" Fool
    , playerB = makePlayer [] "" Fool
    , playerC = makePlayer [] "" Fool
    , playerD = makePlayer [] "" Fool
    }


listToPlayers : List (List Card) -> Players
listToPlayers cardListList =
    case cardListList of
        [ a, b, c, d ] ->
            { playerA = makePlayer a "Alex" Saver
            , playerB = makePlayer b "Beatrice" Aggressive
            , playerC = makePlayer c "Charles" Fool
            , playerD = makePlayer d "Diane" Saver -- strategy is meaningless for the player but is easier to work with.
            }

        _ ->
            dummyPlayers


randomCards : Generator ( Players, List SideEffect )
randomCards =
    let
        players =
            Random.List.shuffle Card.deck
                |> Random.map (List.take 32 >> List.Extra.groupsOf 8 >> listToPlayers)

        sideEffects =
            Random.List.shuffle SideEffect.deck
                |> Random.map (List.take 8)
    in
    Random.map2 Tuple.pair players sideEffects


playCard : Player -> SideEffect -> Maybe ( ( Card, Int ), List ( Card, Int ) )
playCard player sideEffect =
    let
        sorted =
            player.hand
                |> List.map (SideEffect.profile sideEffect >> Risk.toComparable)
                |> List.Extra.zip player.hand
                |> List.sortWith (\( _, a ) ( _, b ) -> compare b a)

        withStrategy =
            case player.strategy of
                Aggressive ->
                    List.drop 1 sorted ++ List.take 1 sorted

                Saver ->
                    List.drop 2 sorted ++ List.take 2 sorted

                Fool ->
                    List.reverse sorted
    in
    withStrategy
        |> List.Extra.uncons


updatePlayer : Players -> PlayerId -> ( Card, List Card ) -> Players
updatePlayer ({ playerA, playerB, playerC, playerD } as players) playerId ( card, cardList ) =
    case playerId of
        A ->
            { players
                | playerA = { playerA | hand = cardList, inPlay = Just card }
            }

        B ->
            { players
                | playerB = { playerB | hand = cardList, inPlay = Just card }
            }

        C ->
            { players
                | playerC = { playerC | hand = cardList, inPlay = Just card }
            }

        D ->
            { players
                | playerD = { playerD | hand = cardList, inPlay = Just card }
            }


playerAtId : Players -> PlayerId -> Player
playerAtId players playerId =
    case playerId of
        A ->
            players.playerA

        B ->
            players.playerB

        C ->
            players.playerC

        D ->
            players.playerD


autoPlay : Players -> PlayerId -> SideEffect -> Maybe Players
autoPlay players playerId sideEffect =
    let
        newHandMaybe =
            playCard (playerAtId players playerId) sideEffect
    in
    case newHandMaybe of
        Just ( ( card, _ ), rest ) ->
            Just <| updatePlayer players playerId ( card, List.map Tuple.first rest )

        Nothing ->
            Nothing


type CollectResult
    = One PlayerId
    | NoOne



-- Should not be nothing, since this is only called when all the cards are played


collect : Players -> SideEffect -> Maybe CollectResult
collect players sideEffect =
    let
        played =
            { a = players.playerA.inPlay
            , b = players.playerB.inPlay
            , c = players.playerC.inPlay
            , d = players.playerD.inPlay
            }
    in
    case ( ( played.a, played.b ), ( played.c, played.d ) ) of
        ( ( Just a, Just b ), ( Just c, Just d ) ) ->
            let
                sorted =
                    [ a, b, c, d ]
                        |> List.map (SideEffect.profile sideEffect >> Risk.toComparable)
                        |> List.Extra.zip [ A, B, C, D ]
                        |> List.sortWith (\( _, x ) ( _, y ) -> compare y x)

                maxVal =
                    sorted
                        |> List.head
                        |> Maybe.map Tuple.second
                        |> Maybe.withDefault 0

                numMax =
                    sorted
                        |> List.filter (Tuple.second >> (==) maxVal)
                        |> List.length
            in
            if numMax > 1 then
                Just NoOne

            else
                sorted
                    |> List.head
                    |> Maybe.map Tuple.first
                    |> Maybe.withDefault A
                    -- Shouldn't happen, sorted must have four elements
                    |> One
                    |> Just

        _ ->
            Nothing


updateWithCollect : CollectResult -> Game -> Game
updateWithCollect collectResult ({ players } as game) =
    let
        { playerA, playerB, playerC, playerD } =
            players

        newPlayers =
            { playerA = { playerA | inPlay = Nothing }
            , playerB = { playerB | inPlay = Nothing }
            , playerC = { playerC | inPlay = Nothing }
            , playerD = { playerD | inPlay = Nothing }
            }
    in
    case collectResult of
        One playerId ->
            let
                withTrick =
                    case playerId of
                        A ->
                            { newPlayers | playerA = { playerA | inPlay = Nothing, tricks = playerA.tricks + 1 } }

                        B ->
                            { newPlayers | playerB = { playerB | inPlay = Nothing, tricks = playerB.tricks + 1 } }

                        C ->
                            { newPlayers | playerC = { playerC | inPlay = Nothing, tricks = playerC.tricks + 1 } }

                        D ->
                            { newPlayers | playerD = { playerD | inPlay = Nothing, tricks = playerD.tricks + 1 } }
            in
            { game | players = withTrick }

        NoOne ->
            -- no one gets a trick
            { game | players = newPlayers }


toString : Game -> String
toString game =
    case game.phase of
        DealPhase ->
            "Welcome to Worst Offender."

        ShowEffectPhase ->
            "The offender this round is " ++ SideEffect.toString game.inPlay ++ "."

        TurnPhase turn ->
            "It is " ++ .name (playerAtId game.players turn.playerId) ++ "'s turn."

        ShowRiskPhase ->
            "Here's the results - the more red, the worse the offender."

        CollectPhase result ->
            case result of
                One playerId ->
                    .name (playerAtId game.players playerId) ++ " takes the trick."

                NoOne ->
                    "No one takes the trick."



-- Next


nextPlayer : PlayerId -> PlayerId
nextPlayer playerId =
    case playerId of
        A ->
            B

        B ->
            C

        C ->
            D

        D ->
            A


nextTurn : Turn -> Maybe Turn
nextTurn turn =
    let
        nextPlayerId =
            nextPlayer turn.playerId
    in
    case turn.turnNumber of
        T1 ->
            Just <| Turn T2 nextPlayerId

        T2 ->
            Just <| Turn T3 nextPlayerId

        T3 ->
            Just <| Turn T4 nextPlayerId

        T4 ->
            Nothing
