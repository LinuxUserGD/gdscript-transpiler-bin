class_name Application

## GDScript Execute compatibility class
##
## GDScript Wrapper class for OS execute

func execute(program: String, args: Array) -> Array:
	var stdout: Array = []
	OS.execute(program,args,stdout)
	return stdout
