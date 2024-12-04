// go build aoc4.go && ./aoc4
package main
import (
    "fmt"
    "os"
    "strings"
)

func main() {
    // Day 4 of AOC 2024
    fmt.Println("Day 4 of AOC 2024")

    // Part 1
    fmt.Println("Part 1")

    search_word := "XMAS"

    // read input file
    file_b, _ := os.ReadFile("input.txt")
    file := string(file_b)
    //fmt.Printf("file content:\n%s\n", file)

    // split into lines
    lines := strings.Split(file, "\n")
    lines = lines[:len(lines) - 1]
    //fmt.Println("Split: ", lines)

    // get row and column count
    rows := len(lines)
    columns := len(lines[0])    
    //fmt.Println("Rows: ", rows, " & Columns: ", columns)
    if rows != columns {
        fmt.Println("Rows(", rows, ") should equal columns(", columns, ")!\nAborting...")
        os.Exit(1)
    }

    // search horizontal
    sh := search_h(lines, rows, search_word)
    //fmt.Println("sh: ", sh)

    // search horizontal reversed
    shr := search_h_rev(lines, rows, search_word)
    //fmt.Println("shr: ", shr)

    // search vertical
    sv := search_v(lines, rows, search_word)
    //fmt.Println("sv: ", sv)

    // search vertical reversed
    svr := search_v_rev(lines, rows, search_word)
    //fmt.Println("svr: ", svr)

    // search diagonal 1
    sd1 := search_d1(lines, rows, search_word)
    //fmt.Println("sd1: ", sd1)

    // search diagonal 1 reversed
    sd1r := search_d1_rev(lines, rows, search_word)
    //fmt.Println("sd1r: ", sd1r)

    // search diagonal 2
    sd2 := search_d2(lines, rows, search_word)
    //fmt.Println("sd2: ", sd2)

    // search diagonal 2 reversed
    sd2r := search_d2_rev(lines, rows, search_word)
    //fmt.Println("sd2r: ", sd2r)

    st := sh + shr + sv + svr + sd1 + sd1r + sd2 + sd2r
    fmt.Println("Total occurances of \"", search_word, "\" is ", st)

    // Part 2
    fmt.Println("Part 2")
    sc := search_cross(lines, rows)
    fmt.Println("Total occurances of X-\"MAS\" is ", sc)
}

// search grid horizontal
func search_h(grid []string, size int, search_word string) int {
    search_word_len := len(search_word)
    occurances := 0

    //fmt.Println("Grid: ", grid)
    //fmt.Println("Size: ", size)
    //fmt.Println("Search word: ", search_word)

    for r := 0; r < size; r++ {
        //fmt.Println("\nr=", r)
        for i := 0; i <= size - search_word_len; i++ {
            word_flag := true
            //fmt.Printf("%c", grid[r][i])     
            for j := 0; j < search_word_len; j++ {
                if grid[r][i + j] != search_word[j] {
                    word_flag = false
                    break
                }
            }
            if word_flag {
                occurances++
            }
        }
    }

    //fmt.Println("Occurances: ", occurances)
    return occurances
}

// search grid horizontal (reversed)
func search_h_rev(grid []string, size int, search_word string) int {
    search_word_len := len(search_word)
    occurances := 0

    for r := 0; r < size; r++ {
        //fmt.Println("\nr=", r)
        for i := size - 1; i >= search_word_len - 1; i-- {
            word_flag := true 
            //fmt.Printf("%c", grid[r][i])  
            for j := 0; j < search_word_len; j++ {
                if grid[r][i - j] != search_word[j] {
                    word_flag = false
                    break
                }
            }
            if word_flag {
                occurances++
            }
        }
    }

    return occurances
}

// search grid vertical
func search_v(grid []string, size int, search_word string) int {
    search_word_len := len(search_word)
    occurances := 0

    for c := 0; c < size; c++ {
        //fmt.Println("\nc=", c)
        for i := 0; i <= size - search_word_len; i++ {
            word_flag := true
            //fmt.Printf("%c", grid[i][c])     
            for j := 0; j < search_word_len; j++ {
                if grid[i + j][c] != search_word[j] {
                    word_flag = false
                    break
                }
            }
            if word_flag {
                occurances++
            }
        }
    }

    return occurances
}

// search grid vertical (reversed)
func search_v_rev(grid []string, size int, search_word string) int {
    search_word_len := len(search_word)
    occurances := 0

    for c := 0; c < size; c++ {
        //fmt.Println("\nc=", c)
        for i := size - 1; i >= search_word_len - 1; i-- {
            word_flag := true 
            //fmt.Printf("%c", grid[i][c])  
            for j := 0; j < search_word_len; j++ {
                if grid[i - j][c] != search_word[j] {
                    word_flag = false
                    break
                }
            }
            if word_flag {
                occurances++
            }
        }
    }

    return occurances
}

