class_name Player extends CharacterBody2D

# sending a signal for the hitbox to change direction with player
signal DirectionChanged( new_direction : Vector2 )
signal player_damaged( hurt_box : HurtBox )

const DIR_4 = [Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT, Vector2.UP]
# The direction the player is facing
var cardinal_direction : Vector2 = Vector2.DOWN
# The direction the player is moving
var direction : Vector2 = Vector2.ZERO

var invulnerable : bool = false
var hp : int = 6
var max_hp : int = 6

# Creates variable for referencing nodes
@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var effect_animation_player: AnimationPlayer = $EffectAnimationPlayer
@onready var hit_box: HitBox = $HitBox
@onready var sprite : Sprite2D = $Sprite2D
@onready var state_machine: PlayerStateMachine = $StateMachine

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# as soon as player loads, set the player reference
	PlayerManager.player = self
	state_machine.Initialise(self)
	hit_box.Damaged.connect( _take_damage )
	update_hp(99)
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process( _delta ):
	
	# Substract so player cannot move opposite directions at once
	#direction.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	#direction.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	direction = Vector2(
		Input.get_axis("left", "right"),
		Input.get_axis("up", "down")
	).normalized()
	pass
	
	
func _physics_process( _delta ):
	move_and_slide()


# Finds the direction that the player is facing
func set_direction() -> bool:
	
	# The direction does not need to be updated if the player is not moving
	if direction == Vector2.ZERO:
		return false
	
	# Take an angle and make sure it only relates to one direction
	# (direction + cardinal_direction * 0.1) skews the direction to honour the cardinal direction
	var direction_id : int = int( round( (direction + cardinal_direction * 0.1).angle() / TAU * DIR_4.size() ) )
	var new_direction = DIR_4[ direction_id ]
	
	# If the new direction is the same as the current one, then there is no need to update
	if new_direction == cardinal_direction:
		return false
	
	cardinal_direction = new_direction
	# If the player is facing left, flip the sprite to face the left
	sprite.scale.x = -1 if cardinal_direction == Vector2.LEFT else 1
	# emit a signal to tell hurtbox the player has change directions
	DirectionChanged.emit( new_direction )
	return true

	
func UpdateAnimation( state : String ) -> void:
	animation_player.play(state + "_" + AnimDirection())
	pass


# Checks which direction the player is facing and converts it to a string so 
# that UpdateAnimation() can play the correct animation
func AnimDirection() -> String:
	if cardinal_direction == Vector2.DOWN:
		return "down"
	elif cardinal_direction == Vector2.UP:
		return "up"
	else:
		return "side"
		
		
func _take_damage( hurt_box : HurtBox ) -> void:
	if invulnerable == true:
		return
	update_hp( -hurt_box.damage )
	if hp > 0:
		player_damaged.emit( hurt_box )
	else:
		player_damaged.emit( hurt_box )
		update_hp(99)
		print("here")
	pass
	
	
func update_hp( delta : int ) -> void:
	# clampi will clamp the value to an integer. minimum hp 0, max hp max_hp
	hp = clampi( hp + delta, 0, max_hp)
	PlayerHud.update_hp( hp, max_hp)
	pass
	
	
func make_invulnerable( _duration : float = 1.0 ) -> void:
	invulnerable = true
	# no taking hits whilst invulnerable
	hit_box.monitoring = false
	
	# create a time and wait for it to run out before setting the function
	await get_tree().create_timer( _duration ).timeout
	
	invulnerable = false
	hit_box.monitoring = true
	pass
	
