

# Bite Cell Scouting

> This puzzle was released on 2019-04-06, and was the Challenge puzzle for the theme *Pretty Pictures*.

It's 2:40am. Facing North, you walk through the corridor on the 5th wall.

![Imgur](https://i.imgur.com/tROiy77.gif)

Time is pressing on. You don't want to forever be known as "the late intern"....You've had nightmares of this before.

You open the book on the table. It's called *Hospital of Babel Submission Proposal: A Comprehensive Look at Bite Cell Morphology*.

Ah, haematology, your old nemesis. Bite cells...what did they indicate again?

You take a read.

> The Bite Cell Scouter is being developed by the Hospital of Babel in order to collect morphology images of bite cells on a large scale.

> The Scouter divides high-power microscopy images of blood films into `217x217` squares and identifies bounding boxes of each bite cell for later extraction and cataloguing.

> The images look like the following:

![Image](https://lh3.googleusercontent.com/AQF-tP1H7rVtT6jPL5MyejPgxxJmWi6tG7eXuM8JeI_fCPpyDxjbewN0jVmzCQnDHPXyd0yrSQsZEfCo7zJfhj026KUnCSYiq_6vW87yPhD-yMITOcUV4SkB9ZyVEFDq60Ytm0CySQ=s231-p-k)

> Your task is to implement The Scouter and determine the centre of each bounding box of each bite cell in the test dataset.

> You are provided with two folders containing 400 images each. Each image looks like this: note that the background for every image has an alpha value of 0, or is pure white if converted to RGB; you may find this useful for segmentation purposes. The only cells present in each image are normal RBCs or bite cells.

> The first directory, `input10_training/` contains 400 images of blood films under high power, cropped to a `217x217` pixels and saved as `.png` files of the form `training_XXX.png` for some three-digit ID `XXX` (e.g. `training_001.png`). This directory also contains a comma-separated-value file called `labels.csv` that contains data on bounding boxes of every cell the following format (note there is no header row):

> ```csv
> training_001.png,BITE,2,155,21,173
> training_001.png,NORMAL,66,112,86,134
> training_001.png,NORMAL,0,194,16,213
> etc.
> ```

> Each value corresponds to, in this exact order:

> 1. The filename of the image file
> 2. The classification of a bounding box (either `NORMAL` or `BITE`)
> 3. The **left** coordinate of the bounding box
> 4. The **upper** coordinate of the bounding box
> 5. The **right** coordinate of the bounding box
> 6. The **bottom** coordinate of the bounding box.

> Please note, and *this is absolutely vital*, that the coordinates of the bounding box **are relative to the upper left corner of the image**. This is why the `bottom` coordinate of the bounding box has a greater value than the `upper` coordinate of the bounding box (the upper-left corner has a y-axis value of 0, and the bottom-left corner has a y-axis value of 217). The x-axis remains as usual (i.e. the upper-left corner has a x-axis value of 0, and the upper-right corner has an x-axis value of 217). If you have any doubt, first extract the bounding box of a test image and ensure this corresponds to a red blood cell.

> The second directory, `input10_test/` contains 400 images of blood films similar to the images in the training dataset.

> Identify the bounding boxes of every bite cell in the test dataset, then find the centre of each bounding box. If you plot the centre of every bounding box for every image (with **the origin defined as upper-left, as per the images**), a numerical code will be revealed.

> For example, for the image above, the centers of the bite cells *only* would look like this:

![Image](https://lh3.googleusercontent.com/NiSh-25wHyiRzJCqhr9J1SB3gccdBEMiJdlhYQ0PAPh9tHjz0_XEj4YzLd8ISisJtSvzxBl4f8krFddk6t8FclOEDWJwG28trBpO8NbZ27GSdrAfGfKsnCRLgBhZu_6cbXfIvJL2AA=w800)

> This doesn't resemble digits at the moment, but once you collect and classify enough images, you the plotted centers should accumulate to form digits.

<br>

## Input

[cgmnt_input10/](https://drive.google.com/drive/folders/1b_4xC1liMmWA7xAXtmM3UgoDXX-lWVQ0?usp=sharing), containing

1. `input10_training/` (400 training ID-labelled 217x217 pixel PNG images and 1 bounding box data file (`labels.csv`), 5.7MB total),
2. `input10_test/` (400 test ID-labelled 217x217 pixel PNG images,  5.9MB total).

## Statement

State the numerical code revealed by plotting the bounding box centre of every bite cell in the test dataset.


## References

Written by the CIGMAH Puzzle Hunt team. We also generated the images; no external images were used in the process. The image generation process is detailed in the Writer's Notes after the puzzle is solved.

## Answer

The correct solution was `412`.

## Explanation

### Map Hint

You feel satisfied for having been able to detect and localise bite cells automatically, though you wonder what research the Hospital of Babel would do with lots of pictures of bite cells...

You open the file `map_hint.txt`. It contains the following:

```text
Key from "La Biblioteca de Babel":

    ...es analogo a un dios.
```

Puzzling indeed.

### Writer's Notes

#### Objectives

1. Introduce applications of computer vision (object detection) and machine learning in medical image interpretation.
2. Provide sample, sanitised training and test data for object detection, of reasonable similarity to medical images.

#### Context

Object detection is a useful task in many medical contexts; pathology and radiology images in particular house a huge number of components in each image, and being able to automatically detect certain components is an important element to interpretation.

We chose a small problem that we could feasibly generate data for, settling on a RBC-only "blood film" with the task of identifying a certain morphology. Although our task is relatively easy as far as object detection goes, we hope it introduces some basic principles behind.

#### Example Solution

> Note: Our example solutions are just one way of approaching our puzzles. They're not necessarily the best way, or even a good way!

Our solution makes use of easy segmentation between background and red-blood cells to find "proposed" regions for red blood cells by binary hole-filling and connected component labelling on the test image dataset. While certain object detection architectures could do this in a more general sense (e.g. RCNN, YOLO), these are more computationally expensive. Although our images are highly sanitised to allow very easy foreground-background separation, the nature of many actual blood film images means that a comparably simple foreground-background separation step may be feasible on real data (though with more sophisticated segmentation techniques).


```python
import numpy as np
import tensorflow as tf
import keras
import matplotlib.pyplot as plt
from matplotlib.colors import rgb_to_hsv
from scipy.ndimage.morphology import binary_fill_holes
from skimage.measure import label, regionprops
from pandas import read_csv
from glob import glob
from imageio import imread
```

    Using TensorFlow backend.



```python
### PREPROCESSING
traindir = "./input10_training/"
traindata = read_csv("./input10_training/labels.csv", names=["fname", "class", "left", "upper", "right", "bottom"])
trainfs = list(dict.fromkeys(traindata["fname"])) # For Python > 3.6 only! Needs to be ordered.
traingroups = [traindata[traindata["fname"] == f] for f in trainfs]
trainims = [binary_fill_holes(rgb_to_hsv(imread(traindir + f)[:,:,0:3])[:,:,2]<255) for f in trainfs]
trainbbs = [im[r.upper:r.bottom, r.left:r.right] for im, g in zip(trainims, traingroups) for i, r in g.iterrows()]
maxy, maxx = map(np.max, (traindata.bottom - traindata.upper, traindata.right - traindata.left))
trainpad = [np.pad(im, ((maxy-im.shape[0],0),(maxx-im.shape[1],0)), 'constant') for im in trainbbs]
trainlabs = [0 if r["class"] == "NORMAL" else 1 for i, r in traindata.iterrows()]

### MODEL
model = keras.Sequential([
    keras.layers.Flatten(input_shape=(maxy,maxx)),
    keras.layers.Dense(128, activation=tf.nn.relu),
    keras.layers.Dense(128, activation=tf.nn.relu),
    keras.layers.Dense(128, activation=tf.nn.relu),
    keras.layers.Dense(2, activation=tf.nn.softmax)
])
model.compile(optimizer='adam', loss='sparse_categorical_crossentropy', metrics=['accuracy'])
model.fit(np.stack(trainpad, axis=0), np.array(trainlabs), epochs=5)

### TESTING
testglob = "./input10_test/*.png"
testfs = sorted(glob(testglob))
testims = [binary_fill_holes(rgb_to_hsv(imread(f)[:,:,0:3])[:,:,2]<255) for f in testfs]
testrs = [regionprops(label(im, background=False)) for im in testims]
testbbco = [[r.bbox for r in rs if (lambda b: b[2]-b[0]<maxy and b[3]-b[1] < maxx)(r.bbox)] for rs in testrs]
testbbs = [im[b[0]:b[2], b[1]:b[3]] for im, bs in zip(testims, testbbco) for b in bs]
testpad = [np.pad(im, ((maxy-im.shape[0],0),(maxx-im.shape[1],0)), 'constant') for im in testbbs]
preds = [np.argmax(p) for p in model.predict(np.stack(testpad, axis=0))]

### BITE CENTRE PLOT
testbbcoflat = [b for bs in testbbco for b in bs]
testxs = [b[1]+(b[3]-b[1])//2 for b,c in zip(testbbcoflat,preds) if c]
testys = [b[2]+(b[2]-b[0])//2 for b,c in zip(testbbcoflat,preds) if c]

f,ax = plt.subplots(1)
ax.set_aspect("equal")
ax.scatter(testxs, testys, s=1, c="black")
ax.set_ylim((max(testys), 0))
ax.set_xlim((0, max(testxs)))
```
```text
    Epoch 1/5
    11780/11780 [==============================] - 2s 161us/step - loss: 0.1748 - acc: 0.9346
    Epoch 2/5
    11780/11780 [==============================] - 2s 156us/step - loss: 0.1114 - acc: 0.9633
    Epoch 3/5
    11780/11780 [==============================] - 2s 132us/step - loss: 0.0877 - acc: 0.9717
    Epoch 4/5
    11780/11780 [==============================] - 2s 145us/step - loss: 0.0853 - acc: 0.9721
    Epoch 5/5
    11780/11780 [==============================] - 2s 140us/step - loss: 0.0773 - acc: 0.9767
```


![png](https://lh3.googleusercontent.com/dbGv934qxMzZwakbKxrDRLNtQzyPAda5wrEDdd9e5GwY1PDpP_tLXM8ayCXSP-qf-Z5BeS6z_4kBZcYUJRLq8MANJ5wdpiJpJfnuyHrBiq8idmpTCF9DhBpQtAimLAzfvaAiLlgqhg=w800)


Here, we can see the classification accuracy is not 100% (mostly at the image edges, which is expected as these RBCs are often cut-off), but even so we can very clearly make out a three-digit number: `412`.

We've written this in a very dense style for brevity, which some may disagree with, but in the words of Arthur Whitney... "hate scrolling."

Here's a rundown of how this solution works. We were unfortunately time-poor this month with a variety of other tasks, so our discussion of this is not in any particular depth (though you can read the code to see exactly what it's doing), but as a general outline:

1. The training images are binarised by the value portion of the HSV-converted image (taking anything non-white) and holes are filled  (where the central clearing of red blood cells may be pure white if the opacity is low enough).
2. Bounding box-cropped images are extracted from all the training images and padded to the maximum bounding box size.
3. The (very simple) CNN model is trained on all the padded bounding boxes. We didn't exhaustively look for any particularly good models, just whatever was sufficient for this puzzle.
4. The test images are binarised and hole-filled as above, then connected components are labelled and filtered rudimentarily to remove anything above the maximum bbox size (we discard many labelled components where RBCs overlap here, but there remain sufficient cells for this puzzle).
5. Bounding box-cropped images for each components are extracted and classified using the model.
6. The centre of each bounding box-cropped image classified as a bite cell is extracted and plotted on a scatter plot with the origin defined as the upper-left corner (as per the specification).

Here's a few images of the binarised and cropped bounding boxes for one of the images as an example.


```python
plt.imshow(trainims[0], cmap="gray")
```





![png](https://lh3.googleusercontent.com/VVlXGJ6nqsuNUAFHiKno9VO-L4ThOrV-uH42Q1VOzIPb_vQgma82LxvNI0ThxzHrTSfhkx0IJNsW0RG16lEB8DDiPDamy1Veh14pnY2HCTqy4PYT8s-8DMuPHTC3HoXo7jUnLGmKZA=w800)



```python
plt.imshow(trainbbs[0], cmap="gray")
```


![png](https://lh3.googleusercontent.com/Uf9fFQF-VTgtdEAlPISNFtEhVeBk9ETluSKVudnkCJ4rFp4ssFcoRUnJ_u4G7A72gwD4hCK600QjOjmKkU4lqo2TuIhQtfyDBQ3j783K7dy9OSqjiq-0HDl1eCRS37nSUavj9pcGTA=w800)


And with padding:


```python
plt.imshow(trainpad[0], cmap="gray")
```




    <matplotlib.image.AxesImage at 0x7f9f62498710>




![png](https://lh3.googleusercontent.com/uSn1yP-PkSfg0wDA9muO-XLLs-inTn7zXw5QhbawZgMWJQkD4t-4z1oCjdXwzJ5uXPqHuIgqVoDwhqW78BAbRQlktUWxTwDdJ_3sCjYoOJhW8j0nOuXUZz-NNSc3Ymt0DEmN941SdQ=w800)


#### Image Generation

We were very time-pressured this month, so our code below is not optimised, nor concise, nor efficient. We hope to clean this up one day, as it mostly consists of array operations. We continuously dream of the day we can fit our code on a business card in APL...


```python
import matplotlib
import numpy as np
from matplotlib import pyplot as plt
import matplotlib.cm as cm
import itertools
import random
import PIL
import PIL.Image as Image
import PIL.ImageFilter as ImageFilter
import PIL.ImageChops as ImageChops
import PIL.ImageDraw as ImageDraw
import PIL.ImageEnhance as ImageEnhance
import math
```


```python
%matplotlib inline
```


```python
from matplotlib import patches
```


```python
imsize = 200

rrbc = imsize // 20
```


```python
def make_base():
    fig, ax = plt.subplots(figsize=(4,4))
    ax.axis("off")
    ax.patch.set_alpha(0)
    ax.set_ylim([0, imsize])
    ax.set_xlim([0, imsize])
    ax.set_axis_off()
    ax.margins(0,0)
    ax.xaxis.set_major_locator(plt.NullLocator())
    ax.yaxis.set_major_locator(plt.NullLocator())
    return fig, ax
```


```python
def rand_around(mean, std, clip_low=0, clip_high=1):
    result = np.random.normal(mean, std)
    if result < clip_low:
        return clip_low
    if result > clip_high:
        return clip_high
    return result
```

##### Solution Digits


```python
solution = np.array([
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 1, 0, 1, 0, 1, 0, 1, 1, 1],
    [0, 1, 0, 1, 0, 1, 0, 0, 0, 1],
    [0, 1, 1, 1, 0, 1, 0, 1, 1, 1],
    [0, 0, 0, 1, 0, 1, 0, 1, 0, 0],
    [0, 0, 0, 1, 0, 1, 0, 1, 1, 1],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
])

ysize, xsize = solution.shape

solution = solution.repeat(20, axis=0).repeat(20, axis=1)

ysol, xsol = np.nonzero(solution)

psol = set(zip(xsol, imsize-ysol))
```





```python
def insolution(p):
    return p in psol
```

##### RBC Function


```python
def random_sign():
    return 1 if random.random() < 0.5 else -1
```


```python
innercol = np.array(
    [0.91,
     0.49,
     0.65,
     0]
)

bodycol= np.array(
    [0.91,
     0.49,
     0.65,
     0.9
    ]
)

### Avoid collisions and cutoff rbcs
xoptions = range(rrbc, imsize, int(imsize / rrbc))
yoptions = range(rrbc, imsize, int(imsize / rrbc))

xyoptions = [(x, y) for x in xoptions for y in yoptions]

def make_rbc(propbite=0.2, checkinsolution=False):
    fig, ax = make_base()

    num_cells = random.randint(20, 40)
    bitecoords = []

    # Check solution
    # ax.imshow(solution, cmap=cm.Greys)

    xyrbcs = random.sample(xyoptions, k=num_cells)

    bboxes = []

    for i in range(num_cells):

        inner = rand_around(rrbc / 4, rrbc/16, 0.1, rrbc / 2)

        xycentre = xyrbcs[i]

        xcentre = xycentre[0] + random.randint(int(-rrbc/2), int(rrbc/2))
        ycentre = xycentre[1] + random.randint(int(-rrbc/2), int(rrbc/2))

        innercol[3] = rand_around(0.3, 0.2, 0, 0.7)

        imcontainer = np.zeros((imsize, imsize, 4))

        xdeform = rand_around(8, 3, 4, 12)
        xdscale = rand_around(1, 1.5, 0, 2.5)
        xpshift = random.uniform(0, np.pi)
        ydeform = rand_around(8, 3, 4, 12)
        ydscale = rand_around(1, 1.5, 0, 2.5)
        ypshift = random.uniform(0, np.pi)

        minx = imsize
        miny = imsize
        maxx = 0
        maxy = 0

        if checkinsolution:
            usebite = insolution((xcentre, ycentre))
        else:
            usebite = True

        if random.random() < propbite and usebite:
            isbite = True
            bitecoords.append((xcentre, ycentre))
            rbite = rand_around(rrbc * 1.5, rrbc/4, rrbc, rrbc*2)
            xbite = xcentre + rrbc * (rand_around(1, 1, 1, 1.2)) * random_sign()
            ybite = ycentre + rrbc * (rand_around(1, 1, 1, 1.2)) * random_sign()
        else:
            isbite = False

        for y in range(imsize):
            for x in range(imsize):
                dx = x - xcentre
                dy = y - ycentre

                # Simple deformation
                dx = dx + np.sin((y+xpshift) / (xdeform)) * xdscale
                dy = dy + np.sin((x+ypshift) / (ydeform)) * ydscale

                r = np.sqrt(dx ** 2 + dy ** 2)

                # Bite check
                if isbite:
                    dxbite = x-xbite
                    dybite = y-ybite
                    dbite = np.sqrt(dxbite ** 2 + dybite ** 2)
                    if dbite < rbite:
                        rimwidth = rand_around(rbite * 1/10, rbite / 30, rbite * 1/20, rbite * 1/3)
                        if rbite - dbite < rimwidth and (r < inner or r < rrbc):
                            prop = np.cbrt(abs(r + rrbc / 10 - inner) / abs(rrbc + rrbc/10 - inner)) #** (1 / 5)
                            imcontainer[y, x] = bodycol * prop + (1 - prop) * innercol
                        continue

                if r < inner:
                    imcontainer[y, x] = innercol
                elif r < rrbc:
                    prop = np.cbrt((r - inner) / (rrbc - inner))
                    imcontainer[y, x] = (prop * bodycol) + ((1-prop) * innercol)
                    if x < minx:
                        minx = x
                    elif x > maxx:
                        maxx = x
                    if y < miny:
                        miny = y
                    elif y > maxy:
                        maxy = y

        ax.imshow(imcontainer)
        bboxes.append((isbite, minx, imsize-maxy, maxx, imsize-miny))
###    Plot
###    ax.scatter([p[0] for p in  bitecoords], [p[1] for p in bitecoords], s = 0.5)
###     bboxpatches = [patches.Rectangle((b[1], b[2]), (b[3]-b[1]), (b[4]-b[2]),
###                                      facecolor = "None",
###                                      edgecolor = ("red" if b[0] else "green"))
###                    for b in bboxes]

###     [ax.add_patch(p) for p in bboxpatches]

    return fig, bboxes
```

##### Training Data


```python
save_directory = "./input10_training/"
bboxfile = "./input10_training/labels.csv"

nimages = 400

###bboxdata = []

factor = 217/200

with open(bboxfile, "a+") as outfile:
    for i in range(0, nimages):
        fig, bboxes = make_rbc(propbite = 0.5, checkinsolution=False)

        bboxes = list(map(lambda b: (b[0],
                                     math.floor(b[1]*factor),
                                     math.floor(b[2]*factor),
                                     math.floor(b[3]*factor),
                                     math.floor(b[4]*factor)),
                          bboxes))

        fname = "training_{0:03d}.png".format(i + 1)
        fig.savefig(save_directory + fname, frameon=False, pad_inches=0, bbox_inches="tight")
        plt.close()

        for b in bboxes:
            outfile.write(
                "{},{},{},{},{},{}\n".format(fname,
                                           ("BITE" if b[0] else "NORMAL"),
                                           b[1],
                                           b[2],
                                           b[3],
                                           b[4]
                                          )
            )
        print(i)
```

##### Test Data


```python
save_directory = "./input10_test/"
bboxfile = "./input10_bboxes_test.csv"

nimages = 400

bboxdata = []

factor = 217/200

with open(bboxfile, "a+") as outfile:
    for i in range(367, nimages):
        fig, bboxes = make_rbc(propbite = 0.75, checkinsolution=True)

        bboxes = list(map(lambda b: (b[0],
                                     math.floor(b[1]*factor),
                                     math.floor(b[2]*factor),
                                     math.floor(b[3]*factor),
                                     math.floor(b[4]*factor)),
                          bboxes))

        fname = "test_{0:03d}.png".format(i + 1)
        fig.savefig(save_directory + fname, frameon=False, pad_inches=0, bbox_inches="tight")
        plt.close()

        for b in bboxes:
            outfile.write(
                "{},{},{},{},{},{}\n".format(fname,
                                           ("BITE" if b[0] else "NORMAL"),
                                           b[1],
                                           b[2],
                                           b[3],
                                           b[4]
                                          )
            )
        print(i)
```

