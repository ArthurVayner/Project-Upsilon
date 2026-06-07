extends Node2D

#Nodes
@onready var label = $Label
var player: Player = null

#Stats
enum PERK_TYPE {HP, Stamina, Reload, DMG}
@export var perk : PERK_TYPE
const stamina_perk_speed: int = 1000
const health_perk_bonus: int = 300

#Actions
var can_buy: bool = false
var has_perk: bool = false

func _ready() -> void:
	var player_group = get_tree().get_nodes_in_group("PlayerGroup")
	if player_group.size() > 0:
		player = player_group[0] as Player

func _process(_delta: float) -> void:
	if can_buy and Input.is_action_just_pressed("interact") and not has_perk:
		buy_perk()

#==============================================================
#Perk Buying
#==============================================================
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player and not has_perk:
		can_buy = true
		label.visible = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Player:
		label.visible = false
		can_buy = false


func buy_perk() -> void:
	can_buy = false
	match perk:
		PERK_TYPE.HP:
			player.MAX_HEALTH += health_perk_bonus
			player.HEALTH += health_perk_bonus
		PERK_TYPE.Stamina:
			player.SPEED += stamina_perk_speed
		PERK_TYPE.Reload:
			print("reload speed")
		PERK_TYPE.DMG:
			print("fire rate + dmg")
		_:
			print("not working")
	has_perk = true
	
