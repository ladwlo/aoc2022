require 'set'

class Valve
  attr_reader :id, :rate, :links
  attr_accessor :distance

  def initialize(id, rate_str, links_str)
    @id = id
    @rate = rate_str.to_i
    @links = links_str.split(', ').each_with_object({}) { |id, links| links[id] = 1 }
  end
end

graph = File.readlines('input/day16.txt')
            .map(&:rstrip)
            .map { |s| s.split(/Valve | has flow rate=|; tunnels? leads? to valves? /) }
            .map { |_, v, f, t| [v, Valve.new(v, f, t)] }
            .to_h

# reduce the graph, eliminating redundant nodes
valves_to_remove = graph.select { |id, v| v.rate.zero? && id != 'AA' }
valves_to_remove.each_value do |redundant_valve|
  # in input data, redundant nodes always have 2 neighbours
  v1, v2 = redundant_valve.links.keys.map { |id| graph[id] }
  distance = redundant_valve.links.values.reduce(&:+)
  v1.links[v2.id] = distance
  v2.links[v1.id] = distance
  v1.links.delete(redundant_valve.id)
  v2.links.delete(redundant_valve.id)
  graph.delete(redundant_valve.id)
end

# find shortest path distances between each pair of valves using Dijkstra's algorithm
distances = {}
graph.each_value do |initial_node|
  unvisited = Set.new(graph.values)
  unvisited.each { |v| v.distance = 999 }
  initial_node.distance = 0
  loop do
    node = unvisited.to_a.sort_by(&:distance).first
    break if node.nil? || node.distance == 999

    node.links.select { |id, _| unvisited.include?(graph[id]) }.each do |id, distance_to_neighbour|
      graph[id].distance = [node.distance + distance_to_neighbour, graph[id].distance].min
    end
    unvisited.delete(node)
  end
  distances[initial_node.id] = graph.values.each_with_object({}) { |v, hash| hash[v.id] = v.distance }
end

# recursively explore different possible sequences of valve opening
def max_pressure_release(remaining_time, initial_valve, valve_sequence, distances)
  result = 0
  best_seq = []
  valve_sequence.each do |valve|
    time = remaining_time - distances[initial_valve.id][valve.id] - 1
    next unless time.positive?

    res, seq = max_pressure_release(time, valve, valve_sequence - [valve], distances)
    result, best_seq = [res, seq] if res > result
  end
  [result + remaining_time * initial_valve.rate, [initial_valve.id, *best_seq]]
end

valves_to_remove = graph.except('AA').values
res, seq = max_pressure_release(30, graph['AA'], valves_to_remove, distances)
puts res
puts seq.inspect

# == part 2 ==

@graph = graph
@max_release = 0
@best_seq_m = []
@best_seq_e = []

# recursively explore different possible sequences of valve opening
def dig_down(release_so_far, seq_m, seq_e, remaining_time_m, remaining_time_e, remaining_valves, distances)
  if (remaining_time_m <= 0 && remaining_time_e <= 0) || remaining_valves.empty?
    if release_so_far > @max_release
      @max_release = release_so_far
      @best_seq_m = seq_m
      @best_seq_e = seq_e
    end
    return

  end

  final_step = true
  if remaining_time_m >= remaining_time_e
    # my turn
    remaining_valves.each do |valve|
      time = remaining_time_m - distances[seq_m.last][valve.id] - 1
      next unless time.positive?

      final_step = false
      release = release_so_far + time * valve.rate
      dig_down(release, seq_m + [valve.id], seq_e, time, remaining_time_e, remaining_valves - [valve], distances)
    end
  else
    # elephant's turn
    remaining_valves.each do |valve|
      time = remaining_time_e - distances[seq_e.last][valve.id] - 1
      next unless time.positive?

      final_step = false
      release = release_so_far + time * valve.rate
      dig_down(release, seq_m, seq_e + [valve.id], remaining_time_m, time, remaining_valves - [valve], distances)
    end
  end
  return unless final_step && release_so_far > @max_release

  @max_release = release_so_far
  @best_seq_m = seq_m
  @best_seq_e = seq_e
end

time = Time.now
remaining_valves = graph.except('AA').values
dig_down(0, ['AA'], ['AA'], 26, 26, remaining_valves, distances)
puts @max_release
puts @best_seq_m.inspect
puts @best_seq_e.inspect
puts (Time.now - time).to_s
