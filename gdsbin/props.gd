class_name Props

## GDScript Transpiler Properties Class
##
## Properties for Transpiler
##

var extend: Array = []

## Godot built-in types
var types: Array = [
	"AABB",
	"Array",
	"Basis",
	"bool",
	"Callable",
	"Color",
	"Dictionary",
	"float",
	"int",
	"max",
	"nil",
	"NodePath",
	"Object",
	"Thread",
	"PackedByteArray",
	"PackedColorArray",
	"PackedFloat32Array",
	"PackedFloat64Array",
	"PackedInt32Array",
	"PackedInt64Array",
	"PackedStringArray",
	"PackedVector2Array",
	"PackedVector3Array",
	"Plane",
	"Quaternion",
	"Rect2",
	"Rect2i",
	"RID",
	"Signal",
	"String",
	"StringName",
	"Transform2D",
	"Transform3D",
	"Vector2",
	"Vector2i",
	"Vector3",
	"Vector3i",
	"void"
]
## Common gdscript operations (for parsing)
const op: Array = [
	"",
	",",
	"[",
	"]",
	"+",
	"-",
	"*",
	"/",
	"+=",
	"-=",
	"*=",
	"/=",
	"=",
	"==",
	"!=",
	">",
	"<",
	">=",
	"<="
]
## Dictionary to replace GDScript syntax with valid Python code
const repl_dict: Dictionary = {
	"-s": "",
	"var": "",
	"const": "",
	"Node": "",
	"SceneTree": "",
	"_ready()": "_init()",
	"_init()": "_init()",
	"_ready():": "_init():",
	"_init():": "_init():",
	"func": "def",
	"true": "True",
	"false": "False",
	"null": "None",
	"&&": "and",
	"||": "or",
	":": "",
	"extends": "",
	"class_name": "",
	"File": "",
	"OS.execute('python',['-c','import": "",
	"sys;print(sys.version)'],stdout,true,false)": "stdout = [sys.version]",
	"OS.execute('python',['-c',import_str1+": "",
	"OS.execute('python',['-c',import_str2+": "",
	"OS.execute('python',['-c',import_str3+": "",
	"OS.execute('python',['-c',imp+": "",
	"OS.execute('python',['-c',xpy+": "",
	"OS.execute('python',['-c',nuitka+": "",
	"';print(Version.getNuitkaVersion())'],stdout,true,false)":
	"stdout = [Version.getNuitkaVersion()]",
	"';print(black.__version__)'],stdout,true,false)":
	"stdout = [black.__version__]",
	"';black.reformat_one(src=src,fast=False,write_back=write_back,mode=mode,report=report)'],stdout,true,false)":
	"versions = set()" + "\n" + "    mode = black.mode.Mode(target_versions=versions,line_length=black.const.DEFAULT_LINE_LENGTH,is_pyi=False,is_ipynb=False,skip_source_first_line=False,string_normalization=True,magic_trailing_comma=True,experimental_string_processing=False,preview=False,python_cell_magics=set(black.handle_ipynb_magics.PYTHON_CELL_MAGICS),)" + "\n" + "    report=black.report.Report(check=False,diff=False,quiet=True,verbose=False)" + "\n" + "    write_back=black.WriteBack.from_configuration(check=False,diff=False,color=False)" + "\n" + "    src=black.Path(_imp_string+'py')" + "\n" + "    black.reformat_one(src=src,fast=False,write_back=write_back,mode=mode,report=report)",
	"';ziglang.__main__'],stdout,true,false)":
	"sys.argv=['zig','version']" + "\n" + "    import ziglang.__main__" + "\n" + "    stdout = [ziglang.__main__]",
	"';nuitka.__main__.main()'],stdout,true,false)":
	"import subprocess" + "\n" + "    x=sys.executable" + "\n" + "    xx=" + "'" + "-m" + "'" + "\n" + "    xxx=" + "'" + "nuitka" + "'" + "\n" + "    y=pathstr+" + "'" + "py" + "'" + "\n" + "    z=" + "'" + "--onefile" + "'" + "\n" + "    a=" + "'" + "--lto=yes" + "'" + "\n" + "    b=" + "'" + "--static-libpython=no" + "'" + "\n" + "    c=" + "'" + "--clang" + "'" + "\n" + "    d=" + "'" + "--assume-yes-for-downloads" + "'" + "\n" + "    e=" + "'" + "--include-package-data=blib2to3" + "'" + "\n" + "    f=" + "'" + "--include-package-data=ziglang" + "'" + "\n" + "    g=" + "'" + "--noinclude-data-files=ziglang/doc" + "'" + "\n" + "    args=[x + ' ' + xx + ' ' + xxx + ' ' + y + ' ' + z + ' ' + a + ' ' + b + ' ' + c + ' ' + d + ' ' + e + ' ' + f + ' ' + g]" + "\n" + "    proc = subprocess.Popen(args, shell = True)" + "\n" + "    proc.communicate()" + "\n" + "    stdout = []",
	"quit()": "sys.exit()",
	"self.quit()": "sys.exit()",
	"#!/usr/bin/godot": "",
	"File.new()": "",
	"Thread.new()": "",
}

