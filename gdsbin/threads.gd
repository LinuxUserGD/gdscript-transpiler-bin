class_name Threads

## GDScript Threads compatibility class
##
## GDScript Wrapper class for Threads options
var tg = Tg.new()

func start(function):
	tg.t = Thread.new()
	tg.t.start(function)

func is_alive() -> bool:
	return tg.t.is_alive()

func wait_to_finish():
	tg.t.wait_to_finish()
	tg.t = null
