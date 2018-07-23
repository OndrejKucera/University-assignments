require_relative "bfs"
require_relative "dfs"

# Problem, which use strategy

class Graph
  def initialize(strategy, count_nodes = 15)
    @strategy = strategy
    @graph = []
    make_graph(count_nodes)
  end

  private
  def make_graph(count_nodes)
    last_number = 0

    (0..count_nodes-1).each do |number|
      if last_number+2 < count_nodes
        @graph[number] = [last_number+1,last_number+2]
        last_number += 2
      elsif last_number+1 < count_nodes
        @graph[number] = [last_number+1,nil]
        last_number += 2
      else
        @graph[number] = [nil,nil]
      end
    end
  end

  public
  def go_through_graph
    @strategy.go_through_graph(@graph)
  end
end

