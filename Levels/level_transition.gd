# allow the script to run in the editor
@tool
class_name LevelTransition extends Area2D

# list / array of constants
enum SIDE { LEFT, RIGHT, TOP, BOTTOM }

# exports an item in the inspector that will accept a scene
@export_file( "*.tscn" ) var level
# provide the name that the transition connects to
@export var target_transition_area : String = "LevelTransition"

@export_category("Collision Area Settings")

@export_range(1, 12, 1, "or_greater") var size : int = 2 : 
	set ( _v ):
		size = _v
		_update_area()

@export var side : SIDE = SIDE.LEFT :
	set( _v ):
		side = _v
		_update_area()

@export var snap_to_grid : bool = false :
	set( _v ):
		_snap_to_grid()

@onready var collision_shape: CollisionShape2D = $CollisionShape2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_update_area()
	# do not run this part in the editor
	if Engine.is_editor_hint():
		return
	
	# will not monitor for player until level is loaded and player is in correct position
	monitoring = false
	_place_player()
	
	# await until level is loaded
	await LevelManager.level_loaded
	
	monitoring = true
	
	# Area2D has a body_entered signal
	# we are only montioring for the player layer, so it will always be the player the enters
	body_entered.connect( _player_entered )
	
	pass

	
# _p is a reference to the player
func _player_entered( _p : Node2D ) -> void:
	# do something with level manager
	LevelManager.load_new_level( level, target_transition_area, get_offset() )
	pass
	
	
func _place_player() -> void:
	# if the name of the LevelTransition area does not equal the one in the LevelManager...
	# ... this LevelTransition area is not the one it is looking for
	if name != LevelManager.target_transition:
		return

	PlayerManager.set_player_position( global_position + LevelManager.position_offset )


func get_offset() -> Vector2:
	var offset : Vector2 = Vector2.ZERO
	var player_pos = PlayerManager.player.global_position
	
	# calculate offset
	if side == SIDE.LEFT or side == SIDE.RIGHT:
		# the offset is the difference between the player's position and the position of...
		# ... the LevelTransition area
		offset.y = player_pos.y - global_position.y
		offset.x = 16
		# player needs to appear on the left as opposed to the right
		if side == SIDE.LEFT:
			offset.x *= -1
	else:
		offset.x = player_pos.x - global_position.x
		offset.y = 16
		if side == SIDE.TOP:
			offset.y *= -1
			
		
	return offset
	
	
func _update_area() -> void:
	var new_rect : Vector2 = Vector2( 32, 32 )
	var new_position : Vector2 = Vector2.ZERO
	
	if side == SIDE.TOP:
		new_rect.x *= size
		new_position.y -= 16
	elif side == SIDE.BOTTOM:
		new_rect.x *= size
		new_position.y += 16
	elif side == SIDE.LEFT:
		new_rect.y *= size
		new_position.x -= 16
	elif side == SIDE.RIGHT:
		new_rect.y *= size
		new_position.x += 16

	# necessary because we are running this script as a tool; there could be times we do not have... 
	# ...the collision shape
	if collision_shape == null:
		collision_shape = get_node("CollisionShape2D")
		
	collision_shape.shape.size = new_rect
	collision_shape.position = new_position
	
	
func _snap_to_grid() -> void:
	position.x = round( position.x / 16 ) * 16
	position.y = round( position.y / 16 ) * 16
