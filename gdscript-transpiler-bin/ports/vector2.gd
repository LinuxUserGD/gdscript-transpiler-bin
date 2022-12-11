class_name VECTOR2

var x : float = 0
var y : float = 0

## Constructor call
func _init(X : float, Y : float):
	x = X
	y = Y

func angle() -> float:
	return atan2(y, x)

func from_angle(p_angle : float):
	return VECTOR2.new(cos(p_angle), sin(p_angle))

func length() -> float:
	return sqrt(x * x + y * y)

func length_squared() -> float:
	return x * x + y * y

func normalized():
	var l : float = x * x + y * y
	if (l != 0):
		l = sqrt(l)
		return VECTOR2.new(x/l, y/l)
	return VECTOR2.new(x,y)

func is_normalized() -> bool:
	return is_equal_approx(length_squared(), 1)

func distance_to(p_vector2) -> float:
	return sqrt((x - p_vector2.x) * (x - p_vector2.x) + (y - p_vector2.y) * (y - p_vector2.y))

func distance_squared_to(p_vector2) -> float:
	return (x - p_vector2.x) * (x - p_vector2.x) + (y - p_vector2.y) * (y - p_vector2.y)

func angle_to(p_vector2) -> float:
	return atan2(cross(p_vector2), dot(p_vector2))

func angle_to_point(p_vector2) -> float:
	return (p_vector2.sub(self)).angle()

func dot(p_other) -> float:
	return x * p_other.x + y * p_other.y

func cross(p_other) -> float:
	return x * p_other.y - y * p_other.x

func sign():
	return VECTOR2.new(sign(x), sign(y))

func floor():
	return VECTOR2.new(floor(x), floor(y))

func ceil():
	return VECTOR2.new(ceil(x), ceil(y))

func round():
	return VECTOR2.new(round(x), round(y))

func rotated(p_by : float):
	var sine : float = sin(p_by)
	var cosi : float = cos(p_by)
	return VECTOR2.new(x * cosi - y * sine, x * sine + y * cosi)

func posmod(p_mod: float):
	return VECTOR2.new(fposmod(x, p_mod), fposmod(y, p_mod))

func posmodv(p_modv):
	return VECTOR2.new(fposmod(x, p_modv.x), fposmod(y, p_modv.y))

func project(p_to):
	return p_to.mul(dot(p_to) / p_to.length_squared())

func clamp(p_min, p_max):
	return VECTOR2.new(clamp(x, p_min.x, p_max.x), clamp(y, p_min.y, p_max.y))

func snapped(p_step):
	return VECTOR2.new(snapped(x, p_step.x), snapped(y, p_step.y))

func limit_length(p_len : float):
	var l : float = length()
	var v = self
	if (l > 0 && p_len < l):
		return v.div(l).mul(p_len)
	return v

func move_toward(p_to, p_delta : float):
	var v = self
	var vd = p_to.sub(v)
	var len : float = vd.length()
	if (len <= p_delta):
		return p_to
	else:
		return v.add(vd.div(len).mul(p_delta))

func slide(p_normal):
	return self.sub(p_normal.mul(self.dot(p_normal)))

func bounce(p_normal):
	return reflect(p_normal).inv()

func reflect(p_normal):
	return p_normal.mul(2.0).mul(self.dot(p_normal)).sub(self)

func is_equal_approx(p_v) -> bool:
	return is_equal_approx(x, p_v.x) and is_equal_approx(y, p_v.y)

func is_zero_approx() -> bool:
	return is_zero_approx(x) and is_zero_approx(y)

func is_finite() -> bool:
	return is_finite(x) and is_finite(y)

func sub(p_vector2):
	return VECTOR2.new(x-p_vector2.x,y-p_vector2.y)

func add(p_vector2):
	return VECTOR2.new(x+p_vector2.x,y+p_vector2.y)

func mul(p_by : float):
	return VECTOR2.new(p_by*x, p_by*y)

func inv():
	return VECTOR2.new(-x,-y)

func div(p_by : float):
	return VECTOR2.new(x/p_by, y/p_by)
