use std::collections::LinkedList;

struct Operator {
    operators: LinkedList<Operator>,
    operands: LinkedList<Operand>,  // should be used as "return" to the next operator in line
    runner: Box<Fn(&Operand) -> Operand>  // should work on the stack directly, instead of on per operand basis
                                          // in which case should receive &mut self and return nothing
}

impl Operator { // make "Incremental Operator" type with all of the same traits for convenience
    fn new(runner: Box<Fn(&Operand) -> Operand>) -> Operator { 
        Operator { operators: LinkedList::new(),
                   operands: LinkedList::new(),
                   runner: runner }
    }
    fn feed(&mut self, operand: Operand) {
        self.operands.push_back(operand);
    }
    fn run(&mut self) {
        let mut iter = self.operands.iter();
        let ref runner = self.runner;
        loop {
               match iter.next() {
                   Some(x) => { runner(x); },
                   None => { break; }
            }
        }
    }
}

enum Operand {
    Number(f64),
    Symbol(String),
    Operator(Operator),
    Sentinel
}

fn main() {
    let mut a = LinkedList::new();
    let mut b = LinkedList::new();
    a.push_back(1);
    a.push_back(2);
    b.push_back(3);
    b.push_back(4);

    a.append(&mut b);

    for e in &a {
        println!("{}", e); // prints 1, then 2, then 3, then 4
    }
    println!("{}", b.len()); // prints 0

    let mut op: Operator = Operator::new(Box::new(|x: &Operand| -> Operand { 
        match *x {
            Operand::Number(y) => {
                println!("{:?}", y);
            },
            _ => { println!("fail!"); }
        }
        Operand::Sentinel
    }));
    op.feed(Operand::Number(777f64));
    op.feed(Operand::Symbol(String::from("hello")));

    op.run();
}
