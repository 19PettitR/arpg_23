class_name Enemy extends CharacterBody2D

signal direction_changed( new_direction : Vector2 )
signal enemy_damaged( hurt_box : HurtBox )
signal enemy_destroyed( hurt_box : HurtBox )

# taken from player.gd
const DIR_4 = [ Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT, Vector2.UP ]

@export var hp : int = 3

var cardinal_direction : Vector2 = Vector2.DOWN
var direction : Vector2 = Vector2.ZERO
# reference to player
var player : Player
# enemy needs to be invulnerable for a small period after being stunned to prevent spamming
var invulnerable : bool = false

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D
@onready var hit_box : HitBox = $HitBox
@onready var state_machine : EnemyStateMachine = $EnemyStateMachine



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# initialise the state machine with the enemy
	state_machine.initialize( self )
	# assumption player is initialised before enemies
	player = PlayerManager.player
	hit_box.Damaged.connect( _take_damage )
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _physics_process(_delta):
	move_and_slide()

# SEE PLAYER.GD FOR EXPLANATIONS
func set_direction( _new_direction : Vector2 ) -> bool:
	direction = _new_direction
	if direction == Vector2.ZERO:
		return false

	var direction_id : int = int( round(
		(direction + cardinal_direction * 0.1 ).angle() / TAU * DIR_4.size()
	))
	
	var new_dir = DIR_4[ direction_id ]
	
	if new_dir == cardinal_direction:
		return false
		
	cardinal_direction = new_dir
	direction_changed.emit( new_dir )
	sprite.scale.x = -1 if cardinal_direction == Vector2.LEFT else 1
	return true
	
	
# SEE PLAYER.GD FOR EXPLANATIONS
func update_animation( state : String ) -> void:
	animation_player.play( state + "_" + anim_direction() )
	pass

	
# SEE PLAYER.GD FOR EXPLANATIONS
func anim_direction() -> String:
	if cardinal_direction == Vector2.DOWN:
		return "down"
	if cardinal_direction == Vector2.UP:
		return "up"
	else:
		return "side"
		


func _take_damage( hurt_box : HurtBox ) -> void:
	if invulnerable == true:
		return
	# decrease the hp of the hurtbox that has been hit
	hp -= hurt_box.damage
	if hp > 0:
		enemy_damaged.emit( hurt_box )
	else: 
		enemy_destroyed.emit( hurt_box )
