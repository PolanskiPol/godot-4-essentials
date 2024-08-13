# Godot 4.x Essentials
## Collection of Nodes, Classes and Systems to save time when developing games

### Health System
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

### Save System
#### Simple system to manage save and configuration files
**TODO:** Add tutorial
