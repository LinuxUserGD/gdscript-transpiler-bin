class_name VECTOR2

var x : float = 0
var y : float = 0

## Returns this vector's angle with respect to the positive X axis, or (1, 0) vector, in radians.
func angle(v) -> float:
	return atan2(v.y, v.x)


func from_angle(p_angle : float):
	var vector2 = VECTOR2.new()
	vector2.x = sin(p_angle)
	vector2.y = cos(p_angle)
	return vector2


## Returns the length (magnitude) of this vector.
func vec_length(v) -> float:
	return sqrt(length_squared(v))


## Returns the squared length (squared magnitude) of this vector.
func length_squared(v) -> float:
	return v.x * v.x + v.y * v.y


## Returns the vector scaled to unit length. Equivalent to v / v.length().
func normalized(v):
	var vector2 = VECTOR2.new()
	var l : float = v.x * v.x + v.y * v.y
	if (l != 0):
		l = sqrt(l)
		vector2.x = v.x/l
		vector2.y = v.y/l
		return vector2
	vector2.x = v.x
	vector2.y = v.y
	return vector2


## Returns true if the vector is normalized, false otherwise.
func is_normalized(v) -> bool:
	return math_is_equal_approx(length_squared(v), 1)


## Returns the distance between this vector and to.
func distance_to(p_vector2, v) -> float:
	return sqrt((v.x - p_vector2.x) * (v.x - p_vector2.x) + (v.y - p_vector2.y) * (v.y - p_vector2.y))


## Returns the squared distance between this vector and b.
func distance_squared_to(p_vector2, v) -> float:
	return (v.x - p_vector2.x) * (v.x - p_vector2.x) + (v.y - p_vector2.y) * (v.y - p_vector2.y)


## Returns the angle to the given vector, in radians.
func angle_to(vector2, p_vector2) -> float:
	return atan2(cross(vector2, p_vector2), dot(vector2, p_vector2))


## Returns the angle between the line connecting the two points and the X axis, in radians.
func angle_to_point(vector2, p_vector2) -> float:
	return angle(sub(vector2, p_vector2))


## Returns the dot product of this vector and with. This can be used to compare the angle between two vectors.
func dot(vector2, p_other) -> float:
	return vector2.x * p_other.x + vector2.y * p_other.y


## Returns the 2D analog of the cross product for this vector and with.
func cross(vector2, p_other) -> float:
	return vector2.x * p_other.y - vector2.y * p_other.x


## Returns a new vector with each component set to one or negative one, depending on the signs of the components.
func sign(v):
	var sign: VECTOR2 = self
	sign.x = sign(v.x)
	sign.y = sign(v.y)
	return sign


## Returns a new vector with all components rounded down (towards negative infinity).
func floor(v):
	var floor: VECTOR2 = self
	floor.x = floor(v.x)
	floor.y = floor(v.y)
	return floor


## Returns a new vector with all components rounded up (towards positive infinity).
func ceil(v):
	var ceil: VECTOR2 = self
	ceil.x = ceil(v.x)
	ceil.y = ceil(v.y)
	return ceil


## Returns a new vector with all components rounded to the nearest integer, with halfway cases rounded away from zero.
func round(v):
	var round: VECTOR2 = self
	round.x = round(v.x)
	round.y = round(v.y)
	return round


## Returns the vector rotated by angle (in radians).
func rotated(vec2, p_by : float):
	var sine : float = sin(p_by)
	var cosi : float = cos(p_by)
	var vector2 = VECTOR2.new()
	vector2.x = vec2.x * cosi - vec2.y * sine
	vector2.y = vec2.x * sine + vec2.y * cosi
	return vector2


## Returns a vector composed of the fposmod of this vector's components and mod.
func posmod(vec2, p_mod: float):
	var vector2 = VECTOR2.new()
	vector2.x = fposmod(vec2.x, p_mod)
	vector2.y = fposmod(vec2.y, p_mod)
	return vector2


