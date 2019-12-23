use std::fmt;

type ExpectResult = (usize, usize);

#[derive(Eq,PartialEq)]
enum OpCode {
    Add  = 1,
    Mult = 2,
    Halt = 99
}

pub struct IntcodeCPU {
    pc: usize,
    r1: usize,
    r2: usize,
    ds: usize,
    mem: Vec<usize>,
    data: Vec<usize>
}

impl IntcodeCPU {
    pub fn new(data: Vec<usize>) -> IntcodeCPU {
        IntcodeCPU { pc: 0, r1: 0, r2: 0, ds: 0, mem: data.clone(), data: data }
    }

    #[inline]
    pub fn reset(&mut self) {
        self.pc = 0;
        self.r1 = 0;
        self.r2 = 0;
        self.ds = 0;
        self.mem = self.data.clone();
    }

    #[inline]
    pub fn patch(&mut self, addr: usize, value: usize) {
        self.mem[addr] = value;
    }

    pub fn run(&mut self) -> usize {
        while OpCode::from(self.mem[self.pc]) != OpCode::Halt { Self::exec(self); }
        self.mem[0]
    }

    pub fn run_expect(&mut self, value: usize) -> Option<ExpectResult> {
        let range = 0..=99;
        for noun in range.clone() {
            for verb in range.clone() {
                self.reset();
                self.patch(0x01, noun);
                self.patch(0x02, verb);
                if self.run() == value {
                    return Some((noun, verb));
                }
            }
        }
        None
    }

    fn exec(&mut self) {
        match OpCode::from(self.mem[self.pc]) {
            OpCode::Add  => {
                Self::load_operands(self);
                self.mem[self.ds] = self.mem[self.r1] +
                                    self.mem[self.r2];
            },
            OpCode::Mult => {
                Self::load_operands(self);
                self.mem[self.ds] = self.mem[self.r1] *
                                    self.mem[self.r2];
            },
            _ => panic!("Invalid OpCode")
        }
    }

    #[inline]
    fn load_operands(&mut self) {
        self.pc += 1; self.r1 = self.mem[self.pc];
        self.pc += 1; self.r2 = self.mem[self.pc];
        self.pc += 1; self.ds = self.mem[self.pc];
        self.pc += 1;
    }
}

impl From<usize> for OpCode {
    fn from(item: usize) -> Self {
        match item {
            1  => OpCode::Add,
            2  => OpCode::Mult,
            99 => OpCode::Halt,
            _ => panic!("Invalid OpCode")
        }
    }
}

impl fmt::Debug for IntcodeCPU {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        write!(f, "IntcodeCPU {{ pc: {}, r1: {}, r2: {}, ds: {} }}",
               self.pc, self.r1, self.r2, self.ds)
    }
}
