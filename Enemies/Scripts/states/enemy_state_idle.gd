class_name EnemyStateIdle extends EnemyState


@export var anim_name : String = "idle"

@export_category("AI")
# minimum and maximum value of the length of the state; we will pick a random value between them
@export var state_duration_min : float = 0.5
@export var state_duration_max : float = 1.5
@export var after_idle_state : EnemyState

var _timer : float = 0.0



# What happens when we initialise this state?
func init() -> void:
	pass
	
	
# What happens when the enemy enters this state?
func enter() -> void:
	enemy.velocity = Vector2.ZERO
	# random float range timer
	_timer = randf_range( state_duration_min, state_duration_max )
	enemy.update_animation( anim_name )
	pass
	
	
# What happens when the enemy exits this state?
func process( _delta : float ) -> EnemyState:
	# count down the timer
	_timer -= _delta
	# if the timer counts down, move to next state
	if _timer <= 0:
		return after_idle_state
	return null
	
	
# What happens when the enemy exits this state?
func physics (_delta : float  ) -> EnemyState:
	return null
