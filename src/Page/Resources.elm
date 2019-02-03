module Page.Resources exposing (Model, Msg, init, subscriptions, toSession, update, view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Lazy exposing (..)
import Markdown
import Page.Nav exposing (navMenu)
import Session exposing (Session)



-- MODEL


type alias Model =
    { session : Session
    , navActive : Bool
    }


init : Session -> ( Model, Cmd Msg )
init session =
    ( { session = session, navActive = False }
    , Cmd.none
    )


toSession : Model -> Session
toSession model =
    model.session


type Msg
    = ToggledNavMenu



-- UPDATE


update msg model =
    case msg of
        ToggledNavMenu ->
            ( { model | navActive = not model.navActive }, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub ()
subscriptions model =
    Sub.none



-- VIEW


navMenuLinked model body =
    div [] [ lazy3 navMenu ToggledNavMenu model.navActive (Session.viewer model.session), body ]


view model =
    { title = "Resources"
    , content = navMenuLinked model <| mainBody
    }


mainBody =
    div
        [ class "px-2 md:px-8 bg-grey-lightest" ]
        [ div
            [ class "mb-4 flex flex-wrap content-center justify-center items-center pt-16" ]
            [ div
                [ class "block md:w-5/6 lg:w-4/5 xl:w-3/4" ]
                [ div
                    [ class "inline-flex flex justify-center w-full" ]
                    [ div
                        [ class "flex items-center  sm:text-xl justify-center  px-5 py-3 rounded-l-lg font-black bg-pink text-grey-lighter border-b-2 border-pink-dark" ]
                        [ span
                            [ class "fas fa-table" ]
                            []
                        ]
                    , div
                        [ class "flex items-center  w-full p-3 px-5 rounded-r-lg text-grey-darkest sm:text-lg font-bold uppercase bg-grey-lighter border-b-2 border-grey" ]
                        [ text "Resources" ]
                    ]
                , div
                    [ class "markdown block w-full my-3 bg-white rounded-lg p-6 w-full text-base border-b-2 border-grey-light pb-12" ]
                    ([ p
                        []
                        [ text "Here are some resources to get you started." ]
                     ]
                        ++ Markdown.toHtml Nothing content
                    )
                ]
            ]
        ]



-- CONTENT


content =
    """

# Tools

If you're just getting started, we would recommend installing Anaconda first and having a play in Jupyter (a notebook in your browser where you can run code and see the output immediately).

<br>

- [Anaconda](https://www.anaconda.com/distribution/) - a wheels-included distribution of Python which has everything you need to start using Python for data (and other!) science. Comes with [Jupyter](https://jupyter.org), an interactive notebook that lets you code and iterate quickly by running code and printing the output in your browser.
- [Atom](https://atom.io), [Visual Studio Code](https://code.visualstudio.com) etc - extensible code editors with plugins to make your life easier. If you don't mind a learning curve, try [Emacs](https://www.gnu.org/software/emacs/) or [Vim](https://www.vim.org), or combine the two with [Spacemacs](http://spacemacs.org) or [Doom Emacs](https://github.com/hlissner/doom-emacs). Emacs also comes with [org-mode](https://orgmode.org),
  a task and note management system like Workflowy with superpowers.
- [Git](https://git-scm.com) - a widely used tool for version control so you don't have to track progress by e.g. renaming your documents with a date or "v2" at the front. Often associated with [GitHub](https://github.com), an online repository to host your work and collaborate.

# Languages We Use for the CIGMAH Puzzle Hunt

We're happy to answer any questions you have about our setup, or if you're interested in learning how it came to be!

<br>

- [Python](https://www.python.org) - a popular general-purpose programming language. We use it with the web framework [Django](https://www.djangoproject.com), which provides a bunch of tools to start building a web backend in Python.
- [Elm](https://elm-lang.org) - a pure, functional language that compiles to JavaScript. We use it for the frontend (i.e. what you're seeing right now!) to handle all the interaction with our Python backend, and also handle things like click events, text inputs, rendering and navigation.

# Coding Practice

<br>

- [Advent of Code](https://adventofcode.com) - A 25-day coding challenge that runs through Christmas.
- [Project Euler](https://projecteuler.net) - A large collection of coding problems with a broad range of difficulty, often with a mathematical slant.
- [Rosalind](http://rosalind.info/problems/locations/) - A bioinformatics-focused platform for learning how to code.
- [HackerRank](https://www.hackerrank.com), [Codeforces](https://codeforces.com), [Codechef](https://www.codechef.com) etc. - programming competitions, often algorithm-focused.



"""
