@tool
class_name TreasureChest extends Node2D

@export var item_data : ItemData : set = _set_item_data
@export var quantity : int = 1 : set = _set_quantity

var is_open : bool = false

@onready var sprite: Sprite2D = $Sprite2D
@onready var item_sprite: Sprite2D = $ItemSprite
@onready var label: Label = $ItemSprite/Label
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var interact_area: Area2D = $Area2D
@onready var is_open_data: PersistentDataHandler = $IsOpen



func _ready() -> void:
	
	_update_texture()
	_update_label()
	
	if Engine.is_editor_hint():
		return
	interact_area.area_entered.connect( _on_area_enter )
	interact_area.area_exited.connect( _on_area_exit )
	# connect to the signal of the persistent data handler for this treasure chest
	is_open_data.data_loaded.connect( set_chest_state )
	# function needs to be called when the code starts as well as when signal is emitted
	set_chest_state()
	pass



func set_chest_state() -> void:
	is_open = is_open_data.value
	# if we find the chest is open, open it
	if is_open:
		animation_player.play("opened")
	else:
		animation_player.play("closed")


func player_interact() -> void:
	if is_open == true:
		return
	# open the chest if it isn't already open when the player interacts
	is_open = true
	# set the persistence value to be open
	is_open_data.set_value()
	animation_player.play("open_chest")
	if item_data and quantity > 0:
		PlayerManager.INVENTORY_DATA.add_item( item_data, quantity )
	else:
		# printerr prints text in red, push_error puts it in the debugger
		printerr("No Items in Chest!")
		push_error("No Items in Chest! Chest Name: ", name)
	pass



# when player's interact area is in the chest's interact area
# check to see if player is attempting to open the chest
func _on_area_enter( _a : Area2D ) -> void:
	PlayerManager.interact_pressed.connect( player_interact )
	pass



# when the player's interact area exits the chest's interact area
# stop checking for player interaction
func _on_area_exit( _a : Area2D ) -> void:
	PlayerManager.interact_pressed.disconnect( player_interact )
	pass



func _set_item_data( value : ItemData ) -> void:
	item_data = value
	_update_texture()
	pass



func _set_quantity( value : int ) -> void:
	quantity = value
	_update_label()
	pass



func _update_texture() -> void:
	if item_data and sprite:
		item_sprite.texture = item_data.texture



func _update_label() -> void:
	if label:
		if quantity <= 1:
			label.text = ""
		else:
			label.text = "x" + str(quantity)
