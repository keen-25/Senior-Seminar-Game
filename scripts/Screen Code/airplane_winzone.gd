extends Area2D

@onready var inventory: Inventory = preload("res://Inventory/Tres/playerinv.tres")
var player_in_area=false

var player=null

func _process(delta: float) -> void:
	if player_in_area:
		if Input.is_action_just_pressed("use_item"):
			var index = Global.hotbar_instance.current_selected
			if inventory.slots[index].item == null:
				return
			if inventory.slots[index].item.name == "key_collectible":
				for i in range(0,12):
					inventory.remove_at_index(i)
					inventory.removeItemAtIndex(i)
				get_tree().change_scene_to_file("res://Scenes/win_screen.tscn")
				queue_free()



func _on_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		player_in_area = true
		player=body
	

func _on_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		player_in_area =false
		player =null
