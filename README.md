# Thirst
Thirst is a concatenative programming language that uses proper polish notation and is based on linked lists instead of stacks.

As of this moment the interpreter is being prototyped in Lua. It is planned to be rewritten in Rust once the core is ready.

##Finished:
* most of the core
* simple arithmetics a al Lisp
* loops
* quotes
* quote evaluator
* conditional fork
* some tail recursion, needs testing

##Todo:
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