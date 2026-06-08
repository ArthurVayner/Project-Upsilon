extends RigidBody2D

class_name Grenade

#Stats
const DAMAGE: int = 50
const GRENADE_TIME: int = 3

#Nodes
@onready var explode_timer: Timer = $ExplodeTimer

#Action
var zombies: Array[Zombie] = []

func _ready() -> void:
	gravity_scale = 0
	linear_damp = 2.0 #friction
	explode_timer.start(GRENADE_TIME)

#====================================================================
#Grenade Explosion
#====================================================================
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Zombie and not zombies.has(body):
		zombies.append(body)
		
		
func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Zombie and zombies.has(body):
		zombies.erase(body)


func _on_explode_timer_timeout() -> void:
	print("timer off")
	for zombie in zombies:
		if is_instance_valid(zombie):
			zombie.take_damage(DAMAGE)
			print(zombie.health)
	queue_free()
