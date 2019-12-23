extern crate intcode;

use std::fs::File;
use std::io::BufReader;
use std::path::Path;
use std::path::PathBuf;
use std::io::prelude::*;
use std::env;

use intcode::IntcodeCPU;

const DATAPATH: &str = "../../../data/input.txt";
const CPU_RESULT: usize = 19690720;

fn main() {
    let data = read_data();
    let mut cpu = IntcodeCPU::new(data);
    cpu.patch(0x01, 0x0c);
    cpu.patch(0x02, 0x02);
    println!("CPU return value for input 1202: {}", cpu.run());

    let (noun, verb) = cpu.run_expect(CPU_RESULT).unwrap();
    let input = 100 * noun + verb;
    println!("CPU input for {}: {}.", CPU_RESULT, input);
}

fn read_data() -> Vec<usize> {
    let arg0 = env::args().next().unwrap();
    let exepath = Path::new(&arg0).parent().unwrap();
    let datapath: PathBuf =
        [ exepath.to_str().unwrap(), DATAPATH ].iter().collect();

    let file = File::open(datapath).unwrap();
    let mut reader = BufReader::new(file);
    let mut s = String::new();
    reader.read_to_string(&mut s).unwrap();

    s.trim().split(',')
        .map(|v| v.parse::<usize>().unwrap())
        .collect()
}
