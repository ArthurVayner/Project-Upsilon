extends CharacterBody2D

@export var SPEED = 400

func move():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * SPEED
	
		

func _physics_process(delta):
	move()
	
