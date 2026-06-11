extends Node2D
class_name Weapon

const ONE_MINUTE: float = 60.0

#Nodes
@onready var shoot_timer : Timer = $ShootTimer
@onready var reload_timer : Timer = $ReloadTimer
@onready var ray_cast: RayCast2D = $RayCast2D
@onready var ammo_label: Label = $CanvasLayer/AmmoLabel
@onready var weapon_sprite: Sprite2D = $Sprite2D

#Stats
enum WEAPON_TYPE {AK, M4}
@export var weapon_type: WEAPON_TYPE
enum FIREMODE {AUTO, SEMI, BURST}
@export var firemode : FIREMODE
@export var fire_rate: float #rpm
@export var max_ammo: int
@export var current_ammo: int
@export var mag_size: int
@export var weapon_dmg: int
@export var reload_speed: float = 2.0

#Action
var can_shoot: bool = true
var reloading: bool = false

func _ready() -> void:
	set_weapon_stats()
	current_ammo = mag_size
	ammo_label.text = str(current_ammo) + "/" + str(mag_size) + "/" + str(max_ammo)


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
			
	if Input.is_action_just_pressed("reload") and max_ammo > 0:
		reload()

#===============================================================
#Weapon shoot
#===============================================================
func shoot() -> void:
	can_shoot = false
	if current_ammo > 0:
		if ray_cast.is_colliding():
			var collider = ray_cast.get_collider()
			if collider is Zombie:
				collider.take_damage(weapon_dmg)
		current_ammo -= 1
		ammo_label.text = str(current_ammo) + "/" + str(mag_size) + "/" + str(max_ammo)
		shoot_timer.start(ONE_MINUTE * fire_rate)
	else:
		reload()

		
func reload() -> void:
		reloading = true
		reload_timer.start(reload_speed)
	

func _on_shoot_timer_timeout() -> void:
	can_shoot = true

func _on_reload_timer_timeout() -> void:
		if max_ammo >= mag_size:
			max_ammo -= mag_size - current_ammo
			current_ammo += mag_size - current_ammo
		else:
			current_ammo = max_ammo
			max_ammo = 0
		can_shoot = true
		reloading = false
		ammo_label.text = str(current_ammo) + "/" + str(mag_size) + "/" + str(max_ammo)


#=================================================================
#Weapon rotation
#=================================================================
func weapon_rotation() -> void:
	look_at(get_global_mouse_position())
	
	rotation_degrees = wrap(rotation_degrees,0,360)
	if rotation_degrees > 90 and rotation_degrees < 270:
		scale.y = -1
	else:
		scale.y = 1
	
	
#=================================================================
#Create Weapon
#=================================================================
func set_weapon_stats() -> void:
	match weapon_type:
		WEAPON_TYPE.AK:
			weapon_sprite.texture = load("res://Assets/Guns/ak-47.png")
			firemode = FIREMODE.AUTO
			fire_rate = 1/600.0
			max_ammo = 320
			mag_size = 32
			weapon_dmg = 34
		WEAPON_TYPE.M4:
			weapon_sprite.texture = load("res://Assets/Guns/m4.png")
			firemode = FIREMODE.AUTO
			fire_rate = 1/700.0
			max_ammo = 400
			mag_size = 40
			weapon_dmg = 26
	var player = get_parent()
	if player is Player:
		if player.perks.has("DMG"):
			weapon_dmg *= 2
		if player.perks.has("RELOAD"):
			reload_speed /= 2
		
