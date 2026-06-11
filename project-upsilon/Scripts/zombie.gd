extends CharacterBody2D
class_name Zombie

#Stats
var speed: float = 100
var health: float = 100
const DAMAGE: int = 50

#Nodes
var player: Player = null
@onready var attack_timer: Timer = $AttackTimer
@onready var pivot_point: Node2D = $Pivot
@onready var hp_label: Label = $Label

#Actions
var can_attack: bool = true
var player_in_range: bool = false

func _ready() -> void:
	hp_label.text = "HP " + str(health)

	var player_group = get_tree().get_nodes_in_group("PlayerGroup")
	if player_group.size() > 0:
		player = player_group[0] as Player

func _physics_process(_delta) -> void:
	follow_player()
	
#=======================================================================
#Zombie Attack
#=======================================================================

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		player_in_range = true
		attack()

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Player:
		player_in_range = false
		attack_timer.stop()
		can_attack = true

func attack() -> void:
	if can_attack:
		player.take_damage()
	can_attack = false
	attack_timer.start(1)

func _on_attack_timer_timeout() -> void:
	can_attack = true
	if player_in_range:
		attack()

#=========================================================================
#zombie Movement
#=========================================================================

func follow_player() -> void:
	if player:
		var direction = (player.position - position).normalized()
		velocity = direction * speed
		if velocity.x < 0:
			pivot_point.scale.x = -1
		elif velocity.x > 0:
			pivot_point.scale.x = 1
		move_and_slide()

#=========================================================================
#zombie Take DMG
#===================================================================
func take_damage(dmg: float) -> void:
	health -= dmg
	hp_label.text = "HP " + str(health)
	player.currency_zombie_body_hit()
	if health <= 0:
		zombie_die()
		
func zombie_die() -> void:
	queue_free()
	player.currency_zombie_killed()
	
