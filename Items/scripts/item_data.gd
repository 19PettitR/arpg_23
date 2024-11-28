# script is present on every item resource
class_name ItemData extends Resource

@export var name : String = ""
@export_multiline var description : String = ""
@export var texture : Texture2D

@export_category("Item Use Effects")
@export var effects : Array[ ItemEffect ]


func use() -> bool:
	# if the item has no effects it cannot be used
	if effects.size() == 0:
		return false
		
	# for each effect the item has, call its use function
	for e in effects:
		if e:
			e.use()
	return true
