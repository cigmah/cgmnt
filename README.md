# CIGMAH Site Frontend

This is the frontend code for the CIGMAH Website.

This project is bootstrapped with [Create Elm App](https://github.com/halfzebra/create-elm-app).

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

We are using [Tailwind](https://tailwindcss.com/docs/what-is-tailwind/)
for styling.

You will need to have Node installed to build the styles.

To build the styles, navigate to the `src/Styles/` directory and run:

```
npx tailwind build custom.css -c ./config.js -o main.css
```

# Structure

Here's a simple structure hierarchy, starting from most low-level to most high-level.

```

Types
    -> Requests
        -> Handlers
            -> Views
                -> App
                    -> Main

```

Nothing should be importing anything to the right of it.
