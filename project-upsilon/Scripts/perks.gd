extends Node2D
class_name Perk
#Nodes
@onready var label = $Label
var player: Player = null

#Stats
enum PERK_TYPE {HP, Stamina, Reload, DMG}
@export var perk : PERK_TYPE
const STAMINA_PERK_SPEED: int = 1000
const HEALTH_PERK_BONUS: int = 300

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
			player.max_health += HEALTH_PERK_BONUS
			player.health += HEALTH_PERK_BONUS
			player.perks.append("HP")
		PERK_TYPE.Stamina:
			player.SPEED += STAMINA_PERK_SPEED
			player.perks.append("STAMINA")
		PERK_TYPE.Reload:
			player.weapon.reload_speed /= 2
			player.perks.append("RELOAD")
		PERK_TYPE.DMG:
			player.weapon.fire_rate /= 2
			player.weapon.weapon_dmg *= 2
			player.perks.append("DMG")
		_:
			print("not working")
	has_perk = true
	
