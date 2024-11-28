extends CanvasLayer


var hearts : Array[ HeartGUI ] = []



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# get all the children of the container (all the hearts)
	for child in $Control/HFlowContainer.get_children():
		if child is HeartGUI:
			hearts.append( child )
			child.visible = false
	pass
	
	
	
func update_hp( _hp : int, _max_hp : int ) -> void:
	update_max_hp( _max_hp )
	for i in _max_hp:
		update_heart( i, _hp )
		pass
	pass



func update_heart( _index : int, _hp : int ) -> void:
	# figuring out what hp should be for each heart. min 0, max 2
	var _value : int = clampi( _hp - _index * 2, 0, 2 )
	hearts[ _index ].value = _value
	pass
	
	
	
func update_max_hp( _max_hp : int ) -> void:
	# number of hearts needed
	var _heart_count : int = roundi( _max_hp * 0.5 )
	# goes through all hearts, making each one visible and not visible as necessary
	for i in hearts.size():
		if i < _heart_count:
			hearts[i].visible = true
		else: 
			hearts[i].visible = false
	pass
	
	
	
