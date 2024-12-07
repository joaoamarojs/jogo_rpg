extends CanvasLayer

@onready var animation_player: AnimationPlayer = $Control/AnimationPlayer


func fade_out() -> bool:
	animation_player.play("fade_out")
	await animation_player.animation_finished
	return true


func fade_in() -> bool:
	animation_player.play("fade_in")
	return true


func fade_out_white() -> bool:
	animation_player.play("fade_out_white")
	await animation_player.animation_finished
	return true
	

func fade_in_white() -> bool:
	animation_player.play("fade_in_white")
	await animation_player.animation_finished
	return true
	
	
