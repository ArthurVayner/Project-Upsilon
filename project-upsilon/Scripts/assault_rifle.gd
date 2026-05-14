extends Node2D

@onready var weapon = $Weapon


func _ready() -> void:
	weapon.firemode = "auto"



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
