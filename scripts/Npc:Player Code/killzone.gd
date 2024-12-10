extends Area2D

@onready var inventory = preload("res://Inventory/Tres/playerinv.tres")
@onready var timer= $Timer


func _on_body_entered(body: Node2D) -> void:
	print("You died!")
	for i in range(0,12):
		inventory.remove_at_index(i)
		inventory.removeItemAtIndex(i)
	Engine.time_scale = 0.5
	body.get_node("CollisionShape2D").queue_free()
	timer.start()


func _on_timer_timeout() -> void:
	Engine.time_scale = 1.0
	get_tree().reload_current_scene()
