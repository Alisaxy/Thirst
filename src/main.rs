use std::collections::LinkedList;

struct Operator {
	operators: LinkedList<Operator>,
	operands: LinkedList<Operand>
}

impl Operator {
    fn feed(&mut self, operand: Operand) { 
    	self.operands.push_back(operand);
    }
    fn new() -> Operator { 
    	Operator { operators: LinkedList::new(), operands: LinkedList::new() }
    }
}

enum Operand {
    Number(f64),
    Symbol(Box<str>),
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

	let mut op: Operator = Operator::new();
	op.feed(Operand::Number(777f64));
}