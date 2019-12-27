use std::fs::File;
use std::io::BufReader;
use std::path::{Path,PathBuf};
use std::io::prelude::*;

use std::env;
use std::fmt;

use crate::op_code::{Mneumonic,OpCode};

type ExpectResult = (isize, isize);

pub struct IntcodeCPU {
    ip: usize,
    mem: Vec<isize>,
    data: Vec<isize>
}

impl IntcodeCPU {
    pub fn new(data: Vec<isize>) -> IntcodeCPU {
        IntcodeCPU { ip: 0, mem: data.clone(), data: data }
    }

    pub fn read_data(datapath: &str) -> IntcodeCPU {
        let arg0 = env::args().next().unwrap();
        let exepath = Path::new(&arg0).parent().unwrap();
        let datapath: PathBuf =
            [ exepath.to_str().unwrap(), datapath ].iter().collect();

        let file = File::open(datapath).unwrap();
        let mut reader = BufReader::new(file);
        let mut s = String::new();
        reader.read_to_string(&mut s).unwrap();

        let data = s.trim().split(',')
            .map(|v| v.parse::<isize>().unwrap())
            .collect();

        IntcodeCPU::new(data)
    }

    #[inline]
    pub fn reset(&mut self) {
        self.ip = 0;
        self.mem = self.data.clone();
    }

    #[inline]
    pub fn patch(&mut self, addr: usize, value: isize) {
        self.mem[addr] = value;
    }

    pub fn run(&mut self) -> isize {
        let mut op_code = OpCode::from(self.mem[self.ip]);
        while op_code != Mneumonic::Halt {
            self.ip = op_code.exec(self.ip, &mut self.mem);
            op_code = OpCode::from(self.mem[self.ip]);
        }
        self.mem[0]
    }

    pub fn run_expect(&mut self, value: isize) -> Option<ExpectResult> {
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
}

impl fmt::Debug for IntcodeCPU {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        write!(f, "IntcodeCPU {{ ip: {} }}", self.ip)
    }
}
