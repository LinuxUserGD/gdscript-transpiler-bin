from subprocess import call, TimeoutExpired

timeLimit = 40  # seconds
errMsg = ''
ret_code = 0
f = open('report.txt','w')

try:
    ret_code = call('D:\a\gdscript-transpiler-bin\gdscript-transpiler-bin\gdscript-transpiler-bin\godot.exe D:\a\gdscript-transpiler-bin\gdscript-transpiler-bin\gdscript-transpiler-bin\project.godot -v --headless --path "D:\a\gdscript-transpiler-bin\gdscript-transpiler-bin\gdscript-transpiler-bin" --export "Web" D:\a\gdscript-transpiler-bin\gdscript-transpiler-bin\gdscript-transpiler-bin\temp/index.html', stdout = f, stderr = f, timeout = timeLimit)

except TimeoutExpired as e:
    errMsg = 'Error: Time limit exceeded, terminating..'

except Exception as e:
    errMsg = 'Error: ' + str(e)

if ret_code:
    errMsg = 'Error: ' + str(ret_code)

f.write(errMsg)
f.close()