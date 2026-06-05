extends Node2D


# Called when the node enters the scene tree for the first time.
const BULLET: PackedScene = preload("uid://c4t4ut4su4pxm")

@onready var muzzle: Marker2D = $Marker2D
@onready var shoot_timer : Timer = $shoot_timer
@onready var reload_timer : Timer = $reload_timer
@onready var ammo_label: Label = $"../Camera2D/Label"
@export_enum("semi","auto") var firemode: String = "semi"


var can_shoot: bool = true
var reloading: bool = false
var fire_rate: float = 5 
var max_ammo: int = 10
var current_ammo: int = 0

func _ready() -> void:
	current_ammo = max_ammo

func _process(delta: float) -> void:
	weapon_rotation()
	ammo_label.text = str(current_ammo) + " / " + str(max_ammo)
	
		
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
		can_shoot = false
		var bullet_instance = BULLET.instantiate()
		current_ammo -= 1
		get_tree().root.add_child(bullet_instance)
		bullet_instance.global_position = muzzle.global_position
		bullet_instance.rotation_degrees = rotation_degrees
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
	 
