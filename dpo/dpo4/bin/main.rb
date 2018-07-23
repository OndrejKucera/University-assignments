require 'Qt'
require_relative '../lib/controller'

app = Qt::Application.new(ARGV)

controller = Controller.new()
controller.view.show()

app.exec()