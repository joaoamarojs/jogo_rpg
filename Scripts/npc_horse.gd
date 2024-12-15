class_name Horse extends NPC

@onready var attack = $NPCStateMachine/Attack
@onready var idle = $NPCStateMachine/Idle
@onready var mount = $NPCStateMachine/Mount
@onready var left = $NPCInteractions/MountArea/CollisionShape2D
@onready var right = $NPCInteractions/MountArea/CollisionShape2D2


# Called when the node enters the scene tree for the first time.
func _ready():
	state_machine.initialize( self )
	player_boy = PlayerManager.player_boy
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if state_machine.prev_state == NPCStateIdleAttack or state_machine.prev_state == NPCStateMount:
		HorseManager.set_current_scene(LevelManager.get_current_scene_path())
		HorseManager.set_horse_position(global_position)
	pass


func _physics_process(_delta):
	move_and_slide()

func change_to_mount():
	state_machine.change_state(mount)
	
func change_to_idle():
	state_machine.change_state(idle)

func change_to_attack():
	state_machine.change_state(attack)
