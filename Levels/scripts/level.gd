class_name Level extends Node2D



func _ready() -> void:
	# make sure y sort is enabled in each level
	self.y_sort_enabled = true
	# pass this level as the new parent
	PlayerManager.set_as_parent( self )
	LevelManager.level_load_started.connect( _free_level )
	
	
	
func _free_level() -> void:
	# unparent the player from the level so we do not destroy it with the level
	PlayerManager.unparent_player( self )
	# destroy the level we are leaving
	queue_free()
	
