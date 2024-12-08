class_name NPC extends CharacterBody2D

signal direction_changed( new_direction : Vector2 )
signal npc_damaged( Brother_hit_box : HitBox )
signal npc_destroyed( Brother_hit_box : HitBox )

const DIR_4 = [ Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT, Vector2.UP ]

@export var Brother_hp : int = 1

var cardinal_direction : Vector2 = Vector2.DOWN
var direction : Vector2 = Vector2.ZERO
var player_boy : PlayerBoy
var invulnerable : bool = false

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var state_machine : NPCStateMachine = $NPCStateMachine
@onready var Brother_hit_box: HitBox = $HitBox

# Called when the node enters the scene tree for the first time.
func _ready():
	state_machine.initialize( self )
	player_boy = PlayerManager.player_boy
	Brother_hit_box.damaged.connect( _take_damage )
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
	animated_sprite.scale.x = -1 if cardinal_direction == Vector2.LEFT else 1 
	return true


func update_animation( state : String ) -> void:
	animated_sprite.play( anim_direction() + "_" + state)


func anim_direction() -> String:
	if cardinal_direction == Vector2.DOWN:
		return "down"
	elif cardinal_direction == Vector2.UP:
		return "up"
	else:
		return "side"
func _take_damage(Brother_hit_box : HurtBox):
	npc_destroyed.emit(Brother_hit_box)
