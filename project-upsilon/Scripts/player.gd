extends CharacterBody2D
class_name Player
#Stats
var health: int = 100
var max_health: int = 100
var SPEED: int = 400
const REGEN_AMOUNT: int = 10
const ZOMBIE_DMG: int = 50
var currency: int = 10000


#Actions
var can_roll: bool = true
var can_throw_nade: bool = true
const GRENADE_INTERVAL: int = 1
const GUN_HOLD_DISTANCE: float = 45


#Nodes
@onready var pivot_point: Node2D = $Pivot
@onready var gun_pivot: Marker2D = $Pivot/GunPivot
@onready var hp_label: Label = $CanvasLayer/HP
@onready var currency_label: Label = $CanvasLayer/Currency
@onready var player: Player = $"."
@onready var weapon: Weapon = $Weapon1
const GRENADE = preload("res://Scenes/grenade.tscn")
@onready var heal_timer: Timer = $HealTimer
@onready var roll_timer: Timer = $RollTimer
@onready var grenade_timer: Timer = $GrenadeTimer

#Items
@onready var perks: Array[Perk.PERK_TYPE] = []


func _ready() -> void:
	hp_label.text = "HP: " + str(health)
	currency_label.text = "$: " + str(currency)
	

func _process(_delta) -> void:
	pass
	
	
func _physics_process(_delta) -> void:
	player_move()
	player_roll()
	player_rotation()
	weapon_position()
	throw_grenade()

#===========================================================
#Player Movement
#===========================================================
func player_move() -> void:
	var input_direction := Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * SPEED
	move_and_slide()
	
func player_roll() -> void:
	var roll_force = 200
	
	var input_direction = Input.get_vector("left", "right", "up", "down")
	var position_to_roll = global_position + input_direction * roll_force

	if Input.is_action_just_pressed("roll") and can_roll:
		var tween = get_tree().create_tween()
		can_roll = false
		tween.tween_property(self,"global_position", position_to_roll, 0.1)
		roll_timer.start(0.5)
		
func _on_roll_timer_timeout() -> void:
	can_roll = true	
		
func player_rotation() -> void:
	var mouse_position = get_global_mouse_position()
	
	if mouse_position.x > position.x:
		pivot_point.scale.x = 1
	elif mouse_position.x < position.x:
		pivot_point.scale.x = -1
		
#===========================================================
#Weapon position
#===========================================================
func weapon_position() -> void:
	var mouse_direction := gun_pivot.global_position.direction_to(get_global_mouse_position())
	weapon.global_position = gun_pivot.global_position + mouse_direction * GUN_HOLD_DISTANCE

#==============================================================
#health
#==============================================================

func health_regen() -> void:
	if health < max_health:
		health += REGEN_AMOUNT
	else:
		heal_timer.stop()
	hp_label.text = "HP: " + str(health)

func _on_heal_timer_timeout() -> void:
	health_regen()
#=========================================================================
#Take DMG
#=========================================================================

func take_damage() -> void:
	health -= ZOMBIE_DMG
	hp_label.text = "HP: " + str(health)
	heal_timer.start(1)
	
#=========================================================================
#Throw grenade
#=========================================================================
func throw_grenade() -> void:
	if Input.is_action_just_pressed("grenade") and can_throw_nade:
		var new_grenade = GRENADE.instantiate() as RigidBody2D
		new_grenade.global_position = global_position
		get_parent().add_child(new_grenade)
		var throw_direction = global_position.direction_to(get_global_mouse_position())
		var throw_force = 1500
		new_grenade.apply_central_impulse(throw_direction * throw_force)
		weapon.visible = false
		can_throw_nade = false
		grenade_timer.start(1)

func _on_grenade_timer_timeout() -> void:
	can_throw_nade = true
	weapon.visible = true


#=========================================================================
#Player Currency
#=========================================================================

func currency_zombie_body_hit() -> void:
	currency += 10
	currency_label.text = "$: " + str(currency)
	
	
func currency_zombie_headshot() -> void:
	pass
	
func currency_zombie_killed() -> void:
	currency += 100
	currency_label.text = "$: " + str(currency)

#=========================================================================
#Player Currency
#=========================================================================

func buy_perk(price: int, perk: Perk) -> void:
	match perk.perk_type:
		perk.PERK_TYPE.HP:
			print(perk.HEALTH_PERK_BONUS)
			max_health += perk.HEALTH_PERK_BONUS
			health = max_health
			hp_label.text = "HP: " + str(health)
			perks.append(perk.perk_type)
		perk.PERK_TYPE.Stamina:
			SPEED += perk.STAMINA_PERK_SPEED
			perks.append(perk.perk_type)
		perk.PERK_TYPE.Reload:
			weapon.reload_speed /= 2
			perks.append(perk.perk_type)
		perk.PERK_TYPE.DMG:
			weapon.fire_rate /= 2
			weapon.weapon_dmg *= 2
			perks.append(perk.perk_type)
		_:
			print("buy perk not working")
	currency -= perk.price
	currency_label.text = "$: " + str(currency)
	
	
