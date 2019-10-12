module Risk exposing
    ( Risk(..)
    , toClass
    , toComparable
    )


type Risk
    = Rare
    | Low
    | Medium
    | High


toComparable : Risk -> Int
toComparable risk =
    case risk of
        Rare ->
            0

        Low ->
            1

        Medium ->
            2

        High ->
            3


toClass : Risk -> String
toClass risk =
    case risk of
        Rare ->
            "rare"

        Low ->
            "low"

        Medium ->
            "medium"

        High ->
            "high"
