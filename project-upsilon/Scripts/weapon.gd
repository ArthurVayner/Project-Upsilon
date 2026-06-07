extends Node2D

class_name Weapon

@onready var shoot_timer : Timer = $shoot_timer
@onready var reload_timer : Timer = $reload_timer
@onready var ray_cast: RayCast2D = $RayCast2D


@export_enum("semi","auto") var firemode: String = "semi"


var can_shoot: bool = true
var reloading: bool = false
var fire_rate: float = 5 
var max_ammo: int = 10
var current_ammo: int = 0
var weapon_dmg: int = 34

func _ready() -> void:
	current_ammo = max_ammo
	

func _process(delta: float) -> void:
	weapon_rotation()
	#ammo_label.text = str(current_ammo) + " / " + str(max_ammo)
	
	if Input.is_action_just_pressed("shoot") and can_shoot and not reloading:
		shoot()

	if firemode == "auto":
		if Input.is_action_pressed("shoot") and can_shoot and not reloading:
			shoot()
			
	if Input.is_action_just_pressed("reload") and current_ammo < max_ammo:
		reload()

#Weapon shoot
#===============================================================
func shoot() -> void:
	if current_ammo > 0:
		if ray_cast.is_colliding():
			var collider = ray_cast.get_collider()
			if collider is Zombie:
				collider.take_damage(weapon_dmg)
				collider.hp_label.text = "HP " + str(collider.HEALTH)
		can_shoot = false
		current_ammo -= 1
		shoot_timer.start(1 / fire_rate)
	else:
		reload()

		
func reload():
	reloading = true
	reload_timer.start(2)
	

func _on_shoot_timer_timeout() -> void:
	can_shoot = true
	
func _on_reload_timer_timeout() -> void:
		current_ammo = max_ammo
		can_shoot = true
		reloading = false
		
	
#Weapon rotation
#=================================================================
func weapon_rotation() -> void:
	look_at(get_global_mouse_position())
	
	rotation_degrees = wrap(rotation_degrees,0,360)
	if rotation_degrees > 90 and rotation_degrees < 270:
		scale.y = -1
	else:
		scale.y = 1
	
