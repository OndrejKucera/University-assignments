require_relative 'viewgui'
require_relative 'viewtable'


class View < Qt::Widget

  attr_reader :view1, :view2

  def initialize
    super

    setWindowTitle "HomeWork 4"
    move 300, 300

    init_ui
  end


  def init_ui
    h_box = Qt::HBoxLayout.new(self)

    @view1 = View_gui.new()
    @view2 = View_table.new()

    h_box.addWidget(@view1, 1)
    h_box.addWidget(@view2, 2)
  end
end