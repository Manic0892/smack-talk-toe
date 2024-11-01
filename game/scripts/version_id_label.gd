extends Label

const build_number_file_path: String = "res://build_number.txt"

# Called when the node enters the scene tree for the first time.
func _ready():
	var version: String = ProjectSettings.get_setting("application/config/version", "no version # found")
	var file: FileAccess = FileAccess.open(build_number_file_path, FileAccess.READ)
	var build_number = file.get_as_text()
	set_text("v%s b%s" % [version, build_number])
