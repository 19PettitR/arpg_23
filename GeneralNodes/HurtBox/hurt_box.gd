class_name HurtBox extends Area2D

# damage the hurt box will apply to others
@export var damage : int = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	# signal for area_entered gives the name of the area (the hitbox) that entered it
	area_entered.connect( AreaEntered )
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float):
	pass
	
	
	
func AreaEntered( a : Area2D ) -> void:
	# if the area that entered the hurtbox is a hitbox, send a signal to make it take damage
	if a is HitBox:
		# emit the whole hurtbox
		a.TakeDamage( self )
	pass
