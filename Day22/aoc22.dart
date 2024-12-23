// dart run aoc22.dart
import 'dart:async';
import 'dart:io';
import 'dart:convert';

// Quadruple
class Quadruple {
    final int a, b, c, d;
    Quadruple(this.a, this.b, this.c, this.d);
    int mapToInt() {
        return a * 1000 + b * 100 + c * 10 + d;
    }
}

// mix function
int mix(int secret, int number) {
    return secret ^ number;
}

// prune function
int prune(int secret) {
    return secret % 16777216;
}

// get next secret value
int next_secret(int secret) {
    secret = mix(secret, secret * 64);
    secret = prune(secret);
    secret = mix(secret, secret ~/ 32);
    secret = prune(secret);
    secret = mix(secret, secret * 2048);
    secret = prune(secret);

    return secret;
}

// get list of secrets
list_secret(var secret, int iters) {
    if (iters == 0) {
        return secret;
    }
    secret.add(next_secret(secret.last));
    return list_secret(secret, iters - 1);
}

// get last digits of lists
last_digit_list(var list) {
    var new_list = [];
    list.forEach((elem) {
        new_list.add(elem % 10);
    });
    return new_list;
}

// get differences of list
get_diff_list(var list) {
    var new_list = [];
    for(int i = 1; i < list.length; i++) {
        new_list.add(list[i] - list[i - 1]);
    }
    return new_list;
}

// fill map
void fill_map(var list, var map) {
    // get last digits and difference digits
    var digit_list = last_digit_list(list);
    var diff_list = get_diff_list(digit_list);

    // fill local map
    Map<String, int> map_loc = {};
    for (int i = 4; i < digit_list.length; i++) {
        String key = diff_list.sublist(i - 4, i).join();
        if (!map_loc.containsKey(key)) {
            map_loc[key] = digit_list[i];
        }
    }

    // update map
    map_loc.forEach((key, val) {
        if (map.containsKey(key)) {
            map[key] = map[key] + val;
        } else {
            map[key] = val;
        }
    });
}

void main() async {
    // Day 22 of AOC 2024
    print('Day 22 of AOC 2024');
    // Part 1 & 2
    print('Part 1 & 2');

    // input parameters
    var path = 'input.txt';
    var file = new File(path);
    var lines = await file.readAsLines();
    int iters = 2000;

    // get map
    Map<String, int> banana_map = {};

    // read file
    num secret_sum = 0;
    lines.forEach((line) {
        var list = list_secret([int.parse(line)], iters);
        secret_sum += list.last;
        fill_map(list, banana_map);
    });

    print('Part 1: Secret sum is: $secret_sum');

    var max_banana = 0;
    banana_map.forEach((key, val) {
        if (val > max_banana) {
            max_banana = val;
        }
    });

    print('Part 2: Maximum bananas is: $max_banana');
}
