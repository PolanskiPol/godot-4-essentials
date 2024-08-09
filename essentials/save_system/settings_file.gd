@icon("isettings_file.svg")
class_name SettingsFile
extends Resource

## Virtual function. Defines the save's metadata to be read (for example) on a 'Select file to load' screen.
## Overwrite to set custom metadata.
## This function may never be used in the future.
## @experimental
func get_meta_info() -> Dictionary:
	return {
		"name": "meta_name",
		"modify_date": "0000-00-00 00:00",
		"version": 1
	}
