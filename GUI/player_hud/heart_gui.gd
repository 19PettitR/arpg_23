class_name HeartGUI extends Control

@onready var sprite: Sprite2D = $Sprite2D

# by default, value of full heart is 2
var value : int = 2 :
	# everytime value is updated / set
	set(_value):
		value = _value
		update_sprite()


func update_sprite() -> void:
	# if value is 0, heart is empty etc
	sprite.frame = value
