import { Elm } from './Main.elm';
import "./Styles/main.css";
import { unregister } from './registerServiceWorker';

unregister();

if ('serviceWorker' in navigator) {
  navigator.serviceWorker.getRegistrations().then(function (registrations) {
    if (registrations.length) {
      for(let registration of registrations) {
        registration.unregister();
      }
    }
  });
}

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
