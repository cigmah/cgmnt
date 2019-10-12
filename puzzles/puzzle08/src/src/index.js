import { Elm } from './Main.elm';
import {Howl} from 'howler';

var app = Elm.Main.init({
  node: document.getElementById('root')
});


var bgm = new Howl({
  src: ['./assets/tarsaltumble.mp3'],
  loop: true,
  volume: 0.8,
});

var drop = new Howl({
  src: ['./assets/drop.mp3'],
  volume: 0.8,
})

var correct = new Howl({
  src: ['./assets/correct.mp3'],
  volume: 0.8,
})

var rowClear = new Howl({
  src: ['./assets/rowClear.mp3'],
  volume: 0.8,
})

var incorrect = new Howl({
  src: ['./assets/incorrect.mp3'],
  volume: 0.8,
})

var success = new Howl({
  src: ['./assets/success.mp3'],
  volume: 0.8,
})

var failure = new Howl({
  src: ['./assets/failure.mp3'],
  volume: 0.8,
})

app.ports.playBgm.subscribe(function (play) {
  if (play) {
    bgm.play();
  }
  else {
    bgm.stop();
  }
});

app.ports.playFx.subscribe(function(fx) {

  if (fx == "drop") {
    drop.play();
  }

  else if (fx == "correct") {
    correct.play();
  }

  else if (fx == "rowClear") {
    rowClear.play();
  }

  else if (fx == "incorrect") {
    incorrect.play();
  }

  else if (fx == "success") {
    success.play();
  }

  else if (fx == "failure") {
    failure.play();
  }

})
