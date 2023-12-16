def find_differences(seq)
  seq.each_cons(2).map { |a, b| b - a }
end

def calculate_differences(seq)
  differences = [find_differences(seq)]
  differences << find_differences(differences.last) until differences.last.all?(&:zero?)
  differences
end

def calculate_seq_num(sequence, forward = true)
  differences = calculate_differences(sequence)
  last_diff = differences.reverse_each.reduce(0) do |acc, diff|
    forward ? diff.last + acc : diff.first - acc
  end

  forward ? sequence.last + last_diff : sequence.first - last_diff
end

def part_one(data)
  data.sum { |sequence| calculate_seq_num(sequence) }
end

def part_two(data)
  data.sum { |sequence| calculate_seq_num(sequence, false) }
end

def main
  data = File.readlines("day9input.txt").map { |line| line.split.map(&:to_i) }

  puts "Part One: #{part_one(data)}"
  puts "Part Two: #{part_two(data)}"
end

main
