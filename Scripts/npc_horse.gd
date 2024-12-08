class_name Horse extends NPC


# Called when the node enters the scene tree for the first time.
func _ready():
	cardinal_direction = Vector2.LEFT
	state_machine.initialize( self )
	player_boy = PlayerManager.player_boy
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _physics_process(_delta):
	move_and_slide()

func set_direction( _new_direction : Vector2 ) -> bool:
	direction = _new_direction
	if direction == Vector2.ZERO:
		return false
	
	var direction_id : int = int( round(
			( direction + cardinal_direction * 0.1 ).angle()
			/ TAU * DIR_4.size()
	))
	var new_dir = DIR_4[ direction_id ]
	
	if new_dir == cardinal_direction:
		return false
	
	cardinal_direction = new_dir
	direction_changed.emit( new_dir )
	animated_sprite.scale.x = -1 if cardinal_direction == Vector2.RIGHT else 1 
	return true
