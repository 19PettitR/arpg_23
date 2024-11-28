class_name State_Attack extends State

var attacking : bool = false
# Export variables display in the inspector
@export var attack_sound : AudioStream
@export_range(1, 20, 0.5) var decelerate_speed : float = 5

@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"
@onready var attack_anim: AnimationPlayer = $"../../Sprite2D/AttackEffectSprite/AnimationPlayer"
@onready var audio: AudioStreamPlayer2D = $"../../Audio/AudioStreamPlayer2D"


@onready var idle: State_Idle = $"../Idle"
@onready var walk: State = $"../Walk"

@onready var hurt_box: HurtBox = %AttackHurtBox



# What happens when the player enters this state
func Enter() -> void:
	# Plays the attack animation (animation_player) and the attack effects (attack_anim)
	player.UpdateAnimation("attack")
	attack_anim.play("attack_" + player.AnimDirection())
	animation_player.animation_finished.connect( EndAttack )
	# Play the attack sound at a random pitch
	audio.stream = attack_sound
	audio.pitch_scale = randf_range(0.9, 1.1)
	audio.play()
	
	attacking = true
	
	# this line will wait until the timer times out  (0.075 seconds)
	# purpose is to delay attack for effect
	await get_tree().create_timer( 0.075 ).timeout
	
	# hurt box should be active whilst attacking
	if attacking: 
		hurt_box.monitoring = true
	pass
	
	
# What happens when the player enters this state
func Exit() -> void:
	animation_player.animation_finished.disconnect( EndAttack )
	attacking = false
	hurt_box.monitoring = false
	
	pass
	
	
# What happens during the _process update in this state?
func Process( _delta : float ) -> State:
	player.velocity -= player.velocity * decelerate_speed * _delta
	
	# if not attacking, find which state to return to
	if attacking == false:
		if player.direction == Vector2.ZERO:
			return idle
		else:
			return walk
	return null
	
	
#  What happens during the _physics_process update in this state?
func Physics ( _delta : float ) -> State:
	return null
	
	
# What happens with the input events in this state?
func HandleInput ( _event : InputEvent ) -> State:
	return null


func EndAttack( _newAnimName : String ) -> void:
	attacking = false
