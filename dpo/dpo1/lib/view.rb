class View
  def input
    $stdin.each_line do |input_line|
      return input_line.chomp
    end
  end

  def output(text)
    puts text
  end

  def clear_screen
    print "\e[2J"
  end
end