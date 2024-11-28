class_name EnemyStateDestroy extends EnemyState

const PICKUP = preload("res://Items/item_pickup/item_pickup.tscn")

@export var anim_name : String = "destroy"
@export var knockback_speed : float = 200
@export var decelerate_speed : float = 10.0

@export_category("AI")

@export_category("Item Drops")
@export var drops : Array[ DropData ]

# the position of the hurtbox that damaged the enemy
var _damage_position : Vector2
var _direction : Vector2


# What happens when we initialise this state?
func init() -> void:
	enemy.enemy_destroyed.connect( _on_enemy_destroyed )
	pass
	
	
# What happens when the enemy enters this state?
func enter() -> void:
	enemy.invulnerable = true
	# global position gives coordinates of where the slime is regardless of parent position
	# the direction of the enemy should face player position
	_direction = enemy.global_position.direction_to( _damage_position )
	enemy.set_direction( _direction )
	# knockback_speed negative because he moves backwards
	enemy.velocity = _direction * -knockback_speed
	enemy.update_animation( anim_name )
	enemy.animation_player.animation_finished.connect( _on_animation_finished )
	disable_hurt_box()
	drop_items()
	pass


# What happens when the enemy exits this state?
func exit() -> void:
	pass


# What happens when the enemy exits this state?
func process( _delta : float ) -> EnemyState:
	enemy.velocity -= enemy.velocity * decelerate_speed * _delta
	return null
	
	
# What happens when the enemy exits this state?
func physics (_delta : float  ) -> EnemyState:
	return null
	

func _on_enemy_destroyed( hurt_box : HurtBox ) -> void:
	_damage_position = hurt_box.global_position
	# if damage taken, set state to stun
	state_machine.change_state( self )
	
# the _ in _a tells godot the variable will not be used
func _on_animation_finished( _a : String ) -> void:
	# destroy node
	enemy.queue_free()


func disable_hurt_box() -> void:
	var hurt_box : HurtBox = enemy.get_node_or_null("HurtBox")
	if hurt_box:
		hurt_box.monitoring = false


func drop_items() -> void:
	if drops.size() == 0:
		return
	
	for i in drops.size():
		if drops[ i ] == null or drops[i].item == null:
			# skip any subsequent code and loop over the for loop again
			continue
		# number of each item to be dropped
		var drop_count : int = drops[ i ].get_drop_count()
		# loop for the amount we want to drop
		for j in drop_count:
			# drop the item by instantiating an item pickup scene
			var drop : ItemPickup = PICKUP.instantiate() as ItemPickup
			# set the item data of the dropped item to the item (in the array) we are dropping
			drop.item_data = drops[ i ].item
			# cannot use 'add_child' so use 'call_deferred' and include 'add_child' as a string
			enemy.get_parent().call_deferred( "add_child", drop )
			drop.global_position = enemy.global_position 
			# randomise the drop velocity by changing its direction slightly from the enemy's vel
			drop.velocity = enemy.velocity.rotated( randf_range( -1.5, 1.5 ) ) * randf_range( 0.9, 1.5 	)
	pass
