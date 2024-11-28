class_name EnemyStateMachine extends Node


var states : Array[ EnemyState ]
var prev_state : EnemyState
var current_state : EnemyState


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# disable node until it is initialised
	process_mode = Node.PROCESS_MODE_DISABLED
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	change_state( current_state.process( delta ) )
	pass
	
	
	
func _physics_process(delta):
	change_state( current_state.physics(delta ) )
	pass

	
	
func initialize( _enemy : Enemy ) -> void:
	states = []
	
	# get children, build an array of states
	for c in get_children():
		if c is EnemyState:
			states.append( c )
	
	# iterate through all states and set up each one	
	for s in states:
		# set the enemy to the enemy passed into the function
		s.enemy = _enemy
		# set the state machine so each state has a reference to it
		s.state_machine = self
		# run the initialise function
		s.init()
		
	# if there are states present	
	if states.size() > 0:
		# set state to first in array
		change_state( states[0] )
		# start process
		process_mode = Node.PROCESS_MODE_INHERIT
	
	
	

func change_state( new_state : EnemyState ) -> void:
	# do not switch state if there is no new state to switch to or the states are the same
	if new_state == null || new_state == current_state:
		return 
		
	if current_state:
		current_state.exit()
		
	prev_state = current_state
	current_state = new_state
	current_state.enter()
