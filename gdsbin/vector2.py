import math

x = 0
y = 0


def angle(v):
    return math.atan2(v.y, v.x)


def from_angle(p_angle):
    import gdsbin.vector2

    vector2 = type(gdsbin.vector2)(gdsbin.vector2.__name__, gdsbin.vector2.__doc__)
    vector2.__dict__.update(gdsbin.vector2.__dict__)
    vector2.x = math.sin(p_angle)
    vector2.y = math.cos(p_angle)
    return vector2


def vec_length(v):
    return math.sqrt(length_squared(v))


def length_squared(v):
    return v.x * v.x + v.y * v.y


def normalized(v):
    import gdsbin.vector2

    vector2 = type(gdsbin.vector2)(gdsbin.vector2.__name__, gdsbin.vector2.__doc__)
    vector2.__dict__.update(gdsbin.vector2.__dict__)
    l = v.x * v.x + v.y * v.y
    if l != 0:
        l = math.sqrt(l)
        vector2.x = v.x / l
        vector2.y = v.y / l
        return vector2
    vector2.x = v.x
    vector2.y = v.y
    return vector2


def is_normalized(v):
    return math_is_equal_approx(length_squared(v), 1)


def distance_to(p_vector2, v):
    return math.sqrt(
        (v.x - p_vector2.x) * (v.x - p_vector2.x)
        + (v.y - p_vector2.y) * (v.y - p_vector2.y)
    )


def distance_squared_to(p_vector2, v):
    return (v.x - p_vector2.x) * (v.x - p_vector2.x) + (v.y - p_vector2.y) * (
        v.y - p_vector2.y
    )


def angle_to(vector2, p_vector2):
    return math.atan2(cross(vector2, p_vector2), dot(vector2, p_vector2))


def angle_to_point(vector2, p_vector2):
    return angle(sub(vector2, p_vector2))


def dot(vector2, p_other):
    return vector2.x * p_other.x + vector2.y * p_other.y


def cross(vector2, p_other):
    return vector2.x * p_other.y - vector2.y * p_other.x


def sign(v):
    sign = self
    sign.x = sign(v.x)
    sign.y = sign(v.y)
    return sign


def floor(v):
    floor = self
    floor.x = floor(v.x)
    floor.y = floor(v.y)
    return floor


def ceil(v):
    ceil = self
    ceil.x = ceil(v.x)
    ceil.y = ceil(v.y)
    return ceil


def round(v):
    round = self
    round.x = round(v.x)
    round.y = round(v.y)
    return round


def rotated(vec2, p_by):
    sine = math.sin(p_by)
    cosi = math.cos(p_by)
    import gdsbin.vector2

    vector2 = type(gdsbin.vector2)(gdsbin.vector2.__name__, gdsbin.vector2.__doc__)
    vector2.__dict__.update(gdsbin.vector2.__dict__)
    vector2.x = vec2.x * cosi - vec2.y * sine
    vector2.y = vec2.x * sine + vec2.y * cosi
    return vector2


def posmod(vec2, p_mod):
    import gdsbin.vector2

    vector2 = type(gdsbin.vector2)(gdsbin.vector2.__name__, gdsbin.vector2.__doc__)
    vector2.__dict__.update(gdsbin.vector2.__dict__)
    vector2.x = fposmod(vec2.x, p_mod)
    vector2.y = fposmod(vec2.y, p_mod)
    return vector2


def posmodv(vec2, p_modv):
    import gdsbin.vector2

    vector2 = type(gdsbin.vector2)(gdsbin.vector2.__name__, gdsbin.vector2.__doc__)
    vector2.__dict__.update(gdsbin.vector2.__dict__)
    vector2.x = fposmod(vec2.x, p_modv.x)
    vector2.y = fposmod(vec2.y, p_modv.y)
    return vector2


def project(vector2, p_to):
    return mul(p_to, dot(vector2, p_to) / p_to.length_squared(p_to))


