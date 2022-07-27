#!/usr/bin/env python 
def _init(): 
   main = Main() 
   path = "main.gd"
   path2 = "main.py"
   content = main.read(path) 
   out = main.transpile(content) 
   print(out) 
   main.save(path2, out) 
   quit() 
class Main: 
   types = [ "AABB", "Array", "Basis", "bool", "Callable", "Color", "Dictionary", "float", "int", "max", "nil", "NodePath", "Object", "PackedByteArray", "PackedColorArray", "PackedFloat32Array", "PackedFloat64Array", "PackedInt32Array", "PackedInt64Array", "PackedStringArray", "PackedVector2Array", "PackedVector3Array", "Plane", "Quaternion", "Rect2", "Rect2i", "RID", "Signal", "String", "StringName", "Transform2D", "Transform3D", "Vector2", "Vector2i", "Vector3", "Vector3i"] 
   op = [ "", ",", "[", "]", "+", "-", "*", "/", "+=", "-=", "*=", "/=", "=", "==", "!=", ">", "<", ">=", "<="] 
   debug = True 
   right_def = False 
   left_def = False 
    
   def transpile(self, content ):
      self.types.sort()
      t = ""
      for line in content.split( "\n"): 
         t += self.analyze(line)
       
      if self.left_def:
         t += "def left(s, amount):"
         t += "\n"
         t += "	return s[:amount]"
         t += "\n"
      if self.right_def:
         t += "def right(s, amount):"
         t += "\n"
         t += "	return s[len(s)-amount:]"
         t += "\n"
       
      t += "i"
      t += "f"
      t += " __name__=="
      t += "\""
      t += "__main__"
      t += "\""
      t += ":"
      t += "\n"
      t += "	_init()"
      t += "\n"
      return t 
   def read(self, path ):
      file = "" 
      file = open(path, "r") 
      string = file.read() 
      file.close() 
      return string 
   def save(self, path , content ):
      file = "" 
      file = open(path, "w") 
      file.write(content) 
      file.close() 
       
   def analyze(self, l ):
      out = ""
      string_prev = l.split( "\"" + "\\" + "\"" + "\"")
      c = 0 
      for ii in range(0, len(string_prev)): 
         string = string_prev[ii].split( "\"")
         if ii > 0: 
            out += "\"" + "\\" + "\"" + "\""
         for i in range(0, len(string)): 
            if ii > 0: 
               if string[i] == "\\"+ "\\":
                  out += "\"" + string[i] + "\""
               else: 
                  out += string[i] 
            elif c ^ 1 != c + 1: 
               out += "\"" + string[i] + "\""
            else: 
               out += self.translate(string[i])
            c+=1 
      if len(out) > 0: 
         res = "res"
         res += "://"
         while 0 <= out.find(res): 
            out = out.replace(res, "") 
         while 0 <= out.find( "if") and out.endswith( "\""):
            out += ":"
         out += "\n"
      return out 
   def translate(self, e ):
      if (e == ","): 
         return ","
      if (e == ""): 
         return ""
      args = e.split( " ") 
      e = ""
      for arg in args: 
         if len(arg)==0: 
            continue 
         if arg in self.op:
            e += arg 
            e += " "
            continue 
         while (arg.startswith( "	")): 
            e += "	"
            arg = right(arg, len(arg)-1)
         if arg == "#!/usr/bin/godot":
            e += "#!/usr/bin/env python"
            e += " "
            continue 
         if arg == "-s":
            continue 
         if arg in self.types:
            continue 
         if arg == "var":
            continue 
         if arg == "Node":
            continue 
         if arg == "SceneTree":
            continue 
         if arg == "func":
            e += "def"
            e += " "
            continue 
         if arg == "true":
            e += "True"
            e += " "
            continue 
         if arg == "false":
            e += "False"
            e += " "
            continue 
         if arg == ":":
            continue 
         if arg == "extends":
            continue 
         if arg == "File":
            continue 
         if arg == "File.new()":
            e += "\""
            e += "\""
            e += " "
            continue 
         con = False 
         while 0 <= arg.find( ".size()"): 
            arg = arg.replace( ".size()", ")") 
            if 0 <= arg.find( "("): 
               arg = arg.replace( "(", "(len(") 
            else: 
               arg = "len("+ arg 
            con = True 
         while 0 <= arg.find( ".length()"): 
            arg = arg.replace( ".length()", ")") 
            if 0 <= arg.find( "("): 
               arg = arg.replace( "(", "(len(") 
            else: 
               arg = "len("+ arg 
            con = True 
         while 0 <= arg.find( ".right("): 
            arg = arg.replace( ".right(", ", ") 
            arg = "right("+ arg 
            self.right_def = True 
            con = True 
         while 0 <= arg.find( ".left("): 
            arg = arg.replace( ".left(", ", ") 
            arg = "left("+ arg 
            self.left_def = True 
            con = True 
         while 0 <= arg.find( ".open"): 
            arg = arg.replace( ".open", " = open") 
            con = True 
         while 0 <= arg.find( ".begins_with"): 
            arg = arg.replace( ".begins_with", ".startswith") 
            con = True 
         while 0 <= arg.find( ".ends_with"): 
            arg = arg.replace( ".ends_with", ".endswith") 
            con = True 
         while 0 <= arg.find( ".contains"): 
            arg = arg.replace( ".contains", ".find") 
            arg = "0 <= "+ arg 
            con = True 
         while 0 <= arg.find( "File.READ"): 
            r = ""
            r += "\""
            r += "r"
            r += "\""
            arg = arg.replace( "File.READ", r) 
            con = True 
         while 0 <= arg.find( "File.WRITE"): 
            w = ""
            w += "\""
            w += "w"
            w += "\""
            arg = arg.replace( "File.WRITE", w) 
            con = True 
         while 0 <= arg.find( ".get_as_text"): 
            arg = arg.replace( ".get_as_text", ".read") 
            con = True 
         while 0 <= arg.find( ".store_string"): 
            arg = arg.replace( ".store_string", ".write") 
            con = True 
         while 0 <= (arg.find( ".new()")): 
            arg = arg.replace( ".new()", "()") 
            con = True 
         found = False 
         for type in self.types:
            while arg.startswith(type): 
               found = True 
               arg = arg.replace(type, "") 
               break 
         if found: 
            e += arg 
            e += " "
            continue 
         if con: 
            e += arg 
            e += " "
            continue 
         if self.debug:
            print( "DEBUG: "+ arg) 
         e += arg 
         e += " "
      while 0 <= e.find( "	"): 
         e = e.replace( "	", "   ") 
      return e 
def right(s, amount):
	return s[len(s)-amount:]
if __name__=="__main__":
	_init()
