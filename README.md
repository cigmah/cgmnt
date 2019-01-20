# CIGMAH Site Frontend

This is the frontend code for the CIGMAH Website.

This project is bootstrapped with [Create Elm App](https://github.com/halfzebra/create-elm-app).

# GitHub Pages Deployment

Development takes place on the `develop` branch.

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
