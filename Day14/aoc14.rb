# ruby aoc14.rb

# Day 14 of AOC 2024
puts "Day 14 of AOC 2024"

# Part 1
puts "Part 1"

pos_x = []
pos_y = []
vel_x = []
vel_y = []

max_x = 101
max_y = 103

iterations = 100

# read file
File.open("input.txt", "r") do |file|
    file.each_line do |line|
        if match = line.match(/p=(-?\d+),(-?\d+) v=(-?\d+),(-?\d+)/)
            pos_x << match[1].to_i
            pos_y << match[2].to_i
            vel_x << match[3].to_i
            vel_y << match[4].to_i
        end
    end
end

# function for evolution 1 step
def evolve(pos_x, pos_y, vel_x, vel_y, max_x, max_y)
    n = pos_x.length() - 1
    for i in 0..n
        pos_x[i] = (pos_x[i] + vel_x[i]) % max_x
        pos_y[i] = (pos_y[i] + vel_y[i]) % max_y
    end
end

# print the grid
def print_grid(pos_x, pos_y, max_x, max_y)
    n = pos_x.length() - 1
    for y in 0..max_y - 1
        for x in 0..max_x - 1
            count = 0
            for i in 0..n
                if pos_x[i] == x and pos_y[i] == y
                    count += 1
                end
            end
            if count == 0
                print "."
            else
                print count
            end
        end
        puts ""
    end
end

# calculate safety factor
def safety_factor(pos_x, pos_y, max_x, max_y)
    n = pos_x.length() - 1
    dx = max_x / 2
    dy = max_y / 2

    sec1 = 0
    sec2 = 0
    sec3 = 0
    sec4 = 0
    for i in 0..n
        if pos_x[i] < dx
            if pos_y[i] < dy
                sec1 += 1
            elsif pos_y[i] > dy
                sec2 += 1
            end
        elsif pos_x[i] > dx
            if pos_y[i] < dy
                sec3 += 1
            elsif pos_y[i] > dy
                sec4 += 1
            end
        end
    end

    return sec1 * sec2 * sec3 * sec4
end

#puts "Grid to start"
#print_grid(pos_x, pos_y, max_x, max_y)

for i in 1..iterations
    evolve(pos_x, pos_y, vel_x, vel_y, max_x, max_y)
    #puts "Grid at iteration i=#{i}"
    #print_grid(pos_x, pos_y, max_x, max_y)
end

#puts "Grid at end"
#print_grid(pos_x, pos_y, max_x, max_y)

sf = safety_factor(pos_x, pos_y, max_x, max_y)
puts "Safety factor: #{sf}"


# Part 2
puts "Part 2"

# check if there are a couple of 1s in the output
def find_tree(pos_x, pos_y, max_x, max_y)
    n = pos_x.length() - 1
    for y in 0..max_y - 1
        #line = ""
        for x in 0..max_x - 1
            count = 0
            for i in 0..n
                if pos_x[i] == x and pos_y[i] == y
                    count += 1
                end
            end
            #if count == 0
            #    line = line + "."
            #else
            #    line = line + "*"
            #end
        end
        #if line.include? "********"
        #    return true
        #end
    end
    return false
end

pos_x = []
pos_y = []
vel_x = []
vel_y = []
sfs = []

# read file again
File.open("input.txt", "r") do |file|
    file.each_line do |line|
        if match = line.match(/p=(-?\d+),(-?\d+) v=(-?\d+),(-?\d+)/)
            pos_x << match[1].to_i
            pos_y << match[2].to_i
            vel_x << match[3].to_i
            vel_y << match[4].to_i
        end
    end
end

for _ in 0..10000
    evolve(pos_x, pos_y, vel_x, vel_y, max_x, max_y)
    sfs << safety_factor(pos_x, pos_y, max_x, max_y)
end

_, idx = sfs.each_with_index.min
idx += 1




puts "Tree found after #{idx} seconds"

pos_x = []
pos_y = []
vel_x = []
vel_y = []

# read file again
File.open("input.txt", "r") do |file|
    file.each_line do |line|
        if match = line.match(/p=(-?\d+),(-?\d+) v=(-?\d+),(-?\d+)/)
            pos_x << match[1].to_i
            pos_y << match[2].to_i
            vel_x << match[3].to_i
            vel_y << match[4].to_i
        end
    end
end

for _ in 1..idx
    evolve(pos_x, pos_y, vel_x, vel_y, max_x, max_y)
end
print_grid(pos_x, pos_y, max_x, max_y)











