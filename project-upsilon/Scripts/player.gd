extends CharacterBody2D

var HEALTH: float = 100
var SPEED: float = 400

@export var player: CharacterBody2D
@export var gun_hold_distance: float

@onready var pivot_point: Node2D = $Pivot
@onready var gun: Node2D = $Weapon
@onready var gun_pivot: Marker2D = $Pivot/GunPivot


func _physics_process(delta):
	player_move()
	player_roll()
	player_rotation()
	weapon_position()
	
	
func player_move() -> void:
	var input_direction := Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * SPEED
	move_and_slide()
	
func player_roll():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	if Input.is_action_just_pressed("roll"):
		velocity = input_direction * SPEED * 15
		move_and_slide()
		
func player_rotation() -> void:
	var mouse_position = get_global_mouse_position()
	
	if mouse_position.x > player.position.x:
		pivot_point.scale.x = 1
	elif mouse_position.x < player.position.x:
		pivot_point.scale.x = -1
		
		
#Weapon position
#===========================================================
func weapon_position() -> void:
	var mouse_direction := gun_pivot.global_position.direction_to(get_global_mouse_position())
	gun.global_position = gun_pivot.global_position + mouse_direction * gun_hold_distance