const pyproject_toml: Array = [
	"[build-system]",
	"requires = ['setuptools>=42']",
	"build-backend = 'setuptools.build_meta'",
]

const setup: Array = [
	"#!/usr/bin/env python",
	"from setuptools import setup, find_packages",
	"# Parse version number from gdsbin/version.py:",
	"with open('gdsbin/version.py') as f:",
	"    info = {}",
	"    for line in f:",
	"        if line.startswith('__version__'):",
	"            exec(line, info)",
	"            break",
	"install_requires = []",
	"with open('requirements.txt') as f:",
	"    for line in f:",
	"        if line and not line.startswith('#'):",
	"            install_requires.append(line)",
	"setup_info = dict(",
	"    name='gdsbin',",
	"    version=info['__version__'],",
	"    author='LinuxUserGD',",
	"    author_email='hugegameartgd@gmail.com',",
	"    url='https://codeberg.org/LinuxUserGD/gdscript-transpiler-bin',",
	"    download_url='https://linuxusergd.itch.io/gdscript-transpiler-bin',",
	"    project_urls={",
	"        'Documentation': 'https://codeberg.org/LinuxUserGD/gdscript-transpiler-bin/wiki',",
	"        'Source': 'https://codeberg.org/LinuxUserGD/gdscript-transpiler-bin',",
	"        'Tracker': 'https://codeberg.org/LinuxUserGD/gdscript-transpiler-bin/issues',",
	"    },",
	"    description='GDScript and Python runtime environment',",
	"    long_description=open('README.md').read(),",
	"    long_description_content_type='text/markdown',",
	"    license='MIT',",
	"    classifiers=[",
	"        'License :: OSI Approved :: MIT License',",
	"        'Operating System :: MacOS :: MacOS X',",
	"        'Operating System :: Microsoft :: Windows',",
	"        'Operating System :: POSIX :: Linux',",
	"        'Programming Language :: Python :: 2',",
	"        'Programming Language :: Python :: 2.7',",
	"        'Programming Language :: Python :: 3',",
	"        'Programming Language :: Python :: 3.3',",
	"        'Programming Language :: Python :: 3.4',",
	"        'Programming Language :: Python :: 3.5',",
	"        'Programming Language :: Python :: 3.6',",
	"        'Programming Language :: Python :: 3.7',",
	"        'Programming Language :: Python :: 3.8',",
	"        'Programming Language :: Python :: 3.9',",
	"        'Programming Language :: Python :: 3.10',",
	"        'Programming Language :: Python :: 3.11',",
	"        'Topic :: Software Development :: Libraries :: Python Modules',",
	"    ],",
	"    # Package info",
	"    packages=['gdsbin'] + ['gdsbin.' + pkg for pkg in find_packages('gdsbin')] + ['test'] + ['test.' + pkg for pkg in find_packages('test')],",
	"    # Add _ prefix to the names of temporary build dirs",
	"    options={'build': {'build_base': '_build'}, },",
	"    zip_safe=True,",
	"    install_requires=install_requires,",
	")",
	"setup(**setup_info)",
]

