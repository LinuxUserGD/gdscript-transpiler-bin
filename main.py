import os

types = [ "var", "AABB", "Array", "Basis", "bool", "Callable", "Color", "Dictionary", "float", "int", "max", "nil", "NodePath", "Object", "PackedByteArray", "PackedColorArray", "PackedFloat32Array", "PackedFloat64Array", "PackedInt32Array", "PackedInt64Array", "PackedStringArray", "PackedVector2Array", "PackedVector3Array", "Plane", "Quaternion", "Rect2", "Rect2i", "RID", "Signal", "String", "StringName", "Transform2D", "Transform3D", "Vector2", "Vector2i", "Vector3", "Vector3i"]

def _ready():
  path = "main.gd"
  content = read(path)
  out = transpile(content)
  print(out)

def transpile(content):
  types.sort()
  translated = ""
  for line in content.split("\n"):
    translated += analyze(line) + "\n"
  return translated

def read(path):
  file = open(path, "r")
  data = file.read()
  file.close()
  return data

def analyze(l):
  out = ""
  string_prev = l.split("\"" + "\\" + "\"" + "\"")
  c = 0
  for ii in range(0, len(string_prev)):
    string = string_prev[ii].split("\"")
    if ii > 0:
      out += "\"" + "\\" + "\"" + "\""
    for i in range(0, len(string)):
      if ii > 0:
        if string[i] == "\\" + "\\":
          out += "\"" + string[i] + "\""
        else:
          out += string[i]
      elif c ^ 1 != c + 1:
        out += "\"" + string[i] + "\""
      else:
        out += translate(string[i])
      c+=1
  return out

def translate(e):
  old_args = e.split(" ")
  e = ""
  args = e.split(" ")
  for arg in old_args:
    if len(arg)>0:
      args.append(arg)
  if len(args) > 0:
    for i in range(0, len(args)):
      if args[i] != "":
        if args[i] == "extends":
          args[i] = "import"
        elif args[i] == "func":
          args[i] = "def"
        for type in types:
          if args[i].find(":" + type):
            args[i] = args[i].replace(":" + type, "")
          elif args[i].find(type + ")"):
            args[i] = args[i].replace(type + ")", ")")
          elif args[i] == type:
            args[i] = ""
          elif args[i] == ":" and i < len(args)-1:
            args[i] = ""
        if len(args[i]) > 0 and i > 0 and not args[i].startswith(")"):
          e += " " + args[i]
        else:
          e += args[i]
    if old_args[len(old_args)-1] == "":
      	e += " "
  return e

if __name__=="__main__":
  _ready()
