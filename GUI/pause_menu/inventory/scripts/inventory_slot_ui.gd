# script on the buttons / slots
class_name InventorySlotUI extends Button

# whenever slot_data is set, call set_slot_data
var slot_data : SlotData : set = set_slot_data

@onready var texture_rect: TextureRect = $TextureRect
@onready var label: Label = $Label



func _ready() -> void:
	# remove texture and label text from the button
	texture_rect.texture = null
	label.text = ""
	focus_entered.connect( item_focused )
	focus_exited.connect( item_unfocused )#
	pressed.connect( item_pressed )


func set_slot_data( value : SlotData ) -> void:
	slot_data = value
	if slot_data == null:
		return
	texture_rect.texture = slot_data.item_data.texture
	label.text = str( slot_data.quantity )


func item_focused() -> void:
	if slot_data != null:
		if slot_data.item_data != null:
			PauseMenu.update_item_description( slot_data.item_data.description )
	pass


func item_unfocused() -> void:
	PauseMenu.update_item_description( "" )
	pass


func item_pressed() -> void:
	if slot_data:
		# if there is item data in the slot
		if slot_data.item_data:
			var was_used = slot_data.item_data.use()
			if was_used == false:
				# if the item was not used, it does not need to be removed
				return
			slot_data.quantity -= 1
			label.text = str( slot_data.quantity )