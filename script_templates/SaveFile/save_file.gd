# meta-name: SaveFile base template
# meta-description: Add your own metadata and save variables
# meta-default: true
# meta-space-indent: 4

class_name _CLASS_
extends SaveFile

# Virtual function. Defines the save's metadata to be read (for example) on a 'Select file to load' screen.
# Overwrite to set custom metadata.
func get_meta_info() -> Dictionary:
	return {
		"name": "meta_name",
		"description": "meta_description",
		"create_date": "0000-00-00 00:00",
		"modify_date": "0000-00-00 00:00",
		"version": 1,
		# example: "example"
		# ...
	}