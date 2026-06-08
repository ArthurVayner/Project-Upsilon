extends Node2D
class_name Weapon

#Nodes
@onready var shoot_timer : Timer = $ShootTimer
@onready var reload_timer : Timer = $ReloadTimer
@onready var ray_cast: RayCast2D = $RayCast2D
@onready var ammo_label: Label = $CanvasLayer/AmmoLabel

#Stats
enum FIREMODE {AUTO, SEMI, BURST}
@export var firemode : FIREMODE
@export var fire_rate: float
@export var max_ammo: int
var current_ammo: int
@export var weapon_dmg: int

#Action
var can_shoot: bool = true
var reloading: bool = false

func _ready() -> void:
	current_ammo = max_ammo
	ammo_label.text = str(current_ammo) + "/" + str(max_ammo)
	

func _process(_delta: float) -> void:
	weapon_rotation()
	
	if Input.is_action_just_pressed("shoot") and can_shoot and not reloading:
		if firemode == FIREMODE.SEMI:
			shoot()
		elif firemode == FIREMODE.BURST:
			pass #burst logic

	if firemode == FIREMODE.AUTO:
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
		can_shoot = false
		current_ammo -= 1
		ammo_label.text = str(current_ammo) + "/" + str(max_ammo)
		shoot_timer.start(1 / fire_rate)
	else:
		reload()

		
func reload() -> void:
	reloading = true
	reload_timer.start(2)
	

func _on_shoot_timer_timeout() -> void:
	can_shoot = true

func _on_reload_timer_timeout() -> void:
		current_ammo = max_ammo
		can_shoot = true
		reloading = false
		ammo_label.text = str(current_ammo) + "/" + str(max_ammo)


	
#Weapon rotation
#=================================================================
func weapon_rotation() -> void:
	look_at(get_global_mouse_position())
	
	rotation_degrees = wrap(rotation_degrees,0,360)
	if rotation_degrees > 90 and rotation_degrees < 270:
		scale.y = -1
	else:
		scale.y = 1
	
