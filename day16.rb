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

res, seq = max_pressure_release(30, graph['AA'], graph.except('AA').values, distances)
puts res
puts seq.inspect
