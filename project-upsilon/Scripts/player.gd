extends CharacterBody2D
class_name Player
#stats
var HEALTH: int = 100
var MAX_HEALTH: int = 100
var SPEED: int = 400

#actions
var can_roll: bool = true
@export var player: CharacterBody2D
@export var gun_hold_distance: float

@onready var pivot_point: Node2D = $Pivot
@onready var gun_pivot: Marker2D = $Pivot/GunPivot
@onready var heal_timer: Timer = $Heal_timer
@onready var hp_label: Label = $HP
@onready var weapon: Node2D = $Weapon
@onready var roll_timer: Timer = $Roll_timer

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
	var roll_force = 200
	var tween = get_tree().create_tween()
	var input_direction = Input.get_vector("left", "right", "up", "down")
	var position_to_roll = global_position + input_direction * roll_force

	if Input.is_action_just_pressed("roll") and can_roll:
		can_roll = false
		tween.tween_property(self,"global_position", position_to_roll, 0.1)
		roll_timer.start(0.5)
		
func _on_roll_timer_timeout() -> void:
	can_roll = true	
		
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
