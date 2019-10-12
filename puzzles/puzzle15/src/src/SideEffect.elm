module SideEffect exposing
    ( SideEffect(..)
    , deck
    , profile
    , sideEffectList
    , toString
    )

import Animation
import Card exposing (..)
import Risk exposing (..)



-- Decks


type SideEffect
    = Anticholinergic
    | Dyslipidaemia
    | Extrapyramidal
    | Hyperprolactinaemia
    | Nms
    | PosturalHypotension
    | ProlongedQt
    | Sedation
    | Seizures
    | SexualDysfunction
    | Diabetes
    | WeightGain


sideEffectList =
    [ Anticholinergic
    , Dyslipidaemia
    , Extrapyramidal
    , Hyperprolactinaemia
    , Nms
    , PosturalHypotension
    , ProlongedQt
    , Sedation
    , Seizures
    , SexualDysfunction
    , Diabetes
    , WeightGain
    ]



-- Deck


deck : List SideEffect
deck =
    sideEffectList



-- data


profile : SideEffect -> Card -> Risk
profile sideEffect card =
    case card of
        Haloperidol ->
            case sideEffect of
                Anticholinergic ->
                    Low

                Dyslipidaemia ->
                    Low

                Extrapyramidal ->
                    High

                Hyperprolactinaemia ->
                    High

                Nms ->
                    Medium

                PosturalHypotension ->
                    Low

                ProlongedQt ->
                    Low

                Sedation ->
                    Low

                Seizures ->
                    Low

                SexualDysfunction ->
                    Medium

                Diabetes ->
                    Low

                WeightGain ->
                    Low

        Chlorpromazine ->
            case sideEffect of
                Anticholinergic ->
                    High

                Dyslipidaemia ->
                    Medium

                Extrapyramidal ->
                    Low

                Hyperprolactinaemia ->
                    Medium

                Nms ->
                    Low

                PosturalHypotension ->
                    High

                ProlongedQt ->
                    Medium

                Sedation ->
                    High

                Seizures ->
                    Low

                SexualDysfunction ->
                    High

                Diabetes ->
                    Low

                WeightGain ->
                    Medium

        Aripiprazole ->
            case sideEffect of
                Anticholinergic ->
                    Rare

                Dyslipidaemia ->
                    Rare

                Extrapyramidal ->
                    Low

                Hyperprolactinaemia ->
                    Rare

                Nms ->
                    Low

                PosturalHypotension ->
                    Low

                ProlongedQt ->
                    Low

                Sedation ->
                    Low

                Seizures ->
                    Low

                SexualDysfunction ->
                    Low

                Diabetes ->
                    Low

                WeightGain ->
                    Rare

        Clozapine ->
            case sideEffect of
                Anticholinergic ->
                    High

                Dyslipidaemia ->
                    High

                Extrapyramidal ->
                    Rare

                Hyperprolactinaemia ->
                    Rare

                Nms ->
                    Low

                PosturalHypotension ->
                    High

                ProlongedQt ->
                    Low

                Sedation ->
                    High

                Seizures ->
                    High

                SexualDysfunction ->
                    Low

                Diabetes ->
                    Medium

                WeightGain ->
                    High

        Olanzapine ->
            case sideEffect of
                Anticholinergic ->
                    Low

                Dyslipidaemia ->
                    High

                Extrapyramidal ->
                    Low

                Hyperprolactinaemia ->
                    Low

                Nms ->
                    Low

                PosturalHypotension ->
                    Low

                ProlongedQt ->
                    Low

                Sedation ->
                    Medium

                Seizures ->
                    Low

                SexualDysfunction ->
                    Low

                Diabetes ->
                    Medium

                WeightGain ->
                    High

        Quetiapine ->
            case sideEffect of
                Anticholinergic ->
                    Low

                Dyslipidaemia ->
                    Medium

                Extrapyramidal ->
                    Rare

                Hyperprolactinaemia ->
                    Rare

                Nms ->
                    Low

                PosturalHypotension ->
                    Medium

                ProlongedQt ->
                    Low

                Sedation ->
                    Medium

                Seizures ->
                    Low

                SexualDysfunction ->
                    Low

                Diabetes ->
                    Low

                WeightGain ->
                    Medium

        Risperidone ->
            case sideEffect of
                Anticholinergic ->
                    Rare

                Dyslipidaemia ->
                    Low

                Extrapyramidal ->
                    Medium

                Hyperprolactinaemia ->
                    High

                Nms ->
                    Low

                PosturalHypotension ->
                    Medium

                ProlongedQt ->
                    Low

                Sedation ->
                    Low

                Seizures ->
                    Low

                SexualDysfunction ->
                    Medium

                Diabetes ->
                    Low

                WeightGain ->
                    Medium

        Ziprasidone ->
            case sideEffect of
                Anticholinergic ->
                    Rare

                Dyslipidaemia ->
                    Rare

                Extrapyramidal ->
                    Low

                Hyperprolactinaemia ->
                    Low

                Nms ->
                    Low

                PosturalHypotension ->
                    Low

                ProlongedQt ->
                    Medium

                Sedation ->
                    Low

                Seizures ->
                    Low

                SexualDysfunction ->
                    Low

                Diabetes ->
                    Low

                WeightGain ->
                    Rare


toString : SideEffect -> String
toString sideEffect =
    case sideEffect of
        Anticholinergic ->
            "Anticholinergic Symptoms"

        Dyslipidaemia ->
            "Dyslipidaemia"

        Extrapyramidal ->
            "Extrapyramidal Symptoms"

        Hyperprolactinaemia ->
            "Hyperprolactinaemia"

        Nms ->
            "Neuroleptic Malignant Syndrome"

        PosturalHypotension ->
            "Postural Hypotension"

        ProlongedQt ->
            "ProlongedQt"

        Sedation ->
            "Sedation"

        Seizures ->
            "Lowered Seizure Threshold"

        SexualDysfunction ->
            "Sexual Dysfunction"

        Diabetes ->
            "Diabetes"

        WeightGain ->
            "Weight Gain"
