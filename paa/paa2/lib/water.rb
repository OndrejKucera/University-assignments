
require_relative "item.rb"

class Water

  def initialize
    @file = "../data120/data120.txt"

    @array_capacity = []
    @array_start = []
    @array_aim = []

    @operations = []
  end


  def load_file
    File.open(@file, "r") do |file|
      while (line = file.gets)

        array_line = line.split

        puts "----------------------------"
        puts "id #{array_line[0].to_i}"
        @array_capacity = []
        @array_start = []
        @array_aim = []

        (0..array_line[1].to_i-1).each { |index|
          @array_capacity[index] = array_line[index+2].to_i
          @array_start[index] = array_line[index+2+array_line[1].to_i].to_i
          @array_aim[index] = array_line[index+2+2*array_line[1].to_i].to_i
        }
        make_operations(array_line[1].to_i)

        make_bfs_solution

        make_heuristic_solution
      end
    end
  end


  def make_heuristic_solution
    hash = Hash.new(false)
    hash_open = Hash.new(false)

    item = Item.new(@array_start)
    cost = item.cost_function(@array_aim, @array_capacity)

    if !hash_open[cost]
      hash_open[cost] = [item]
    else
      array = hash_open[cost]
      array.push(item)
      hash_open[cost] = array
    end

    hash[item.get_state] = true

    iterations = 0

    until hash_open.empty?
      iterations += 1

      item = nil

      while (item == nil) && !hash_open.empty?
        max = hash_open.max
        if max[1] == []
          hash_open.delete(max[0])
        else
          item = max[1].shift
          if max[1] == []
            hash_open.delete(max[0])
          else
          hash_open[max[0]] = max[1]
          end
        end
      end

      if item.equal?(@array_aim)
        puts "state #{item.get_state}"
        puts "iterations #{iterations}"
        puts "path #{item.get_path}"
        puts "count op. #{item.get_path.length}"
        #puts "Operations:"
        #(0..@operations.length-1).each { |index|
        #  puts "#{index} > #{@operations[index]}"
        #}
        puts "----------------------------"
        return

      end

      (0..@operations.length-1).each { |index_operation|
        if (new_item = use_operation(index_operation, item)) != nil

          if !hash[new_item.get_state]
            cost = new_item.cost_function(@array_aim, @array_capacity)
            if !hash_open[cost]
              hash_open[cost] = [new_item]
            else
              array = hash_open[cost]
              array.push(new_item)
              hash_open[cost] = array
            end

            hash[new_item.get_state] = true
          end
        end
      }
    end
  end


  def make_bfs_solution
    open = []
    hash = Hash.new(false)

    item = Item.new(@array_start)
    open.push(item)
    hash[item.get_state] = true

    iterations = 0

    until open.empty?
      iterations += 1

      item = open.shift

      if item.equal?(@array_aim)
        puts "state #{item.get_state}"
        puts "iterations #{iterations}"
        puts "path #{item.get_path}"
        puts "count op. #{item.get_path.length}"
        #puts "Operations:"
        #(0..@operations.length-1).each { |index|
        #  puts "#{index} > #{@operations[index]}"
        #}
        puts "----------------------------"
        return

      end

      (0..@operations.length-1).each { |index_operation|
        if (new_item = use_operation(index_operation, item)) != nil
          #puts "#{new_item.get_state} = #{hash[new_item.get_state]}"

          if !hash[new_item.get_state]
            open.push(new_item)
            hash[new_item.get_state] = true
          end
        end
      }
    end
  end


  def use_operation(index_operation, item)

    operation = @operations[index_operation].split
    index_bottle = operation[1].to_i

    case operation[0]
      when "full"
        if item.get_bottle(index_bottle) != @array_capacity[index_bottle]
          new_item = Marshal.load(Marshal.dump(item))
          new_item.set_bottle(index_bottle, @array_capacity[index_bottle].to_i)
          new_item.push_path(index_operation)

          return new_item
        end

      when "spill"
        if item.get_bottle(index_bottle) != 0
          new_item = Marshal.load(Marshal.dump(item))
          new_item.set_bottle(index_bottle, 0)
          new_item.push_path(index_operation)

          return new_item
        end

      when "from"
        index_bottle_to = operation[3].to_i

        if item.get_bottle(index_bottle) != 0 && item.get_bottle(index_bottle_to) != @array_capacity[index_bottle_to].to_i
          new_item = Marshal.load(Marshal.dump(item))

          tmp = @array_capacity[index_bottle_to] - new_item.get_bottle(index_bottle_to)

          if new_item.get_bottle(index_bottle) <= tmp
            new_item.set_bottle(index_bottle_to, new_item.get_bottle(index_bottle_to) + new_item.get_bottle(index_bottle))
            new_item.set_bottle(index_bottle, 0)
          else
            new_item.set_bottle(index_bottle_to, @array_capacity[index_bottle_to])
            new_item.set_bottle(index_bottle, new_item.get_bottle(index_bottle) - tmp)
          end

          new_item.push_path(index_operation)

          return new_item
        end
      else
    end
  end


  def make_operations(number)
    (0..number-1).each { |index|
      @operations[index] = "full #{index}"
      @operations[index + number] = "spill #{index}"
    }

    i = 2*number

    (0..number-1).each { |from|
      (0..number-1).each { |to|
        if from.to_i != to.to_i
          @operations[i] = "from #{from} to #{to}"

          i += 1
        end
      }
    }
  end

end

