require_relative "algorithm"

class Dynamic_programming < Algorithm

  def solve_problem(problem)
    id = problem[0]
    count_of_things = problem[1].to_i
    max_weight = problem[2].to_i
    list_of_things = Array.new

    # Load items
    (0...count_of_things*2).each do |index|
      list_of_things.push(problem[index+3].to_i) # [weight, price]
    end

    # Seed table
    table = Hash[0 => [0,0]]

    mask = 1
    mask = mask << (count_of_things-1)

    comp = 0

    # Find optimum
    count_of_things.times do |index|

      temp_array = []

      table.each do |key, array|
        price = key
        weight = array[1]
        path = array[0]

        comp += 1
        if (new_weight = weight + list_of_things[(index)*2]) <= max_weight
          new_price = price + list_of_things[(index)*2+1]
          new_path = path | mask
          temp_array.push([new_price, new_path, new_weight])
        end
      end
      mask = mask >> 1

      temp_array.each do |item|
        price = item[0]

        if table[price] != nil
          if table[price][1] > item[2]
            table[price] = [item[1], item[2]]
          end
        else
          table[price] = [item[1], item[2]]
        end
      end
    end

    max_item = table.max

    optimum = table.max[1][0]
    result = ""

    mask = 1
    mask = mask << (count_of_things-1)
    (0..count_of_things-1).each do
      d = optimum & mask
      if d != 0
        result += "1"
      else
        result += "0"
      end
      mask = mask >> 1
    end

    [id, count_of_things, max_item[0], result, comp]
  end

end