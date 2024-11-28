class_name State_Walk extends State
	
# Export variables display in the inspector
@export var move_speed : float = 100.0
# Necessary incase we need to reference idle to change state
@onready var idle : State = $"../Idle"
@onready var attack: State_Attack = $"../Attack"

# What happens when the player enters this state
func Enter() -> void:
	player.UpdateAnimation("walk")
	pass
	
	
# What happens when the player enters this state
func Exit() -> void:
	pass
	
	
# What happens during the _process update in this state?
func Process( _delta : float ) -> State:
	
	# If player stops moving, return "idle" to the function machine to change state
	if player.direction == Vector2.ZERO:
		return idle
	
	player.velocity = player.direction * move_speed
	
	# If direction changes, update animation
	if player.set_direction():
		player.UpdateAnimation("walk")
	return null
	
	
#  What happens during the _physics_process update in this state?
func Physics ( _delta : float ) -> State:
	return null
	
	
# What happens with the input events in this state?
func HandleInput ( _event : InputEvent ) -> State:
	if _event.is_action_pressed("Attack"):
		return attack
	if _event.is_action_pressed("interact"):
		PlayerManager.interact_pressed.emit()
	return null
