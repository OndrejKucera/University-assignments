require_relative "algorithm"

# Concrete algorithm strategy

class DFS < Algorithm

  def go_through_graph(graph)
    puts "DFS path:"

    open = [0]
    close = []

    until open.empty?
      node = open.shift
      print "#{node} "
      close.push(node)

      1.downto(0) do |index|
        if graph[node][index] != nil
          open.unshift(graph[node][index])
        end
      end
    end
    puts
    return close
  end
end