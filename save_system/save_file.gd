class_name SaveFile
extends Resource

@export var meta : Dictionary

func _init() -> void:
	meta["key"] = "meta_key"
	meta["name"] = "meta_name"
	meta["description"] = "meta_description"
	meta["create_date"] = "0000-00-00 00:00"
	meta["modify_date"] = "0000-00-00 00:00"
	meta["version"] = 1
