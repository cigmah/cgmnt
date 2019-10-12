

# Genetic Thrift

> This puzzle was released on 2019-08-10, and was the Beginner puzzle for the theme *"Code"*. 

You're a bit creeped out by the last room and shiver.

It's 6:20am. Facing North, you walk through the corridor on the 5th wall.

![Imgur](https://i.imgur.com/zuIShWZ.gif)
This room has a computer in the centre, thankfully. You turn it on. 

---

The four nucleobases found in DNA are: 
- Adenine (A), which pairs with thymine (T), and
- Cytosine (C), which pairs with guanine (G). 

In the [FASTA file format](https://en.wikipedia.org/wiki/FASTA_format), nucleobase sequences may be represented with a sequence of the one-letter representations of the nucleobases (that is, A, T, C and G), such as:

```text
TACATCTTTCGATCGATCGGACGAACAATGTGTCGGTGACTCGATCTAACAT
```

The FASTA file format contains extra information (such as a header and characters representing unknown bases), which we will not consider. Instead, consider the case where we are able to definitively determine the identity of every nucleobase in a sequence and represent it into a single string composed *only* of A, T, C or G characters. 

We can then represent these four characters with two bits of information, like so:

<table>
<tr><th>A</th><td>00</td></tr>
<tr><th>T</th><td>01</td></tr>
<tr><th>C</th><td>10</td></tr>
<tr><th>G</th><td>11</td></tr>
</table>

Using this correspondence table, a nucleobase sequence can then be represented as a sequence of 0s and 1s. The above, sequence, for example, would convert to:
```text
01 00 10 00 01 10 01 01 01 10 11 00 01 10 11 00 01 10 11 11 00 10 11 00 00 10 00 00 01 11 01 11 01 10 11 11 01 11 00 10 01 10 11 00 01 10 01 00 00 10 00 01
```

For a nucleobase sequence with a length divisible by four, every four successive pairs of bits can be grouped together to form groups of 8 bits, like so:

```text
01001000 01100101 01101100 01101100 01101111 00101100 00100000 01110111 01101111 01110010 01101100 01100100 00100001
```
Each 8-bit representation can then be converted into a corresponding [UTF-8](https://en.wikipedia.org/wiki/UTF-8) character. UTF-8 is a character encoding scheme which maps 8-bit codepoints to single characters. The above example would convert to:

```text
Hello, world!
```

In this manner of encoding the nucleobase sequence, we can reduce the character length of a definitive nucleobase sequence string by a factor of 4 if it has a length divisible by 4. 

You have been provided with another nucleobase string with a length divisible by 4. When encoded in the manner describe above, it will spell out a short question with a single-word answer.

# Input

[Click here to download your puzzle input (440 bytes, .txt)](https://drive.google.com/file/d/1jjy-Bc_tV3sxMOc9XLXY5Fg8gBYTxkj2/view?usp=sharing)

# Statement

State the answer to the question found by encoding your puzzle input in the manner described above.


# References

Written by the CIGMAH Puzzle Hunt Team.

# Answer

The correct solution was `URACIL`.

# Explanation

# Map Hint

You wonder whether you would find any words in naturally sequenced data using this encoding method. 

You open the file `map_hint.txt`. It reads:

```
The exit room is the end labelled L-V. 
```

That might be useful. 

# Writer's Notes

Unfortunately, we didn't get much time to do a full writeup, but perhaps we will return to do it sometime. The "code" theme tie-in for this puzzle was genetic code and unicode. This manner of encoding FASTA nucleobase strings is not particularly useful, but was a simple way to introduce a tie-in between nucleobases and character encoding. 

Here is an example solution in Python:

```python
with open('cgmnt_input21.txt') as infile:
    RAW = infile.read()
    
MAPPINGS = {k:f'{i:b}' for i, k in enumerate('ATCG')}
BINARY = iter([f'{int(MAPPINGS[c]):02d}' for c in RAW])
print(''.join([chr(int(''.join([start, next(BINARY), next(BINARY), next(BINARY)]), 2)) for start in BINARY]))
```

Here is the data generation code and a solution in J (the data is generated with the `decode` function which converts a UTF-8 string into ATCG bases, and the solution is the `encode` function which converts ATCG bases into a UTF-8 string): 

```j
Message =: 'What is the name of the nucleobase that may be found in RNA but not DNA? It starts with U and has six letters.'

NB. Generate the data
toBinary =: 0;@:(,"1)3#:@:u:]
encouple =: (1 0 $~#) (<;.1) ]
decode =:'ATCG' {~2 #. each encouple&toBinary
DecodedMessage =: decode Message
DecodedMessage fwrite < 'input.txt'

NB. Solution
enoctuple =: ] <;.1~ 0=8|i.&#
encode =: ;@:(u:&#. each)@enoctuple@;@#:@:('ATCG'&i.) 

```

