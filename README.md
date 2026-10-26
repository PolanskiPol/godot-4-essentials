# Godot 4.x Essentials
##### Made by Polanski

This repository is a collection of classes, custom nodes, systems and utils developed for Godot 4.x.

All the included essentials have been developed following the composition principle, minimizing inheritance to the bare minimum. As such, you should consider using the given tools in the same way.

## Health System
#### Simple system to create and manage complex health systems
##### [Node] Health
Health is a node that can be inserted into any scene. Its base stats can be changed from the editor, and it has functions to handle damage & healing done.
1. Insert a Health node into a scene
2. Configure its properties
3. Call the damage and healing functions from the scene's root

##### [Resource] HealthState
A HealthState is a resource that can be instanced inside a Health node to modify its behaviour or add custom healing or damage effects.

By default, this repository comes with 4 basic HealthStates:
- Heal(total_ammount : int, ticks : int, duration : float): Heals the Health in the given ticks the desired amount for the duration
- Poison(total_ammount : int, ticks : int, duration : float): Damages the Health in the given ticks the desired amount for the duration
- Invincible(duration : float): Prevents damage for the duration
- Weak(duration : float): Prevents healing for the duration

To add a HealthState, simply call Health.add_state(HealthState.new(...params...)).
To remove a HealthState, simply call Health.remove_state("HealthStateName").

##### Creating a new HealthState
Custom HealthStates can be made by extending the class HealthState.
1. Create a new script
2. In 'Inherits', select HealthState
3. Name your script as the following: [my_state]_health_state.gd, where [my_state] is the name of your HealthState
4. Override get_state_name() to return the name of your state as a string
4. Override allows_multiple() to return true/false whether you want your HealthState to be able to be instanced multiple times in the same Health
5. Override any other virtual function that you need for your state

Check the Health node properties and functions, many of them may be of use to make your own states.

## Save System
#### Simple system to save and load any Resource to disk
The SaveSystem stores any Godot Resource as JSON using GRON, so there is no base class to extend and no serialization code to write: every @export property of the Resource (and of its sub-resources) is saved automatically.

##### Configuring the SaveSystem
1. Add save_system.gd as a singleton (autoload) named SaveSystem
2. By default, files are saved to 'user://', change the property save_directory to save them somewhere else

##### Creating a resource to save
Any Resource works, just make sure the values you want to save are @export properties.
```gdscript
class_name PlayerData
extends Resource

@export var coins : int = 0
@export var unlocked_items : Array[String] = []
@export var skin_color : Color = Color.WHITE
```

##### Saving a resource
Call save_resource(resource, file_name, file_format) from your SaveSystem singleton.
The file_format can be FileFormat.SAVE (.save, default) or FileFormat.CONFIG (.conf).
```gdscript
SaveSystem.save_resource(player_data, "player_data")
SaveSystem.save_resource(config, "game", SaveSystem.FileFormat.CONFIG)
```

##### Loading a resource
Call load_resource(file_name, file_format) to get the saved resource back, or null if there is no file.
Call load_resource_not_null(file_name, fallback, file_format) to get a fallback resource instead of null.
```gdscript
var player_data : PlayerData = SaveSystem.load_resource_not_null("player_data", PlayerData.new())
```

##### Beware
This SaveSystem does not provide safety for save file rewrites or any security feature. These features must be handled by yourself.
The property save_locked is not used by the SaveSystem, use it to control the saving flow of your game.

## GRON
#### Universal serializer from any Resource to JSON and back
GRON is a static class that serializes any Resource to JSON and deserializes it back to an equivalent Resource: nested and shared sub-resources, typed Arrays and Dictionaries and every built-in type are supported without precision loss.
```gdscript
var json : String = GRON.serialize(resource)
var copy : Resource = GRON.deserialize(json)
```
Only properties stored by Godot (@export properties) are serialized. Sub-resources saved in their own file under 'res://' are stored as a reference to their path, pass embed_external as true to embed them instead.
