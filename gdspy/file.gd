class_name File

## GDScript File compatibility class
##
## GDScript Wrapper class for previous File options
## (which were changed to static FileAccess)


## Internal File variable (using FileAccess)
var file: FileAccess = null
var path: String = ""

## FileOpts enum options for different FileAccess types
enum FileOpts {READ, WRITE, WRITE_READ, READ_WRITE}

## "Open" function for compatibility
func open(path_str : String, fo : FileOpts) -> void:
	self.path = path_str
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
	self.file = FileAccess.open(self.path, opts)

## "Get as text" function for compatibility
func get_as_text() -> String:
	if self.file != null:
		return self.file.get_as_text()
	else:
		print("Error: File '" + self.path + "' does not exist")
		return ""

## "Store string" function for compatibility
func store_string(string : String) -> void:
	self.file.store_string(string)

## "Close" function for compatibility
func close() -> void:
	file = null
