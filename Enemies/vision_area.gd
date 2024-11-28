class_name VisionArea extends Area2D

# for when player enters / exits vision area
signal player_entered()
signal player_exited



# connect to body_entered and body_exited signals; which are built in to Area2D
# update 'vision cone' based on enemy direction
func _ready() -> void:
	body_entered.connect( _on_body_enter )
	body_exited.connect( _on_body_exit )
	
	# check there is an enemy as a parent; then connect
	var p = get_parent()
	if p is Enemy:
		p.direction_changed.connect( _on_direction_change )



# Node2D is the body that entered
func _on_body_enter( _b : Node2D ) -> void:
	if _b is Player:
		player_entered.emit()
	pass



# Node2D is the body that entered
func _on_body_exit( _b : Node2D ) -> void:
	if _b is Player:
		player_exited.emit()
	pass



# change direction of the vision cone when the enemy changes directions
func _on_direction_change( new_direction : Vector2 ) -> void:
	match new_direction:
		Vector2.DOWN:
			rotation_degrees = 0
		Vector2.UP:
			rotation_degrees = 180
		Vector2.LEFT:
			rotation_degrees = 90
		Vector2.RIGHT:
			rotation_degrees = -90
		_:
			rotation_degrees = 0
	pass 
