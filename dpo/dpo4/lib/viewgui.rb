class View_gui < Qt::Widget

  signals 'signal_create_square(int, int, int)'
  signals 'signal_create_circle(int, int, int)'

  def initialize(parent = nil)
    super()

    setFixedSize(300, 400)

    setPalette(Qt::Palette.new(Qt::Color.new(255, 255, 255)))
    setAutoFillBackground(true)

    @squares = []
    @circles = []
  end


  def update_state(squa, circ)
    @squares = []
    @circles = []

    squa.each do |key, item|
      rect = Qt::Rect.new(item[0], item[1], item[2], item[2])
      @squares.push(rect)
    end

    circ.each do |key, item|
      rect = Qt::Rect.new(item[0], item[1], item[2], item[2])
      @circles.push(rect)
    end

    update()
  end


  def mousePressEvent(event)
      if (event.button() == Qt::LeftButton)
        emit signal_create_square(event.pos().x, event.pos().y, 10)
      elsif (event.button() == Qt::RightButton)
        emit signal_create_circle(event.pos().x, event.pos().y, 10)
      end
  end


  def paintEvent(event)
    painter = Qt::Painter.new(self)

    @squares.each do |rect|
      painter.drawRect(rect)
    end

    @circles.each do |rect|
      painter.drawEllipse(rect)
    end

    painter.end
  end

end