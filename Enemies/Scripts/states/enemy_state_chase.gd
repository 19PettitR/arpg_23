class_name EnemyStateChase extends EnemyState


@export var anim_name : String = "chase"
@export var chase_speed : float = 40.0
@export var turn_rate : float = 0.25

@export_category("AI")
@export var vision_area : VisionArea
@export var attack_area : HurtBox
@export var state_aggro_duration : float = 0.5
@export var next_state : EnemyState

var _timer : float = 0.0
var _direction : Vector2
var _can_see_player : bool = false

# What happens when we initialise this state?
func init() -> void:
	# if we have a vision area, we need to connect to the player enter signals
	if vision_area:
		vision_area.player_entered.connect( _on_player_enter )
		vision_area.player_exited.connect( _on_player_exit )
	pass
	
	
# What happens when the enemy enters this state?
func enter() -> void:
	_timer = state_aggro_duration
	enemy.update_animation( anim_name )
	if attack_area: 
		attack_area.monitoring = true
	pass



func exit() -> void:
	if attack_area:
		attack_area.monitoring = false
	_can_see_player = false
	pass



# What happens when the enemy exits this state?
func process( _delta : float ) -> EnemyState:
	# set the enemy's direction to the player direction
	var new_dir : Vector2 = enemy.global_position.direction_to( PlayerManager.player.global_position)
	# lerp will linear interpolate between variables provided (slow turn speed)
	_direction = lerp( _direction, new_dir, turn_rate)
	enemy.velocity = _direction * chase_speed
	# if enemy direction is changed
	if enemy.set_direction( _direction ):
		enemy.update_animation( anim_name )
	
	if _can_see_player == false:
		_timer -= _delta
		# if the timer counts down, move to next state
		if _timer <= 0:
			return next_state
	else:
		_timer = state_aggro_duration
	return null
	
	
# What happens when the enemy exits this state?
func physics (_delta : float  ) -> EnemyState:
	return null



func _on_player_enter() -> void:
	_can_see_player = true
	if state_machine.current_state is EnemyStateStun:
		return
	# set chase state to the current state (if not stunned) 
	state_machine.change_state( self )
	pass



func _on_player_exit() -> void:
	_can_see_player = false
	pass