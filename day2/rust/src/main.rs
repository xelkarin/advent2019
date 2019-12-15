use std::fs::File;
use std::io::BufReader;
use std::path::Path;
use std::path::PathBuf;
use std::io::prelude::*;
use std::env;

mod intcode;
use intcode::Intcode;

const DATAPATH: &str = "../../../data/input.txt";

fn main() {
    let mut data = read_data();
    let mut cpu = Intcode::new(&mut data);
    cpu.patch(0x01, 0x0c);
    cpu.patch(0x02, 0x02);
    println!("Intcode return value: {}", cpu.run());
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
