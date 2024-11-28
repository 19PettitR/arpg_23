class_name LevelTileMap extends TileMap


# Called when the node enters the scene tree for the first time (A.K.A WHEN A TILE MAP LOADS)
func _ready() -> void:
	# send values of the tile map bounds to the level manager
	LevelManager.ChangeTilemapBounds( GetTilemapBounds() )
	pass

# get tile map bounds to send
func GetTilemapBounds() -> Array[ Vector2 ]:
	var bounds : Array[ Vector2 ] = []
	# appends the top left corner of the drawn tiles
	bounds.append(
		# rect is the rectangle that contains all tiles in tile map
		# .position would get position of the tiles, multiply by rendering_quadrant size to get pixels
		Vector2( get_used_rect().position * rendering_quadrant_size )
	)
	# appends the bottom right corner of the drawn tiles
	bounds.append(
		Vector2( get_used_rect().end * rendering_quadrant_size)
	)
	return bounds
