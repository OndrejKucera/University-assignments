class Model
  def initialize()
    @observers = []
    @squares = {}
    @circles = {}
    @id_number = 0
  end


  def create_square(x, y, r)
    if r > 0
      @id_number += 1
      @squares[@id_number] = [x, y, r]
      notify()
      return true
    end

    false
  end


  def create_circle(x, y, r)
    if r > 0
      @id_number += 1
      @circles[@id_number] = [x, y, r]
      notify()
      return true
    end

    false
  end
    
  def change(x, y, r, id)
    if r > 0
      if @circles[id] != nil
        @circles[id] = [x, y, r]
        notify()
        return true
      elsif @squares[id] != nil
        @squares[id] = [x, y, r]
        notify()
        return true
      end
    else
      notify()
    end

    false
  end

  
  def clear_all
    @squares = {}
    @circles = {}
    notify()
    true
  end


  def update
    notify()
    true
  end


  def notify()
    @observers.each {|observer| observer.update_state(@squares, @circles) }
  end

  
  def attach(observer)
    @observers.push(observer)
  end

=begin
  def dettach(observer)
    @observers.delete(observer)
  end
=end

end