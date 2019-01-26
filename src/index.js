import { Elm } from './Main.elm';
import registerServiceWorker from './registerServiceWorker';

var app = Elm.Main.init({
  node: document.getElementById('root'),
  flags: localStorage.getItem('cache')
});

registerServiceWorker();

app.ports.cache.subscribe(function(data) {
  localStorage.setItem('cache', JSON.stringify(data))
})
