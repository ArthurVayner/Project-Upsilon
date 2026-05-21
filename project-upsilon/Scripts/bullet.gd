extends Node2D


const SPEED: int = 3000

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += transform.x * SPEED * delta
	
	
	
	


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()


#Bullet hit zombie
#=====================================================
func _on_area_2d_body_entered(body: Node2D) -> void:
	print(body.name)
	if body.scene_file_path == "res://Scenes/zombie.tscn":
		bullet_hit() # Replace with function body.
		body.queue_free()
		

func bullet_hit():
	print("Zombie hit")
	queue_free()
