class_name PlayerCamera extends Camera2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# anytime level manager sends a signal with updated tile bounds, UpdateLimits is called
	LevelManager.TileMapBoundsChanged.connect( UpdateLimits )
	
	# manually get current_tilemap_bounds the first time in case the first signal is sent before this script loads
	UpdateLimits( LevelManager.current_tilemap_bounds )
	
	pass # Replace with function body.


# updates camera limits based on size of tile map
func UpdateLimits( bounds : Array[ Vector2 ] ) -> void:
	
	# return function in the event this script loaded and got current_tile_map_bounds from LevelManager (line 10)...
	# ...before the bounds had been appended
	if bounds == []:
		return
	
	# some scenes camera boundaries do not work properly
	# Area 01: 01, 02, 03
	limit_left = int( bounds[0].x + 4)
	limit_top = int( bounds[0].y )
	limit_right = int( bounds[1].x )
	limit_bottom = int( bounds[1].y )
	pass 
