require_relative "genetic"

class Main

  def initialize
    @strategy = Genetic.new()

    dir_name = File.dirname(__FILE__)
    dir_name.slice!('lib')


    Dir[dir_name + 'data120/*30*.dat'].each do |name_file|

      @problems = load_problem(name_file)

      @problems.each do |problem|
        t1 = Time.now
        result = solve_problem(problem)
        t2 = Time.now

        puts "#{result[0]} #{result[1]} #{result[2]} #{result[3]}"
        puts "CAS = #{(t2 - t1) * 1000.0}"
      end
    end
  end


  def load_problem(name_file)
    array_of_problems = Array.new

    File.open(name_file).readlines.each do |input_line|
      input_line = input_line.chomp.split
      array_of_problems.push(input_line)
    end

    array_of_problems
  end


  def solve_problem(problem)
    @strategy.solve_problem(problem)
  end

end