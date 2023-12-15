# Define functions for GCD and LCM
function gcd(a, b) {
    while (b != 0) {
        t = b;
        b = a % b;
        a = t;
    }
    return a;
}

function lcm(a, b) {
    return (a * b) / gcd(a, b);
}

function get_lcm(numbers, result, i) {
    result = 1;
    for (i in numbers) {
        result = lcm(result, numbers[i]);
    }
    return result;
}

function find_cycle_length(instructions, network, location, p2, current, steps, i, condition) {
    current = location;
    steps = 0;
    i = 0;
    while (1) {
        current = network[current][substr(instructions, i + 1, 1)];
        steps++;
        if (p2) {
            condition = (substr(current, length(current)) == "Z");
        } else {
            condition = (current == "ZZZ");
        }

        if (condition) {
            return steps;
        }
        i = (i + 1) % length(instructions);
    }
}

function part_one(instructions, network, result) {
    return find_cycle_length(instructions, network, "AAA", 0);
}

function part_two(instructions, network, result, i) {
    result = 0;
    i = 1

    for (location in network) {
        if (substr(location, length(location)) == "A") {
            locations[i] = location;
            i++
        }
    }

    for (i = 1; i <= length(locations); i++) {
        cycle_lengths[i] = find_cycle_length(instructions, network, locations[i], 1);
    }

    return get_lcm(cycle_lengths);
}

BEGIN {
    i = 1
    while ((getline < "day8input.txt") > 0) {
        if (i == 1) {
            instructions = $0;
        } else if (i > 2) {
            split($0, parts, " = ");
            current = parts[1];
            split(substr(parts[2], 2, length(parts[2]) - 2), mapped, ", ");
            network[current]["L"] = mapped[1];
            network[current]["R"] = mapped[2];
        }
        i += 1
    }

    close("day8input.txt");

    print part_one(instructions, network);
    print part_two(instructions, network);
}
