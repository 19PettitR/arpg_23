class_name EnemyStateWander extends EnemyState


@export var anim_name : String = "walk"
@export var wander_speed : float = 20.0

@export_category("AI")
# go by animation instead of a time because the slime jumps and should not be stopped mid air
@export var state_animation_duration : float = 0.5
@export var state_cycles_min : int = 1
@export var state_cycles_max : int = 3
@export var next_state : EnemyState

var _timer : float = 0.0
var _direction : Vector2


# What happens when we initialise this state?
func init() -> void:
	pass
	
	
# What happens when the enemy enters this state?
func enter() -> void:
	# timer should be the length of the (randomly selected) number of animation cycles
	_timer = randi_range( state_cycles_min, state_cycles_max) * state_animation_duration
	var rand = randi_range( 0, 3 )
	_direction = enemy.DIR_4[ rand ]
	enemy.velocity = _direction * wander_speed
	enemy.set_direction( _direction )
	enemy.update_animation( anim_name )
	pass
	
	
# What happens when the enemy exits this state?
func process( _delta : float ) -> EnemyState:
		# count down the timer
	_timer -= _delta
	# if the timer counts down, move to next state
	if _timer <= 0:
		return next_state
	return null
	
	
# What happens when the enemy exits this state?
func physics (_delta : float  ) -> EnemyState:
	return null