// search grid diagonal 1
func search_d1(grid []string, size int, search_word string) int {
    search_word_len := len(search_word)
    occurances := 0

    for d := 0; d < 2 * size - 1; d++ {
        //fmt.Println("d: ", d)
        // calculate length of diagonal
        d_len := d + 1
        if d > size - 1 {
            d_len = 2 * (size - 1) - d + 1
        }
        //fmt.Println("len(diag): ", d_len)

        // skip if diagonal is too short
        if d_len < search_word_len {
            continue
        }

        // calculate start column and start row
        sr := size - 1 - d
        if d >= size - 1 {
            sr = 0
        }
        //fmt.Println("sr: ", sr)

        sc := d - (size - 1)
        if d < size - 1 {
            sc = 0
        }
        //fmt.Println("sc: ", sc)

        for i := 0; i <= d_len - search_word_len; i++ {
            word_flag := true
            //fmt.Printf("%c", grid[sr + i][sc + i])     
            for j := 0; j < search_word_len; j++ {
                if grid[sr + i + j][sc + i + j] != search_word[j] {
                    word_flag = false
                    break
                }
            }
            if word_flag {
                occurances++
            }
        }
    }

    return occurances
}

// search grid diagonal 1 (reversed)
func search_d1_rev(grid []string, size int, search_word string) int {
    search_word_len := len(search_word)
    occurances := 0

    for d := 0; d < 2 * size - 1; d++ {
        // calculate length of diagonal
        d_len := d + 1
        if d > size - 1 {
            d_len = 2 * (size - 1) - d + 1
        }

        // skip if diagonal is too short
        if d_len < search_word_len {
            continue
        }

        // calculate start column and start row
        sr := size - 1 - d
        if d >= size - 1 {
            sr = 0
        }

        sc := d - (size - 1)
        if d < size - 1 {
            sc = 0
        }

        for i := d_len - 1; i >= search_word_len - 1; i-- {
            word_flag := true
            //fmt.Printf("%c", grid[sr + i][sc + i])     
            for j := 0; j < search_word_len; j++ {
                if grid[sr + i - j][sc + i - j] != search_word[j] {
                    word_flag = false
                    break
                }
            }
            if word_flag {
                occurances++
            }
        }
    }

    return occurances
}

// search grid diagonal 2
func search_d2(grid []string, size int, search_word string) int {
    search_word_len := len(search_word)
    occurances := 0

    for d := 0; d < 2 * size - 1; d++ {
        //fmt.Println("d: ", d)
        // calculate length of diagonal
        d_len := d + 1
        if d > size - 1 {
            d_len = 2 * (size - 1) - d + 1
        }
        //fmt.Println("len(diag): ", d_len)

        // skip if diagonal is too short
        if d_len < search_word_len {
            continue
        }

        // calculate start column and start row
        sr := size - 1 - d
        if d >= size - 1 {
            sr = 0
        }
        //fmt.Println("sr: ", sr)

        sc := 2 * (size - 1) - d
        if d < size - 1 {
            sc = size - 1
        }
        //fmt.Println("sc: ", sc)

        for i := 0; i <= d_len - search_word_len; i++ {
            word_flag := true
            //fmt.Printf("%c", grid[sr + i][sc - i])     
            for j := 0; j < search_word_len; j++ {
                if grid[sr + i + j][sc - i - j] != search_word[j] {
                    word_flag = false
                    break
                }
            }
            if word_flag {
                occurances++
            }
        }
    }

    return occurances
}

// search grid diagonal 2 (reversed)
func search_d2_rev(grid []string, size int, search_word string) int {
    search_word_len := len(search_word)
    occurances := 0

    for d := 0; d < 2 * size - 1; d++ {
        // calculate length of diagonal
        d_len := d + 1
        if d > size - 1 {
            d_len = 2 * (size - 1) - d + 1
        }

        // skip if diagonal is too short
        if d_len < search_word_len {
            continue
        }

        // calculate start column and start row
        sr := size - 1 - d
        if d >= size - 1 {
            sr = 0
        }

        sc := 2 * (size - 1) - d
        if d < size - 1 {
            sc = size - 1
        }

        for i := d_len - 1; i >= search_word_len - 1; i-- {
            word_flag := true
            //fmt.Printf("%c", grid[sr + i][sc - i])     
            for j := 0; j < search_word_len; j++ {
                if grid[sr + i - j][sc - i + j] != search_word[j] {
                    word_flag = false
                    break
                }
            }
            if word_flag {
                occurances++
            }
        }
    }

    return occurances
}

// search grid for X-MAS
func search_cross(grid []string, size int) int {
    occurances := 0

    for r := 1; r < size - 1; r++ {
        for c:= 1; c < size - 1; c++ {
            // check if "A" is the center point
            if grid[r][c] != 'A' {
                continue
            }
            
            // check how often "M" and "S" surround the "A"
            n := 0
            if grid[r - 1][c - 1] == 'M' && grid[r + 1][c + 1] == 'S' {
                n++
            }
            if grid[r + 1][c + 1] == 'M' && grid[r - 1][c - 1] == 'S' {
                n++
            }
            if grid[r + 1][c - 1] == 'M' && grid[r - 1][c + 1] == 'S' {
                n++
            }
            if grid[r - 1][c + 1] == 'M' && grid[r + 1][c - 1] == 'S' {
                n++
            }
            if n == 2 {
                occurances++
            }
        }
    }

    return occurances
}









