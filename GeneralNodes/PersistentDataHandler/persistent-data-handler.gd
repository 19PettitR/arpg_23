# have a value of true or false, emit a signal so parent nodes can react to change in value
class_name PersistentDataHandler extends Node

signal data_loaded

var value : bool = false


func _ready() -> void:
	get_value()
	pass


# set the persistent value and add it to the current save
func set_value() -> void:
	SaveManager.add_persistent_value( _get_name() )
	pass


# find the value whenever the scene containing this node loads
func get_value() -> void:
	value = SaveManager.check_persistent_value( _get_name() )
	data_loaded.emit()
	pass


# get the unique identifier of the object that will persist
func _get_name() -> String:
	# create the file path, starting with the scene, parent object, then this node
	return get_tree().current_scene.scene_file_path + "/" + get_parent().name + "/" + name
	
