extends Node2D


const SPEED: int = 100000

@onready var timer: Timer = $Timer


func _process(delta: float) -> void:
	position += transform.x * SPEED * delta
	
#Bullet out of screen
#=======================================================
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	timer.start(2)


func _on_timer_timeout() -> void:
	queue_free()


#Bullet hit zombie
#=====================================================
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.scene_file_path == "res://Scenes/zombie.tscn":
		body.HEALTH = bullet_hit(body.HEALTH)
		if body.HEALTH <= 0:
			body.queue_free()
		
		
		
			
			
func bullet_hit(health: float) -> float:
	queue_free()
	print("Zombie hit")
	health -= 34
	return health
	
