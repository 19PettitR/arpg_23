class_name ItemEffectHeal extends ItemEffect

@export var heal_amount : int = 1
@export var audio : AudioStream


func use() -> void:
	# add one to the player's hp
	PlayerManager.player.update_hp( heal_amount )
	# the sound effect is really loud so lower the volume before playing it
	PauseMenu.audio_stream_player.volume_db = -20
	PauseMenu.play_audio( audio )
	await PauseMenu.audio_stream_player.finished
	PauseMenu.audio_stream_player.volume_db = 0
