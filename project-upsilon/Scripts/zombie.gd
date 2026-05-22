extends CharacterBody2D

var SPEED: int = 100

@onready var player: CharacterBody2D = $"../Player"
@onready var attack_timer: Timer = $Attack_timer
@onready var pivot_point: Node2D = $Pivot

var can_attack: bool = true
var player_in_range: bool = false


func _physics_process(delta):
	#zombie_move()
	follow_player()
	
	


#Zombie attack player
#=======================================================================	
	  
	

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		player_in_range = true
		attack()
	
func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		player_in_range = false
		attack_timer.stop()
		can_attack = true

func attack() -> void:
	if can_attack:
		print("hit")
	can_attack = false
	attack_timer.start(1)
	
func _on_attack_timer_timeout() -> void:
	can_attack = true
	if player_in_range:
		attack()
#=========================================================================

func follow_player() -> void:
	var direction = (player.position - position).normalized()
	velocity = direction * SPEED
	if velocity.x < 0:
		pivot_point.scale.x = -1
	elif velocity.x > 0:
		pivot_point.scale.x = 1
	move_and_slide()
	
