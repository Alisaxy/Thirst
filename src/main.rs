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
    	Operator { operators: LinkedList::new(),
    			   operands: LinkedList::new() }
    }
    fn run<F: Fn(&Operand) -> Operand>(&mut self, callback: F) {
    	let mut iter = self.operands.iter();
    	loop {
	    	match iter.next() {
		        Some(x) => { callback(x); },
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

fn f(x: &Operand) -> Operand {
	Operand::Sentinel
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

	let mut a: &mut Fn(i32) -> i32;

	let mut op: Operator = Operator::new();
	op.feed(Operand::Number(777f64));
	op.feed(Operand::Symbol(String::from("hello")));


	op.run(|x: &Operand| -> Operand { 
		match *x {
			Operand::Number(y) => {
				
			},
			_ => {}
		}
		Operand::Sentinel
	});
}