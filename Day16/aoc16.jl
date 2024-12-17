# julia aoc16.jl
# Day 16 of AOC 2024
println("Day 16 of AOC 2024")
# Part 1
println("Part 1")

# read file
function read_grid(filename)
    lines = readlines(filename)

    grid = []
    pos_start = nothing
    pos_end = nothing

    for (i, line) in enumerate(lines)
        row = []
        for (j, char) in enumerate(line)
            if char == '#'
                push!(row, 1)
            elseif char == '.'
                push!(row, 0)
            elseif char == 'S'
                push!(row, 0)
                pos_start = (i, j)
            elseif char == 'E'
                push!(row, 0)
                pos_end = (i, j)
            end
        end
        push!(grid, row)
    end

    return grid, pos_start, pos_end
end

# print grid
function print_grid(grid, pos_start, pos_end)
    for (i, row_grid) in enumerate(grid)
        row = ""
        for (j, elem) in enumerate(row_grid)
            if (i, j) == pos_start
                row *= "S"
            elseif (i, j) == pos_end
                row *= "E"
            elseif elem == 1
                row *= "#"
            elseif elem == 0
                row *= "."
            end
        end
        println(row)
    end
end

# read grid
filename = "input.txt"
direction = 1  # 0: up, 1: right, 2: down, 3: left
score = 0
grid, pos_start, pos_end = read_grid(filename)
#print_grid(grid, pos_start, pos_end)

# state dictionary and end scores
state_dict = Dict()
end_score = nothing

# evolve grid
function evolve_grid(pos_start, direction, score, just_rotated)
    # global variables
    global grid
    global pos_end
    global state_dict
    global end_score

    #println(pos_start, direction, score)

    # do nothing if we are in a wall
    if grid[pos_start[1]][pos_start[2]] == 1
        return
    # check if we were here before and had a lower score
    elseif haskey(state_dict, (pos_start, direction))
        if state_dict[(pos_start, direction)] <= score
            return
        end
    # add to end score if we reached the end
    elseif pos_start == pos_end
        #println("End reached with score: ", score)
        if end_score == nothing
            end_score = score
        elseif score > end_score
            return
        elseif score < end_score
            end_score = score
        end
        return
    end

    # add score to dict
    state_dict[(pos_start, direction)] = score

    # move forward
    new_pos = nothing
    if direction == 0
        new_pos = (pos_start[1] - 1, pos_start[2])
    elseif direction == 1
        new_pos = (pos_start[1], pos_start[2] + 1)
    elseif direction == 2
        new_pos = (pos_start[1] + 1, pos_start[2])
    elseif direction == 3
        new_pos = (pos_start[1], pos_start[2] - 1)
    end
    evolve_grid(new_pos, direction, score + 1, 0)

    # do not rotate again if we already rotated - makes no sense
    if just_rotated == 1
        return
    end

    # rotate left
    evolve_grid(pos_start, (direction + 3) % 4, score + 1000, 1)

    # rotate right
    evolve_grid(pos_start, (direction + 1) % 4, score + 1000, 1)
end

# find end
evolve_grid(pos_start, direction, score, 0)

# find minimum score
println("Minimum score is: ", end_score)


# Part 2
println("Part 2")

# store best paths
state_dict = Dict()
best_paths = []

# evolve grid with path
function evolve_grid_with_path(pos_start, direction, score, path, just_rotated)
    # global variables
    global grid
    global pos_end
    global state_dict
    global best_paths
    global end_score

    # stop if score is too big
    if score > end_score
        return 
    # do nothing if we are in a wall
    elseif grid[pos_start[1]][pos_start[2]] == 1
        return
    # check if we were here before and had a lower score
    elseif haskey(state_dict, (pos_start, direction))
        if state_dict[(pos_start, direction)] < score
            return
        end
    # add to end score if we reached the end
    elseif pos_start == pos_end
        #println("End reached with score: ", score)
        #println(path)
        push!(path, (pos_start, direction, score))
        if score > end_score
            return
        end
        push!(best_paths, path)
        return
    end

    # add score to dict
    state_dict[(pos_start, direction)] = score
    push!(path, (pos_start, direction, score))

    # move forward
    new_pos = nothing
    if direction == 0
        new_pos = (pos_start[1] - 1, pos_start[2])
    elseif direction == 1
        new_pos = (pos_start[1], pos_start[2] + 1)
    elseif direction == 2
        new_pos = (pos_start[1] + 1, pos_start[2])
    elseif direction == 3
        new_pos = (pos_start[1], pos_start[2] - 1)
    end
    evolve_grid_with_path(new_pos, direction, score + 1, copy(path), 0)

    # do not rotate again if we already rotated - makes no sense
    if just_rotated == 1
        return
    end

    # rotate left
    evolve_grid_with_path(pos_start, (direction + 3) % 4, score + 1000, copy(path), 1)

    # rotate right
    evolve_grid_with_path(pos_start, (direction + 1) % 4, score + 1000, copy(path), 1)
end

# evolve grid (again)
evolve_grid_with_path(pos_start, direction, score, [], 0)

# calculate visited cells
visited_cells = Set()
for path in best_paths
    for cell in path
        push!(visited_cells, cell[1])
    end
end

println("Visited cells: ", length(visited_cells))

