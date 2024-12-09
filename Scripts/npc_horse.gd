class_name Horse extends NPC

@onready var idle = $NPCStateMachine/Idle
@onready var mount = $NPCStateMachine/Mount


# Called when the node enters the scene tree for the first time.
func _ready():
	state_machine.initialize( self )
	player_boy = PlayerManager.player_boy
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _physics_process(_delta):
	move_and_slide()

func change_to_mount():
	state_machine.change_state(mount)
	print("montando")
	
func change_to_idle():
	state_machine.change_state(idle)
	print("idle")
