# Thirst
Thirst is a concatenative programming language that uses proper polish notation and is based on linked lists instead of stacks.

Thirst was prototyped in lua which proved the concept and hence was abandoned in favor of a rewrite in a systems programming language. Rust was considered, but dropped because of very long development iteration cycles as compared to most other languages. A far more productive language was chosen and that language is Nim.

Syntax example (draft):
*	+ 1 2 3 * 10 3 / - 20 1 / ! [ ^ 2 3 ] / : 6 2 / /
*, where:
*	+|*|-|!|: are operators, respectively the summation, multiplication, substraction, evaluation and division
*	[ and ] are the special quote operator and its delimiter respectively
*	/ is the data-like delimiter
The biggest difference from other languages as of now is the fact that everything is data, which means everything.
The most notable case is that the delimiters themselves are data to and can be freely passed to operators as operands.
Delimiters serves a signals to the operators to consume its operand stack/list/vector and to return program control to
the next operand in the chain, together with the result which is a variable list. Thirst is thus even more homoiconic than Lisp where the parentheses lose their meaning after being parsed, which is really a shame. Just as with any concatenative language
everything is conceptually a function (implementations may differ for the sake of efficiency and simplicity).

To compile and run build and install the nim compiler suite (should be on the system path), navigate to the source directory and run: nim compile -r main.nim

##Finished (in the prototype):
* most of the core
* simple arithmetics a al Lisp
* loops
* quotes
* quote evaluator
* conditional fork
* some tail recursion, needs testing

##Todo:
* rewrite everything done so far in Nim
* rest of the core
* proper recursion from the language itself
* lists
* hash-maps
* string evaluator
* implement a pool hash-map per application and access restrictions on functions a la persistent databases only in memory to do away with the traditional scoping rules
* make powerful profiling and debugging tools
* port to a proper systems language such as Rust
* make embeddable
* implement a bytecode VM
* test everything thoroughly
* write the all encompassing language reference and an extensive documentation
* add safe concurrency (functional, slot-based)
* think on async programming, which should be interesting because one of Thirst' emerging properties could be just that
* implement optional incremental evaluation for functions that don't care about async

Inspired by: newLisp, Factor