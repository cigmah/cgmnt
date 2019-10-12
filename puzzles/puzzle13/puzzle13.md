

# Allele Inference

> This puzzle was released on 2019-05-11, and was the Challenge puzzle for the theme *A Little Logic*. 

Who ever thought a giant library of identical rooms was a good idea?

It's 3:40am. Facing North, you walk through the corridor on the 5th wall.

![Image](https://i.imgur.com/BoYYqxg.gif)

The puzzle of this room is *Allele Inference*.

1. A genetic disease runs through the Babel Imperial Family. 
2. This genetic disease is inherited through a *single* gene on an autosomal
   chromosome. 
   

   ``` text
   Here's a short refresher on inheritance.
   
   ALLELES: 2 types. 
   1) RECESSIVE, or 
   2) DOMINANT.

   Each person has 2 alleles; one inherited from each parent.

   Since each person has 2 alleles, they can have one of three genotypes:

   GENOTYPES: 3 types.
   1) Homozygous recessive (2x recessive alleles)
   2) Heterozygous (1x dominant, 1x recessive)
   3) Homozygous dominant (2x dominant alleles)
   ```
  
   An important part to note here is that there are only three possible genotypes:
   homozygous recessive, heterozygous or homozygous dominant. 

3. Your task is to determine how many members of the Babel Imperial Family are
    **homozygous dominant** for this gene.
    
4. You are given four pieces of information:
    1. The 100 known members of the Imperial Family. (`cgmnt13_people.txt`)
    2. The parent relations of a subset of the Imperial Family.
        (`cgmnt13_relations.txt`)
    3. A list of all the people with a **heterozygous** genotype.
        (`cgmnt13_heterozygous.txt`)
        Those with a heterozygous genotype are easily distinguishable from the
        homozygous recessive and dominant genotypes, so **this file is exhasutive.**
        i.e. **any family member not in this list has either a homozygous dominant
        or recessive genotype.**
    4. A list of a select number of members with known homozygous genotypes.
        (`cgmnt13_known.txt`). This list is not exhaustive.
5. From these files, you will need to use Mendelian inheritance logic to deduce 
    the remaining 30 or so unknown genotypes. You already have a sizeable amount.
6. Once you have determined the genotypes of all 100 members of the imperial
    family, **count the number of family members with a homozygous *dominant* genotype
    and submit is as your answer.**
7. There is only one solution, and it is definitively deducible from the data
    and information you have been provided.

# Input

- [All files.](https://drive.google.com/drive/folders/17BHi9E84w3fYcOuHa9t-wVtEKEMK4N2R?usp=sharing)
- [cgmnt13_people.txt](https://drive.google.com/file/d/1XsIDMI2KF2tQquZd5lMy7ivAP_-rqNNo/view?usp=sharing) (718B)
- [cgmnt13_relations.txt](https://drive.google.com/file/d/18K9ugyQpw0z9Nq6i7e_nBvs15DSH3VyF/view?usp=sharing) (3KB)
- [cgmnt13_heterozygous.txt](https://drive.google.com/file/d/1YNVkHvkx4tvspngjKiGtVRiya3GM3uic/view?usp=sharing) (228B)
- [cgmnt13_known.txt](https://drive.google.com/file/d/11ccf7VuUPiLd8fvQ0AsQ9M41b6_94VwH/view?usp=sharing) (927B)

# Statement

State the total number of members in the Imperial Family who have a *homozygous dominant* genotype.


# References

Written by the CIGMAH Puzzle Hunt Team.

# Answer

The correct solution was `36`.

# Explanation

# Map Hint
 
 You are proud of your ability to deduce, but realise that life is not usually
 this deterministic. You reflect on your powerlessness to confront the messiness
 of the world.
 
 You open the file `map_hint.txt`.
 
 ```
 The key is:
 
 enalgunanaqueldealgunhexagonorazonaronloshombresdebeexistirunlibroquesealacifrayelcompendioperfectodetodoslosdemasalgunbibliotecarioloharecorridoyesanalogoaundios
 
 When deciphering, preserve the capitalisation of the original map text and skip
 non alphabetic characters, leaving them as they are.
 
 ```
 
 Well this is finally useful. You experience a feeling of deja vu of a feeling
 of deja vu.
 
# Writer's Notes

We sincerely apologise, but our Writer's Notes for this month are very sparse.
We have provided our solutions, but that's it for now. A proper writeup
including the data generation will come in due course. 

We had a lot of trouble with generating data for this particular puzzle.
Designing the puzzle to be solvable purely with deterministic logic was more
difficult than we thought. We learned some important lessons, but for another time...

This puzzle wasn't originally intended as a constraint puzzle (since we've done
that a few other times), but we realised it was easier than what we originally
tried with miniKanren, so we rolled with it.

## Example Solution
 

```python
import re
from pathlib import Path
from itertools import product
from constraint import *
#
# Data load and preprocessing
people       = Path('./cgmnt13_people.txt').read_text().splitlines()
reparent     = re.compile(r'(\w+) is the child of (\w+) and (\w+).')
parents      = reparent.findall(Path('./cgmnt13_relations.txt').read_text())
heterozygous = set(Path('./cgmnt13_heterozygous.txt').read_text().splitlines())
reknown      = re.compile(r'(\w+) is homozygous (\w+).')
known        = reknown.findall(Path('./cgmnt13_known.txt').read_text())

# Possible genotypes assuming each person has 2 alleles for a gene, represented as number of dominant alleles. 
genotypes = tuple(set(map(sum, product((0,1), repeat=2))))

# Possible children for each genotype
parentcombos    = list((product(product((0,1), repeat=2), repeat=2)))
parentgenotypes = list(map(lambda p: tuple(set(map(sum, p))), parentcombos))
childgenotypes  = [tuple(set(map(sum, product(*p)))) for p in parentcombos]
validchildtype  = {combo: child for combo, child in set(zip(parentgenotypes, childgenotypes))}

# Add problem and variables
problem = Problem()
problem.addVariables(people, genotypes)

# Define constraint that child genotype must be valid given parent genotypes
def addParentConstraint(ch, par1, par2):
    problem.addConstraint(lambda c, p1, p2: c in validchildtype[tuple(set((p1,p2)))], (ch, par1, par2))    

# Add valid child genotype constraint
[addParentConstraint(*relation) for relation in parents]

# Genotype constraints.
addHeterozygousConstraint = lambda person: problem.addConstraint(lambda p: p == 1, (person,))
addHomozygousConstraint   = lambda person: problem.addConstraint(lambda p: p == 0 or p == 2, (person,))
addKnownGenotype          = lambda person, genotype: problem.addConstraint(lambda p: p == genotype, (person,))

# Add known heterozygous members. 
[addHeterozygousConstraint(person) for person in heterozygous]

# Other known genotypes
knowntotype = {"recessive": 0, "dominant": 2}
[addKnownGenotype(d[0], knowntotype[d[1]]) for d in known]

# Restrict the remainder to homozygous.
[addHomozygousConstraint(person) for person in people if person not in heterozygous]

solution = problem.getSolution()

# Count the homozygous dominant genotype
print(len([name for name, genotype in solution.items() if genotype == 2])) 

# To verify one solution only.
# solutions = problem.getSolutions()
# print(solutions)
# print(len(solutions))
```

