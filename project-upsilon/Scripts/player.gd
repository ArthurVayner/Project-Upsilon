extends CharacterBody2D

@export var SPEED: int = 400

@onready var player: CharacterBody2D = $"."
@onready var pivot_point: Node2D = $Pivot


func _physics_process(delta):
	player_move()
	player_roll()
	player_rotation()
	
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
