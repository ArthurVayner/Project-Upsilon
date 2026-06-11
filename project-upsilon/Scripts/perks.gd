extends Node2D
class_name Perk
#Nodes
@onready var label = $Label
var player: Player = null
@onready var perk_sprite: Sprite2D = $Sprite2D


#Stats
enum PERK_TYPE {HP, Stamina, Reload, DMG}
@export var perk : PERK_TYPE
const STAMINA_PERK_SPEED: int = 1000
const HEALTH_PERK_BONUS: int = 300
var price: int
const hp_price: int = 2500
const stamina_price: int = 1500
const  reload_price: int = 2000
const dmg_price: int = 3000

#Actions
var can_buy: bool = false
var has_perk: bool = false

func _ready() -> void:
	setup_perk()
	label.text = "Press F to interact (" + str(price) + ")"
	
	var player_group = get_tree().get_nodes_in_group("PlayerGroup")
	if player_group.size() > 0:
		player = player_group[0] as Player

func _process(_delta: float) -> void:
	
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
	if can_buy and Input.is_action_just_pressed("interact") and not has_perk and player.currency >= price:
		can_buy = false
		match perk:
			PERK_TYPE.HP:
				player.max_health += HEALTH_PERK_BONUS
				player.health += HEALTH_PERK_BONUS
				player.perks.append("HP")
				player.currency 
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
				print("buy perk not working")
		player.buy_perk(price)
		has_perk = true
		label.visible = false
	

func setup_perk() -> void:
	match perk:
		PERK_TYPE.HP:
			price = hp_price
			#texture
		PERK_TYPE.Stamina:
			price = stamina_price
			#teture
		PERK_TYPE.Reload:
			price = reload_price
			#teture
		PERK_TYPE.DMG:
			price = dmg_price
			#teture
		_:
			print("set perk not working")
