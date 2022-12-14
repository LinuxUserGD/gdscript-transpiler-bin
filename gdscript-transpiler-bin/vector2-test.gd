extends SceneTree

func _init() -> void:
	var vector2 = VECTOR2.new()
	vector2.x = 3
	vector2.y = 5
	print(vector2.vec_length())
	print(vector2.length_squared())
