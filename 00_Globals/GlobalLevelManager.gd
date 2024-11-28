extends Node

signal level_load_started
signal level_loaded
# signal for whenever the tile map bounds change
signal TileMapBoundsChanged(bounds : Array[ Vector2 ] )

# keeping track of the current tilemap bounds
var current_tilemap_bounds : Array[ Vector2 ]
var target_transition : String
# position of the player on the level transition body
var position_offset : Vector2


func _ready() -> void:
	# await for the first process frame (means all scenes have been loaded)
	await get_tree().process_frame
	level_loaded.emit()
	
	

# every time a new tile map is loaded, this function is called by LevelTileMap so the new bounds can be signalled
func ChangeTilemapBounds( bounds : Array[ Vector2 ] ) -> void:
	current_tilemap_bounds = bounds
	TileMapBoundsChanged.emit( bounds )


func load_new_level(
	level_path : String,
	_target_transition : String,
	_position_offset : Vector2, 
) -> void:
	
	# pause the game
	get_tree().paused = true
	target_transition = _target_transition
	position_offset = _position_offset
	
	# wait for the scene to fade out before loading the level
	await SceneTransition.fade_out()
	
	level_load_started.emit()
	
	# await for the next 'process tick'
	await get_tree().process_frame
	
	get_tree().change_scene_to_file( level_path )
	
	# wait for the scene to fade in before unpausing the game
	await SceneTransition.fade_in()
	
	# unpause the game
	get_tree().paused = false
	
	await get_tree().process_frame
	
	level_loaded.emit()
	
	pass
