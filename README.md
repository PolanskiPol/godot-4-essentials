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
#### Simple system to manage save and configuration files
##### Creating a custom SaveFile/SettingsFile for your game
The SaveSystem comes with a default SaveFile class that can be extended to make your game's custom save file.
1. Create a new script
2. In 'Inherits', select SaveFile
3. Name your script as the following: [my_save_file]_save_file.gd, where [my_save_file] is the name of your SaveFile
4. Override get_meta_info() to return a custom Dictionary with your own metadata, such as the file's name, creation date or version
5. Add properties to the SaveFile as such as the following: @export var save_prop : int, a SaveFile is a Godot Resource, and Godot Resources only read @export properties

All the previous steps are the same for your SettingsFiles, but instead of saving data from the game, you must save configuration data.

##### Configuring the SaveSystem
This SaveSystem comes with some configuration and prerequisites that must be configured beforehand.
The SaveSystem comes with a script named save_system.gd (how convenient) to store your SaveFiles and SettingFiles.
1. Add save_system.gd as a singleton (autoload)
2. By default, the property debug is set as true, saving data to 'res://', change this to false in production to save to 'user://'
3. By default, the SaveSystem comes with 3 slots to save a game, configure the property slots to your linkng
4. Change the type of the property save_file to your custom SaveFile class
5. Change the type of the property settings_file to your custom SettingsFile class

##### Saving a game
Now that the SaveSystem is already set up, you can save from any scene in your game.
1. Call the function save_game(slot : int) from your SaveSystem singleton, this will save the game into the desired slot
2. The saved information is that of the property save_file, you must modify the properties of save_file from outer scenes

##### Loading a game
Now that the SaveSystem is already set up, you can save from any scene in your game.
1. Call the function load_game(slot : int) from your SaveSystem singleton, this will load the game from the desired slot
2. The loaded information stored into the property save_file to be modified anywhere

##### Beware
This SaveSystem does not provide safety for SaveFile rewrites or any security feature. These features must be handled by yourself.

This is a consideration for future releases of this Godot package, but as of now, be sure to double check your saving and loading logic.
