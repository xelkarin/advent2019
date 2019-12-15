use std::fmt;

#[derive(Eq,PartialEq)]
enum OpCode {
    Add  = 1,
    Mult = 2,
    Halt = 99
}

pub struct Intcode<'a> {
    pc: usize,
    r1: usize,
    r2: usize,
    ds: usize,
    mem: &'a mut [usize]
}

impl<'a> Intcode<'a> {
    pub fn new(data: &'a mut [usize]) -> Intcode {
        Intcode { pc: 0, r1: 0, r2: 0, ds: 0, mem: data }
    }

    pub fn patch(&mut self, addr: usize, value: usize) {
        self.mem[addr] = value;
    }

    pub fn run(&mut self) -> usize {
        while OpCode::from(self.mem[self.pc]) != OpCode::Halt { Self::exec(self); }
        self.mem[0]
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

impl fmt::Debug for Intcode<'_> {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(f, "Intcode {{ pc: {}, r1: {}, r2: {}, ds: {} }}",
               self.pc, self.r1, self.r2, self.ds)
    }
}
