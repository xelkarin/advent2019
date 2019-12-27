extern crate intcode;
use intcode::IntcodeCPU;

const DATAPATH: &str = "../../../data/input.txt";

fn main() {
    let mut cpu = IntcodeCPU::read_data(DATAPATH);
    cpu.run();
}
