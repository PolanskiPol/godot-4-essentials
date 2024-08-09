# meta-name: SettingsFile base template
# meta-description: Add your own metadata and setting variables
# meta-default: true
# meta-space-indent: 4

class_name _CLASS_
extends SettingsFile

# Virtual function. Defines the save's metadata to be read (for example) on a 'Select file to load' screen.
# Overwrite to set custom metadata.
func get_meta_info() -> Dictionary:
	return {
		"name": "meta_name",
		"modify_date": "0000-00-00 00:00",
		"version": 1,
		# example: "example"
		# ...
	}
