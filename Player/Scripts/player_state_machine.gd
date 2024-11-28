class_name PlayerStateMachine extends Node

# Holds collection of state objects
var states : Array[ State ]
var prev_state : State
var current_state : State

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# disable node until it is initialised
	process_mode = Node.PROCESS_MODE_DISABLED
	pass # Replace with function body.

# https://www.youtube.com/watch?v=ozUS1cSgFKs&list=PLfcCiyd_V9GH8M9xd_QKlyU8jryGcy3Xa&index=4&t=1140s
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# The current state will perform its function and notify whether state should be changed or not;
	# It will return either null or the new state
	ChangeState( current_state.Process( delta ) )
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	# The current state will perform its function and notify whether state should be changed or not;
	# It will return either null or the new state
	ChangeState( current_state.Physics( delta ) )
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _unhandled_input(event):
	# The current state will perform its function and notify whether state should be changed or not;
	# It will return either null or the new state
	ChangeState( current_state.HandleInput( event ))	
	
	
	
# Sets up the state machine
func Initialise( _player : Player ) -> void:
	states = []
	
	# Getting all states in state machine
	# get_children() returns an array / collection of nodes
	for c in get_children():
		# If node is a state or class that inherits/extends state
		if c is State:
			states.append(c)
			
	if states.size() == 0:
		return
	
	# The state's player is the player
	states[0].player = _player
	states[0].state_machine = self
	
	for state in states:
		state.init()
	
	# Change the state to the first state
	ChangeState( states[0] )
	# Inherits process_mode from the player
	# If the player is disabled, states will also be disabled
	process_mode = Node.PROCESS_MODE_INHERIT
	
	
	
func ChangeState( new_state : State ) -> void :
	# Does not return anything if no new state is given or it is the same as the current state.
	if new_state == null || new_state == current_state:
		return
	
	# If there is a current state (there will not be when the script is first initialised),
	# then exit it
	if current_state:
		current_state.Exit()
	
	prev_state = current_state
	current_state = new_state
	current_state.Enter()
		
