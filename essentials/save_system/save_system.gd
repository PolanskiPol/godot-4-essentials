@icon("isave_file.svg")
extends Node

## Saves and loads any [Resource] to/from disk as JSON using [GRON].
## No base class or serialization code is needed: every [code]@export[/code] property
## of the Resource (and of its sub-resources) is stored automatically.

const SAVE_FILE_EXTENSION : String = ".save"
const CONFIG_FILE_EXTENSION : String = ".conf"
const UNKNOWN_FILE_EXTENSION : String = ".unk"

enum FileFormat {
	SAVE,
	CONFIG
}

## Directory where the files are stored.
@onready var save_directory : String = "user://"
## Not used by any of the methods, but as an external way
## to control saving flow.
@onready var save_locked : bool = false

func _get_file_extension(file_format : FileFormat) -> String:
	if(file_format == FileFormat.SAVE):
		return SAVE_FILE_EXTENSION
	elif(file_format == FileFormat.CONFIG):
		return CONFIG_FILE_EXTENSION
	else:
		return UNKNOWN_FILE_EXTENSION

func _get_file_path(file_name : String, file_format : FileFormat) -> String:
	return save_directory.path_join(file_name + _get_file_extension(file_format))

## Saves [param resource] into the file [param file_name] with the extension of [param file_format].
## Returns whether the resource could be saved.
func save_resource(
	resource : Resource,
	file_name : String,
	file_format : FileFormat = FileFormat.SAVE
) -> bool:
	var serialized : String = GRON.serialize(resource)
	if(serialized == ""):
		return false
	var path : String = _get_file_path(file_name, file_format)
	DirAccess.make_dir_recursive_absolute(path.get_base_dir())
	var savefile : FileAccess = FileAccess.open(path, FileAccess.WRITE)
	if(savefile == null):
		push_error("Could not open [" + path + "] to save: " + error_string(FileAccess.get_open_error()))
		return false
	savefile.store_string(serialized)
	savefile.close()
	return true

## Loads the resource stored in the file [param file_name] with the extension of [param file_format].
## Returns [code]null[/code] if the file does not exist or could not be deserialized.
func load_resource(
	file_name : String,
	file_format : FileFormat = FileFormat.SAVE
) -> Resource:
	var path : String = _get_file_path(file_name, file_format)
	if(!FileAccess.file_exists(path)):
		return null
	var savefile_content : String = FileAccess.get_file_as_string(path)
	if(savefile_content == ""):
		return null
	return GRON.deserialize(savefile_content)

## Same as [method load_resource], but returns [param fallback] if the resource could not be loaded.
func load_resource_not_null(
	file_name : String,
	fallback : Resource,
	file_format : FileFormat = FileFormat.SAVE
) -> Resource:
	var loaded_resource : Resource = load_resource(file_name, file_format)
	if(loaded_resource == null):
		return fallback
	return loaded_resource
