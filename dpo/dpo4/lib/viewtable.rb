class View_table < Qt::Widget

  signals 'signal_change(int, int, int, int)'
  signals 'signal_update()'
  slots 'slot_change_square(int, int)'
  slots 'slot_change_circle(int, int)'
  slots 'slot_can_change()'

  attr_reader :clear

  def initialize(parent = nil)
    super()

    @user_change = false

    setFixedSize(440, 400)

    init_ui

    connect(@table_squares, SIGNAL('cellChanged (int, int)'), self, SLOT('slot_change_square(int, int)'))
    connect(@table_squares, SIGNAL('cellDoubleClicked  (int, int)'), self, SLOT('slot_can_change()'))

    connect(@table_circles, SIGNAL('cellChanged (int, int)'), self, SLOT('slot_change_circle(int, int)'))
    connect(@table_circles, SIGNAL('cellDoubleClicked  (int, int)'), self, SLOT('slot_can_change()'))
  end


  def init_ui
    v_box = Qt::VBoxLayout.new(self)

    label_square = Qt::Label.new("Squares")
    label_square.setMaximumSize(label_square.sizeHint())
    @table_squares = Qt::TableWidget.new(0, 4, self)
    header1 = Qt::TableWidgetItem.new("ID",0)
    @table_squares.setHorizontalHeaderItem(0,header1)
    header2 = Qt::TableWidgetItem.new("X",0)
    @table_squares.setHorizontalHeaderItem(1,header2)
    header3 = Qt::TableWidgetItem.new("Y",0)
    @table_squares.setHorizontalHeaderItem(2,header3)
    header4 = Qt::TableWidgetItem.new("R",0)
    @table_squares.setHorizontalHeaderItem(3,header4)

    label_circle = Qt::Label.new("Circles")
    label_circle.setMaximumSize(label_circle.sizeHint())
    @table_circles = Qt::TableWidget.new(0, 4, self)
    @table_circles.setHorizontalHeaderItem(0,header1)
    @table_circles.setHorizontalHeaderItem(1,header2)
    @table_circles.setHorizontalHeaderItem(2,header3)
    @table_circles.setHorizontalHeaderItem(3,header4)

    @clear = Qt::PushButton.new('Clear all')
    @clear.resize(75, 30)
    @clear.setFont(Qt::Font.new('Arial', 18, Qt::Font::Bold))

    v_box.addWidget(label_square, 1)
    v_box.addWidget(@table_squares, 2)
    v_box.addWidget(label_circle, 3)
    v_box.addWidget(@table_circles, 4)
    v_box.addWidget(@clear, 5)
  end


  def update_state(squa, circ)
    row = 0
    @table_squares.setRowCount(squa.size)
    squa.each do |key, item|
      id = Qt::TableWidgetItem.new(key.to_s,0)
      @table_squares.setItem(row, 0, id)
      x = Qt::TableWidgetItem.new(item[0].to_s,0)
      @table_squares.setItem(row, 1, x)
      y = Qt::TableWidgetItem.new(item[1].to_s,0)
      @table_squares.setItem(row, 2, y)
      r = Qt::TableWidgetItem.new(item[2].to_s,0)
      @table_squares.setItem(row, 3, r)

      row += 1
    end


    row = 0
    @table_circles.setRowCount(circ.size)
    circ.each do |key, item|
      id = Qt::TableWidgetItem.new(key.to_s,0)
      @table_circles.setItem(row, 0, id)
      x = Qt::TableWidgetItem.new(item[0].to_s,0)
      @table_circles.setItem(row, 1, x)
      y = Qt::TableWidgetItem.new(item[1].to_s,0)
      @table_circles.setItem(row, 2, y)
      r = Qt::TableWidgetItem.new(item[2].to_s,0)
      @table_circles.setItem(row, 3, r)

      row += 1
    end
  end


  def slot_can_change()
    @user_change = true
  end


  def slot_change_square(row, column)
    if @user_change == true
      @user_change = false
      if column !=0
        id = @table_squares.item(row, 0).text.to_i
        x = @table_squares.item(row, 1).text.to_i
        y = @table_squares.item(row, 2).text.to_i
        r = @table_squares.item(row, 3).text.to_i
        emit signal_change(x, y, r, id)
      else
        emit signal_update()
      end
    end
  end


  def slot_change_circle(row, column)
    if @user_change == true
      @user_change = false
      if column !=0
        id = @table_circles.item(row, 0).text.to_i
        x = @table_circles.item(row, 1).text.to_i
        y = @table_circles.item(row, 2).text.to_i
        r = @table_circles.item(row, 3).text.to_i
        emit signal_change(x, y, r, id)
      else
        emit signal_update()
      end
    end
  end

end