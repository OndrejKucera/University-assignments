require_relative "genetic"

class Main

  def initialize
    @strategy = Genetic.new()

    dir_name = File.dirname(__FILE__)
    dir_name.slice!('lib')

    Dir[dir_name + 'data225/uf50-010.cnf'].each do |name_file|
      problem = load_problem(name_file)

      t1 = Time.now
      result = solve_problem(problem)
      t2 = Time.now

      #puts
      puts "Fitness  #{result[1]}"
      puts "Clause   #{result[2]}"
      puts "Result   #{result[0]}"
      puts "Weight   #{result[3]}"
      puts "Time     #{(t2 - t1) * 1000.0}"
    end
  end


  def load_problem(name_file)
    array_of_problems = []

    File.open(name_file).readlines.each do |input_line|
      if input_line[0] == "c"
      elsif input_line[0] == "p"
        input_line = input_line.chomp.split
        array_of_problems.push(input_line[2],input_line[3])
      elsif input_line[0] == "0" || input_line[0] == "%"
        break
      else
        input_line = input_line.chomp.split
        array_of_problems.push([[input_line[0].to_i.abs, input_line[0].to_i>0],
                                [input_line[1].to_i.abs, input_line[1].to_i>0],
                                [input_line[2].to_i.abs, input_line[2].to_i>0]])
      end
    end

    array_of_problems
  end


  def solve_problem(problem)
    @strategy.solve_problem(problem)
  end

end