def clamped(vec2, p_min, p_max):
    import gdsbin.vector2

    vector2 = type(gdsbin.vector2)(gdsbin.vector2.__name__, gdsbin.vector2.__doc__)
    vector2.__dict__.update(gdsbin.vector2.__dict__)
    vector2.x = clamp(vec2.x, p_min.x, p_max.x)
    vector2.y = clamp(vec2.y, p_min.y, p_max.y)
    return vector2


def snapped(vec2, p_step):
    import gdsbin.vector2

    vector2 = type(gdsbin.vector2)(gdsbin.vector2.__name__, gdsbin.vector2.__doc__)
    vector2.__dict__.update(gdsbin.vector2.__dict__)
    vector2.x = snapped(vec2.x, p_step.x)
    vector2.y = snapped(vec2.y, p_step.y)
    return vector2


def limit_length(vec2, p_len, v1):
    l = vec_length(v1)
    v = vec2
    if l > 0 and p_len < l:
        return mul(div(v, l), p_len)
    return v


def move_toward(vec2, p_to, p_delta):
    v = vec2
    vd = p_to.sub(v)
    len = vd.vec_length()
    if len <= p_delta:
        return p_to
    else:
        return add(v, mul(vd.div(len), p_delta))


def slide(vector2, p_normal):
    return sub(vector2, mul(p_normal, dot(vector2, p_normal)))


def bounce(vector2, p_normal):
    return inv(reflect(vector2, p_normal))


def reflect(vector2, p_normal):
    return sub(mul(mul(p_normal, 2.0), dot(vector2, p_normal)), vector2)


def vec_is_equal_approx(p_v, v):
    return math_is_equal_approx(v.x, p_v.x) and math_is_equal_approx(v.y, p_v.y)


def is_zero_approx(v):
    return is_zero_approx(v.x) and is_zero_approx(v.y)


def is_finite(v):
    return is_finite(v.x) and is_finite(v.y)


def sub(vec1, vec2):
    import gdsbin.vector2

    vector2 = type(gdsbin.vector2)(gdsbin.vector2.__name__, gdsbin.vector2.__doc__)
    vector2.__dict__.update(gdsbin.vector2.__dict__)
    vector2.x = vec1.x - vec2.x
    vector2.y = vec1.y - vec2.y
    return vector2


def add(vec1, vec2):
    import gdsbin.vector2

    vector2 = type(gdsbin.vector2)(gdsbin.vector2.__name__, gdsbin.vector2.__doc__)
    vector2.__dict__.update(gdsbin.vector2.__dict__)
    vector2.x = vec1.x + vec2.x
    vector2.y = vec1.y + vec2.y
    return vector2


def mul(vec, p_by):
    import gdsbin.vector2

    vector2 = type(gdsbin.vector2)(gdsbin.vector2.__name__, gdsbin.vector2.__doc__)
    vector2.__dict__.update(gdsbin.vector2.__dict__)
    vector2.x = vec.x * p_by
    vector2.y = vec.y * p_by
    return vector2


def inv(vec):
    import gdsbin.vector2

    vector2 = type(gdsbin.vector2)(gdsbin.vector2.__name__, gdsbin.vector2.__doc__)
    vector2.__dict__.update(gdsbin.vector2.__dict__)
    vector2.x = -vec.x
    vector2.y = -vec.y
    return vector2


def div(vec, p_by):
    import gdsbin.vector2

    vector2 = type(gdsbin.vector2)(gdsbin.vector2.__name__, gdsbin.vector2.__doc__)
    vector2.__dict__.update(gdsbin.vector2.__dict__)
    vector2.x = vec.x / p_by
    vector2.y = vec.y / p_by
    return vector2


def math_is_equal_approx(a, b):
    # Check for exact equality first, required to handle "infinity"values.
    if a == b:
        return True
    CMP_EPSILON = 0.00001
    tolerance = CMP_EPSILON * abs(a)
    if tolerance < CMP_EPSILON:
        tolerance = CMP_EPSILON
    return abs(a - b) < tolerance
