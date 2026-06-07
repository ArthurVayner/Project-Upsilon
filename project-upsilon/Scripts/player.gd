extends CharacterBody2D
class_name Player
#stats
var HEALTH: int = 100
var MAX_HEALTH: int = 100
var SPEED: int = 400

#actions

@export var player: CharacterBody2D
@export var gun_hold_distance: float

@onready var pivot_point: Node2D = $Pivot
@onready var gun_pivot: Marker2D = $Pivot/GunPivot
@onready var heal_timer: Timer = $Heal_timer
@onready var hp_label: Label = $HP
@onready var weapon: Node2D = $Weapon

func _ready() -> void:
	hp_label.text = "HP: " + str(HEALTH)

	
func _process(delta: float) -> void:
	hp_label.text = "HP: " + str(HEALTH)
	

func _physics_process(delta):
	player_move()
	player_roll()
	player_rotation()
	weapon_position()
	
	
	
#Player Movement
#====================================================================	
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
	weapon.global_position = gun_pivot.global_position + mouse_direction * gun_hold_distance

#Health
#==============================================================


func health_regen():
	if HEALTH < MAX_HEALTH:
		print(HEALTH)
		heal_timer.start(1)
		print("func still going")

func _on_heal_timer_timeout() -> void:
	HEALTH += 10
	print("timer still going")
	health_regen()
