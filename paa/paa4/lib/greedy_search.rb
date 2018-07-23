require_relative "algorithm"

class Greedy_search < Algorithm

  def solve_problem(problem)
    id = problem[0]
    count_of_things = problem[1].to_i
    max_weight = problem[2].to_i
    list_of_things = Array.new

    pack = 0
    price_of_optimum = 0
    list_result = []

    # Load items
    (0...count_of_things).each do |index|
      weight = problem[index*2+0+3].to_i
      price  = problem[index*2+1+3].to_i
      sum = price.to_f/weight.to_f
      order = index
      list_of_things.push([weight, price, sum.to_f, order])
    end

    # Sort things
    list = list_of_things.sort_by{ |x| [x[2],x[1]]}.reverse!

    comp = 0

    list.each do |item|
      comp += 1
      if max_weight >= pack + item[0]
        pack += item[0]
        price_of_optimum += item[1]
        list_result.push(item[3])
      end
    end

    result = ""
    (0...count_of_things).each do  |index|
      if list_result.include?(index)
        result << "1"
      else
        result << "0"
      end
    end

    [id, count_of_things, price_of_optimum, result, comp]

    end
end