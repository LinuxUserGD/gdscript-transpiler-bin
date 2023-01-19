import subprocess
cmd = ['/home/runner/work/gdscript-transpiler-bin/gdscript-transpiler-bin/godot', 'D:/a/gdscript-transpiler-bin/gdscript-transpiler-bin/gdscript-transpiler-bin/project.godot', '-v', '--headless', '--path', 'D:/a/gdscript-transpiler-bin/gdscript-transpiler-bin/gdscript-transpiler-bin', '--export', '\"Web\"', '/home/runner/work/gdscript-transpiler-bin/gdscript-transpiler-bin/temp/index.html']
try:
    subprocess.run(cmd, timeout=20)
except subprocess.TimeoutExpired:
    print("done")
cmd = ['/home/runner/work/gdscript-transpiler-bin/gdscript-transpiler-bin/godot', '--headless', '--path', 'D:/a/gdscript-transpiler-bin/gdscript-transpiler-bin/gdscript-transpiler-bin', '--export', '\"Web\"', '/home/runner/work/gdscript-transpiler-bin/gdscript-transpiler-bin/dist/index.html']
try:
    subprocess.run(cmd, timeout=20)
except subprocess.TimeoutExpired:
    print("done")
