// scalac aoc18.scala && scala Aoc18
import scala.io.Source._
import scala.collection.mutable

object Aoc18 {
    // input parameters
    val grid_size = 70 + 1
    var fallen_bytes = 1024
    val filename = "input.txt"

    // other gloabal variables
    val grid: Array[Array[Int]] = Array.ofDim[Int](grid_size, grid_size)
    val visited: Array[Array[Int]] = Array.ofDim[Int](grid_size, grid_size)

    
    def main(
        args: Array[String]
    ): Unit = {
        // Day 18 of AOC 2024
        println("Day 18 of AOC 2024")
        // Part 1
        println("Part 1")

        // initialize grid
        for (i <- 0 until grid_size; j <- 0 until grid_size) {
            grid(i)(j) = 0
        }

        // read file
        val lines = fromFile(filename).getLines.toList
        if (fallen_bytes == -1) {
            fallen_bytes = lines.length
        }
        if (fallen_bytes > lines.length) {
            println("Fallen bytes are longer than file... this will crash")
        }
        // fill grid
        for (i <- 0 until fallen_bytes) {
            val split = lines(i).split(",")
            grid(split(1).toInt)(split(0).toInt) = 1
        }

        // start and end positions
        val pos_start: (Int, Int) = (0, 0)
        val pos_end: (Int, Int) = (grid_size - 1, grid_size - 1)

        // print grid
        //print_grid()

        // find shortest path length
        val path = shortest_path(pos_start, pos_end)
        val path_len = path.length - 1
        println(s"Shortest path is: $path_len")

        // Part 2
        println("Part 2")

        // fill more of the grid until there is no exit
        for (i <- fallen_bytes until lines.length) {
            // fill grid
            val split = lines(i).split(",")
            grid(split(1).toInt)(split(0).toInt) = 1

            // search for path
            val path_exists = shortest_path(pos_start, pos_end)
            if (path_exists.length == 0) {
                print("Coordinates to break the path are: ")
                println(lines(i))

                // no idea how to stop loop, just return from main function i guess...
                return
            }
        }
    }

    // function to print the grid
    def print_grid() = {
        for (i <- 0 until grid_size) {
            for (j <- 0 until grid_size) {
                if (grid(i)(j) == 0) {
                    print(".")
                } else {
                    print("#")
                }
            }
            println("")
        }
    }

    // find shortest path and return it
    def shortest_path(
        pos_start: (Int, Int),
        pos_end: (Int, Int)
    ) : List[(Int, Int)] = {
        val directions = List((0, 1), (1, 0), (0, -1), (-1, 0))
        val queue = mutable.Queue[(Int, Int, List[(Int, Int)])]()
        val seen = mutable.Set[(Int, Int)]()

        // start position
        queue.enqueue((pos_start._1, pos_start._2, List(pos_start)))
        seen.add(pos_start)

        // loop over queue
        while (queue.nonEmpty) {
            val (x, y, path) = queue.dequeue()

            // reached end
            if (x == pos_end._1 && y == pos_end._2) {
                return path
            }

            // do directions
            for ((dx, dy) <- directions) {
                val nx = x + dx
                val ny = y + dy

                if (nx >= 0 && ny >= 0 && nx < grid_size && ny < grid_size &&
                    grid(nx)(ny) == 0 && !seen.contains((nx, ny))) {

                    queue.enqueue((nx, ny, path :+ (nx, ny)))
                    seen.add((nx, ny))
                }
            }
        }
        
        // return empty list
        List.empty
    }
}