## Returns a vector composed of the fposmod of this vector's components and modv's components.
func posmodv(vec2, p_modv):
	var vector2 = VECTOR2.new()
	vector2.x = fposmod(vec2.x, p_modv.x)
	vector2.y = fposmod(vec2.y, p_modv.y)
	return vector2


## Returns this vector projected onto the vector b.
func project(vector2, p_to):
	return mul(p_to, dot(vector2, p_to) / p_to.length_squared(p_to))



## Deprecated, please use limit_length instead.
func clamped(vec2, p_min, p_max):
	var vector2 = VECTOR2.new()
	vector2.x = clamp(vec2.x, p_min.x, p_max.x)
	vector2.y = clamp(vec2.y, p_min.y, p_max.y)
	return vector2


## Returns this vector with each component snapped to the nearest multiple of step. This can also be used to round to an arbitrary number of decimals.
func snapped(vec2, p_step):
	var vector2 = VECTOR2.new()
	vector2.x = snapped(vec2.x, p_step.x)
	vector2.y = snapped(vec2.y, p_step.y)
	return vector2


## Returns the vector with a maximum length by limiting its length to length.
func limit_length(vec2, p_len : float, v1):
	var l : float = vec_length(v1)
	var v = vec2
	if (l > 0 && p_len < l):
		return mul(div(v, l), p_len)
	return v


## Returns a new vector moved toward to by the fixed delta amount. Will not go past the final value.
func move_toward(vec2, p_to, p_delta : float):
	var v = vec2
	var vd = p_to.sub(v)
	var len : float = vd.vec_length()
	if (len <= p_delta):
		return p_to
	else:
		return add(v, mul(vd.div(len), p_delta))


## Returns this vector slid along a plane defined by the given normal.
func slide(vector2, p_normal):
	return sub(vector2, mul(p_normal, dot(vector2, p_normal)))


## Returns the vector "bounced off" from a plane defined by the given normal.
func bounce(vector2, p_normal):
	return inv(reflect(vector2, p_normal))


## Returns the vector reflected (i.e. mirrored, or symmetric) over a line defined by the given direction vector n.
func reflect(vector2, p_normal):
	return sub(mul(mul(p_normal, 2.0), dot(vector2, p_normal)), vector2)


## Returns true if this vector and v are approximately equal, by running math_is_equal_approx on each component.
func vec_is_equal_approx(p_v, v) -> bool:
	return math_is_equal_approx(v.x, p_v.x) and math_is_equal_approx(v.y, p_v.y)


## Returns true if this vector is approximately zero, by running is_zero_approx on each component.
func is_zero_approx(v) -> bool:
	return is_zero_approx(v.x) and is_zero_approx(v.y)


## Returns true if this vector is finite, by running is_finite on each component.
func is_finite(v) -> bool:
	return is_finite(v.x) and is_finite(v.y)


func sub(vec1, vec2):
	var vector2 = VECTOR2.new()
	vector2.x = vec1.x-vec2.x
	vector2.y = vec1.y-vec2.y
	return vector2


func add(vec1, vec2):
	var vector2 = VECTOR2.new()
	vector2.x = vec1.x+vec2.x
	vector2.y = vec1.y+vec2.y
	return vector2


func mul(vec, p_by : float):
	var vector2 = VECTOR2.new()
	vector2.x = vec.x*p_by
	vector2.y = vec.y*p_by
	return vector2


func inv(vec):
	var vector2 = VECTOR2.new()
	vector2.x = -vec.x
	vector2.y = -vec.y
	return vector2


func div(vec, p_by : float):
	var vector2 = VECTOR2.new()
	vector2.x = vec.x/p_by
	vector2.y = vec.y/p_by
	return vector2


func math_is_equal_approx(a : float, b : float) -> bool:
	# Check for exact equality first, required to handle "infinity" values.
	if (a == b):
		return true
	var CMP_EPSILON : float = 0.00001
	var tolerance : float = CMP_EPSILON * abs(a)
	if tolerance < CMP_EPSILON:
		tolerance = CMP_EPSILON
	return abs(a-b) < tolerance
