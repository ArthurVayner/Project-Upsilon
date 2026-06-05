extends Node2D

@onready var zombie = preload("res://Scenes/zombie.tscn")
@onready var timer: Timer = $Timer

@export var spawn_interval = 10000 

func _ready() -> void:
	timer.start(spawn_interval)



func spawn_zombie() -> void:
	var new_zombie = zombie.instantiate()
	get_parent().add_child(new_zombie)
	new_zombie.global_position = global_position
	

func _on_timer_timeout() -> void:
	spawn_zombie()
