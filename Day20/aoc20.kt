// kotlinc aoc20.kt -include-runtime -d aoc20.jar && java -jar aoc20.jar
import java.io.File
import java.util.Queue
import java.util.LinkedList
import kotlin.math.abs

// function to read grid from file
fun readGrid(
    filename: String
): Triple<Array<IntArray>, Pair<Int, Int>, Pair<Int, Int>> {
    val lines = File(filename).readLines()
    val grid = Array(lines.size) {
        row -> IntArray(lines[row].length) {
            col -> when (lines[row][col]) {
                '#' -> 1
                '.', 'S', 'E' -> 0
                else -> throw IllegalArgumentException("Invalid character in input")
            }
        }
    }

    var posStart: Pair<Int, Int>? = null
    var posEnd: Pair<Int, Int>? = null

    for (row in lines.indices) {
        for (col in lines[row].indices) {
            when (lines[row][col]) {
                'S' -> posStart = Pair(row, col)
                'E' -> posEnd = Pair(row, col)
            }
        }
    }

    if (posStart == null || posEnd == null) {
        throw IllegalArgumentException("No start or end position available")
    }

    return Triple(grid, posStart, posEnd)
}

// find length shortest path and return it (if path exists, otherwise -1)
fun shortestpathLen(
    grid: Array<IntArray>,
    posStart: Pair<Int, Int>,   
    posEnd: Pair<Int, Int>
): Int {
    val directions = listOf(Pair(0, 1), Pair(1, 0), Pair(0, -1), Pair(-1, 0))
    val queue = LinkedList<Triple<Int, Int, Int>>() // (x, y, len)
    val seen = mutableSetOf<Pair<Int, Int>>() // (x, y)

    val gridX = grid.size
    val gridY = grid[0].size

    // start position
    queue.add(Triple(posStart.first, posStart.second, 0))
    seen.add(posStart)

    // loop over queue
    while (queue.isNotEmpty()) {
        val (x, y, len) = queue.poll()

        // reached end
        if (x == posEnd.first && y == posEnd.second) {
            return len
        }

        // do directions
        for ((dx, dy) in directions) {
            val nx = x + dx
            val ny = y + dy

            if (nx >= 0 && ny >= 0 && nx < gridX && ny < gridY &&
                grid[nx][ny] == 0 && !seen.contains(Pair(nx, ny))) {

                queue.add(Triple(nx, ny, len + 1))
                seen.add(Pair(nx, ny))
            }
        }
    }

    // no possible solution
    return -1
}

// find length shortest path with maxCheats and return it
fun shortestpathLenCheat(
    grid: Array<IntArray>,
    posStart: Pair<Int, Int>,
    maxCheats: Int,
    saveLen: Int
): Int {
    val directions = listOf(Pair(0, 1), Pair(1, 0), Pair(0, -1), Pair(-1, 0))
    val queue = mutableListOf(posStart)
    val dist = mutableMapOf<Pair<Int, Int>, Int>()
    dist[posStart] = 0

    val gridX = grid.size
    val gridY = grid[0].size

    // loop over queue
    while (queue.isNotEmpty()) {
        val (x, y) = queue.removeAt(0)
        val curDist = dist[Pair(x, y)]!!

        // do directions
        for ((dx, dy) in directions) {
            val nx = x + dx
            val ny = y + dy

            if (nx >= 0 && ny >= 0 && nx < gridX && ny < gridY &&
                grid[nx][ny] == 0 && Pair(nx, ny) !in dist) {

                queue.add(Pair(nx, ny))
                dist[Pair(nx, ny)] = curDist + 1
            }
        }
    }

    //println("Distances from start: $dist")

    // collect reachable points
    val points = dist.keys.toList()
    var count = 0

    // check for valid paths with cheats
    for (i in points.indices) {
        for (j in i + 1 until points.size) {
            val mhDist = abs(points[i].first - points[j].first) + abs(points[i].second - points[j].second)
            val diffDist = abs(dist[points[i]]!! - dist[points[j]]!!)

            //println("Checking points: ${points[i]} and ${points[j]}")
            //println("MhDist: $mhDist, diffDist: $diffDist")

            if (mhDist <= maxCheats && diffDist - mhDist >= saveLen) {
                //println("-> Valid path between ${points[i]} and ${points[j]}")
                count++
            }
        }
    }

    return count
}

// modify grid horizontally
fun cheatPathsOnce(
    grid: Array<IntArray>,
    posStart: Pair<Int, Int>,
    posEnd: Pair<Int, Int>
): MutableList<Int> {
    val pathLens: MutableList<Int> = mutableListOf()
    val gridX = grid.size
    val gridY = grid[0].size

    // do one cheat
    for (x in 1 until gridX - 1) {
        for (y in 1 until gridY - 1) {
            if (grid[x][y] == 1) {
                grid[x][y] = 0
                pathLens.add(shortestpathLen(grid, posStart, posEnd))
                grid[x][y] = 1
            }
        }
    }

    return pathLens
}

// check for shorter paths
fun checkCheatOnce(
    grid: Array<IntArray>,
    posStart: Pair<Int, Int>,
    posEnd: Pair<Int, Int>,
    saving: Int
): Int {
    val initLen = shortestpathLen(grid, posStart, posEnd)
    val cheatLens = cheatPathsOnce(grid, posStart, posEnd)
    var courses = 0

    for (cheatLen in cheatLens) {
        val saved = initLen - cheatLen
        if (saved >= saving) {
            //println("saved $saved")
            courses++
        }
    }

    return courses
}

fun main() {
    // Day 20 of AOC 2024
    println("Day 20 of AOC 2024")
    // Part 1
    println("Part 1")

    // read file
    val (grid, posStart, posEnd) = readGrid("input.txt")

    //grid.forEach{
    //    row -> println(row.joinToString(""))
    //}
    //println("Position start: $posStart")
    //println("Position start: $posEnd")

    // first implementation of Part 1
    //val coursesTwo = checkCheatOnce(grid, posStart, posEnd, 100)
    //println("There are $coursesTwo courses")

    
    val coursesTwoFast = shortestpathLenCheat(grid, posStart, 2, 100)
    println("There are $coursesTwoFast courses")

    // Part 2
    println("Part 2")

    val coursesTwentyFast = shortestpathLenCheat(grid, posStart, 20, 100)
    println("There are $coursesTwentyFast courses")
}
