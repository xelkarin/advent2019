extern crate intcode;
use intcode::IntcodeCPU;

const DATAPATH: &str = "../../../data/input.txt";
const CPU_RESULT: isize = 19690720;

fn main() {
    let mut cpu = IntcodeCPU::read_data(DATAPATH);
    cpu.patch(0x01, 0x0c);
    cpu.patch(0x02, 0x02);
    println!("CPU return value for input 1202: {}", cpu.run());

    let (noun, verb) = cpu.run_expect(CPU_RESULT).unwrap();
    let input = 100 * noun + verb;
    println!("CPU input for {}: {}.", CPU_RESULT, input);
}
