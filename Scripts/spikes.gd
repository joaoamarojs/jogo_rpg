extends Node2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var hurt_box: HurtBox = $HurtBox
@onready var audio: AudioStreamPlayer = $AudioStreamPlayer

var _timer : float = 6.0
var isUp = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_timer -= delta
	if _timer <= 2.0 and not isUp:
		isUp = true
		animated_sprite.play("up")
		await animated_sprite.animation_finished
		hurt_box.monitoring = true
	if	_timer <= 1.5 and _timer >= 1.4:
		audio.play()
	
	if _timer <= 0.0 and isUp:
		isUp = false
		_timer = 6.0
		animated_sprite.play("down")
		await animated_sprite.animation_finished
		hurt_box.monitoring = false
