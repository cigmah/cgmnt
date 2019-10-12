module Views.Contact exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Markdown
import RemoteData exposing (RemoteData(..), WebData)
import Types exposing (..)


faq =
    """
We will add more information to this page soon.

## What is CIGMAH?

A Coding Interest Group in Medicine and Healthcare. Mostly medical students who are interested in learning how to code. Our home website is [cigmah.github.io](https://cigmah.github.io).

## Who is CIGMAH?

The group is based at Monash University, but the Puzzle Hunt is open to anyone. The internal team is made up of three volunteers.

## What is the Puzzle Hunt?

A collection of 25 puzzles relating to coding and medicine, released at a rate of 3 puzzles per month from March to September 2019. Puzzles can be viewed by anyone; submitting answers requires registration. Anyone can register, and we use an email-based verification system.

"""


contactForm : ContactData -> Html Msg
contactForm contactData =
    Html.form [ class "contact", onSubmit (ContactMsg ClickedSend) ]
        [ input [ type_ "text", value contactData.name, placeholder "Name (optional)", onInput (ContactMsg << ChangedContactName) ] []
        , input [ type_ "email", value contactData.email, placeholder "Email (optional)", onInput (ContactMsg << ChangedContactEmail) ] []
        , input [ type_ "text", value contactData.subject, placeholder "Subject (required)", onInput (ContactMsg << ChangedContactSubject) ] []
        , textarea [ rows 5, value contactData.body, placeholder "Message (required)", onInput (ContactMsg << ChangedContactBody) ] []
        , button [] [ text "Send." ]
        ]


view : Model -> ContactData -> WebData ContactResponse -> Html Msg
view model contactData contactResponseWebData =
    let
        contactArea =
            case contactResponseWebData of
                Loading ->
                    div [] [ br [] [], text "Loading..." ]

                Success _ ->
                    div [] [ br [] [], text "Your message was successfully sent. Thank you." ]

                _ ->
                    contactForm contactData
    in
    div [] <|
        [ h1 [] [ text "FAQ" ]
        , div [ class "footnote" ]
                [ text <| "If you have any queries or concerns, please get in touch with us with the message box below."
                , br [] []
                , contactArea
                ]
            ]
            ++ Markdown.toHtml Nothing faq
