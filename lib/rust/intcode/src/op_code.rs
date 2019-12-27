use std::io::{stdin,stdout};
use std::io::Write;

#[derive(Clone,Copy,Debug,Eq,PartialEq)]
pub enum Mneumonic {
    Add,
    Mult,
    In,
    Out,
    Jnz,
    Jz,
    Stol,
    Stoe,
    Halt
}

#[derive(Clone,Copy,Debug,Eq,PartialEq)]
pub enum Mode { Mem, Imm }

pub struct OpCode {
    mne: Mneumonic,
    modes: [Mode; 3],
    size: u8
}

impl OpCode {
    pub fn exec(&self, ip: usize, mem: &mut [isize]) -> usize {
        use Mneumonic::*;

        match self.mne {
            Add  => Self::add_op(self, ip, mem),
            Mult => Self::mult_op(self, ip, mem),
            In   => Self::input(self, ip, mem),
            Out  => Self::output(self, ip, mem),
            Jnz  => Self::jump_if_true(self, ip, mem),
            Jz   => Self::jump_if_false(self, ip, mem),
            Stol => Self::store_if_less(self, ip, mem),
            Stoe => Self::store_if_equal(self, ip, mem),
            _    => 0
        }
    }

    #[inline]
    fn add_op(&self, ip: usize, mem: &mut [isize]) -> usize {
        let o = Self::load_operands(self, ip, mem);
        let addr = o[2] as usize;
        mem[addr] = o[0] + o[1];
        ip + self.size as usize
    }

    #[inline]
    fn mult_op(&self, ip: usize, mem: &mut [isize]) -> usize {
        let o = Self::load_operands(self, ip, mem);
        let addr = o[2] as usize;
        mem[addr] = o[0] * o[1];
        ip + self.size as usize
    }

    #[inline]
    fn input(&self, ip: usize, mem: &mut [isize]) -> usize {
        print!("? ");
        stdout().flush().unwrap();

        let o = Self::read_operands(self, ip, mem);
        let addr = o[0] as usize;
        let mut buf = String::new();
        stdin().read_line(&mut buf).unwrap();
        mem[addr] = buf.trim().parse().unwrap();
        ip + self.size as usize
    }

    #[inline]
    fn output(&self, ip: usize, mem: &[isize]) -> usize {
        let o = Self::load_operands(self, ip, mem);
        println!("{}", o[0]);
        ip + self.size as usize
    }

    #[inline]
    fn jump_if_true(&self, ip: usize, mem: &[isize]) -> usize {
        let o = Self::load_operands(self, ip, mem);
        if o[0] == 0 { ip + self.size as usize } else { o[1] as usize }
    }

    #[inline]
    fn jump_if_false(&self, ip: usize, mem: &[isize]) -> usize {
        let o = Self::load_operands(self, ip, mem);
        if o[0] == 0 { o[1] as usize } else { ip + self.size as usize }
    }

    #[inline]
    fn store_if_less(&self, ip: usize, mem: &mut [isize]) -> usize {
        let o = Self::load_operands(self, ip, mem);
        let addr = o[2] as usize;
        mem[addr] = if o[0] < o[1] { 1 } else { 0 };
        ip + self.size as usize
    }

    #[inline]
    fn store_if_equal(&self, ip: usize, mem: &mut [isize]) -> usize {
        let o = Self::load_operands(self, ip, mem);
        let addr = o[2] as usize;
        mem[addr] = if o[0] == o[1] { 1 } else { 0 };
        ip + self.size as usize
    }

    #[inline]
    fn read_operands<'t>(&self, ip: usize, mem: &'t [isize]) -> &'t [isize] {
        &mem[ip + 1 .. (ip + self.size as usize)]
    }

    #[inline]
    fn load_operands<'t>(&self, ip: usize, mem: &'t [isize]) -> Vec<isize> {
        use Mode::Mem;
        Self::read_operands(self, ip, mem).iter()
            .zip(&self.modes)
            .map(|(val, mode)| if *mode == Mem { mem[*val as usize] } else { *val })
            .collect()
    }
}

impl From<isize> for OpCode {
    fn from(item: isize) -> Self {
        use Mode::Imm;
        use Mneumonic::*;

        let code = item % 100;
        let mut modes = read_modes(item / 100);
        match code {
            1  => {
                modes[2] = Imm;
                OpCode { mne: Add,  modes, size: 4 }
            },

            2  => {
                modes[2] = Imm;
                OpCode { mne: Mult, modes, size: 4 }
            },

            3  => OpCode { mne: In,   modes, size: 2 },
            4  => OpCode { mne: Out,  modes, size: 2 },
            5  => OpCode { mne: Jnz,  modes, size: 3 },
            6  => OpCode { mne: Jz,   modes, size: 3 },

            7  => {
                modes[2] = Imm;
                OpCode { mne: Stol, modes, size: 4 }
            }

            8  => {
                modes[2] = Imm;
                OpCode { mne: Stoe, modes, size: 4 }
            },

            99 => OpCode { mne: Halt, modes, size: 1 },
            _ => panic!("Invalid OpCode")
        }
    }
}

fn read_modes(code: isize) -> [Mode; 3] {
    use Mode::*;

    let mut i = 0;
    let mut code = code;
    let mut modes = [Mem; 3];
    while code > 0 {
        let mode = if code % 10 == 1 { Imm } else { Mem };
        modes[i] = mode;
        i += 1;
        code /= 10;
    }
    modes
}

impl Eq for OpCode { }

impl PartialEq for OpCode {
    fn eq(&self, other: &Self) -> bool {
        self.mne == other.mne
    }
}

impl PartialEq<Mneumonic> for OpCode {
    fn eq(&self, other: &Mneumonic) -> bool {
        self.mne == *other
    }
}
