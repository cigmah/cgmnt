

# Reschedule All

> This puzzle was released on 2019-05-11, and was the Beginner puzzle for the theme *A Little Logic*.

It's 3:20am. Facing North, you walk through the corridor on the 4th wall.

![Image](https://i.imgur.com/SbjycVm.gif)

1. Dr Y. L. Noehtmi is the only doctor at The Clinic on the Outskirts.
2. He was supposed to be back from holiday tomorrow, but his flight's been delayed.
3. He's determined not to let his patients down and will work 8am to 5pm the
following day to catch up.
4. You task is to **reschedule his patients for a new appointment from 8am to 5pm the day he arrives.**
5. There are 26 patients.
6. Each patient gets an *exactly* **20-minute slot**, and Dr Noehtmi is *always* on time.
7. Slots start from 8am and run on the dot every 20 minutes (i.e. 8:00, 8:20, 8:40 etc.).
8. You've received from each patient a range of times during which they are
    available to come in for their rescheduled appointment.
9. You need to schedule each patient such that the **full 20 minutes of the
   appointment** fall within the range of times they are available.
10. As there are 9 hours between 8am and 5pm, there are 27 20-minute slots.
11. That means Dr Noehtmi gets one 20-minute break during the day.
12. **Reschedule all the patients according to their availabilities**, then
    **determine what time during the day Dr Noehtmi *starts* his only break.**
13. There is only one solution.

Non-alphanumeric characters are stripped. Punctuation and spacing doesn't matter.

## Input

[cgmnt_input12.txt (1KB)](https://drive.google.com/file/d/1Xd4s7tHgW195xHNAr1uQNVGjZ_g-aO31/view?usp=sharing)

## Statement

When the patients are scheduled successfully, state the time (in 4-digit 24 hour time) when Dr Noehtmi's only scheduled break starts.


## References

Written by the CIGMAH Puzzle Hunt Team.

## Answer

The correct solution was `1220`.

## Explanation

### Map Hint

 Your ability to logically reschedule patients is impressive. You wonder if you
 could schedule more things. Sleep, perhaps.

 You open the file `map_hint.txt`.

 ```
 The key is:

 enalgunanaqueldealgunhexagonorazonaronloshombresdebeexistirunlibroquesealacifrayelcompendioperfectodetodoslosdemasalgunbibliotecarioloharecorridoyesanalogoaundios

 When deciphering, preserve the capitalisation of the original map text and skip
 non alphabetic characters, leaving them as they are.

 ```

 Well this is finally useful. You experience a feeling of deja vu.

### Writer's Notes

We sincerely apologise, but our writer's notes for this month are very sparse.
We have provided our solutions, but that's it for now. A proper writeup
including the data generation will come in due course.

Scheduling is a problem particularly amenable to logic programming. A more
interesting discussion than this one line to come soon...or eventually.

(We note that programming is not explicitly required to answer the actual question of this puzzle. But it is useful to use programming to find the arrangement...)


```python
import re
from constraint import *
from pathlib import Path
from datetime import datetime, timedelta

### Default by datetime.strptime when parsing hours and minutes alone.
d0 = datetime(1900, 1, 1, 8, 0)

### Preprocessing. Wish Python had more functional idioms.
redata   = re.compile(r'(\w+) is available between (.*)\.')
data     = redata.findall(Path("./cgmnt_input12.txt").read_text())
names    = [t[0] for t in data]
timestrs = [tuple(map(lambda s: s.split(" to "), t[1].split("and"))) for t in data]
times    = list(map(lambda rs:tuple(map(lambda r:tuple(map(lambda s:\
           int((datetime.strptime(s.strip(),"%H:%M")-d0).total_seconds()/60),r)),rs)),timestrs))

### Allowable appointment slots in minutes since start of workday.
slots = range(0, 60 * 9, 20)

problem = Problem()

### Add variables and with the appropriate domain for each person's availabilities.
for name, time in zip(names, times):
    domain = [s for s in slots if any(map(lambda t: t[0] <= s <= s + 20 <= t[1], time))]
    problem.addVariable(name, domain)

### No clashing appointments
problem.addConstraint(AllDifferentConstraint())

solution      = sorted([(time, name) for name, time in problem.getSolution().items()])
breakstart    = next(iter(set(slots) - set([time for time, _ in solution])))
print(datetime.strftime(d0 + timedelta(minutes=breakstart), "%H:%M"))
```

