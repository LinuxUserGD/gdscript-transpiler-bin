class_name File

## GDScript File compatibility class
##
## GDScript Wrapper class for previous File options
## (which were changed to static FileAccess)
##
## @tutorial(GitHub issue comment): https://github.com/godotengine/godot/issues/66241#issuecomment-1256787662


## Internal File variable (using FileAccess)
var file : FileAccess


## FileOpts enum options for different FileAccess types
enum FileOpts {READ, WRITE, WRITE_READ, READ_WRITE}

## Constructor call
func _init() -> void:
	file = null

## "Open" function for compatibility
func open(path : String, fo : FileOpts) -> void:
	var opts
	match fo:
		FileOpts.READ:
			opts = FileAccess.READ
		FileOpts.WRITE:
			opts = FileAccess.WRITE
		FileOpts.WRITE_READ:
			opts = FileAccess.WRITE_READ
		FileOpts.READ_WRITE:
			opts = FileAccess.READ_WRITE
	file = FileAccess.open(path, opts)

## "Get as text" function for compatibility
func get_as_text() -> String:
	if file != null:
		return file.get_as_text()
	else:
		print("Error: File does not exist")
		return ""

## "Store string" function for compatibility
func store_string(string : String) -> void:
	file.store_string(string)

## "Close" function for compatibility
func close() -> void:
	file = null
