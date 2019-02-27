import { Elm } from './Main.elm';
import "./Styles/main.css";
import "./Styles/highlight-default.css";
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
