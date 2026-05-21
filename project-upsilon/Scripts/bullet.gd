extends Node2D


const SPEED: int = 100000


func _process(delta: float) -> void:
	position += transform.x * SPEED * delta
	
#Bullet out of screen
#=======================================================
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	$Timer.start(2)


func _on_timer_timeout() -> void:
	queue_free()
	print("gone")


#Bullet hit zombie
#=====================================================
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Zombie":
		bullet_hit() 
		body.queue_free()
			
			
func bullet_hit():
	print("Zombie hit")
	queue_free()
