@icon("isave_file.svg")
class_name SaveFile
extends Resource

## Virtual function. Defines the save's metadata to be read (for example) on a 'Select file to load' screen.
## Overwrite to set custom metadata.
func get_meta_info() -> Dictionary:
	return {
		"name": "meta_name",
		"description": "meta_description",
		"create_date": "0000-00-00 00:00",
		"modify_date": "0000-00-00 00:00",
		"version": 1
	}
