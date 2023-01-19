class_name GdUnitTestSuiteDefaultTemplate
extends RefCounted

## GDScript Transpiler Properties Class
##
## Properties for Transpiler
##
## @tutorial(Generated python script): https://gist.github.com/LinuxUserGD/73d8e030a44eb7f91bdeaea96a321f6d#file-tokenizer-py

const DEFAULT_TEMP_TS_GD = \
"""# GdUnit generated TestSuite
class_name ${suite_class_name}
extends GdUnitTestSuite
@warning_ignore(unused_parameter)
@warning_ignore(return_value_discarded)
# TestSuite generated from
const __source = '${source_resource_path}'
"""

const DEFAULT_TEMP_TS_CS = \
"""// GdUnit generated TestSuite
using Godot;
using GdUnit3;
namespace ${name_space}
{
	using static Assertions;
	using static Utils;
	[TestSuite]
	public class ${suite_class_name}
	{
		// TestSuite generated from
		private const string sourceClazzPath = "${source_resource_path}";
		
	}
}
"""
