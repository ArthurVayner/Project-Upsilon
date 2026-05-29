extends Node2D


const SPEED: int = 100000
var bullet_dmg: float = 34

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
		body.take_damage(bullet_dmg)
		body.hp_label.text = "HP " + str(body.HEALTH)
