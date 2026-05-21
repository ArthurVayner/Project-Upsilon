extends CharacterBody2D

@export var SPEED = 400


func _physics_process(delta):
	player_move()
	player_roll()
	
	
	
func player_move() -> void:
	var input_direction := Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * SPEED
	if velocity.x < 0:
		$Pivot.scale.x = -1
	elif velocity.x > 0:
		$Pivot.scale.x = 1
	move_and_slide()
	
func player_roll():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	if Input.is_action_just_pressed("roll"):
		velocity = input_direction * SPEED * 15
		move_and_slide()
