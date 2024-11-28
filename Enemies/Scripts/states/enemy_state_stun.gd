class_name EnemyStateStun extends EnemyState


@export var anim_name : String = "stun"
@export var knockback_speed : float = 200
@export var decelerate_speed : float = 10.0

@export_category("AI")
@export var next_state : EnemyState

# the position of the hurtbox that damaged the enemy
var _damage_position : Vector2

var _direction : Vector2
var _animation_finished : bool = false


# What happens when we initialise this state?
func init() -> void:
	enemy.enemy_damaged.connect( _on_enemy_damaged )
	pass
	
	
# What happens when the enemy enters this state?
func enter() -> void:
	enemy.invulnerable = true
	
	_animation_finished = false
	# global position gives coordinates of where the slime is regardless of parent position
	# the direction of the enemy should face player position
	_direction = enemy.global_position.direction_to( _damage_position )

	enemy.set_direction( _direction )
	# knockback_speed negative because he moves backwards
	enemy.velocity = _direction * -knockback_speed
	enemy.update_animation( anim_name )
	enemy.animation_player.animation_finished.connect( _on_animation_finished )
	pass
	

# What happens when we exit this state?
func exit() -> void:
	enemy.invulnerable = false
	enemy.animation_player.animation_finished.disconnect( _on_animation_finished )
	pass
	
	
# What happens when the enemy exits this state?
func process( _delta : float ) -> EnemyState:
	# if the stun animation is finished, move into the state after stun
	if _animation_finished == true: 
		return next_state
	enemy.velocity -= enemy.velocity * decelerate_speed * _delta
	return null
	
	
# What happens when the enemy exits this state?
func physics (_delta : float  ) -> EnemyState:
	return null
	

func _on_enemy_damaged( hurt_box : HurtBox ) -> void:
	_damage_position = hurt_box.global_position
	# if damage taken, set state to stun
	state_machine.change_state( self )
	
# the _ in _a tells godot the variable will not be used
func _on_animation_finished( _a : String ) -> void:
	# in the process function, the next state will be returned
	_animation_finished = true
	
