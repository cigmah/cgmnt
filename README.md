# CIGMAH Site Frontend

This is the frontend code for the CIGMAH Website.

This project is bootstrapped with [Create Elm App](https://github.com/halfzebra/create-elm-app).

After multiple refactors, we ended up structuring our app very similarly to
Richard Feldman's [elm-spa-example](https://github.com/rtfeldman/elm-spa-example).
The `elm-spa-example` codebase is a great reference for structuring an SPA in Elm.
When we came to our own difficulties in keeping components modular but
with some shared state, we came up with an untidier, hacked-on version of the
basic structure in Feldman's example and decided to completely rewrite from
scratch to follow it more closely.

If you would like to contribute, clone this project and change to the `develop` branch.

``` sh
git clone https://github.com/cigmah/cigmah.github.io.git cigmah.github.io
git checkout develop
```

# GitHub Pages Deployment

All development takes place on the `develop` branch.

To deploy, first merge and build the app in the `master` branch:

``` sh
git checkout master
git merge develop
elm-app build
```

Stage and commit the changes:

``` sh
git add .
git commit -m "[Commit message]"
```

Then, to deploy to GitHub pages:

``` sh
git subtree push --prefix build origin master
```

After you are done, make sure you go back to the `develop` branch to make
changes.

``` sh
git checkout develop
```

# Styling

We are using [Bulma](https://bulma.io) with SASS to set some custom variables.

To compile the custom styles, you will need to have NPM installed.

Once it is installed, you can install the required Node modules using:

``` sh
npm install
```

Then, you can run either "watch" for changes in the SASS file using:

``` sh
npm run css-watch
```

Or you can compile the styles using:

``` sh
npm run css-build
```

# Structure

Here's a simple structure hierarchy, starting from most low-level to most high-level.

```

Content
Types
    -> Msg
        -> Functions
            -> Update
            -> View
            -> Subscriptions
                -> Main

```

Nothing should be importing anything to the left of it.
