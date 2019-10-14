

# Neural Decoding

> This puzzle was released on 2019-08-10, and was the Challenge puzzle for the theme *"Code"*.

It's 6:40am. Facing North, you walk through the corridor on the 6th wall.

![Imgur](https://i.imgur.com/Tr5hqm6.gif)
You tell yourself you can only do your best, and to stop berating yourself for getting lost in this library in the first place.

You turn on the computer in the middle of the room.

---

Neurons around the body are able communicate with each other to coordinate the sensory and motor functionality of the human body. The communication within and between neurons is electrochemical in nature and can be measured with a wide variety of neurophysiological recording techniques.

The ability to record neural activity has interesting implications. For example, some patients with motor paralysis may not be able to move one or more limbs of their body due to peripheral neurological causes. [However, as the brain is still active, it may be possible to extract meaning out of neural activity in the brain by recording neural activity and mapping this to an interface in the environment, such as a cursor on a computer screen or a prosthetic limb.](https://en.wikipedia.org/wiki/Brain%E2%80%93computer_interface). One difficulty with these devices, however, is how exactly meaning can be extracted out of measurements of extremely noisy neural activity.

We will consider a hypothetical scenario related to decoding noisy data into something meaningful.

---

You are given an input file, `cgmnt_input22_training_data.txt` which consists of 12 lines, each containing a sequence of 0s and 1s. Consider each line to represent the recording of a single distinct theoretical neuron with unknown tuning characteristics; 12 neurons are recorded simultaneously. The sequence of 0s and 1s represent neural spikes measured at a frequency of 1000Hz, so for example, the first 1000 digits of the second line correspond to the first 1 second of measurement of the 2nd neuron. In total, you have 240 seconds of training data for 12 simultaneously-recorded neurons.

You are also given a file of labels, `cgmnt_input22_training_labels.txt`, which contains 240 characters. Each character is one of 'U', 'R', 'D', or 'L'. These characters represent directions (up, right, down and left respectively), which the participant from which the neural data was recorded was instructed to think of during the time the neural data was recorded.

So, for example, the first character of the training labels file is 'U'. This means the first 1 second of the training data file (i.e. the first 1000 digits of each line) is the neural activity expected to correspond to thinking about upward movement, though with added noise. The next character of the labels file is 'R'. This means the next 1 second of the training data file (i.e. the next 1000 digits of each line) is the neural activity expected to corresponding to thinking about rightward movement, though with added noise.

We can use this data to try and extract underlying patterns of neural activity that correspond to the different movements up, right, down and left. These patterns might then be used to determine what direction the participant is thinking of when they are asked to think of directions themselves.

---

**Your task** is to determine the movements the patient is thinking of in your file input `cgmnt_input_22_test_data.txt` and to plot the movement of the cursor on the screen. This file is of similar format to the training data file (i.e. the same 12 neurons recorded at 1000Hz, and with 1 second corresponding to one direction of movement). Plotting the movements will spell a word.

You have also been provided with an *example* file, `cgmnt_input_22_example_data.txt`, which is an example of your task which you may use to check that you are extracting movements correctly. The example data contains 36 seconds (i.e. 36000 samples) of neural spike data. Below is a spike raster plot of the *example* data, where each of the 12 rows corresponds to the stream of 36000 measurements for each of the 12 neurons recorded simultaneously:

![Raster](https://i.imgur.com/G0ZZ8pO.png)
A successful decoding of this example data will reveal the 36 movements UUDRUDDRUURLDRLDRRUUDDRRUUDDRRUURDDL, each movement corresponding to 1 second (1000 samples) of data. Plotting this stream of cursor movements will show the following result:

![Example](https://i.imgur.com/YeJtLfI.gif)

This spells the word "HELLO" (you will need to interpret the letter-forms - they spell a meaningful word in your test data).

You must do the same for your test data, which is 44 seconds (44000 samples) long. While in practice, your training data would need to be much larger for this sort of problem, the training and test data we have provided should be sufficient to solve this puzzle.

## Input

[Click here to download your input data (4 .txt files: 422 KB, 516 KB, 3MB and 240 bytes)](https://drive.google.com/open?id=1ZGiSzuZ4_js82XwVyZA9DoUoLB_yOhJb)

## Statement

State the word traced out by the *test* data when it is decoded into a stream of cursor movements.


## References

Written by the CIGMAH Puzzle Hunt Team.

## Answer

The correct solution was `SIGNAL`.

## Explanation

### Map Hint

You wonder what the future will look like.

You open the file `map_hint.txt`. It reads:

```text
You will arrive at the dead-end room D-H on the last, 25th puzzle.
```

What's this?

### Writer's Notes

![Answer](https://i.imgur.com/y0Iu9hG.gif)

The answer movements are LDRDLRRUUDDRUURLDDRULRDRUURDDRUURDLRDRUUDDRR.

We really wanted to do a more in-depth write up about this problem, but didn't get time. We may come back to it.

Brief notes:

1. A machine learning approach for this particular problem like we took here is definitely overkill, but it's relatively simple with `tf.keras` to extract patterns when you don't know what the pattern might be. This particular pattern was very very simple (the underlying signal always occurs for each direction, and the underlying signal for each direction is completely different - the only deterrent is the noise).
2. Our generated data isn't realistic, but the general idea is similar. We didn't add all that much noise to the data (we added noise as a 33% chance for any particular bit to flip), so a very limited amount of training data was sufficient.

Example solution:

```python
import tensorflow as tf # tensorflow version 2.0.0 beta
import numpy as np
from turtle import *
from typing import List

### Read the training data
with open('cgmnt_input22_training_data.txt') as infile:
    RAW_TRAINING_DATA = infile.readlines()

with open('cgmnt_input22_training_labels.txt') as infile:
    RAW_TRAINING_LABELS = infile.read()

### Define directions classes as integers
LABELS_DICT = {
    'U': 0,
    'R': 1,
    'D': 2,
    'L': 3,
}

### Define conversion function from data text lines to numpy array in proper shape
def to_array(lines: List[str]) -> np.ndarray:
    return np.array([list(map(int, list(line.strip()))) for line in lines])\
          .transpose()\
          .reshape(-1, 1000, 12) # trials x samples x channel array

### Convert training data to arrays
ARRAY_TRAINING_DATA = to_array(RAW_TRAINING_DATA)
ARRAY_TRAINING_LABELS = tf.one_hot(np.array([LABELS_DICT[c] for c in RAW_TRAINING_LABELS]), depth=4)

### Define and fit a model
model = tf.keras.Sequential()
model.add(tf.keras.layers.Flatten(input_shape=(1000,12)))
model.add(tf.keras.layers.Dense(144, activation='relu'))
model.add(tf.keras.layers.Dense(72, activation='relu'))
model.add(tf.keras.layers.Dense(48, activation='relu'))
model.add(tf.keras.layers.Dense(4, activation='softmax'))

model.compile(loss='categorical_crossentropy', optimizer='adam', metrics=['accuracy'])
model.fit(ARRAY_TRAINING_DATA, ARRAY_TRAINING_LABELS, epochs=10, batch_size=10)

### Read the example data and process
### with open('cgmnt_input22_example_data.txt') as infile:
###     RAW_EXAMPLE_DATA = infile.readlines()
### ARRAY_EXAMPLE_DATA = to_array(RAW_EXAMPLE_DATA)
### EXAMPLE_PREDICTIONS = tf.argmax(model.predict(ARRAY_EXAMPLE_DATA), axis=1).numpy().tolist()

### Define a drawing function
STEP_SIZE = 20
def draw_predictions(predictions: List[int]) -> None:
    # Face up first
    left(90)
    for prediction in predictions:
        # Always face up
        if prediction == 0:
            forward(STEP_SIZE)
        elif prediction == 1:
            right(90)
            forward(STEP_SIZE)
            left(90)
        elif prediction == 2:
            right(180)
            forward(STEP_SIZE)
            left(180)
        else:
            left(90)
            forward(STEP_SIZE)
            right(90)
    done()

### draw_predictions(EXAMPLE_PREDICTIONS)

### Read the test data and perform the exact same as the example data
with open('cgmnt_input22_test_data.txt') as infile:
    RAW_TEST_DATA = infile.readlines()
ARRAY_TEST_DATA = to_array(RAW_TEST_DATA)
TEST_PREDICTIONS = tf.argmax(model.predict(ARRAY_TEST_DATA), axis=1).numpy().tolist()
draw_predictions(TEST_PREDICTIONS)
```

Data generation code below in J.

```j
NB. Make the training labels and write to file.
makeLabels =: ]{~240?@:##
Labels =: makeLabels 'URDL'
Labels fwrite < 'cgmnt_input22_training_labels.txt'

NB. Generate ground truth values
gen =: [: ? 12 1000 $ ]
U =: gen 2
R =: gen 2
D =: gen 2
L =: gen 2
Truth =: U;R;D;<L

NB. Create noisy training data
noisen =: 2|]+0.33>$?@:$0:
createData =: verb :'|:;|: each noisen each Truth{~''URDL''i.y'
writeData =: dyad :'(_1}.;LF,~"1;"1 ": each x) fwrite < y'


NB. Training data creation
TrainingData =: createData Labels
TrainingData writeData 'cgmnt_input22_training_data.txt'

NB. Answer data creation
Answer =: 'LDRDLRRUUDDRUURLDDRULRDRUURDDRUURDLRDRUUDDRR'
AnswerData =: createData Answer
AnswerData writeData 'cgmnt_input22_test_data.txt'

NB. Example data creation
Example =: 'UUDRUDDRUURLDRLDRRUUDDRRUUDDRRUURDDL'
ExampleData =: createData Example
ExampleData writeData 'cgmnt_input22_example_data.txt'
```

