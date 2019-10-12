import './main.css';
import { Elm } from './Main.elm';
import {Howl, Howler} from 'howler';

var bgm = new Howl({
  src: ['./sounds/bgm.mp3'],
  loop: true,
  volume: 1.0,
});

var correct = new Howl({
  src: ['./sounds/correct.mp3'],
})

var incorrect = new Howl({
  src: ['./sounds/incorrect.mp3']
})

var tap = new Howl({
  src: ['./sounds/tap.mp3']
})

var finish = new Howl({
  src: ['./sounds/finish.mp3']
})

var app = Elm.Main.init({
  node: document.getElementById('root'),
});

app.ports.sound.subscribe(function (msg) {
  if (msg == "playBgm") {
    bgm.play();
  } else if (msg == "playCorrect") {
    correct.play();
  } else if (msg == "playIncorrect") {
    bgm.stop();
    incorrect.play();
  } else if (msg == "playTap") {
    tap.play();
  } else if (msg == "playFinish") {
    bgm.stop();
    finish.play();
  } else if (msg == "muteAll") {
    Howler.mute();
  } else if (msg == "stopBgm") {
    bgm.stop();
  }
})
