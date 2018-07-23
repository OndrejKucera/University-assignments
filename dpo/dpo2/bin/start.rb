require_relative "../lib/graph"

(Graph.new(DFS.new)).go_through_graph if ARGV[0] == "dfs"
(Graph.new(BFS.new)).go_through_graph if ARGV[0] == "bfs"