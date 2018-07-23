require_relative "algorithm"

class Brute_force < Algorithm

  def solve_problem(problem)
    id = problem[0]
    count_of_things = problem[1].to_i
    max_weight = problem[2].to_i
    list_of_things = Array.new

    optimum = 0
    price_of_optimum = 0

    # Load items
    (0..(count_of_things*2-1)).each do |index|
      list_of_things.push(problem[index+3].to_i) # [weight, price]
    end

    comp = 0

    # Find optimum
    end_iteration = (2 ** count_of_things)
    (0...end_iteration).each do |index|
      pack = 0
      price = 0
      mask = 1

      (0..count_of_things-1).each do |index_j|
        d = index & mask
        if d != 0
          if max_weight >= (pack + list_of_things[index_j*2])
            pack += list_of_things[index_j*2]
            price += list_of_things[index_j*2+1]
          else
            break
          end
        end
        mask = mask << 1
      end

      comp += 1
      # Did we find optimum
      if price > price_of_optimum
        optimum = index
        price_of_optimum = price
      end
    end

    result = ""
    mask = 1
    (0..count_of_things-1).each do
        d = optimum & mask
        if d != 0
          result += "1"
        else
          result += "0"
        end
        mask = mask << 1
    end

    [id, count_of_things, price_of_optimum, result, comp]
  end
end