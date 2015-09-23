# Word-Search Puzzle Generator

This is a simple library and utility for generating word-search puzzles
from vocabulary lists. The puzzles can be configured to allow words to
be hidden in various ways (diagonal, backwards), as well as to include a
message hidden in the unused squares. The puzzles are emitted as PDF
documents.

## Installation

Use RubyGems:

    $ gem install wordsearch

## Usage

The simplest way to use the tool is via the included command-line utility:

    $ wordsearch -h
    USAGE: bin/wordsearch [options] [words] [-]
        -r, --rows ROWS
        -c, --columns COLS
        -b, --[no-]backward
        -d, --[no-]diagonal
        -o, --output FILENAME
        -f, --font FONT
        -s, --seed SEED
        -v, --[no-]solve
        -m, --message MESSAGE
        -w, --word-file FILE

Specify words in any of three ways; on the command-line:

    $ wordsearch nitwit blubber oddment tweak

Or in a separate file (each word on its own line):

    $ wordsearch -w words.txt

Or via `stdin`:

    $ cat dict | wordsearch -

Program arguments are:

* `--rows` : the number of rows in the grid (defaults to 15)
* `--columns` : the number of columns in the grid (defaults to 15)
* `--backward` : allow words to be spelled backwards on the grid
* `--diagonal` : allow words to be spelled diagonally on the grid
* `--output` : the name of the file to save the puzzle to (defaults to `puzzle.pdf`)
* `--font` : the name of a font to use to render the puzzle (defaults to `Helvetica`).
  You can use any PDF font (Helvetica, Times-Roman, Courier) or any TTF font
  by providing the full path name of the TTF file.
* `--seed` : the number used to seed the random number generator. By providing
  the same seed, you can (re)generate the same puzzle. This is particularly
  useful for encoding a message in the unused squares of a puzzle (see below).
* `--solve` : the generated PDF will consist of two pages, with the solution
  on the second page.
* `--message` : a message to encode in the unused squares of the puzzle. Non-letter
  characters are discarded. The resulting message should be the same length
  as the number of unused squares in the puzzle.
* `--word-file` : a text file containing words to use in the puzzle.

## Encoding Messages

To encode a message in the unused squares of a puzzle, first generate a
puzzle with the desired vocabulary list:

    $ wordsearch -w words.txt -r 10 -c 10
    seed: 1443047854
    unused squares: 15 (of 100)

Repeat until the desired number of unused squares are found (you want
a number of unused squares that matches the message you want to encode
in the puzzle). If we wanted to encode the message "Puzzles are fun!",
we would need 13 unused squares (spaces and punctuation are ignored).

Once you get a puzzle with the appropriate number of unused squares,
note the seed value:

    $ wordsearch -w words.txt -r 10 -c 10
    seed: 1443047875
    unused squares: 13 (of 100)

Then, generate it again, passing the `-m` (message) and `-s` (seed)
options:

    $ wordsearch -w words.txt -r 10 -c 10 -s 1443047875 -m "puzzles are fun"
    seed: 1443047875
    unused squares: 13 (of 100)

The resulting puzzle will spell out "puzzles are fun" with the squares
that are left after finding all the words!

(Note that if your message is longer than the number of unused squares,
it will be truncated, and if it is shorter, it will be padded with
random letters.)

## Caveats

No word may be too large to fit on the grid, or an error will result. Also,
trying to fit too many words into too small of a grid may take a very long
time, and will probably fail. If you get an error, or if the utility is
taking too long to generate the puzzle, try using a larger grid size.

## License

<a rel="license" href="http://creativecommons.org/licenses/by/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by/4.0/88x31.png" /></a>
<br />
<span xmlns:dct="http://purl.org/dc/terms/" property="dct:title">WordSearch Puzzle Generator</span> by <a xmlns:cc="http://creativecommons.org/ns#" href="http://weblog.jamisbuck.org" property="cc:attributionName" rel="cc:attributionURL">Jamis Buck</a> is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by/4.0/">Creative Commons Attribution 4.0 International License</a>.<br />Based on a work at <a xmlns:dct="http://purl.org/dc/terms/" href="http://github.com/jamis/wordsearch" rel="dct:source">http://github.com/jamis/wordsearch</a>.
