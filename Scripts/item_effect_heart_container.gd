class_name ItemEffectHeartContainer extends ItemEffect


func use() -> bool:
	var max_hp = PlayerManager.player_boy.max_hp+4
	PlayerManager.set_health(max_hp,max_hp)
	return true
