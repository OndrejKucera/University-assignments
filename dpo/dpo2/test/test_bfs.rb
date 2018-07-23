require_relative '../lib/graph'

class Test_BFS < Test::Unit::TestCase
  def test_bfs
    expected = (Graph.new(BFS.new, 4)).go_through_graph
    assert_equal expected, [0, 1, 2, 3]
  end
end