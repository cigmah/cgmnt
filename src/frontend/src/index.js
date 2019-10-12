import { Elm } from './Main.elm';
import "./Styles/highlight-paraiso.css";
import { unregister } from './registerServiceWorker';
import hljs from 'highlight.js';


unregister();

var style = document.getElementById("style")

style.setAttribute("href", "./main.css")

var storageKey = "puzzlehunt_cache"

var app = Elm.Main.init({
  node: document.getElementById('root'),
  flags: localStorage.getItem(storageKey)
});

app.ports.storeCache.subscribe(function(data) {
  if (data == "") {
    localStorage.removeItem(storageKey)
  } else {
    localStorage.setItem(storageKey, JSON.stringify(data))
  }

})

app.ports.portChangedRoute.subscribe(function() {
  setTimeout(function() {
    hljs.initHighlighting.called = false;
    hljs.initHighlighting();
        }, 1000);
})

app.ports.theme.subscribe(function(theme) {
  if (theme == "light") {
    style.setAttribute("href", "./main.css")
    document.documentElement.style.setProperty('--background', '#ffffff');
    document.documentElement.style.setProperty('--foreground', '#0f0f0f');
    document.documentElement.style.setProperty('--foreground-lesser', '#444444');
    document.documentElement.style.setProperty('--hyperlink', '#aa0000');
    document.documentElement.style.setProperty('--primary', '#bb2222');
    document.documentElement.style.setProperty('--background-code', '#f4f4f4');
  }
  else if (theme == "fun") {
    style.setAttribute("href", "./main-alt.css")
  }
  else {
    style.setAttribute("href", "./main.css")
    document.documentElement.style.setProperty('--background', '#0f0f0f');
    document.documentElement.style.setProperty('--foreground', '#bbbbbb');
    document.documentElement.style.setProperty('--foreground-lesser', '#888888');
    document.documentElement.style.setProperty('--hyperlink', '#bb4444');
    document.documentElement.style.setProperty('--primary', '#bb4444');
    document.documentElement.style.setProperty('--background-code', '#1f1f1f');

  }
})
