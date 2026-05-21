extends Node2D


# Called when the node enters the scene tree for the first time.
const BULLET = preload("res://Scenes/bullet.tscn")

@onready var muzzle: Marker2D = $Marker2D
@export_enum("semi","auto") var firemode: String = "semi"


var can_shoot: bool = true
var fire_rate: float = 10 



func _process(delta: float) -> void:
	weapon_rotation()
			
	if Input.is_action_just_pressed("shoot") and can_shoot:
		shoot()
		
	if firemode == "auto":
		if Input.is_action_pressed("shoot") and can_shoot:
			shoot()

#Weapon shoot
#===============================================================
func shoot() -> void:
	var bullet_instance = BULLET.instantiate()
	get_tree().root.add_child(bullet_instance)
	bullet_instance.global_position = muzzle.global_position
	bullet_instance.rotation_degrees = rotation_degrees
	
	can_shoot = false
	
	$shoot_timer.start(1 / fire_rate)

func _on_shoot_timer_timeout() -> void:
	can_shoot = true
	
#Weapon rotation
#=================================================================
func weapon_rotation() -> void:
	look_at(get_global_mouse_position())

	rotation_degrees = wrap(rotation_degrees,0,360)
	if rotation_degrees > 90 and rotation_degrees < 270:
		scale.y = -1
	else:
		scale.y = 1
	 
