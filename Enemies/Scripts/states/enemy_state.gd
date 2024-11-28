class_name EnemyState extends Node

# stores a reference to the enemy that this state belongs to
var enemy : Enemy
var state_machine : EnemyStateMachine


# What happens when we initialise this state?
func init() -> void:
	pass
	
	
# What happens when the enemy enters this state?
func enter() -> void:
	pass
	

func exit() -> void:
	pass
	
	
# What happens when the enemy exits this state?
func process( _delta : float ) -> EnemyState:
	return null
	
	
# What happens when the enemy exits this state?
func physics (_delta : float  ) -> EnemyState:
	return null
