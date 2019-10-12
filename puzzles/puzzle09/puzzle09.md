

# Fundal Flow

> This puzzle was released on 2019-04-06, and was the Beginner puzzle for the theme *Pretty Pictures*. 

It's 2:20am. Facing North, you walk through the corridor on the 6th wall.

![Imgur](https://i.imgur.com/dd0Fxxd.gif)

You wonder how this library came to be. Or what the *Hospital of Babel* does with all these medically-related books.

The book on the table is entitled *A Fundal Atlas: Central Retinal Artery Occlusion (CRAO)*.

Like clockwork, the phrase "cherry red macula" pops into your head. Though you remember that buzzword, you remember precious little else to do with CRAO.

You flip through the book. There's an introductory paragraph, followed by a gazillion images of fundi. 

> This book contains 2000 images. The first 1000 consist of 500 labelled images of normal fundi contrasted with 500 labelled images of fundi from patients with a severe central retinal artery occlusion (CRAO). We leave the remaining 1000 images as an exercise to the budding ophthalmologist to practise their fundal interpretation skills. One can never have too much fun with fundi interpretation. 

You can almost hear the author chuckling. Or maybe they were entirely serious. You've never understood ophthalmologists...

You open the book on the computer. 

<br>

> Your task in this puzzle is to write a program that will classify images of fundi as either "normal" or "CRAO" with reasonable accuracy. 

> Your puzzle input consists of two folders containing 1000 images each. All images are `.png` files with dimensions `75x75` pixels. 

> The first folder, `input09_training/` contains 1000 ground-truth images: 500 normal fundi and 500 fundi suggesting CRAO. Each image file is of the form `XXXX_normal.png` or `XXXX_crao.png` for some ID `XXXX` (e.g. `0001_normal.png`).  

> This is a normal fundus:

![Normal](https://lh3.googleusercontent.com/daVg5cRKjxz7pnm525yiaoD_pL4By0hIGi6hU1M91lmHUA-0brGyCgGKVIv-INjFFr5Jn6yHy6OLwGaLxKLP2KR7-ciGzvNsWSYtlESDh270sXxAVcQLm3M_kmUrKhSpYL9-HGcBXA=s198-p-k)

> This fundus is suggestive of a CRAO:

![CRAO](https://lh3.googleusercontent.com/YysI3HZycEtwEQU5Zkq-l9iQhhxTGmuuE-3OIurVo6aerW8o4uofXiMPQilx4wTGMQFawr2E2YpS9vhgPR1gUJpkHhg64A6r4_r2X-QTx_XoKpRCqK84tIs12hC8kc8C8Sy-0BqO3g=s198-p-k)

> Each ID is unique. You may use this training data to train a classifier to distinguish between normal and CRAO fundi. 

>  The second folder, `input10_test/` contains 1000 images for classification. Each image is of the form `XXXX_Y.png` for some ID `XXXX` and for some alphabet character `Y` (e.g. `0001_Z.png`). 

> Identify all the images in the second folder `input10_test` which suggest CRAO. Once you have identified all these images and put them in order of their ID, the resulting characters will spell out a short riddle for you to solve.

<br>

# Input

[cgmnt_input09/](https://drive.google.com/drive/folders/1w2fptmKRlkYdQf5D5yCbCWuEU56qOGLM?usp=sharing), containing:

1. `input09_training/` (1000 class-labelled 75x75 pixel PNG images, 9.1MB total)
2. `input09_test/` (1000 letter-labelled 75x75 pixel PNG images, 8.8MB total)

Templates on [Binder](https://mybinder.org/v2/gh/cigmah/cgmnt-beginners/master), [Azure Notebooks](https://notebooks.azure.com/cigmah-cgmnt/projects/cgmnt) and [GitHub](https://github.com/cigmah/cgmnt-beginners/).

# Statement

State the answer to the riddle formed by the CRAO images in `input10_test/`.


# References

Written by the CIGMAH Puzzle Hunt team. We also generated the images; no external images were used in the process. Details of the image generation are revealed in the Writer's Notes after the puzzle is solved.

# Answer

The correct solution was `RB`.

# Explanation

# Map Hint

You pat yourself on the back for having outwitted this fundal atlas. If only it were so easy in real life...

You open the file `map_hint.txt`. It contains the following:

```text
Key from "La Biblioteca de Babel":
    
    En algun anaquel de algun...
```

You wonder what this could mean.

# Writer's Notes

## Objectives

1. Introduce applications of computer vision (image classification) and machine learning in medical image interpretation.
2. Provide sample, sanitised training and test data for image classification, of reasonable similarity to medical images.

## Context

We were very keen to write a basic image classification puzzle as it was one of the most prominent applications of machine learning/artifical intelligence in clinical medicine. Images are particularly central to specialties such as radiology, pathology, ophthalmology and dermatology - so much so, that there have been growing claims and fears that machines could dramatically alter (or even replace) the work of doctors in these specialties. The future of image classification tasks in medicine is unclear at this point, but the use of computer interpretation is certainly becoming more and more widespread (though clearly on a much more complex scale than we have indicated in this puzzle). 

We chose to generate fundi as an example, and chose to make the problem one of classifying between "normal" fundi and fundi showing typical signs of a severe central retinal artery occlusion (CRAO). We greatly exaggerated the appearance of the pathological fundi slightly to make this task suitable for beginners, but took into account two often-repeated phrases when discussing fundi in CRAO - "cherry red macula" and "pale retina."

We spent a *lot* of time trying to get our generated fundi to look semi-realistic (mostly on vessel paths and branching). We have a principle of minimising our use of external data in CIGMAH, and this was no exception; we wanted to generate all of our images automatically and *without* using any "base" clinical images - i.e. all our images were to be generated *de novo*. Fundi were something we felt were feasible to simulate with array operations, geometry and filters, and indeed we were able to come up with a simple fundi generator using `matplotlib` and `PIL` - no clinical images needed. Although this means models won't generalise to real clinical datasets (which are much messier), it does mean we can have participants undergo the whole image-to-model training and classification process and achieve very good results, even with a completely naive network. The model may be different, but the principles are similar.

## Example Solution

> Note: Our example solutions are just one way of approaching our puzzles. They're not necessarily the best way, or even a good way!

Here's an example of a solution using Tensorflow. Using convolutional neural networks (CNNs) for this problem is definitely overkill, but Tensorflow makes this so *criminally* easy for simple cases like this one, and reasonably performant for even personal laptops on a CPU, that our example solution uses a CNN anyway. 

Our example solution is about 22 lines of Python (excluding imports, but including all preprocessing and intepretation steps) and trains a very simple CNN to classify the images. We have written it in a fairly dense format, which some may disagree with, but in the spirit of APL/J/K......

> As an aside: if not a CNN, then what? The images of this puzzle are sanitised enough that performing some simpler machine learning methods (e.g. K-nearest neighbours, support vector machines, or even a logistic regression) on some very simple image statistics (for this particular puzzle, perhaps on a combination of some aggregate of HSV values) may work. We haven't tried these, and they're certainly not as generalisable, but if you would like to explore or compare machine learning methods, we leave these as an exercise to the reader :) 

First we import modules (note you will need to have these installed, either through `pip` or `conda`):


```python
import re
import numpy as np
import keras
import tensorflow as tf
from glob import glob
from pandas import DataFrame as DF
from imageio import imread
```

    Using TensorFlow backend.


And our solution:


```python
# PREPROCESSING
trainglob = "./input09_training/*.png"
trainfs = sorted(glob(trainglob))
renm = re.compile(r".*?(\d+)_(\w+).png")
trainlabs = DF.from_records([{k: renm.match(f)[i] for k,i in zip(["id", "class"], [1,2])} for f in trainfs])
trainlabs["class"] = trainlabs["class"].apply(lambda c: 0 if c=="normal" else 1)
trainims = np.stack([imread(f) / 255 for f in trainfs], axis=0)

# MODEL
model = keras.Sequential([
    keras.layers.Flatten(input_shape=(75, 75, 3)),
    keras.layers.Dense(64, activation=tf.nn.relu),
    keras.layers.Dense(64, activation=tf.nn.relu),
    keras.layers.Dense(2, activation=tf.nn.softmax)
])
model.compile(optimizer='adam', loss='sparse_categorical_crossentropy', metrics=['accuracy'])
model.fit(trainims, np.array(trainlabs["class"]), epochs=5)

# MODEL PREDICTIONS
testglob = "./input09_test/*.png"
testfs = sorted(glob(testglob))
testims = np.stack([imread(file) / 255 for file in testfs], axis=0)
testlabs = DF.from_records([{k: renm.match(f)[i] for k,i in zip(["id", "class"], [1,2])} for f in testfs])
preds = [np.argmax(p) for p in model.predict(testims)]

# RIDDLE 
icrao = np.array([i for i, p in enumerate(preds) if p == 1])
letters = "".join(testlabs.loc[icrao,"class"])
print(letters)
```

    Epoch 1/5
    1000/1000 [==============================] - 2s 2ms/step - loss: 0.4892 - acc: 0.7530
    Epoch 2/5
    1000/1000 [==============================] - 1s 838us/step - loss: 0.0941 - acc: 0.9890
    Epoch 3/5
    1000/1000 [==============================] - 1s 1ms/step - loss: 0.0520 - acc: 0.9930
    Epoch 4/5
    1000/1000 [==============================] - 1s 1ms/step - loss: 0.0307 - acc: 0.9960
    Epoch 5/5
    1000/1000 [==============================] - 1s 1ms/step - loss: 0.0348 - acc: 0.9950
    
```text
TWOLTERSRETINOBLASTOMAROTEN
```


You can see the classification accuracy is not 100%, but the riddle is still legible "Two letters retinoblastoma protein". 

This riddle refers to the two letters `RB`, which is the standard symbol for the retinoblastoma protein (the gene of which should be very familiar to medical students as it is often the prototypical gene for explaining the ["two-hit hypothesis"](https://en.wikipedia.org/wiki/Knudson_hypothesis)).

## Image Generation

We were very time-pressured this month with a variety of other tasks, so our image generation code is neither clean, nor optimised, nor short. In the future, we hope to have time to redo this code (now that we know better) and possibly rewrite it for a client-side generator that could be called from the browser. Much of our dissatisfaction with the current code is the number of loops through Numpy arrays; we have high hopes in either APL or J that we could fit this code on a business card, as it really is mostly array manipulation...all we need is to find the time! 

We have not had the time this month to walkthrough this image generation code step-by-step as we have done previously, but we have clarified a few points briefly where appropriate. 

### Setup


```python
import matplotlib
import numpy as np
import matplotlib.cm as cm
import itertools
import random
import PIL
import PIL.Image as Image
import PIL.ImageFilter as ImageFilter
import PIL.ImageChops as ImageChops
import PIL.ImageDraw as ImageDraw
import PIL.ImageEnhance as ImageEnhance
from matplotlib import pyplot as plt
from matplotlib import patches
```


```python
%matplotlib inline
```

### Constants


```python
radius = 64
imextent = [-radius, radius, -radius, radius]
```

### General Functions


```python
def make_base():
    fig, ax = plt.subplots(figsize=(4,4))
    ax.axis("off")
    ax.patch.set_alpha(0)
    ax.set_ylim([-radius, radius])
    ax.set_xlim([-radius, radius])
    return fig, ax
```


```python
def fig2img(fig):
    """Based on http://www.icare.univ-lille1.fr/tutorials/convert_a_matplotlib_figure"""
    fig.canvas.draw()
    width, height = fig.canvas.get_width_height()
    buffer = np.frombuffer(fig.canvas.tostring_argb(), dtype=np.uint8)
    buffer.shape = (width, height, 4)
    buffer = np.roll(buffer, 3, axis=2)
    image = Image.frombytes("RGBA", (width, height), buffer.tostring())
    return image
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


```python
def make_imnoise(ax, radius, scalefactor, redmodifier=1, green=0.35, blue=0.25):
    imsize = radius
    imcontainer = np.zeros([imsize, imsize, 4])
    bgnoise = ((np.random.random((imsize, imsize)) - 0.5) / scalefactor) + 0.8
    imcontainer[:, :, 0] = bgnoise * redmodifier
    imcontainer[:, :, 1] = green
    imcontainer[:, :, 2] = blue
    imcontainer[:, :, 3] = 1
    im = ax.imshow(imcontainer,
            origin='lower',
            interpolation='bilinear',
            extent=imextent)
```

### Background


```python
def make_bg(odxcentre, odycentre, odradius, fvxcentre, fvycentre, fvradius, crao=False):
    
    fig, ax = make_base()
    plt.close()
    
    make_imnoise(ax, radius, 8)

    if crao:
        fvcol = (rand_around(0.55, 0.05, 0, 1),
                 rand_around(0, 0.05, 0, 1),
                 rand_around(0, 0.05, 0, 1)
                )
    else:
        fvcol = (rand_around(0.2, 0.05, 0, 1),
                 rand_around(0, 0.05, 0, 1),
                 rand_around(0, 0.05, 0, 1)
                )

    fovea = patches.Circle((fvxcentre, fvycentre), fvradius, facecolor=fvcol, alpha = 0.5)
    fovea_extend = patches.Circle((fvxcentre, fvycentre), fvradius * 2, facecolor = fvcol, alpha = 0.1)
    fovea_extend_extend = patches.Circle((fvxcentre, fvycentre), fvradius * 3, facecolor = fvcol, alpha = 0.1)

    # Optic disc "Halo"
    odcol = (rand_around(1, 0.05, 0, 1),
             rand_around(0.8, 0.05, 0, 1),
             rand_around(0.8, 0.05, 0, 1)
            )
    od_halo = patches.Circle((odxcentre, odycentre), odradius * 2, facecolor=odcol, alpha = 0.1)
    od_halo_extend = patches.Circle((odxcentre, odycentre), odradius * 4, facecolor=odcol, alpha = 0.1)
    od_halo_extend_extend = patches.Circle((odxcentre, odycentre), odradius * 6, facecolor=odcol, alpha = 0.1)
    
    # Retinal opacity if CRAO
    if crao:
        retcol = (rand_around(0.9, 0.05, 0.8, 1),
                  rand_around(0.8, 0.05, 0.6, 1),
                  rand_around(0.7, 0.05, 0.4, 1)
                 )
        for rmod, alpha in zip([rand_around(1, 2, 0.1, 2), rand_around(0.8, 0.5, 0.1, 2), 0.5], (0.6, 0.4, 0.3)):
            ax.add_patch(patches.Circle((fvxcentre, fvycentre), radius/rmod, facecolor=retcol, alpha=alpha))
        
    # Adding patches
    ax.add_patch(od_halo)
    ax.add_patch(od_halo_extend)
    ax.add_patch(od_halo_extend_extend)
    ax.add_patch(fovea)
    ax.add_patch(fovea_extend)
    ax.add_patch(fovea_extend_extend)
    
    im = fig2img(fig).filter(ImageFilter.GaussianBlur(5))
    
    # Shadows
    figsh, axsh = make_base()
    plt.close()
    shadows = np.random.random((4,4)) / 2
    axsh.imshow(shadows, vmin = 0, vmax = 1, interpolation = "bicubic", cmap=cm.Greys, extent=imextent)
    imsh = fig2img(figsh).filter(ImageFilter.GaussianBlur())
    
    combined = ImageChops.multiply(imsh, im)
    
    return combined
```

Example:


```python
make_bg(-20, 0, 10, 10, 0, 8)
```




![png](https://lh3.googleusercontent.com/51af6xeMGNqHgUMO5pQmoTDuEaFsCPr_3tw5qA5fLBmFKHb3jSin3I9ngzAbJJEBs29Zsy0AgKRAuo1M-HTFTPrBd2Zf164bAhkgrHRMBtLxPRPW-RHyCGAtsFdi_I_zkYNiarnBbg=s288-p-k)



Example "with" CRAO:


```python
make_bg(-20, 0, 10, 10, 0, 8, crao=True)
```




![png](https://lh3.googleusercontent.com/U2DvRpO7gy04tvQhI4PvJGL9AzATvNZqLgulWCOX6bcT-_S6NUoYkJrII1JF5OXpXa3S-nLNLbFgO1OSfb2MMAMYEO5Eyr6JGKAztCMUP84m4iUkPwUpTJueEVvbPeYR7bqxJiYOcg=s288-p-k)



### Vessels

We spent most of our effort on creating semi-realistic depictions of vessels on the retina. Currently, we have implemented a recursive branching algorithm that widens the vessel on each branch (such that vessels with more branches appear thicker) and with gradual deviation towards the fovea. There are a large number of random variables incorporated in this to ensure the vessel patterns are unique. 

We know the code below is very messy, and would like to clean it up at some point in the future.


```python
def make_vessels(odxcentre, odycentre, fvxcentre, fvycentre, iterations, thickness, numbranches=2, base_steps=20):
    fig, ax = make_base()
    plt.close()
    
    lines = []
    
    unit_step = (4 * radius / base_steps)
    
    def move(accumulator, facing_angle, main_direction, steps_left, diverged_left, first=False, towardsfv=True):
        if steps_left == 0:
            lines.append(accumulator)
        else:
            if diverged_left > 0:
                # Make decision whether to diverge here or not
                randf = random.random()
                if randf < 0.3:
                    next_diverged_left = diverged_left - 1
                    next_main_direction = main_direction * random.uniform(-2, -1)
                    shifted_accum = list(map(lambda p: (p[0] + thickness / 2, p[1] + thickness/2), accumulator))
                    
                    if random.random() < 0.5:
                        next_towardsfv = False
                    else:
                        next_towardsfv = True
                    
                    move(shifted_accum, facing_angle, next_main_direction, steps_left, next_diverged_left, False, next_towardsfv)
                else:
                    next_diverged_left = diverged_left
            else:
                next_diverged_left = 0
            
            if random.random() < 0.98:
                turn_angle_modifier = np.random.normal(0, 3)
                turn_angle = main_direction * turn_angle_modifier
            else:
                turn_angle = main_direction + random.uniform(-np.pi/2, np.pi/2)
            
            
            xlast, ylast = accumulator[-1]
            
            # Deviate towards the fovea
            if towardsfv:
                fvx = rand_around(fvxcentre - xlast, abs((fvxcentre-xlast)/5), fvxcentre - 2*xlast, fvxcentre + 2*xlast)
                fvy = rand_around(fvycentre - ylast, abs((fvycentre-ylast)/5), fvycentre - 2*ylast, fvycentre + 2*ylast)

                angle_to_fv = np.arctan2(fvy, fvx)

                if angle_to_fv > 0:
                    angle_to_fv = angle_to_fv + (angle_to_fv - np.pi)  / 2
                else:
                    angle_to_fv = (np.pi + angle_to_fv) / 2 + angle_to_fv
                angle_to_fv = (angle_to_fv - facing_angle)
                angle_to_fv = rand_around(angle_to_fv, np.pi/8, angle_to_fv / 2, angle_to_fv * 2)

                deviate_prop = rand_around(1, 2, 0, 6)
                turn_angle = (deviate_prop * angle_to_fv + 1 * turn_angle) / (1 + deviate_prop)

                
            
            if first:
                start_dist = rand_around(12, 3, 4, 12)
                start_angle = turn_angle + rand_around(np.pi/8, np.pi/16, np.pi/8, 7*np.pi/8)
                next_point = (xlast + (start_dist * np.cos(facing_angle + start_angle)),
                              ylast + (start_dist * np.sin(facing_angle + start_angle)))
            else:
                step_distance = rand_around(steps_left / base_steps * unit_step, base_steps/5, 0,  base_steps * 10)
                
                next_point = (xlast + (step_distance * np.cos(facing_angle + turn_angle)),
                              ylast + (step_distance * np.sin(facing_angle + turn_angle)))
                
            next_facing = facing_angle + turn_angle
            
            while next_facing > 2 * np.pi:
                next_facing -= (2 * np.pi)
            while next_facing < 0:
                next_facing += (2 * np.pi)
            if np.pi < next_facing:
                next_facing = -(2 * np.pi - next_facing)
            move(accumulator + [next_point], next_facing, main_direction, steps_left - 1, next_diverged_left)
    

    unit_rotate = (1.5 * np.pi / iterations)
    
    for i in range(iterations):
        starting_point = (rand_around(odxcentre, 2, odxcentre - 10, odxcentre + 10),
                          rand_around(odycentre, 2, odycentre - 10, odycentre + 10))
        start_accum = [starting_point]
        num_steps = int(random.uniform(base_steps * 0.75, base_steps * 1.25))
        num_diverge = random.randint(1, numbranches)
        facing_angle = (unit_rotate * i) + (np.pi / 8)
        angle_total = random.uniform(-np.pi , np.pi )
        main_direction = angle_total / (num_steps * 1)
        if random.random() < 0.5:
            new_towardsfv = False
        else:
            new_towardsfv = True
        move(start_accum, facing_angle, main_direction, num_steps, num_diverge, first=True, towardsfv = new_towardsfv)
    
    for line in lines:
        linecol = (rand_around(0.4, 0.02, 0, 1),
                   rand_around(0.1, 0.01, 0, 1),
                   rand_around(0.1, 0.01, 0, 1)
                  )
        linewidth = rand_around(thickness, 0.1, 0, thickness * 2)
        vx = [p[0] for p in line]
        vy = [p[1] for p in line]
        ax.plot(vx, vy, color=linecol, linewidth=linewidth)
    
    im = fig2img(fig)
    
    return im
```

Example


```python
make_vessels(-32, 0, 10, 0, 8, 0.5, numbranches=3)
```




![png](https://lh3.googleusercontent.com/3iGsnEm_ZckFOsWC736nVXtclwGrpU0-YoWbY1rXJ-JkWJUtWr6eMFPJxCk5tm5bnHtvYBM8eiy2yefdgcJFPpmpWqkf4kf_KjRQVLEkG6H2FUboWzEPPwD8WkdzCZdvH-p5spA25w=s288-p-k)



### Intermediate Shadows


```python
def make_inter():
    fig, ax = make_base()
    plt.close()
    make_imnoise(ax, random.randint(radius//2, radius*3/4), 2.5)
    im = fig2img(fig)
    
    # Shadows
    figsh, axsh = make_base()
    plt.close()
    shadows = np.random.random((4,4)) / 1
    axsh.imshow(shadows, vmin = 0, vmax = 1, interpolation = "bicubic", cmap=cm.Greys, extent=imextent)
    imsh = fig2img(figsh).filter(ImageFilter.GaussianBlur())
    
    combined = ImageChops.blend(im, imsh, 0.4)
    
    return combined
```


```python
make_inter()
```




![png](https://lh3.googleusercontent.com/jZall_Ea4PF0SuO1wyTCeRV2bXUsfhPReV3XEK15jvsiVbSYC18MhOrqe7lT8uCG6bzyhcoYx7rpb2kcTtFIF0scFucxh8VRWZlavO4xvt0kBLmefFIH5MT8q_UcL0669v8G5IPPpg=s288-p-k)



### Optic Disc


```python
def make_od(odxcentre, odycentre, odradius_original):
    
    fig, ax = make_base()
    plt.close()
    
    imsize = 250
    
    odradius = odradius_original * (imsize/radius) * 0.8
    
    cup_to_disc = rand_around(0.3, 0.05, 0, 1)
    ocradius = int(odradius * cup_to_disc)
    
    imcontainer = np.zeros((imsize*2, imsize*2, 4))
    
    odxtrans = int((odxcentre * imsize/radius) + imsize)
    odytrans = int((odycentre * imsize/radius) + imsize)
    
    odcolbase = np.array([rand_around(1, 0.05, 0, 1),
                 rand_around(0.7, 0.05, 0, 1),
                 rand_around(0.3, 0.05, 0, 1),
                 1
                ])
    
    occolbase = np.array([rand_around(1, 0.05, 0, 1),
                 rand_around(0.95, 0.05, 0, 1),
                 rand_around(0.95, 0.05, 0, 1), 
                 1
                ])
    
    rimhalfwidth = odradius / 10
    
    xmod = rand_around(1 + abs(odxcentre / radius)/4, 0.05, 1, 1.5)
    
    for y in range(imsize*2):
        for x in range(imsize*2):
            r = np.sqrt(((x - odxtrans) * xmod) ** 2 + (y - odytrans) ** 2)
            if r < ocradius:
                alpha = rand_around(0.85, 0.1, 0.7, 1)
                col = occolbase
                col[3] = alpha
                imcontainer[y, x] = col
            elif r < odradius + rimhalfwidth:
                alpha = rand_around(0.7, 0.1, 0.5, 1)
                factor = np.sqrt((r - ocradius) / (odradius + rimhalfwidth - ocradius))
                col = np.add(factor * odcolbase, (1 - factor) * occolbase)
                col[3] = alpha
                imcontainer[y, x] = col
            if (odradius - rimhalfwidth < r < odradius):
                alpha = rand_around(0.4, 0.2, 0.5, 1)
                col = odcolbase / (rand_around(1.2, 0.05, 1, 1.4))
                col[3] = alpha
                imcontainer[y, x] = col
    ax.imshow(imcontainer, extent=imextent, origin="lower")
    
    im = fig2img(fig)
    
    return im
```

Example:


```python
make_od(-32, 5, 10)
```




![png](https://lh3.googleusercontent.com/PB4vYxdDRw5g-ZPNxAhZSjJDMK971ngMvMm5imVrF6kUCqJ9moigRlTmroEKxybXrO_aPzjR1mtrcNtIFlhyOx8IYe6CYIJ1j_6UqHpDC3hiYhV44qlo8onZUWFv3b4m5eVyMksKuQ=s288-p-k)



### Optic Disc Highlight


```python
def make_odhighlight(odxcentre, odycentre):
    
    fig, ax = make_base()
    plt.close()
    
    imcontainer = np.zeros((2*radius, 2*radius))
    
    for y in range(2*radius):
        for x in range(2*radius):
            distance = np.sqrt((y-radius-odycentre) ** 2 + (x-radius-odxcentre) ** 2)
            imcontainer[y, x] = distance
    
    dmax = np.amax(imcontainer)
    #invert = lambda v: 1 - v
    #vinvert = np.vectorize(invert)
    #imcontainer = vinvert(imcontainer / dmax)
    
    vmin = random.uniform(0, 0.3)
    vmax = random.uniform(0.9, 1.1)
    
    ax.imshow(imcontainer / dmax , cmap=cm.Greys, vmin=vmin, vmax=vmax, interpolation = "bicubic", extent=imextent)

    im = fig2img(fig)
    return im
```

Example:


```python
make_odhighlight(-32, 0)
```




![png](https://lh3.googleusercontent.com/MzNrzAWtWcS6uh6PCtkml437x0C5-WvFv_6cdcE6cZyNs6YCR99o9GEnEGIZ8WzaJUvgZTfZ-125UuZ9Ee03Bl8trBDSP-Y_hdQUhWfdfG66YC3ASC-TEnYkXfCiJ8wP_xzaDI9Ajw=s288-p-k)



### Noise


```python
def make_noise():
    
    fig, ax = make_base()
    plt.close()
    
    imsize = 2*radius
    
    imcontainer = np.random.random((imsize, imsize))
    
    vmin = random.uniform(-0.5, 0)
    vmax = random.uniform(1, 1.5)
    
    ax.imshow(imcontainer / 5, cmap=cm.Greys, vmin=vmin, vmax=vmax, interpolation = "bicubic", extent=imextent)

    im = fig2img(fig)
    return im
```

Example:


```python
make_noise()
```




![png](https://lh3.googleusercontent.com/j00r_0I4vWqCOADfdeaJ_Vh2X_6v4WVAV_pkDWZxviVQIqcoB87Wh52LbO_EH2ABPU23_VlR4eLPE18ZIpp2uZGdiYB6IQ-sLtR5uMsAm_bOtuJTlHH2-TbSJFlEXQXA8yLiPe887g=s288-p-k)



### Compositing


```python
def make_fundus(crao=False):
    
    # OD parameters
    odradius = rand_around(radius / 8, radius / 24, radius / 7, radius / 5)
    odxcentre = rand_around(- radius / 2, radius / 8, -radius + odradius, 0)
    odycentre = rand_around(0, radius / 8, -radius + odradius, radius - odradius)
    
    # Fovea parameters
    fvradius_base = odradius / 1.5
    fvxcentre_base = odxcentre + (odradius * 2 * 2)
    fvycentre_base = odycentre
    
    fvxcentre = rand_around(fvxcentre_base, 1.5, clip_low=-radius, clip_high=radius)
    fvycentre = rand_around(fvycentre_base, 1.5, clip_low=-radius, clip_high=radius)
    fvradius = rand_around(fvradius_base, 1, clip_low=1, clip_high=odradius)
    
    # Making images
    bg = make_bg(odxcentre, odycentre, odradius, fvxcentre, fvycentre, fvradius, crao=crao)
    smves = make_vessels(odxcentre, odycentre, fvxcentre, fvycentre, 10, 0.2, numbranches = 3)
    inter = make_inter()
    od = make_od(odxcentre, odycentre, odradius )
    lgves = make_vessels(odxcentre, odycentre, fvxcentre, fvycentre, 5, 0.75, numbranches=3)
    inter2 = make_inter().filter(ImageFilter.SMOOTH)
    highlighter = make_odhighlight(odxcentre, odycentre)
    noise = make_noise()
    
    im = bg.copy()
    
    im.paste(smves, (0,0), smves)
    im = ImageChops.blend(im, inter, 0.2)
    im.paste(od, (0,0), od)
    im = im.filter(ImageFilter.GaussianBlur(1)).filter(ImageFilter.SHARPEN)
    im.paste(lgves, (0,0), lgves)
    
    # Enhancements
    im = ImageChops.blend(im, inter2, rand_around(0.3, 0.1, 0, 0.8))
    im = ImageChops.multiply(im, highlighter)
    im = ImageChops.multiply(im, noise)
    
    brightener = ImageEnhance.Brightness(im)
    im = brightener.enhance(rand_around(1.65, 0.05, 1.5, 1.75))
    contraster = ImageEnhance.Contrast(im)
    im = contraster.enhance(rand_around(1, 0.05, 0.95, 1.05))
    
    # Circular Mask
    bigsize = (im.size[0] * 3, im.size[1] * 3)
    mask = Image.new('L', bigsize, 0)
    draw = ImageDraw.Draw(mask) 
    draw.ellipse((im.size[0] / 2, im.size[1] / 2) + (im.size[0] * 2.5, im.size[1] * 2.5), fill=255)
    mask = mask.resize(im.size, Image.ANTIALIAS)

    im.putalpha(mask)    
    
    # Black Background
    im_black = Image.new('RGB', im.size, 0)
    im_black.paste(im, (0,0), im)
    
    margin = 45
    cropped = im_black.crop((margin,margin) + (im.size[0] - margin, im.size[1] - margin))
    
    if random.random() < 0.5:
        cropped = cropped.transpose(Image.FLIP_LEFT_RIGHT)
    
    return cropped
```

Example:


```python
make_fundus()
```




![png](https://lh3.googleusercontent.com/YTU-n1jCwi9eXNJaPZDp9xOAOCXjJjbZk25Tiza8fNdX72yuiArrPLBY9BH6xAn_CrZHeB8wSBoJLMXf9-4YMFOQtz4jGG9VrBnQzSRZJhycfRFZUYP1GpXPDhsEquzwJaW44Mxw8g=s198-p-k)



Example of CRAO fundus:


```python
make_fundus(crao=True)
```




![png](https://lh3.googleusercontent.com/R2Hzv06-MGDPk253hFmweiFYcSc8VTlUODTYUhSe7bIr2XmTsVzlDE256vzysSPjutnCbjeB2IIBbhr_ClvA4c4Eebgt9JGOkwLeXi6yF7iu-M09LCYFpiOs1AljZtlR5QVwBHkacA=s198-p-k)



We downsampled these images to 75 by 75 pixels for the actual input.

### Training Set

500 normal and 500 "with" CRAO. 


```python
save_directory = "./input08_training/"

for i in range(871, 1000):
    if i < 500:
        fileid = "{0:04d}_normal.png".format(i + 1)
        image = make_fundus()
    else:
        fileid = "{0:04d}_crao.png".format(i + 1)
        image = make_fundus(crao=True)
    image = image.resize((75, 75))
    image.save(save_directory + fileid)
```

### Riddle

We tried to ensure that the pattern of letters wouldn't give away the riddle, so we generated the letters randomly and only allocated a CRAO image if incidentally this corresponded to the next letter in the riddle. 


```python
question_full = "TWO LETTERS RETINOBLASTOMA PROTEIN"
question= question_full.replace(" ", "")
alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
```


```python
position = 0
counter = 0
max_position = len(question)

save_directory = "./input08_test/"

while position < max_position:
    next_letter = question[position]
    new_letter = random.choice(alphabet)
    noiser = random.random()
    fileid = "{0:04d}_{1:1s}.png".format(counter, new_letter)
    if new_letter == next_letter and noiser < 0.9:
        image = make_fundus(crao=True)
        print("POSITION {}, COUNTER {}".format(position, counter))
        position += 1
    else:
        image = make_fundus()
    image = image.resize((75, 75))
    image.save(save_directory + fileid)
    counter += 1
    
# Fill up to 1000.
while counter <= 1000:
    new_letter = random.choice(alphabet)
    fileid = "{0:04d}_{1:1s}.png".format(counter, new_letter)
    image = make_fundus()
    image = image.resize((75, 75))
    image.save(save_directory + fileid)
    counter += 1
```

