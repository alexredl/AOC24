use std::fs;

fn main() {
    // Day 2 of AOC 2024
    println!("Day 2 of AOC 2024");
    // Part 1
    println!("Part 1");

    let filepath = "input.txt";

    let file = fs::read_to_string(filepath).expect("Could not read file");
    //println!("File contents:\n{file}");

    let mut safe_counter: u32 = 0;

    for line in file.split("\n") {
        if line.is_empty() {
            continue;    
        }
        //println!("Line: {line}");

        let mut inc: u32 = 0;
        let mut dec: u32 = 0;
        let mut inc_flag = true;
        let mut dec_flag = true;
        for number_str in line.split(" ") {
            let number: u32 = number_str.parse().unwrap();
            //println!(" N: {number_str}, {number}");
            if inc == 0 && dec == 0 {
                inc = number;
                dec = number;
                continue;
            }

            if number > inc && number - inc <= 3 {
                inc = number;
            } else {
                inc_flag = false;
            }

            if number < dec && dec - number <= 3 {
                dec = number;
            } else {
                dec_flag = false;
            }
        }

        //println!("inc_flag: {inc_flag}\ndec_flag: {dec_flag}");
        if inc_flag || dec_flag {
            safe_counter += 1;
        }
    }

    println!("Safe counter: {safe_counter}");

   
    // Part 2
    println!("Part 2");

    let mut safe_counter_tolerate: u32 = 0;

    for line in file.split("\n") {
        if line.is_empty() {
            continue;    
        }
        //println!("Line: {line}");

        let mut inc: u32 = 0;
        let mut dec: u32 = 0;

        let mut line_len: u8 = 0;
        for _ in line.split(" ") {
            line_len += 1;
        }
        //println!("Number of elements: {line_len}");

        for j in 0..line_len + 1 {
            //println!("j={j}");
 
            let mut inc_i: u32 = 0;
            let mut dec_i: u32 = 0;
            let mut inc_flag_i = true;
            let mut dec_flag_i = true;

            let mut i: u8 = 0;
            for number_str in line.split(" ") {
                if i == j {
                    i += 1;
                    continue;
                }
                i += 1;
                //print!(" {number_str}");

                let number: u32 = number_str.parse().unwrap();
                //println!(" N: {number_str}, {number}");
                if inc_i == 0 && dec_i == 0 {
                    inc_i = number;
                    dec_i = number;
                    continue;
                }

                if number > inc_i && number - inc_i <= 3 {
                    inc_i = number;
                } else {
                    inc_flag_i = false;
                }

                if number < dec_i && dec_i - number <= 3 {
                    dec_i = number;
                } else {
                    dec_flag_i = false;
                }
            }
            //println!("");

            //println!("inc_flag_i: {inc_flag_i}\ndec_flag_i: {dec_flag_i}");
            if inc_flag_i {
                inc += 1;
            }
            if dec_flag_i {
                dec += 1;
            }
        }

        //println!("inc: {inc}\ndec: {dec}");
        if inc > 0 || dec > 0 {
            //println!("safe");
            safe_counter_tolerate += 1;
        } else {            
            //println!("unsafe");
        }
    }



    println!("Safe counter tolerate: {safe_counter_tolerate}");
}
