class_name ItemEffectHeal extends ItemEffect

@export var heal_amount : int = 1
#@export var audio : AudioStream


func use() -> bool:
	PlayerManager.player_boy.update_hp( heal_amount )
	#PauseMenu.play_audio( audio )
	return true
