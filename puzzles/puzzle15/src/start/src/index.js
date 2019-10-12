import './main.css';
import { Elm } from './Main.elm';
import registerServiceWorker from './registerServiceWorker';
import {Howler, Howl} from ''

var app = Elm.Main.init({
  node: document.getElementById('root')
});

var bgm = new Howl({
  src: ['bgm.mp3'],
  loop: true,
});

app.ports.sound.subscribe(function(msg) {
  if (msg == "play") {
    bgm.play()
  } else if (msg == "stop") {
    bgm.stop()
  }
})

registerServiceWorker();