## Add additional python import to transpiled script if required
var py_imp: bool = false
## Print additional parsing information if true
var debug: bool = false
## Print transpiled script as output to console
var verbose: bool = false
## Add additional python code for _init() method to transpiled script if required
var init_def: bool = false
## Add additional python code for Thread class to transpiled script if required
var thread_def: bool = false
## Add additional python code for resize() method to transpiled script if required
var resize_def: bool = false
## Add additional python code for right() method to transpiled script if required
var right_def: bool = false
## Add additional python code for left() method to transpiled script if required
var left_def: bool = false
## Add additional python code for newinstance() method to transpiled script if required
var newinstance_def: bool = false
## Add additional python sys import to transpiled script if required
var sys_imp: bool = false
## Add additional python os import to transpiled script if required
var os_imp: bool = false
## Add additional python nuitka version import to transpiled script if required
var nuitka_imp: bool = false
## Add additional python black import to transpiled script if required
var black_imp: bool = false
## Add additional python math import to transpiled script if required
var math_imp: bool = false
## Add additional python random import to transpiled script if required
var rand_imp: bool = false
## Add additional python datetime import to transpiled script if required
var datetime_imp: bool = false
## Add additional python zig import to transpiled script if required
var zig_imp: bool = false
## GDScript dependencies
var gds_deps : Array = []
## Internal GDScript to exclude
var gds_class : Array = ["File"]
## Godot classes to exclude
const gd_class : Array = [ "@GDScript",
	"@GlobalScope",
	"Node",
	"AcceptDialog",
	"AnimatableBody2D",
	"AnimatableBody3D",
	"AnimatedSprite2D",
	"AnimatedSprite3D",
	"AnimationPlayer",
	"AnimationTree",
	"Area2D",
	"Area3D",
	"AspectRatioContainer",
	"AudioListener2D",
	"AudioListener3D",
	"AudioStreamPlayer",
	"AudioStreamPlayer2D",
	"AudioStreamPlayer3D",
	"BackBufferCopy",
	"BaseButton",
	"Bone2D",
	"BoneAttachment3D",
	"BoxContainer",
	"Button",
	"Camera2D",
	"Camera3D",
	"CanvasGroup",
	"CanvasItem",
	"CanvasLayer",
	"CanvasModulate",
	"CenterContainer",
	"CharacterBody2D",
	"CharacterBody3D",
	"CheckBox",
	"CheckButton",
	"CodeEdit",
	"CollisionObject2D",
	"CollisionObject3D",
	"CollisionPolygon2D",
	"CollisionPolygon3D",
	"CollisionShape2D",
	"CollisionShape3D",
	"ColorPicker",
	"ColorPickerButton",
	"ColorRect",
	"ConeTwistJoint3D",
	"ConfirmationDialog",
	"Container",
	"Control",
	"CPUParticles2D",
	"CPUParticles3D",
	"CSGBox3D",
	"CSGCombiner3D",
	"CSGCylinder3D",
	"CSGMesh3D",
	"CSGPolygon3D",
	"CSGPrimitive3D",
	"CSGShape3D",
	"CSGSphere3D",
	"CSGTorus3D",
	"DampedSpringJoint2D",
	"Decal",
	"DirectionalLight2D",
	"DirectionalLight3D",
	"EditorCommandPalette",
	"EditorFileDialog",
	"EditorFileSystem",
	"EditorInspector",
	"EditorInterface",
	"EditorPlugin",
	"EditorProperty",
	"EditorResourcePicker",
	"EditorResourcePreview",
	"EditorScriptPicker",
	"EditorSpinSlider",
	"FileDialog",
	"FileSystemDock",
	"FlowContainer",
	"FogVolume",
	"Generic6DOFJoint3D",
	"GeometryInstance3D",
	"GPUParticles2D",
	"GPUParticles3D",
	"GPUParticlesAttractor3D",
	"GPUParticlesAttractorBox3D",
	"GPUParticlesAttractorSphere3D",
	"GPUParticlesAttractorVectorField3D",
	"GPUParticlesCollision3D",
	"GPUParticlesCollisionBox3D",
	"GPUParticlesCollisionHeightField3D",
	"GPUParticlesCollisionSDF3D",
	"GPUParticlesCollisionSphere3D",
	"GraphEdit",
	"GraphNode",
	"GridContainer",
	"GridMap",
	"GrooveJoint2D",
	"HBoxContainer",
	"HFlowContainer",
	"HingeJoint3D",
	"HScrollBar",
	"HSeparator",
	"HSlider",
	"HSplitContainer",
	"HTTPRequest",
	"ImporterMeshInstance3D",
	"InstancePlaceholder",
	"ItemList",
	"Joint2D",
	"Joint3D",
	"Label",
	"Label3D",
	"Light2D",
	"Light3D",
	"LightmapGI",
	"LightmapProbe",
	"LightOccluder2D",
	"Line2D",
	"LineEdit",
	"LinkButton",
	"MarginContainer",
	"Marker2D",
	"Marker3D",
	"MenuBar",
	"MenuButton",
	"MeshInstance2D",
	"MeshInstance3D",
	"MissingNode",
	"MultiMeshInstance2D",
	"MultiMeshInstance3D",
	"MultiplayerSpawner",
	"MultiplayerSynchronizer",
	"NavigationAgent2D",
	"NavigationAgent3D",
	"NavigationLink2D",
	"NavigationLink3D",
	"NavigationObstacle2D",
	"NavigationObstacle3D",
	"NavigationRegion2D",
	"NavigationRegion3D",
	"NinePatchRect",
	"Node2D",
	"Node3D",
	"OccluderInstance3D",
	"OmniLight3D",
	"OpenXRHand",
	"OptionButton",
	"Panel",
	"PanelContainer",
	"ParallaxBackground",
	"ParallaxLayer",
	"Path2D",
	"Path3D",
	"PathFollow2D",
	"PathFollow3D",
	"PhysicalBone2D",
	"PhysicalBone3D",
	"PhysicsBody2D",
	"PhysicsBody3D",
	"PinJoint2D",
	"PinJoint3D",
	"PointLight2D",
	"Polygon2D",
	"Popup",
	"PopupMenu",
	"PopupPanel",
	"ProgressBar",
	"Range",
	"RayCast2D",
	"RayCast3D",
	"ReferenceRect",
	"ReflectionProbe",
	"RemoteTransform2D",
	"RemoteTransform3D",
	"ResourcePreloader",
	"RichTextLabel",
	"RigidBody2D",
	"RigidBody3D",
	"RootMotionView",
	"ScriptCreateDialog",
	"ScriptEditor",
	"ScriptEditorBase",
	"ScrollBar",
	"ScrollContainer",
	"Separator",
	"ShaderGlobalsOverride",
	"ShapeCast2D",
	"ShapeCast3D",
	"Skeleton2D",
	"Skeleton3D",
	"SkeletonIK3D",
	"Slider",
	"SliderJoint3D",
	"SoftBody3D",
	"SpinBox",
	"SplitContainer",
	"SpotLight3D",
	"SpringArm3D",
	"Sprite2D",
	"Sprite3D",
	"SpriteBase3D",
	"StaticBody2D",
	"StaticBody3D",
	"SubViewport",
	"SubViewportContainer",
	"TabBar",
	"TabContainer",
	"TextEdit",
	"TextureButton",
	"TextureProgressBar",
	"TextureRect",
	"TileMap",
	"Timer",
	"TouchScreenButton",
	"Tree",
	"VBoxContainer",
	"VehicleBody3D",
	"VehicleWheel3D",
	"VFlowContainer",
	"VideoStreamPlayer",
	"Viewport",
	"VisibleOnScreenEnabler2D",
	"VisibleOnScreenEnabler3D",
	"VisibleOnScreenNotifier2D",
	"VisibleOnScreenNotifier3D",
	"VisualInstance3D",
	"VoxelGI",
	"VScrollBar",
	"VSeparator",
	"VSlider",
	"VSplitContainer",
	"Window",
	"WorldEnvironment",
	"XRAnchor3D",
	"XRCamera3D",
	"XRController3D",
	"XRNode3D",
	"XROrigin3D",
	"Resource",
	"AnimatedTexture",
	"Animation",
	"AnimationLibrary",
	"AnimationNode",
	"AnimationNodeAdd2",
	"AnimationNodeAdd3",
	"AnimationNodeAnimation",
	"AnimationNodeBlend2",
	"AnimationNodeBlend3",
	"AnimationNodeBlendSpace1D",
	"AnimationNodeBlendSpace2D",
	"AnimationNodeBlendTree",
	"AnimationNodeOneShot",
	"AnimationNodeOutput",
	"AnimationNodeStateMachine",
	"AnimationNodeStateMachinePlayback",
	"AnimationNodeStateMachineTransition",
	"AnimationNodeSync",
	"AnimationNodeTimeScale",
	"AnimationNodeTimeSeek",
	"AnimationNodeTransition",
	"AnimationRootNode",
	"ArrayMesh",
	"ArrayOccluder3D",
	"AtlasTexture",
	"AudioBusLayout",
	"AudioEffect",
	"AudioEffectAmplify",
	"AudioEffectBandLimitFilter",
	"AudioEffectBandPassFilter",
	"AudioEffectCapture",
	"AudioEffectChorus",
	"AudioEffectCompressor",
	"AudioEffectDelay",
	"AudioEffectDistortion",
	"AudioEffectEQ",
	"AudioEffectEQ10",
	"AudioEffectEQ21",
	"AudioEffectEQ6",
	"AudioEffectFilter",
	"AudioEffectHighPassFilter",
	"AudioEffectHighShelfFilter",
	"AudioEffectLimiter",
	"AudioEffectLowPassFilter",
	"AudioEffectLowShelfFilter",
	"AudioEffectNotchFilter",
	"AudioEffectPanner",
	"AudioEffectPhaser",
	"AudioEffectPitchShift",
	"AudioEffectRecord",
	"AudioEffectReverb",
	"AudioEffectSpectrumAnalyzer",
	"AudioEffectStereoEnhance",
	"AudioStream",
	"AudioStreamGenerator",
	"AudioStreamMicrophone",
	"AudioStreamMP3",
	"AudioStreamOggVorbis",
	"AudioStreamRandomizer",
	"AudioStreamWAV",
	"BaseMaterial3D",
	"BitMap",
	"BoneMap",
	"BoxMesh",
	"BoxOccluder3D",
	"BoxShape3D",
	"ButtonGroup",
	"CameraAttributes",
	"CameraAttributesPhysical",
	"CameraAttributesPractical",
	"CameraTexture",
	"CanvasItemMaterial",
	"CanvasTexture",
	"CapsuleMesh",
	"CapsuleShape2D",
	"CapsuleShape3D",
	"CircleShape2D",
	"CodeHighlighter",
	"CompressedCubemap",
	"CompressedCubemapArray",
	"CompressedTexture2D",
	"CompressedTexture2DArray",
	"CompressedTexture3D",
	"CompressedTextureLayered",
	"ConcavePolygonShape2D",
	"ConcavePolygonShape3D",
	"ConvexPolygonShape2D",
	"ConvexPolygonShape3D",
	"CryptoKey",
	"CSharpScript",
	"Cubemap",
	"CubemapArray",
	"Curve",
	"Curve2D",
	"Curve3D",
	"CurveTexture",
	"CurveXYZTexture",
	"CylinderMesh",
	"CylinderShape3D",
	"EditorNode3DGizmoPlugin",
	"EditorSettings",
	"EditorSyntaxHighlighter",
	"Environment",
	"FastNoiseLite",
	"FogMaterial",
	"Font",
	"FontFile",
	"FontVariation",
	"GDExtension",
	"GDScript",
	"GLTFAccessor",
	"GLTFAnimation",
	"GLTFBufferView",
	"GLTFCamera",
	"GLTFDocument",
	"GLTFDocumentExtension",
	"GLTFDocumentExtensionConvertImporterMesh",
	"GLTFLight",
	"GLTFMesh",
	"GLTFNode",
	"GLTFSkeleton",
	"GLTFSkin",
	"GLTFSpecGloss",
	"GLTFState",
	"GLTFTexture",
	"GLTFTextureSampler",
	"Gradient",
	"GradientTexture1D",
	"GradientTexture2D",
	"HeightMapShape3D",
	"Image",
	"ImageTexture",
	"ImageTexture3D",
	"ImageTextureLayered",
	"ImmediateMesh",
	"ImporterMesh",
	"InputEvent",
	"InputEventAction",
	"InputEventFromWindow",
	"InputEventGesture",
	"InputEventJoypadButton",
	"InputEventJoypadMotion",
	"InputEventKey",
	"InputEventMagnifyGesture",
	"InputEventMIDI",
	"InputEventMouse",
	"InputEventMouseButton",
	"InputEventMouseMotion",
	"InputEventPanGesture",
	"InputEventScreenDrag",
	"InputEventScreenTouch",
	"InputEventShortcut",
	"InputEventWithModifiers",
	"LabelSettings",
	"LightmapGIData",
	"Material",
	"Mesh",
	"MeshLibrary",
	"MeshTexture",
	"MissingResource",
	"MultiMesh",
	"NavigationMesh",
	"NavigationPolygon",
	"Noise",
	"NoiseTexture2D",
	"Occluder3D",
	"OccluderPolygon2D",
	"OggPacketSequence",
	"OpenXRAction",
	"OpenXRActionMap",
	"OpenXRActionSet",
	"OpenXRInteractionProfile",
	"OpenXRIPBinding",
	"OptimizedTranslation",
	"ORMMaterial3D",
	"PackedDataContainer",
	"PackedScene",
	"PanoramaSkyMaterial",
	"ParticleProcessMaterial",
	"PhysicalSkyMaterial",
	"PhysicsMaterial",
	"PlaceholderCubemap",
	"PlaceholderCubemapArray",
	"PlaceholderMaterial",
	"PlaceholderMesh",
	"PlaceholderTexture2D",
	"PlaceholderTexture2DArray",
	"PlaceholderTexture3D",
	"PlaceholderTextureLayered",
	"PlaneMesh",
	"PointMesh",
	"PolygonOccluder3D",
	"PolygonPathFinder",
	"PortableCompressedTexture2D",
	"PrimitiveMesh",
	"PrismMesh",
	"ProceduralSkyMaterial",
	"QuadMesh",
	"QuadOccluder3D",
	"RDShaderFile",
	"RDShaderSPIRV",
	"RectangleShape2D",
	"RibbonTrailMesh",
	"RichTextEffect",
	"SceneReplicationConfig",
	"Script",
	"ScriptExtension",
	"SegmentShape2D",
	"SeparationRayShape2D",
	"SeparationRayShape3D",
	"Shader",
	"ShaderInclude",
	"ShaderMaterial",
	"Shape2D",
	"Shape3D",
	"Shortcut",
	"SkeletonModification2D",
	"SkeletonModification2DCCDIK",
	"SkeletonModification2DFABRIK",
	"SkeletonModification2DJiggle",
	"SkeletonModification2DLookAt",
	"SkeletonModification2DPhysicalBones",
	"SkeletonModification2DStackHolder",
	"SkeletonModification2DTwoBoneIK",
	"SkeletonModification3D",
	"SkeletonModification3DCCDIK",
	"SkeletonModification3DFABRIK",
	"SkeletonModification3DJiggle",
	"SkeletonModification3DLookAt",
	"SkeletonModification3DStackHolder",
	"SkeletonModification3DTwoBoneIK",
	"SkeletonModificationStack2D",
	"SkeletonModificationStack3D",
	"SkeletonProfile",
	"SkeletonProfileHumanoid",
	"Skin",
	"Sky",
	"SphereMesh",
	"SphereOccluder3D",
	"SphereShape3D",
	"SpriteFrames",
	"StandardMaterial3D",
	"StyleBox",
	"StyleBoxEmpty",
	"StyleBoxFlat",
	"StyleBoxLine",
	"StyleBoxTexture",
	"SyntaxHighlighter",
	"SystemFont",
	"TextMesh",
	"Texture",
	"Texture2D",
	"Texture2DArray",
	"Texture3D",
	"TextureLayered",
	"Theme",
	"TileMapPattern",
	"TileSet",
	"TileSetAtlasSource",
	"TileSetScenesCollectionSource",
	"TileSetSource",
	"TorusMesh",
	"Translation",
	"TubeTrailMesh",
	"VideoStream",
	"VideoStreamTheora",
	"ViewportTexture",
	"VisualShader",
	"VisualShaderNode",
	"VisualShaderNodeBillboard",
	"VisualShaderNodeBooleanConstant",
	"VisualShaderNodeBooleanParameter",
	"VisualShaderNodeClamp",
	"VisualShaderNodeColorConstant",
	"VisualShaderNodeColorFunc",
	"VisualShaderNodeColorOp",
	"VisualShaderNodeColorParameter",
	"VisualShaderNodeComment",
	"VisualShaderNodeCompare",
	"VisualShaderNodeConstant",
	"VisualShaderNodeCubemap",
	"VisualShaderNodeCubemapParameter",
	"VisualShaderNodeCurveTexture",
	"VisualShaderNodeCurveXYZTexture",
	"VisualShaderNodeCustom",
	"VisualShaderNodeDerivativeFunc",
	"VisualShaderNodeDeterminant",
	"VisualShaderNodeDistanceFade",
	"VisualShaderNodeDotProduct",
	"VisualShaderNodeExpression",
	"VisualShaderNodeFaceForward",
	"VisualShaderNodeFloatConstant",
	"VisualShaderNodeFloatFunc",
	"VisualShaderNodeFloatOp",
	"VisualShaderNodeFloatParameter",
	"VisualShaderNodeFresnel",
	"VisualShaderNodeGlobalExpression",
	"VisualShaderNodeGroupBase",
	"VisualShaderNodeIf",
	"VisualShaderNodeInput",
	"VisualShaderNodeIntConstant",
	"VisualShaderNodeIntFunc",
	"VisualShaderNodeIntOp",
	"VisualShaderNodeIntParameter",
	"VisualShaderNodeIs",
	"VisualShaderNodeLinearSceneDepth",
	"VisualShaderNodeMix",
	"VisualShaderNodeMultiplyAdd",
	"VisualShaderNodeOuterProduct",
	"VisualShaderNodeOutput",
	"VisualShaderNodeParameter",
	"VisualShaderNodeParameterRef",
	"VisualShaderNodeParticleAccelerator",
	"VisualShaderNodeParticleBoxEmitter",
	"VisualShaderNodeParticleConeVelocity",
	"VisualShaderNodeParticleEmit",
	"VisualShaderNodeParticleEmitter",
	"VisualShaderNodeParticleMeshEmitter",
	"VisualShaderNodeParticleMultiplyByAxisAngle",
	"VisualShaderNodeParticleOutput",
	"VisualShaderNodeParticleRandomness",
	"VisualShaderNodeParticleRingEmitter",
	"VisualShaderNodeParticleSphereEmitter",
	"VisualShaderNodeProximityFade",
	"VisualShaderNodeRandomRange",
	"VisualShaderNodeRemap",
	"VisualShaderNodeResizableBase",
	"VisualShaderNodeSample3D",
	"VisualShaderNodeScreenUVToSDF",
	"VisualShaderNodeSDFRaymarch",
	"VisualShaderNodeSDFToScreenUV",
	"VisualShaderNodeSmoothStep",
	"VisualShaderNodeStep",
	"VisualShaderNodeSwitch",
	"VisualShaderNodeTexture",
	"VisualShaderNodeTexture2DArray",
	"VisualShaderNodeTexture2DArrayParameter",
	"VisualShaderNodeTexture2DParameter",
	"VisualShaderNodeTexture3D",
	"VisualShaderNodeTexture3DParameter",
	"VisualShaderNodeTextureParameter",
	"VisualShaderNodeTextureParameterTriplanar",
	"VisualShaderNodeTextureSDF",
	"VisualShaderNodeTextureSDFNormal",
	"VisualShaderNodeTransformCompose",
	"VisualShaderNodeTransformConstant",
	"VisualShaderNodeTransformDecompose",
	"VisualShaderNodeTransformFunc",
	"VisualShaderNodeTransformOp",
	"VisualShaderNodeTransformParameter",
	"VisualShaderNodeTransformVecMult",
	"VisualShaderNodeUVFunc",
	"VisualShaderNodeUVPolarCoord",
	"VisualShaderNodeVarying",
	"VisualShaderNodeVaryingGetter",
	"VisualShaderNodeVaryingSetter",
	"VisualShaderNodeVec2Constant",
	"VisualShaderNodeVec2Parameter",
	"VisualShaderNodeVec3Constant",
	"VisualShaderNodeVec3Parameter",
	"VisualShaderNodeVec4Constant",
	"VisualShaderNodeVec4Parameter",
	"VisualShaderNodeVectorBase",
	"VisualShaderNodeVectorCompose",
	"VisualShaderNodeVectorDecompose",
	"VisualShaderNodeVectorDistance",
	"VisualShaderNodeVectorFunc",
	"VisualShaderNodeVectorLen",
	"VisualShaderNodeVectorOp",
	"VisualShaderNodeVectorRefract",
	"VoxelGIData",
	"World2D",
	"World3D",
	"WorldBoundaryShape2D",
	"WorldBoundaryShape3D",
	"X509Certificate",
	"Object",
	"AESContext",
	"AnimationTrackEditPlugin",
	"AStar2D",
	"AStar3D",
	"AStarGrid2D",
	"AudioEffectInstance",
	"AudioEffectSpectrumAnalyzerInstance",
	"AudioServer",
	"AudioStreamGeneratorPlayback",
	"AudioStreamPlayback",
	"AudioStreamPlaybackOggVorbis",
	"AudioStreamPlaybackResampled",
	"CallbackTweener",
	"CameraFeed",
	"CameraServer",
	"CharFXTransform",
	"ClassDB",
	"ConfigFile",
	"Crypto",
	"DirAccess",
	"DisplayServer",
	"DTLSServer",
	"EditorDebuggerPlugin",
	"EditorDebuggerSession",
	"EditorExportPlatform",
	"EditorExportPlugin",
	"EditorFeatureProfile",
	"EditorFileSystemDirectory",
	"EditorFileSystemImportFormatSupportQuery",
	"EditorImportPlugin",
	"EditorInspectorPlugin",
	"EditorNode3DGizmo",
	"EditorPaths",
	"EditorResourceConversionPlugin",
	"EditorResourcePreviewGenerator",
	"EditorSceneFormatImporter",
	"EditorSceneFormatImporterBlend",
	"EditorSceneFormatImporterFBX",
	"EditorSceneFormatImporterGLTF",
	"EditorScenePostImport",
	"EditorScenePostImportPlugin",
	"EditorScript",
	"EditorSelection",
	"EditorTranslationParserPlugin",
	"EditorUndoRedoManager",
	"EditorVCSInterface",
	"EncodedObjectAsID",
	"ENetConnection",
	"ENetMultiplayerPeer",
	"ENetPacketPeer",
	"Engine",
	"EngineDebugger",
	"EngineProfiler",
	"Expression",
	"FileAccess",
	"GDExtensionManager",
	"Geometry2D",
	"Geometry3D",
	"GodotSharp",
	"HashingContext",
	"HMACContext",
	"HTTPClient",
	"ImageFormatLoader",
	"ImageFormatLoaderExtension",
	"Input",
	"InputMap",
	"IntervalTweener",
	"IP",
	"JavaClass",
	"JavaClassWrapper",
	"JavaScriptBridge",
	"JavaScriptObject",
	"JNISingleton",
	"JSON",
	"JSONRPC",
	"KinematicCollision2D",
	"KinematicCollision3D",
	"Lightmapper",
	"LightmapperRD",
	"MainLoop",
	"Marshalls",
	"MeshDataTool",
	"MethodTweener",
	"MobileVRInterface",
	"MovieWriter",
	"MultiplayerAPI",
	"MultiplayerAPIExtension",
	"MultiplayerPeer",
	"MultiplayerPeerExtension",
	"Mutex",
	"NavigationMeshGenerator",
	"NavigationPathQueryParameters2D",
	"NavigationPathQueryParameters3D",
	"NavigationPathQueryResult2D",
	"NavigationPathQueryResult3D",
	"NavigationServer2D",
	"NavigationServer3D",
	"Node",
	"Node3DGizmo",
	"OfflineMultiplayerPeer",
	"OggPacketSequencePlayback",
	"OpenXRInterface",
	"OS",
	"PackedDataContainerRef",
	"PacketPeer",
	"PacketPeerDTLS",
	"PacketPeerExtension",
	"PacketPeerStream",
	"PacketPeerUDP",
	"PCKPacker",
	"Performance",
	"PhysicsDirectBodyState2D",
	"PhysicsDirectBodyState2DExtension",
	"PhysicsDirectBodyState3D",
	"PhysicsDirectBodyState3DExtension",
	"PhysicsDirectSpaceState2D",
	"PhysicsDirectSpaceState2DExtension",
	"PhysicsDirectSpaceState3D",
	"PhysicsDirectSpaceState3DExtension",
	"PhysicsPointQueryParameters2D",
	"PhysicsPointQueryParameters3D",
	"PhysicsRayQueryParameters2D",
	"PhysicsRayQueryParameters3D",
	"PhysicsServer2D",
	"PhysicsServer2DExtension",
	"PhysicsServer2DManager",
	"PhysicsServer3D",
	"PhysicsServer3DExtension",
	"PhysicsServer3DManager",
	"PhysicsServer3DRenderingServerHandler",
	"PhysicsShapeQueryParameters2D",
	"PhysicsShapeQueryParameters3D",
	"PhysicsTestMotionParameters2D",
	"PhysicsTestMotionParameters3D",
	"PhysicsTestMotionResult2D",
	"PhysicsTestMotionResult3D",
	"ProjectSettings",
	"PropertyTweener",
	"RandomNumberGenerator",
	"RDAttachmentFormat",
	"RDFramebufferPass",
	"RDPipelineColorBlendState",
	"RDPipelineColorBlendStateAttachment",
	"RDPipelineDepthStencilState",
	"RDPipelineMultisampleState",
	"RDPipelineRasterizationState",
	"RDPipelineSpecializationConstant",
	"RDSamplerState",
	"RDShaderSource",
	"RDTextureFormat",
	"RDTextureView",
	"RDUniform",
	"RDVertexAttribute",
	"RefCounted",
	"RegEx",
	"RegExMatch",
	"RenderingDevice",
	"RenderingServer",
	"Resource",
	"ResourceFormatLoader",
	"ResourceFormatSaver",
	"ResourceImporter",
	"ResourceLoader",
	"ResourceSaver",
	"ResourceUID",
	"SceneMultiplayer",
	"SceneState",
	"SceneTree",
	"SceneTreeTimer",
	"ScriptLanguage",
	"ScriptLanguageExtension",
	"Semaphore",
	"SkinReference",
	"StreamPeer",
	"StreamPeerBuffer",
	"StreamPeerExtension",
	"StreamPeerGZIP",
	"StreamPeerTCP",
	"StreamPeerTLS",
	"SurfaceTool",
	"TCPServer",
	"TextLine",
	"TextParagraph",
	"TextServer",
	"TextServerAdvanced",
	"TextServerDummy",
	"TextServerExtension",
	"TextServerFallback",
	"TextServerManager",
	"ThemeDB",
	"Thread",
	"TileData",
	"Time",
	"TranslationServer",
	"TreeItem",
	"TriangleMesh",
	"Tween",
	"Tweener",
	"UDPServer",
	"UndoRedo",
	"UPNP",
	"UPNPDevice",
	"WeakRef",
	"WebRTCDataChannel",
	"WebRTCDataChannelExtension",
	"WebRTCMultiplayerPeer",
	"WebRTCPeerConnection",
	"WebRTCPeerConnectionExtension",
	"WebSocketMultiplayerPeer",
	"WebSocketPeer",
	"WebXRInterface",
	"WorkerThreadPool",
	"XMLParser",
	"XRInterface",
	"XRInterfaceExtension",
	"XRPose",
	"XRPositionalTracker",
	"XRServer",
	"ZIPPacker",
	"ZIPReader",
	"AABB",
	"Array",
	"Basis",
	"bool",
	"Callable",
	"Color",
	"Dictionary",
	"float",
	"int",
	"NodePath",
	"Object",
	"PackedByteArray",
	"PackedColorArray",
	"PackedFloat32Array",
	"PackedFloat64Array",
	"PackedInt32Array",
	"PackedInt64Array",
	"PackedStringArray",
	"PackedVector2Array",
	"PackedVector3Array",
	"Plane",
	"Projection",
	"Quaternion",
	"Rect2",
	"Rect2i",
	"RID",
	"Signal",
	"String",
	"StringName",
	"Transform2D",
	"Transform3D",
	"Variant",
	"Vector2",
	"Vector2i",
	"Vector3",
	"Vector3i",
	"Vector4",
	"Vector4i"]
