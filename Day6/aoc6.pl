# perl aoc6.pl
use strict;
use warnings;
use feature qw/say/;

# Day 6 of AOC 2024
print "Day 6 of AOC 2024\n";

# Part 1
print "Part 1\n";

my $filename = "input.txt";

# read matrix
sub read_matrix {
    my ($filename) = @_;
    my @matrix;
    my ($start_row, $start_col);

    open my $file, "<", $filename or die $!;
    my $row_idx = 0;

    while (my $line = <$file>) {
        chomp $line;
        my @row = ();
        for my $col_idx (0 .. length($line) - 1) {
            my $char = substr($line, $col_idx, 1);
            if ($char eq '^') {
                $start_row = $row_idx;
                $start_col = $col_idx;
                push @row, 2;
            } elsif ($char eq '#') {
                push @row, 1;
            } elsif ($char eq '.') {
                push @row, 0;
            } else {
                die "Unknown $char";
            } 
        }

        push @matrix, \@row;
        $row_idx++;
    }
    close $file;

    return (\@matrix, [$start_row, $start_col]);
}

# copy the matrix and index
sub copy {
    my ($matrix, $index) = @_;

    my @matrix_c = map{ [@$_] } @$matrix;
    my @index_c = @$index;

    return (\@matrix_c, \@index_c);
}

# print matrix
sub print_matrix {
    my ($matrix) = @_;
    foreach my $row (@$matrix) {
        print join(" ", @$row), "\n";
    }
}

# print guard
sub print_guard {
    my ($indices) = @_;
    my ($row, $col) = @$indices;
    print "Guard is located at ($row, $col)\n";
}

# move and update
sub move_update {
    my ($matrix, $position, $direction) = @_;
    my ($row, $col) = @$position;
    my ($n_row, $n_col) = ($row, $col);

    # direction 1: up, 2: right, 3: down, 4: left
    if ($direction == 1) { $n_row--; }
    elsif ($direction == 3) { $n_row++; }
    elsif ($direction == 2) { $n_col++; }
    elsif ($direction == 4) { $n_col--; }
    else { die "Invalid direction: $direction"; }

    if ($n_row < 0 || $n_row >= scalar @$matrix || $n_col < 0 || $n_col >= scalar @{$matrix->[0]}) {
        return 0;
    } else {
        if ($matrix->[$n_row][$n_col] != 1) {
            $matrix->[$n_row][$n_col] = 2;
            @$position = ($n_row, $n_col);
            return $direction;
        } else {
            $direction++;
            if ($direction > 4) { $direction = $direction - 4; }
            return $direction;
        }
    }    
}

# update loop
sub update_loop {
    my ($matrix, $position, $direction) = @_;

    while ($direction != 0) {
        #print_matrix($matrix);
        #print_guard($position);
        $direction = move_update($matrix, $position, $direction);
    }
}

# count fields
sub count_fields {
    my ($matrix) = @_;
    my $count = 0;

    for my $row (@$matrix) {
        for my $val (@$row) {
            if ($val == 2) {
                $count++;
            }
        }
    }

    return $count;
}

my $direction = 1;
my ($room, $guard) = read_matrix($filename);

my ($room_1, $guard_1) = copy($room, $guard);
update_loop($room_1, $guard_1, 1);
my $fields = count_fields($room_1);
print "Visited fields: $fields\n";

# Part 2
print "Part 2\n";

# matrix length
sub matrix_len {
    my ($matrix) = @_;
    return scalar @$matrix * scalar @{$matrix->[0]};
}

# index to indicies
sub idx_to_ind {
    my ($idx, $matrix) = @_;
    my $cols = scalar @{$matrix->[0]};

    return [int($idx / $cols), $idx % $cols];
}

# check infinite
sub check_infinite {
    my ($matrix, $position, $direction) = @_;
    my $direction_i = $direction;
    my @position_i = @$position;
    my $iter_max = matrix_len($matrix) * 4;
    my $iter_counter = 0;

    my $break_flag = 0;

    while ($break_flag == 0) {
        $iter_counter++;

        $direction = move_update($matrix, $position, $direction);

        if ($direction == $direction_i && $position->[0] == $position_i[0] && $position->[1] == $position_i[1]) {
            $break_flag = 1;
        }
        if ($direction == 0) { $break_flag = 1; }
        if ($iter_counter > $iter_max) { $break_flag = 1; }
    }
    return $direction;
}

# place obstacle
sub place_obstacle {
    my ($matrix, $idx) = @_;
    my $ind = idx_to_ind($idx, $matrix);
    #print_guard($ind);
    my ($row, $col) = @$ind;

    if ($matrix->[$row][$col] != 0) {
        return 1;
    } else {
        $matrix->[$row][$col] = 1;
        return 0;
    }
}

# count infinites
sub count_infinites {
    my ($matrix_i, $position_i, $direction_i) = @_;
    my $matrix_size = matrix_len($room);
    my $counter = 0;

    for my $idx (0 .. $matrix_size - 1) {
        my ($matrix, $position) = copy($matrix_i, $position_i);
        if (place_obstacle($matrix, $idx) == 0) {
            if (check_infinite($matrix, $position, 1) != 0) {
                $counter++;
            }
        }
    }

    return $counter;
}

my $loopholes = count_infinites($room, $guard, 1);
print "Loopholes: $loopholes\n";

