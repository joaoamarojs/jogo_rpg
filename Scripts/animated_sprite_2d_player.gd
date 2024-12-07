class_name AnimatedSpritePlayer extends AnimatedSprite2D


func play_sleep_animations():
	play("death")
	connect("animation_finished", Callable(self, "_on_death_finished"))

func _on_death_finished():
	disconnect("animation_finished", Callable(self, "_on_death_finished"))
	play("sleeping")
		
