extends CharacterBody2D

@export var speed = 400
@onready var weapon = $Weapon

func _ready() -> void:
	weapon.txt = load("res://Assets/Guns/1911.png")
	weapon.firemode = "semi"
	weapon.fire_rate = 50

func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed

func _physics_process(delta):
	get_input()
	move_and_slide()
