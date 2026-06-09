extends Node2D

var can_buy: bool = false

enum WEAPON_TYPE{AK,M4}
@export var weapon_type : WEAPON_TYPE
@onready var weapon: Weapon = $Weapon

func _ready() -> void:
	set_weapon_type()
	weapon.set_weapon_stats()
	

func set_weapon_type() -> void:
	if weapon_type == WEAPON_TYPE.AK:
		weapon.weapon_type = weapon.WEAPON_TYPE.AK
	elif weapon_type == WEAPON_TYPE.M4:
		weapon.weapon_type = weapon.WEAPON_TYPE.M4



func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		can_buy = true
		
		
		
