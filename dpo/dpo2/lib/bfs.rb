require_relative "algorithm"

# Concrete algorithm strategy

class BFS < Algorithm

  def go_through_graph(graph)
    puts "BFS path:"
    
    open = [0]
    close = []

    until open.empty?
      node = open.shift
      print "#{node} "
      close.push(node)

      (0..1).each do |index|
        if graph[node][index] != nil
          open.push(graph[node][index])
        end
      end
    end
    puts
    return close
  end
end