extends Node

@onready var debug : bool = true
@onready var slots : int = 3
# Change SaveFile for your custom save file resource
@onready var save_file : SaveFile = SaveFile.new()
@onready var settings_file : SettingsFile = SettingsFile.new()
@onready var save_meta : SaveMeta = SaveMeta.new()

func _ready() -> void:
	var path : String = _get_path() + "save_metas.tres"
	if(!ResourceLoader.exists(path)):
		ResourceSaver.save(save_meta, path)
	save_meta = ResourceLoader.load(path)
		
func _get_path() -> String:
	if(debug):
		return "res://"
	else:
		return "user://"

func save_game(slot : int) -> void:
	var path : String = _get_path() + "save_" + str(slot) + ".tres"
	if(slot - 1 > slots):
		push_error("Slot [" + str(slot) + "] out of bounds.")
		return
	ResourceSaver.save(save_file, path)
	save_meta.save_metas["save_" + str(slot)] = save_file.meta
	ResourceSaver.save(save_meta, _get_path() + "save_metas.tres")
	
func load_game(slot : int) -> void:
	var path : String = _get_path() + "save_" + str(slot) + ".tres"
	if(!ResourceLoader.exists(path)):
		push_error("No save file on slot [" + str(slot) + "].")
		return
	if(slot - 1 > slots):
		push_error("Slot [" + str(slot) + "] out of bounds.")
		return
	save_file = ResourceLoader.load(_get_path() + "/save_" + str(slot) + ".save")

func save_settings() -> void:
	var path : String = _get_path() + "settings.tres"
	ResourceSaver.save(save_file, path)
	
func load_settings() -> void:
	var path : String = _get_path() + "settings.tres"
	if(!ResourceLoader.exists(path)):
		push_error("No settings file found.")
		return
	save_file = ResourceLoader.load(_get_path() + "save_.save")
