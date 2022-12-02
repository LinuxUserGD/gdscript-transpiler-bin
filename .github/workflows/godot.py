import subprocess
cmd = ['D:/a/gdscript-transpiler-bin/gdscript-transpiler-bin/gdscript-transpiler-bin/godot.exe', 'D:/a/gdscript-transpiler-bin/gdscript-transpiler-bin/gdscript-transpiler-bin/project.godot', '-v', '--headless', '--path', 'D:/a/gdscript-transpiler-bin/gdscript-transpiler-bin/gdscript-transpiler-bin', '--export', '\"Web\"', 'D:/a/gdscript-transpiler-bin/gdscript-transpiler-bin/gdscript-transpiler-bin/temp/index.html']
try:
    subprocess.run(cmd, timeout=40)
except subprocess.TimeoutExpired:
    print("done")