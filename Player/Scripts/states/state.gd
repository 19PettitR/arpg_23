class_name State extends Node
# THIS SCRIPT IS A BLUEPRINT FOR ALL FUTURE STATE SCRIPTS

# Reference to the player, so every state has the ability to manipulate the player
# Static variable is shared amongst all instances of the script that extend State
static var player : Player
static var state_machine : PlayerStateMachine

func _ready() -> void:
	pass # Replace with function body.
	
	
# What happens when we initialise this state?
func init() -> void:
	pass
	

# What happens when the player enters this state
func Enter() -> void:
	pass
	
	
# What happens when the player enters this state
func Exit() -> void:
	pass
	
	
# What happens during the _process update in this state?
func Process( _delta : float ) -> State:
	return null
	
	
#  What happens during the _physics_process update in this state?
func Physics ( _delta : float ) -> State:
	return null
	
	
# What happens with the input events in this state?
func HandleInput ( _event : InputEvent ) -> State:
	return null
