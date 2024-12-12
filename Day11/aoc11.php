<?php
// php aoc11.php

// Day 11 of AOC 2024
echo("Day 11 of AOC 2024\n");
// Part 1
echo("Part 1\n");

// read integers from file
$file = fopen("input.txt", "r");
$input_line = fgets($file);
fclose($file);
$ints = array_map("intval", explode(" ", $input_line));
//print_r($ints);

// blinking
$blinks = 25;
for ($i = 0; $i < $blinks; $i++) {
    $new_ints = array();
    foreach ($ints as $int) {
        if ($int == 0) {
            array_push($new_ints, 1);
        } elseif (strlen((string)$int) % 2 == 0) {
            $digits = strlen((string)$int);
            $int_s = (string)$int;
            array_push($new_ints, (int)substr($int_s, 0, $digits / 2));
            array_push($new_ints, (int)substr($int_s, $digits / 2, $digits / 2));
        } else {
            array_push($new_ints, 2024 * $int);
        }
        
    }
    $ints = $new_ints;
    //print_r($ints);
}

echo("Number of stones after " . $blinks . " iterations: " . count($ints) . "\n");

// Part 2
echo("Part 2\n");

// keep visited stones in memory
$lookup = array();
function getStones(int $stone, int $blink) {
    global $lookup;
    if ($blink == 0) {
        return 1;
    }
    $key = (string)$stone . "." . (string)$blink;
    if(array_key_exists($key, $lookup)) {
        return $lookup[$key];
    }
    $val = 0;
    if ($stone == 0) {
        $val = getStones(1, $blink - 1);
    }
    elseif (strlen((string)$stone) % 2 == 0) {
        $digits = strlen((string)$stone);
        $stone_s = (string)$stone;
        $val = getStones((int)substr($stone_s, 0, $digits / 2), $blink - 1);
        $val += getStones((int)substr($stone_s, $digits / 2, $digits / 2), $blink - 1);
    }
    else {
        $val = getStones($stone * 2024, $blink - 1);
    }
    $lookup[$key] = $val;
    return $val;
}

// blinking
$ints = array_map("intval", explode(" ", $input_line));
$blinks = 75;
$stones = 0;
foreach($ints as $int) {
    $stones += getStones($int, $blinks);
    //echo("Done for Stone " . $int . "\n");
}

//echo("Dict length: " . count($lookup) . "\n");

echo("Number of stones after " . $blinks . " iterations: " . $stones . "\n");
?>
