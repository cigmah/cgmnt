import { Elm } from './Main.elm';
import "./Styles/main.css";
import "./Styles/highlight-paraiso.css";
import { unregister } from './registerServiceWorker';
import hljs from 'highlight.js';


unregister();

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

app.ports.themeLight.subscribe(function(isLight) {
  if (isLight) {
    document.documentElement.style.setProperty('--background', '#f2f6f7');
    document.documentElement.style.setProperty('--background-inactive', '#dae0ea');
    document.documentElement.style.setProperty('--background-puzzle', '#fefefe');
    document.documentElement.style.setProperty('--foreground', '#262828');
    document.documentElement.style.setProperty('--foreground-inactive', '#75797f');
    document.documentElement.style.setProperty('--foreground-lessen', '#75797f');
    document.documentElement.style.setProperty('--colour-emphasis', '#111111');
  }
  else {
    document.documentElement.style.setProperty('--background', '#2c3030');
    document.documentElement.style.setProperty('--background-inactive', '#1d2120');
    document.documentElement.style.setProperty('--background-puzzle', '#272b2b');
    document.documentElement.style.setProperty('--foreground', '#a9adad');
    document.documentElement.style.setProperty('--foreground-inactive', '#5d6060');
    document.documentElement.style.setProperty('--foreground-lessen', '#7c8282');
    document.documentElement.style.setProperty('--colour-emphasis', '#eeeeee');

  }
})
