extends CanvasLayer


func _on_retry_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/gamelevel_map.tscn")


func _on_exit_pressed() -> void:
	get_tree().quit()
