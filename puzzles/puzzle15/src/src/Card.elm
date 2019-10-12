module Card exposing
    ( Card(..)
    , cardList
    , deck
    , toShort
    , toString
    )


type Card
    = Haloperidol
    | Chlorpromazine
    | Aripiprazole
    | Clozapine
    | Olanzapine
    | Quetiapine
    | Risperidone
    | Ziprasidone


cardList =
    [ Haloperidol
    , Chlorpromazine
    , Aripiprazole
    , Clozapine
    , Olanzapine
    , Quetiapine
    , Risperidone
    , Ziprasidone
    ]



-- Deck


deck : List Card
deck =
    cardList
        |> List.repeat 8
        |> List.concat



-- Stringifying


toString : Card -> String
toString card =
    case card of
        Haloperidol ->
            "Haloperidol"

        Chlorpromazine ->
            "Chlorpromazine"

        Aripiprazole ->
            "Aripiprazole"

        Clozapine ->
            "Clozapine"

        Olanzapine ->
            "Olanzapine"

        Quetiapine ->
            "Quetiapine"

        Risperidone ->
            "Risperidone"

        Ziprasidone ->
            "Ziprasidone"


toShort : Card -> String
toShort card =
    case card of
        Haloperidol ->
            "HALO"

        Chlorpromazine ->
            "CHLP"

        Aripiprazole ->
            "ARIP"

        Clozapine ->
            "CLOZ"

        Olanzapine ->
            "OLNZ"

        Quetiapine ->
            "QTPN"

        Risperidone ->
            "RISP"

        Ziprasidone ->
            "ZIPR"
