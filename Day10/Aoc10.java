// java Aoc10.java
import java.io.File;
import java.io.FileNotFoundException;
import java.util.Scanner;

public class Aoc10 {
    public static void main(String []args) {
        // Day 10 of AOC 2024
        System.out.println("Day 10 of AOC 2024");
        // Part 1
        System.out.println("Part 1");

        int rows = 0;
        int cols = 0;

        // read file
        try {
            File file_handle = new File("input.txt");

            // get grid dimensions
            Scanner file = new Scanner(file_handle);
            while (file.hasNextLine()) {
                rows++;
                String data = file.nextLine();
                cols = data.length();
            }
            //System.out.println("Rows: " + rows);
            //System.out.println("Cols: " + cols);

            int grid[][] = new int[rows][cols];

            // fill grid
            int r = 0;
            file = new Scanner(file_handle);
            while (file.hasNextLine()) {
                String data = file.nextLine();
                for (int c = 0; c < cols; c++) {
                    grid[r][c] = data.charAt(c) - '0';
                    //System.out.println(r + ", " + c + ": " + grid[r][c]);
                }
                r++;
            }

            //print2D(grid);

            // get zero positions
            int[][] zeros_pos = searchZeros(grid);
            //print2D(zeros_pos);

            // for each position search routes
            int paths = 0;
            for (int i = 0; i < zeros_pos.length; i++) {
                int paths_i = searchPaths(grid, zeros_pos[i]);
                //System.out.println("Pos (" + zeros_pos[i][0] + "," + zeros_pos[i][1] + "): " + paths_i + " paths");
                paths += paths_i;
            }

            System.out.println("End positions: " + paths);

            // Part 2
            System.out.println("Part 2");

            int paths_all = 0;
            for (int i = 0; i < zeros_pos.length; i++) {
                paths_all += searchPathsAll(grid, zeros_pos[i]);
            }

            System.out.println("All end positions: " + paths_all);

        // why we need to catch this in java - not good
        } catch (FileNotFoundException e) {
            System.out.println("An error occurred:");
            e.printStackTrace();
        }
    }

    // get grid dimensions
    public static int[] dimensions2D(int[][] grid) {
        int[] dims = {grid.length, grid[0].length};
        return dims;
    }

    // print the grid (2D array)
    public static void print2D(int[][] grid) {
        int[] dims = dimensions2D(grid);
        for (int r = 0; r < dims[0]; r++) {
            for (int c = 0; c < dims[1]; c++) {
                System.out.print(grid[r][c]);
            }
            System.out.println();
        }
    }

    // search for zeros in grid and return their positions as array of (x, y)
    public static int[][] searchZeros(int[][] grid) {
        int[] dims = dimensions2D(grid);
        int zeros = 0;
        for (int r = 0; r < dims[0]; r++) {
            for (int c = 0; c < dims[1]; c++) {
                if (grid[r][c] == 0) {
                    zeros++;
                }
            }
        }
        
        int[][] zeros_pos = new int[zeros][2];
        int i = 0;
        for (int r = 0; r < dims[0]; r++) {
            for (int c = 0; c < dims[1]; c++) {
                if (grid[r][c] == 0) {
                    zeros_pos[i][0] = r;
                    zeros_pos[i][1] = c;
                    i++;
                }
            }
        }

        return zeros_pos;
    }

    // search paths
    public static int searchPaths(int[][] grid, int[] pos) {
        int[][] paths = searchPathsH(grid, new int[][]{}, pos, 0);
        return paths.length;
    }

    // search paths (help function)
    public static int[][] searchPathsH(int[][] grid, int[][] prev_hills, int[] pos, int level) {
        int[] dims = dimensions2D(grid);
        int row = pos[0];
        int col = pos[1];


        // base cases
        if (row < 0 || row >= dims[0] || col < 0 || col >= dims[1]) {
            return prev_hills;
        }
        if (grid[row][col] != level) {
            return prev_hills;
        }

        // if we got to 9, check if it was seen before
        if (level == 9) {
            for (int i = 0; i < prev_hills.length; i++) {
                //System.out.println("i: " + i + ", prev_hills.length: " + prev_hills.length);
                //print2D(prev_hills);
                if (prev_hills[i][0] == row && prev_hills[i][1] == col) {
                    return prev_hills;
                }
            }
            int[][] hills = new int[prev_hills.length + 1][2];
            for (int i = 0; i < prev_hills.length; i++) {
                hills[i][0] = prev_hills[i][0];
                hills[i][1] = prev_hills[i][1];
            }
            hills[hills.length - 1][0] = row;
            hills[hills.length - 1][1] = col;

            return hills;
        }

        prev_hills = searchPathsH(grid, prev_hills, new int[]{row + 1, col}, level + 1);
        prev_hills = searchPathsH(grid, prev_hills, new int[]{row - 1, col}, level + 1);
        prev_hills = searchPathsH(grid, prev_hills, new int[]{row, col + 1}, level + 1);
        prev_hills = searchPathsH(grid, prev_hills, new int[]{row, col - 1}, level + 1);

        return prev_hills;
    }

    // search all paths
    public static int searchPathsAll(int[][] grid, int[] pos) {
        return searchPathsAllH(grid, pos, 0);
    }

    // search all paths (help function)
    public static int searchPathsAllH(int[][] grid, int[] pos, int level) {
        int[] dims = dimensions2D(grid);
        int row = pos[0];
        int col = pos[1];
        int paths = 0;

        // base cases
        if (row < 0 || row >= dims[0] || col < 0 || col >= dims[1]) {
            return 0;
        }
        if (grid[row][col] != level) {
            return 0;
        }

        // new 9 encountered
        if (level == 9) {
            return 1;
        }

        paths += searchPathsAllH(grid, new int[]{row + 1, col}, level + 1);
        paths += searchPathsAllH(grid, new int[]{row - 1, col}, level + 1);
        paths += searchPathsAllH(grid, new int[]{row, col + 1}, level + 1);
        paths += searchPathsAllH(grid, new int[]{row, col - 1}, level + 1);

        return paths;
    }


};






