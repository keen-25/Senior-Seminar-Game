extends Area2D

@onready var inventory = preload("res://inventory/playerinv.tres")

@onready var timer = $Timer


func _on_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
                for i in range(0,12):
                	inventory.remove_at_index(i)
			inventory.removeItemAtIndex(i)
		print("you died")
		Engine.time_scale=0.5
		body.get_node("CollisionShape2D").queue_free()
		timer.start()
	
	


func _on_timer_timeout() -> void:
	Engine.time_scale= 1
	get_tree().reload_current_scene()
