class_name ItemEffectGotSword extends ItemEffect

@export var damage : int = 1


func use() -> bool:
	PlayerManager.update_sword(true, damage )
	return true
