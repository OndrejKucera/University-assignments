require_relative "algorithm"

class Reverse_fptas < Algorithm

  def solve_problem(problem)
    ignored_bits = 4

    id = problem[0]
    count_of_things = problem[1].to_i
    max_weight = problem[2].to_i
    list_of_things = Array.new
    list_of_new_things = Array.new

    price = 0
    weight = 0
    path = ""

    # Load items
    (0...count_of_things*2).each do |index|
      list_of_things.push(problem[index+3].to_i) # [weight, price]
    end

    # Ignore some the lowest bits
    count_of_things.times do |index|
      tmp_thing = list_of_things[index*2+1]

      tmp_thing = tmp_thing >> ignored_bits
      tmp_thing = tmp_thing << ignored_bits

      list_of_new_things[index*2] = list_of_things[index*2]
      list_of_new_things[index*2+1] = tmp_thing

      weight += list_of_new_things[index*2]
      price += list_of_new_things[index*2+1]
      path += "1"
    end

    optimum_price = 0
    optimum_path = 0

    # Seed table
    table = Hash[price => [path.to_i(2),weight]]

    mask = 1
    mask = mask << (count_of_things-1)

    comp = 0

    # Find optimum
    count_of_things.times do |index|

      temp_array = []

      table.each do |key, array|
        price = key
        path = array[0]
        weight = array[1]

        comp += 1
        if weight > max_weight
          new_weight = weight - list_of_new_things[(index)*2]
          new_price = price - list_of_new_things[(index)*2+1]
          new_path = path ^ mask
          temp_array.push([new_price, new_path, new_weight])
        else
          if price > optimum_price
            optimum_price = price
          end
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

    table.each do |key, array|
      price = key
      path = array[0]
      weight = array[1]

      if weight <= max_weight
        if price > optimum_price
          optimum_price = price
          optimum_path = path
        end
      end
    end

    result = optimum_path.to_s(2)

    [id, count_of_things, optimum_price, result, comp]

  end

end
