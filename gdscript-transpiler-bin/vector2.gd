class_name VECTOR2

var x : float = 0
var y : float = 0

## Constructor call, for API see https://docs.godotengine.org/de/latest/classes/index.html
func _init():
	self.x = 0
	self.y = 0

## Returns this vector's angle with respect to the positive X axis, or (1, 0) vector, in radians.
func angle() -> float:
	return atan2(y, x)

func from_angle(p_angle : float):
	var vector2 = VECTOR2.new()
	vector2.x = sin(p_angle)
	vector2.y = cos(p_angle)
	return vector2

## Returns the length (magnitude) of this vector.
func vec_length() -> float:
	return sqrt(x * x + y * y)

## Returns the squared length (squared magnitude) of this vector.
func length_squared() -> float:
	return x * x + y * y

## Returns the vector scaled to unit length. Equivalent to v / v.length().
func normalized():
	var l : float = x * x + y * y
	if (l != 0):
		l = sqrt(l)
		return self.new(x/l, y/l)
	return self.new(x,y)

## Returns true if the vector is normalized, false otherwise.
func is_normalized() -> bool:
	return is_equal_approx(length_squared(), 1)

## Returns the distance between this vector and to.
func distance_to(p_vector2) -> float:
	return sqrt((x - p_vector2.x) * (x - p_vector2.x) + (y - p_vector2.y) * (y - p_vector2.y))

## Returns the squared distance between this vector and b.
func distance_squared_to(p_vector2) -> float:
	return (x - p_vector2.x) * (x - p_vector2.x) + (y - p_vector2.y) * (y - p_vector2.y)

## Returns the angle to the given vector, in radians.
func angle_to(p_vector2) -> float:
	return atan2(cross(p_vector2), dot(p_vector2))

## Returns the angle between the line connecting the two points and the X axis, in radians.
func angle_to_point(p_vector2) -> float:
	return (p_vector2.sub(self)).angle()

## Returns the dot product of this vector and with. This can be used to compare the angle between two vectors.
func dot(p_other) -> float:
	return x * p_other.x + y * p_other.y

## Returns the 2D analog of the cross product for this vector and with.
func cross(p_other) -> float:
	return x * p_other.y - y * p_other.x

## Returns a new vector with each component set to one or negative one, depending on the signs of the components.
func sign():
	return self.new(sign(x), sign(y))

## Returns a new vector with all components rounded down (towards negative infinity).
func floor():
	return self.new(floor(x), floor(y))

## Returns a new vector with all components rounded up (towards positive infinity).
func ceil():
	return self.new(ceil(x), ceil(y))

## Returns a new vector with all components rounded to the nearest integer, with halfway cases rounded away from zero.
func round():
	return self.new(round(x), round(y))

## Returns the vector rotated by angle (in radians).
func rotated(p_by : float):
	var sine : float = sin(p_by)
	var cosi : float = cos(p_by)
	return self.new(x * cosi - y * sine, x * sine + y * cosi)

## Returns a vector composed of the fposmod of this vector's components and mod.
func posmod(p_mod: float):
	return self.new(fposmod(x, p_mod), fposmod(y, p_mod))

## Returns a vector composed of the fposmod of this vector's components and modv's components.
func posmodv(p_modv):
	return self.new(fposmod(x, p_modv.x), fposmod(y, p_modv.y))

## Returns this vector projected onto the vector b.
func project(p_to):
	return p_to.mul(dot(p_to) / p_to.length_squared())

## Deprecated, please use limit_length instead.
func clamped(p_min, p_max):
	return self.new(clamp(x, p_min.x, p_max.x), clamp(y, p_min.y, p_max.y))

## Returns this vector with each component snapped to the nearest multiple of step. This can also be used to round to an arbitrary number of decimals.
func snapped(p_step):
	return self.new(snapped(x, p_step.x), snapped(y, p_step.y))

## Returns the vector with a maximum length by limiting its length to length.
func limit_length(p_len : float):
	var l : float = vec_length()
	var v = self
	if (l > 0 && p_len < l):
		return v.div(l).mul(p_len)
	return v

## Returns a new vector moved toward to by the fixed delta amount. Will not go past the final value.
func move_toward(p_to, p_delta : float):
	var v = self
	var vd = p_to.sub(v)
	var len : float = vd.vec_length()
	if (len <= p_delta):
		return p_to
	else:
		return v.add(vd.div(len).mul(p_delta))

## Returns this vector slid along a plane defined by the given normal.
func slide(p_normal):
	return self.sub(p_normal.mul(self.dot(p_normal)))

## Returns the vector "bounced off" from a plane defined by the given normal.
func bounce(p_normal):
	return reflect(p_normal).inv()

## Returns the vector reflected (i.e. mirrored, or symmetric) over a line defined by the given direction vector n.
func reflect(p_normal):
	return p_normal.mul(2.0).mul(self.dot(p_normal)).sub(self)

## Returns true if this vector and v are approximately equal, by running is_equal_approx on each component.
func is_equal_approx(p_v) -> bool:
	return is_equal_approx(x, p_v.x) and is_equal_approx(y, p_v.y)

## Returns true if this vector is approximately zero, by running is_zero_approx on each component.
func is_zero_approx() -> bool:
	return is_zero_approx(x) and is_zero_approx(y)

## Returns true if this vector is finite, by running is_finite on each component.
func is_finite() -> bool:
	return is_finite(x) and is_finite(y)

func sub(p_vector2):
	return self.new(x-p_vector2.x,y-p_vector2.y)

func add(p_vector2):
	return self.new(x+p_vector2.x,y+p_vector2.y)

func mul(p_by : float):
	return self.new(p_by*x, p_by*y)

func inv():
	return self.new(-x,-y)

func div(p_by : float):
	return self.new(x/p_by, y/p_by)
