extends Node2D

@onready var label = $Label
@onready var player = $"../Player"

enum PERK_TYPE {HP, Stamina, Reload, DMG}
@export var perk : PERK_TYPE

const stamina_perk_speed: int = 100
const health_perk_bonus: int = 300

var can_buy: bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if can_buy and Input.is_action_just_pressed("interact"):
		buy_perk()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.scene_file_path == "res://Scenes/player.tscn":
		can_buy = true
		label.visible = true
		


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.scene_file_path == "res://Scenes/player.tscn":
		label.visible = false
		can_buy = false
		
func buy_perk():
	can_buy = false
	match perk:
		PERK_TYPE.HP:
			player.HEALTH += health_perk_bonus
		PERK_TYPE.Stamina:
			player.SPEED += stamina_perk_speed
		PERK_TYPE.Reload:
			print("reload speed")
		PERK_TYPE.DMG:
			print("fire rate + dmg")
		_:
			print("not working")
