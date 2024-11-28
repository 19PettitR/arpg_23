extends Node


const SAVE_PATH = "user://"

signal game_loaded
signal game_saved


var current_save : Dictionary = {
	scene_path = "",
	player = {
		hp = 1,
		max_hp = 1,
		pos_x = 0, 
		pos_y = 0
	},
	items = [],
	persistence = [],
	quests = [],
}


## SAVING
func save_game() -> void:
	update_player_data()
	update_scene_path()
	update_item_data()
	var file := FileAccess.open( SAVE_PATH + "save.sav", FileAccess.WRITE )
	# turns things into a json string
	var save_json = JSON.stringify( current_save )
	file.store_line( save_json )
	game_saved.emit()
	pass


## LOADING
func load_game() -> void:
	var file := FileAccess.open( SAVE_PATH + "save.sav", FileAccess.READ )
	# creates a new empty json
	var json := JSON.new()
	# get the first (and only line) in the save
	json.parse( file.get_line() )
	var save_dict : Dictionary = json.get_data() as Dictionary
	current_save = save_dict
	
	# load scene. do not include transition or offset because LevelTransition unused
	LevelManager.load_new_level( current_save.scene_path, "", Vector2.ZERO )
	
	# wait until level begins loading (when the screen is black)
	await LevelManager.level_load_started
	
	PlayerManager.set_player_position( Vector2(current_save.player.pos_x, current_save.player.pos_y) )
	PlayerManager.set_health( current_save.player.hp, current_save.player.max_hp )
	PlayerManager.INVENTORY_DATA.parse_save_data( current_save.items )
	
	await LevelManager.level_loaded
	
	game_loaded.emit()
	
	pass


## SAVING
func update_player_data() -> void:
	var p : Player = PlayerManager.player
	current_save.player.hp = p.hp
	current_save.player.max_hp = p.max_hp
	current_save.player.pos_x = p.global_position.x
	current_save.player.pos_y = p.global_position.y


## SAVING SCENE
func update_scene_path() -> void:
	var p : String = ""
	# get children of the root
	for c in get_tree().root.get_children():
		# if the child is a level
		if c is Level:
			# store the path
			p = c.scene_file_path
	current_save.scene_path = p


## SAVING INVENTORY
func update_item_data() -> void:
	current_save.items = PlayerManager.INVENTORY_DATA.get_save_data()



## ADD PERSISTENT VALUE (EVEN WHEN NOT SAVING)
func add_persistent_value( value : String ) -> void:
	# if the persistent value we want to add is not present already, add it
	if check_persistent_value( value ) == false:
		current_save.persistence.append( value )
	pass


## CHECKING WHETHER CERTAIN PERSISTENCE IS PRESENT (either to add to the save or to load)
func check_persistent_value( value : String ) -> bool:
	# p is the persistent item array
	var p = current_save.persistence as Array
	# returns true if the array contains value we pass in
	return p.has( value )
