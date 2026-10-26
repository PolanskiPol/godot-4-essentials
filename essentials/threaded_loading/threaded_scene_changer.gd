extends Node

## Changes scenes loading them in background threads.
## [br][br]
## Every scene change goes through these steps, emitting a signal on each one:
## [br]1. [signal scene_change_started]: the change begins and the scene starts loading.
## [br]2. [signal loading_progress]: emitted every frame while the scene loads or the change is held.
## [br]3. [signal scene_changed]: the new scene is in the tree.
## [br]4. [signal scene_change_finished]: the change is complete.
## [br][br]
## Listeners of [signal scene_change_started] and [signal scene_changed] can call [method hold]
## to make the change wait until they call [method release], e.g. to cover the screen with
## a transition before the scene is swapped, or to wait for every peer of an online game
## before revealing the new scene.
## If the scene cannot be loaded, [signal scene_change_failed] is emitted instead of steps 3 and 4.

## path is the path of the new scene, or null if it has no path.
signal scene_change_started(path : Variant)
signal loading_progress(path : Variant, progress : float)
signal scene_changed(path : Variant)
signal scene_change_finished(path : Variant)
signal scene_change_failed(path : Variant)

## Whether a scene change is in progress.
@onready var loading : bool = false
@onready var threaded_loader : ResourceLoaderThreaded = ResourceLoaderThreaded.new()
## If true, the scene being replaced is kept out of the tree instead of being freed,
## so it can be restored with [method to_previous].
@onready var keep_previous_scene : bool = false

var previous_scene : Node
var _previous_path : Variant = null
var _current_path : Variant = null
var _holds : int = 0

func _ready() -> void:
	# Scenes can be changed while the game is paused (e.g. from a pause menu).
	process_mode = Node.PROCESS_MODE_ALWAYS
	add_child(threaded_loader)

func _exit_tree() -> void:
	# The previous scene is out of the tree, so nothing else would free it.
	if(is_instance_valid(previous_scene) and !previous_scene.is_inside_tree()):
		previous_scene.free()

## Makes the current scene change wait at its current step until [method release] is called.
## Call it from a listener of [signal scene_change_started] or [signal scene_changed].
func hold() -> void:
	_holds += 1

## Lets the scene change continue after a [method hold].
func release() -> void:
	if(_holds == 0):
		push_warning("ThreadedSceneChanger: release() called without a previous hold().")
		return
	_holds -= 1

## Changes to the scene at [param path], loading it in a background thread if it's not loaded yet.
func go_to_scene(path : String) -> void:
	loading = true
	if(threaded_loader.get_status(path) != ResourceLoader.THREAD_LOAD_LOADED):
		threaded_loader.load_resource(path)
	scene_change_started.emit(path)

	while(_holds > 0 or threaded_loader.get_status(path) == ResourceLoader.THREAD_LOAD_IN_PROGRESS):
		loading_progress.emit(path, maxf(threaded_loader.get_progress(path), 0.0))
		await get_tree().process_frame

	var scene : Variant = threaded_loader.get_resource(path)
	if(!(scene is PackedScene)):
		push_error("ThreadedSceneChanger: Could not load the scene at [" + path + "].")
		loading = false
		scene_change_failed.emit(path)
		return
	loading_progress.emit(path, 1.0)
	await _swap(scene.instantiate(), path)

## Changes to a scene that is already built but not in the tree.
## [param path] is only used for the signals.
func go_to_node(scene_instance : Node, path : Variant = null) -> void:
	loading = true
	scene_change_started.emit(path)
	while(_holds > 0):
		loading_progress.emit(path, 1.0)
		await get_tree().process_frame
	await _swap(scene_instance, path)

## Goes back to the previous scene. Requires [member keep_previous_scene] to be true.
func to_previous() -> void:
	if(!is_instance_valid(previous_scene)):
		push_warning("ThreadedSceneChanger: There is no previous scene, is keep_previous_scene enabled?")
		return
	await go_to_node(previous_scene, _previous_path)

func _swap(scene_instance : Node, path : Variant) -> void:
	_node_swap(scene_instance, path)
	scene_changed.emit(path)
	while(_holds > 0):
		await get_tree().process_frame
	loading = false
	scene_change_finished.emit(path)

func _node_swap(scene_instance : Node, path : Variant) -> void:
	var current_scene : Node = get_tree().current_scene
	if(current_scene != null):
		if(keep_previous_scene):
			if(is_instance_valid(previous_scene) and previous_scene != scene_instance):
				previous_scene.queue_free()
			current_scene.get_parent().remove_child(current_scene)
			previous_scene = current_scene
			_previous_path = _current_path
		else:
			current_scene.queue_free()

	get_tree().root.add_child(scene_instance)
	get_tree().current_scene = scene_instance
	_current_path = path
