# Rscript aoc9.r
# Day 9 of AOC 2024
cat("Day 9 of AOC 2024\n")
# Part 1
cat("Part 1\n")

filename <- "input.txt"
file <- readChar(filename,nchars=1e6)
chars <- strsplit(file, "")[[1]]
chars <- chars[-length(chars)]
ints <- as.integer(chars)
buffer_len <- sum(ints)
buffer <- array(-1, dim=c(buffer_len))

#print(ints)
#print(buffer_len)
#print(buffer)

# fill buffer
idx <- 1
disk_idx <- 0
space <- FALSE
for (int in ints) {
    #print(int)
    if (!space) {
        for (x in 0:(int - 1)) {
            #print(idx + x)
            buffer[idx + x] <- disk_idx 
        }
        disk_idx <- disk_idx + 1
    }
    space <- !space    
    idx <- idx + int
}
#print(space)
#print(buffer)

# sort buffer
start_y <- 1
for (x in buffer_len:1) {
    if (buffer[x] == -1) {
        next
    }
    if (x < start_y) {
        break
    }
    #cat("working on idx: ", x, "with val: ", buffer[x], "\n")
    for (y in start_y:x) {
        if (buffer[y] == -1) {
            buffer[y] <- buffer[x]
            buffer[x] <- -1
            start_y <- y + 1
            break
        }
    }    
}
#print(buffer)

# sum up
buffer_sum <- 0
for (x in 1:buffer_len) {
    if (buffer[x] == -1) {
        next
    }
    buffer_sum <- buffer_sum + (x - 1) * buffer[x]
}

cat("The checksum is: ", format(buffer_sum, scientific=F), "\n")


# Part 2
cat("Part 2\n")

# refill buffer
buffer <- array(-1, dim=c(buffer_len))
idx <- 1
disk_idx <- 0
space <- FALSE
for (int in ints) {
    #print(int)
    if (!space) {
        for (x in 0:(int - 1)) {
            #print(idx + x)
            buffer[idx + x] <- disk_idx 
        }
        disk_idx <- disk_idx + 1
    }
    space <- !space    
    idx <- idx + int
}
#print(buffer)

# sort buffer
x <- buffer_len
while (x >= 1) {
    if (buffer[x] == -1) {
        x <- x - 1
        next
    }

    #cat("Working with: ", buffer[x], "\n")

    # get file length
    file_len <- 1
    for (f in (x - 1):1) {
        if (buffer[x] == buffer[f]) {
            file_len <- file_len + 1
        } else {
            break
        }
    }

    #cat("Length: ", file_len, "\n")
    
    # get first possible hole
    hole_start <- -1
    for (y in 1:x) {
        if (buffer[y] != -1) {
            next
        }
        hole_size <- 1
        for (h in (y + 1):x) {
            if (buffer[h] != -1) {
                break
            }
            hole_size <- hole_size + 1
        }
        #cat("hole size: ", hole_size, "\n")
        if (hole_size >= file_len) {
            hole_start <- y
            break
        }
    }

    #cat("Found hole at: ", hole_start, "\n")


    # skip if no hole size available
    if (hole_start == -1) {
        x <- x - file_len
        next
    }

    # move to hole
    for (i in hole_start:(hole_start + file_len - 1)) {
        buffer[i] <- buffer[x]
    }
    for (i in x:(x - (file_len - 1))) {
        buffer[i] <- -1
    }
    #print(buffer)
    x <- x - file_len
}
#print(buffer)

# sum up
buffer_sum <- 0
for (x in 1:buffer_len) {
    if (buffer[x] == -1) {
        next
    }
    buffer_sum <- buffer_sum + (x - 1) * buffer[x]
}

cat("The checksum is: ", format(buffer_sum, scientific=F), "\n")




