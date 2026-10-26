class_name ResourceLoaderThreaded
extends Node

## Loads resources in background threads (the game doesn't freeze) and caches them once loaded.

signal resource_loaded(path : String)
signal resource_load_failed(path : String)

class ThreadedLoadRequest:
	var progress : Array[float]
	var status : ResourceLoader.ThreadLoadStatus

@onready var _threaded_load_requests : Dictionary[String, ThreadedLoadRequest] = {}
@onready var _finished_loads_error : Dictionary[String, ThreadedLoadRequest] = {}
@onready var _cached_resources : Dictionary[String, Resource] = {}

func _ready() -> void:
	# Loads keep going while the game is paused (e.g. changing scene from a pause menu).
	process_mode = Node.PROCESS_MODE_ALWAYS
	set_process(!_threaded_load_requests.is_empty())

## Load a resource from a path in threaded mode (Godot doesn't freeze).
## The parameters are the same as [method ResourceLoader.load_threaded_request].
func load_resource(path : String, type_hint : String = "", use_sub_threads : bool = false) -> Error:
	# Already loaded or loading. Requesting it again would mark it as in progress, and
	# get_resource(...) would return ERR_BUSY for a resource that's already cached.
	if(_cached_resources.has(path) or _threaded_load_requests.has(path)):
		return Error.OK

	var error : Error = ResourceLoader.load_threaded_request(path, type_hint, use_sub_threads)
	if(error != Error.OK):
		return error

	_finished_loads_error.erase(path)
	var request : ThreadedLoadRequest = ThreadedLoadRequest.new()
	request.progress = []
	request.status = ResourceLoader.THREAD_LOAD_IN_PROGRESS
	_threaded_load_requests[path] = request
	set_process(true)
	return error

## Returns the loaded resource, or an [enum Error] if it's not loaded:
## [constant ERR_BUSY] if it's still loading, [constant FAILED] if the load failed
## and [constant ERR_DOES_NOT_EXIST] if it was never requested with [method load_resource].
func get_resource(path : String) -> Variant:
	if(_threaded_load_requests.has(path)):
		return Error.ERR_BUSY
	if(_finished_loads_error.has(path)):
		return Error.FAILED
	if(_cached_resources.has(path)):
		return _cached_resources[path]
	return Error.ERR_DOES_NOT_EXIST

## Returns the [enum ResourceLoader.ThreadLoadStatus] of the resource.
## Resources never requested with [method load_resource] return [constant ResourceLoader.THREAD_LOAD_INVALID_RESOURCE].
func get_status(path : String) -> ResourceLoader.ThreadLoadStatus:
	if(_cached_resources.has(path)):
		return ResourceLoader.THREAD_LOAD_LOADED
	if(_threaded_load_requests.has(path)):
		return ResourceLoader.THREAD_LOAD_IN_PROGRESS
	if(_finished_loads_error.has(path)):
		return _finished_loads_error[path].status
	return ResourceLoader.THREAD_LOAD_INVALID_RESOURCE

## Returns the progress from 0.0 to 1.0. If the loading process encountered an error
## or it was never requested, returns -1.0.
func get_progress(path : String) -> float:
	if(_cached_resources.has(path)):
		return 1.0
	if(!_threaded_load_requests.has(path)):
		return -1.0
	if(_threaded_load_requests[path].progress.is_empty()):
		return 0.0
	return _threaded_load_requests[path].progress[0]

## Removes the resource from the cache, so it can be freed once nothing else uses it.
func release_resource(path : String) -> void:
	_cached_resources.erase(path)
	_finished_loads_error.erase(path)

func _process(_delta : float) -> void:
	if(_threaded_load_requests.is_empty()):
		set_process(false)
		return
	# Process requests every 5 frames to optimize.
	if(Engine.get_process_frames() % 5 != 0):
		return

	# Iterate over a copy of the keys, as finished requests are erased from the dictionary.
	for key in _threaded_load_requests.keys():
		var request : ThreadedLoadRequest = _threaded_load_requests[key]
		var status : ResourceLoader.ThreadLoadStatus = ResourceLoader.load_threaded_get_status(key, request.progress)
		request.status = status

		if(status == ResourceLoader.THREAD_LOAD_LOADED):
			# ResourceLoader.load_threaded_get(...) only works ONCE, so the resource is cached here.
			_cached_resources[key] = ResourceLoader.load_threaded_get(key)
			_threaded_load_requests.erase(key)
			resource_loaded.emit(key)
		elif(status == ResourceLoader.THREAD_LOAD_INVALID_RESOURCE or status == ResourceLoader.THREAD_LOAD_FAILED):
			_finished_loads_error[key] = request
			_threaded_load_requests.erase(key)
			resource_load_failed.emit(key)
