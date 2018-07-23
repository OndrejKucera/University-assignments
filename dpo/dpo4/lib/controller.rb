require_relative 'model'
require_relative 'view'

class Controller < Qt::Widget

  slots 'create_square(int, int, int)'
  slots 'create_circle(int, int, int)'
  slots 'change(int, int, int, int)'
  slots 'clear_all()'
  slots 'update()'

  attr_reader :view

  def initialize(parent = nil)
    super()
    @model = Model.new()
    @view = View.new

    @model.attach(@view.view1)
    @model.attach(@view.view2)

    connect(@view.view1, SIGNAL('signal_create_square(int, int, int)'), self, SLOT('create_square(int, int, int)'))
    connect(@view.view1, SIGNAL('signal_create_circle(int, int, int)'), self, SLOT('create_circle(int, int, int)'))
    connect(@view.view2, SIGNAL('signal_change(int, int, int, int)'), self, SLOT('change(int, int, int, int)'))
    connect(@view.view2.clear, SIGNAL('clicked()'), self, SLOT('clear_all()'))
    connect(@view.view2, SIGNAL('signal_update()'), self, SLOT('update()'))
  end


  def create_square(x, y, r)
    @model.create_square(x, y, r)
  end


  def create_circle(x, y, r)
    @model.create_circle(x, y, r)
  end


  def change(x, y, r, id)
    @model.change(x, y, r, id)
  end


  def update()
    @model.update()
  end


  def clear_all()
    @model.clear_all()
  end
end